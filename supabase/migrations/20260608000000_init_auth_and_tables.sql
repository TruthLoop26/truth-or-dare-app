-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- 1. Users Profile Table (links to auth.users)
create table public.users (
  id uuid references auth.users on delete cascade primary key,
  username text unique not null,
  avatar_url text,
  role text default 'player' check (role in ('player', 'admin')) not null,
  is_premium boolean default false not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. Rooms Table
create table public.rooms (
  id uuid primary key default gen_random_uuid(),
  code varchar(8) unique not null,
  name text not null,
  host_id uuid references public.users(id) on delete cascade not null,
  category text default 'normal' check (category in ('normal', 'party', 'college', 'couples')) not null,
  max_players int default 8 not null,
  status text default 'lobby' check (status in ('lobby', 'playing', 'finished')) not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 3. Room Members (Many-to-Many link)
create table public.room_members (
  room_id uuid references public.rooms(id) on delete cascade not null,
  user_id uuid references public.users(id) on delete cascade not null,
  is_ready boolean default false not null,
  joined_at timestamp with time zone default timezone('utc'::text, now()) not null,
  primary key (room_id, user_id)
);

-- 4. Games Table
create table public.games (
  id uuid primary key default gen_random_uuid(),
  room_id uuid references public.rooms(id) on delete cascade not null unique,
  current_round_number int default 1 not null,
  status text default 'active' check (status in ('active', 'finished')) not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 5. Questions Table (Truth cards)
create table public.questions (
  id uuid primary key default gen_random_uuid(),
  content text not null,
  category text default 'normal' check (category in ('normal', 'party', 'college', 'couples')) not null,
  is_premium boolean default false not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 6. Dares Table (Dare cards)
create table public.dares (
  id uuid primary key default gen_random_uuid(),
  content text not null,
  category text default 'normal' check (category in ('normal', 'party', 'college', 'couples')) not null,
  is_premium boolean default false not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 7. Punishments Table (Penalty cards)
create table public.punishments (
  id uuid primary key default gen_random_uuid(),
  content text not null,
  severity text default 'medium' check (severity in ('mild', 'medium', 'spicy')) not null,
  is_premium boolean default false not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 8. Rounds Table
create table public.rounds (
  id uuid primary key default gen_random_uuid(),
  game_id uuid references public.games(id) on delete cascade not null,
  round_number int not null,
  turn_player_id uuid references public.users(id) on delete cascade not null,
  choice_type text check (choice_type in ('truth', 'dare')),
  question_id uuid references public.questions(id) on delete set null,
  dare_id uuid references public.dares(id) on delete set null,
  punishment_id uuid references public.punishments(id) on delete set null,
  status text default 'pending' check (status in ('pending', 'completed', 'failed')) not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique (game_id, round_number)
);

-- 9. Votes Table (Voter unique limit per round)
create table public.votes (
  id uuid primary key default gen_random_uuid(),
  round_id uuid references public.rounds(id) on delete cascade not null,
  voter_id uuid references public.users(id) on delete cascade not null,
  vote_value boolean not null, -- true: Completed, false: Failed/Forfeit
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique (round_id, voter_id)
);

-- 10. Rankings Table
create table public.rankings (
  id uuid primary key default gen_random_uuid(),
  room_id uuid references public.rooms(id) on delete cascade not null,
  user_id uuid references public.users(id) on delete cascade not null,
  score int default 0 not null,
  games_played int default 0 not null,
  wins int default 0 not null,
  unique (room_id, user_id)
);

-- Indices for frequently queried properties
create index idx_room_members_user on public.room_members(user_id);
create index idx_rooms_host on public.rooms(host_id);
create index idx_games_room on public.games(room_id);
create index idx_rounds_game on public.rounds(game_id);
create index idx_votes_round on public.votes(round_id);
create index idx_rankings_room on public.rankings(room_id);
create index idx_questions_premium on public.questions(is_premium);
create index idx_dares_premium on public.dares(is_premium);
create index idx_punishments_premium on public.punishments(is_premium);

-- Enable RLS for all tables
alter table public.users enable row level security;
alter table public.rooms enable row level security;
alter table public.room_members enable row level security;
alter table public.games enable row level security;
alter table public.rounds enable row level security;
alter table public.questions enable row level security;
alter table public.dares enable row level security;
alter table public.punishments enable row level security;
alter table public.votes enable row level security;
alter table public.rankings enable row level security;

-- Function with Security Definer to safely verify room membership avoiding RLS recursion
create or replace function public.is_room_member(room_uuid uuid, user_uuid uuid)
returns boolean
security definer
set search_path = public
language plpgsql
as $$
begin
  return exists (
    select 1 from public.room_members
    where room_members.room_id = room_uuid and room_members.user_id = user_uuid
  );
end;
$$;

-- Trigger logic to sync Supabase Auth users to public.users profile automatically
create or replace function public.handle_new_user()
returns trigger
security definer
set search_path = public
language plpgsql
as $$
begin
  insert into public.users (id, username, avatar_url, role, is_premium)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'username', split_part(new.email, '@', 1)),
    new.raw_user_meta_data->>'avatar_url',
    'player',
    false
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();


-- RLS Policies

-- Users Policies
create policy "Allow select for authenticated users" on public.users 
  for select using (auth.role() = 'authenticated');

create policy "Allow update for owners" on public.users 
  for update using (auth.uid() = id);

-- Rooms Policies
create policy "Allow select for members or host" on public.rooms 
  for select using (auth.uid() = host_id or public.is_room_member(id, auth.uid()));

create policy "Allow insert for authenticated hosts" on public.rooms 
  for insert with check (auth.uid() = host_id);

create policy "Allow update for hosts" on public.rooms 
  for update using (auth.uid() = host_id);

create policy "Allow delete for hosts" on public.rooms 
  for delete using (auth.uid() = host_id);

-- Room Members Policies
create policy "Allow select room members for active players" on public.room_members 
  for select using (user_id = auth.uid() or public.is_room_member(room_id, auth.uid()));

create policy "Allow join room for self" on public.room_members 
  for insert with check (user_id = auth.uid());

create policy "Allow leave or kick for self or host" on public.room_members 
  for delete using (
    user_id = auth.uid() 
    or exists (select 1 from public.rooms r where r.id = room_id and r.host_id = auth.uid())
  );

-- Games Policies
create policy "Allow select game for room members" on public.games 
  for select using (
    exists (
      select 1 from public.rooms r 
      where r.id = room_id and (r.host_id = auth.uid() or public.is_room_member(r.id, auth.uid()))
    )
  );

create policy "Allow insert game for host" on public.games 
  for insert with check (
    exists (select 1 from public.rooms r where r.id = room_id and r.host_id = auth.uid())
  );

create policy "Allow update game for host" on public.games 
  for update using (
    exists (select 1 from public.rooms r where r.id = room_id and r.host_id = auth.uid())
  );

-- Rounds Policies
create policy "Allow select rounds for room members" on public.rounds 
  for select using (
    exists (
      select 1 from public.games g 
      join public.rooms r on g.room_id = r.id 
      where g.id = game_id and (r.host_id = auth.uid() or public.is_room_member(r.id, auth.uid()))
    )
  );

create policy "Allow insert rounds for host" on public.rounds 
  for insert with check (
    exists (
      select 1 from public.games g 
      join public.rooms r on g.room_id = r.id 
      where g.id = game_id and r.host_id = auth.uid()
    )
  );

create policy "Allow update rounds for host" on public.rounds 
  for update using (
    exists (
      select 1 from public.games g 
      join public.rooms r on g.room_id = r.id 
      where g.id = game_id and r.host_id = auth.uid()
    )
  );

-- Questions (Truths) Policies
create policy "Allow select questions if free or user is premium" on public.questions 
  for select using (
    not is_premium 
    or exists (select 1 from public.users u where u.id = auth.uid() and u.is_premium = true)
  );

create policy "Allow admins complete control over questions" on public.questions 
  for all using (
    exists (select 1 from public.users u where u.id = auth.uid() and u.role = 'admin')
  );

-- Dares Policies
create policy "Allow select dares if free or user is premium" on public.dares 
  for select using (
    not is_premium 
    or exists (select 1 from public.users u where u.id = auth.uid() and u.is_premium = true)
  );

create policy "Allow admins complete control over dares" on public.dares 
  for all using (
    exists (select 1 from public.users u where u.id = auth.uid() and u.role = 'admin')
  );

-- Punishments Policies
create policy "Allow select punishments if free or user is premium" on public.punishments 
  for select using (
    not is_premium 
    or exists (select 1 from public.users u where u.id = auth.uid() and u.is_premium = true)
  );

create policy "Allow admins complete control over punishments" on public.punishments 
  for all using (
    exists (select 1 from public.users u where u.id = auth.uid() and u.role = 'admin')
  );

-- Votes Policies
create policy "Allow select votes for members" on public.votes 
  for select using (
    exists (
      select 1 from public.rounds rd 
      join public.games g on rd.game_id = g.id 
      join public.rooms r on g.room_id = r.id 
      where rd.id = round_id and (r.host_id = auth.uid() or public.is_room_member(r.id, auth.uid()))
    )
  );

create policy "Allow insert votes for members to vote once" on public.votes 
  for insert with check (
    voter_id = auth.uid() 
    and exists (
      select 1 from public.rounds rd 
      join public.games g on rd.game_id = g.id 
      join public.rooms r on g.room_id = r.id 
      where rd.id = round_id and (r.host_id = auth.uid() or public.is_room_member(r.id, auth.uid()))
    )
  );

-- Rankings Policies
create policy "Allow select rankings for members" on public.rankings 
  for select using (
    exists (
      select 1 from public.rooms r 
      where r.id = room_id and (r.host_id = auth.uid() or public.is_room_member(r.id, auth.uid()))
    )
  );

create policy "Allow host to manage rankings" on public.rankings 
  for all using (
    exists (select 1 from public.rooms r where r.id = room_id and r.host_id = auth.uid())
  );
