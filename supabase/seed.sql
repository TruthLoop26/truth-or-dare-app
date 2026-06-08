-- Seed Data for Questions (Truths)
insert into public.questions (content, category, is_premium) values
-- Normal category (free)
('What is your biggest fear?', 'normal', false),
('What is the most embarrassing thing in your search history?', 'normal', false),
('Have you ever lied to get out of plans?', 'normal', false),
-- Normal category (premium)
('What is the secret you are most afraid your parents will find out?', 'normal', true),
('Have you ever secretly disliked a gift someone here gave you?', 'normal', true),

-- Party category (free)
('Who in this room would you most want to be stuck on an island with?', 'party', false),
('What is the worst date you have ever been on?', 'party', false),
('Have you ever pretended to receive a text to leave a social event?', 'party', false),
-- Party category (premium)
('What is the most illegal thing you have ever gotten away with?', 'party', true),
('Who in this room is the most attractive to you?', 'party', true),

-- College category (free)
('Have you ever slept through a final exam?', 'college', false),
('What is the lowest grade you have ever received on an essay?', 'college', false),
('Did you ever copy homework at the last minute?', 'college', false),
-- College category (premium)
('What is the craziest thing you did during spring break?', 'college', true),
('Have you ever sneaked someone into your dorm room overnight?', 'college', true),

-- Couples category (free)
('What was your exact first impression of your partner?', 'couples', false),
('What is the most romantic date you can imagine?', 'couples', false),
('Do you believe in love at first sight?', 'couples', false),
-- Couples category (premium)
('What is one thing about our relationship that you wish we could change?', 'couples', true),
('What is a secret fantasy you have never shared with me?', 'couples', true);


-- Seed Data for Dares
insert into public.dares (content, category, is_premium) values
-- Normal category (free)
('Do 15 jumping jacks right now.', 'normal', false),
('Call a friend and talk about the weather for 1 minute without explaining why.', 'normal', false),
('Drink a glass of water without using your hands.', 'normal', false),
-- Normal category (premium)
('Let another player send a text of their choice to any contact on your phone.', 'normal', true),
('Do your best impression of another player until someone guesses who it is.', 'normal', true),

-- Party category (free)
('Sing a song chosen by the group for 30 seconds.', 'party', false),
('Show the group the last three photos you took on your phone.', 'party', false),
('Do a silly dance for 1 minute with no background music.', 'party', false),
-- Party category (premium)
('Let the group choose a random contact on your social media and send them a funny message.', 'party', true),
('Recreate a funny viral video selected by the other players.', 'party', true),

-- College category (free)
('Write a funny post about a fake class and post it on your social status.', 'college', false),
('Pretend to give a lecture on how to peel a banana for 2 minutes.', 'college', false),
('Recite a poem with your mouth full of crackers.', 'college', false),
-- College category (premium)
('Call your teacher or a colleague and tell them you solved a major riddle of the universe.', 'college', true),
('Propose to a random study desk or chair in front of everyone.', 'college', true),

-- Couples category (free)
('Give your partner a back rub for 2 minutes.', 'couples', false),
('Whisper a sweet secret in your partner''s ear.', 'couples', false),
('Stare into your partner''s eyes for 1 full minute without laughing.', 'couples', false),
-- Couples category (premium)
('Perform a slow dance with your partner for 2 minutes.', 'couples', true),
('Write and read aloud a short, dramatic poem about how you met your partner.', 'couples', true);


-- Seed Data for Punishments
insert into public.punishments (content, severity, is_premium) values
-- Free Punishments
('Drink a glass of water mixed with a pinch of salt.', 'mild', false),
('Do 20 squats right now.', 'mild', false),
('Keep your eyes closed for the next two rounds.', 'medium', false),
('Eat a spoonful of hot sauce or mustard.', 'medium', false),
('Speak only in questions for the next three rounds.', 'spicy', false),

-- Premium Punishments
('Let the player on your right draw a mustache on your face with a washable marker.', 'medium', true),
('Wear your socks on your hands for the rest of the game.', 'medium', true),
('Perform a dramatic death scene right now.', 'spicy', true),
('Give up your phone to the player of the group''s choice for the next round.', 'spicy', true);
