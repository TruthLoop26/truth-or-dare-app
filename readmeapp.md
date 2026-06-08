# Truth or Dare App - Documentacion Tecnica y Funcional MVP

Party game interactivo de Verdad o Reto. Sincroniza las pantallas de todos tus amigos en tiempo real para votar y cumplir castigos.

## 1. Product Requirements Document (PRD)

### Problema

Los juegos sociales como Verdad o Reto suelen depender de dinamicas manuales, papeles, apps individuales o contenido poco organizado. En grupos grandes es dificil sincronizar turnos, votar preguntas o retos, registrar resultados y mantener una experiencia fluida desde varios telefonos.

### Solucion

Truth or Dare App permite crear salas privadas en tiempo real donde varios jugadores pueden unirse mediante codigo o QR, participar en rondas de Verdad o Reto, votar opciones, recibir castigos, ver resultados sincronizados y competir mediante rankings.

### Publico objetivo

- Grupos de amigos en reuniones sociales.
- Estudiantes universitarios.
- Parejas.
- Usuarios que buscan juegos casuales para fiestas.
- Creadores de contenido o dinamicas grupales.
- Administradores que gestionan paquetes de preguntas y retos.

### Casos de uso

- Un host crea una sala y comparte un codigo QR.
- Jugadores se unen desde sus telefonos.
- El host inicia la partida.
- El sistema selecciona o propone preguntas, retos o castigos.
- Los jugadores votan en tiempo real.
- Todos ven los resultados sincronizados.
- El ranking se actualiza por participacion, retos completados y votos recibidos.

### Propuesta de valor

- Juego social sincronizado en tiempo real.
- Experiencia mobile-first.
- Salas privadas faciles de compartir.
- Contenido categorizado por contexto.
- Votaciones grupales integradas.
- Rankings y estadisticas para aumentar engagement.
- Modelo freemium con paquetes premium.

### Funcionalidades MVP

- Registro e inicio de sesion con Supabase Auth.
- Crear sala privada.
- Unirse mediante codigo.
- Generacion de QR para compartir sala.
- Lista de jugadores en tiempo real.
- Inicio de partida por host.
- Categorias base: Normal, Fiesta, Universitarios, Parejas.
- Rondas de Verdad, Reto y Castigo.
- Sistema de votacion.
- Resultados sincronizados.
- Ranking basico por jugador.
- Historial basico de rondas.

### Funcionalidades futuras

- Categorias personalizadas.
- Suscripciones Premium.
- Compra de paquetes de preguntas y retos.
- IA generadora de preguntas y retos.
- Moderacion automatica de contenido.
- Modo anonimo.
- Chat en sala.
- Modo streaming.
- Torneos o ligas sociales.
- Integracion con notificaciones push.
- Sistema de reportes.
- Multilenguaje.

## 2. User Stories

### Host

```text
Como host
Quiero crear una sala privada
Para invitar a mis amigos a jugar en un entorno controlado.
```

```text
Como host
Quiero compartir un codigo o QR
Para que los jugadores se unan facilmente desde sus telefonos.
```

```text
Como host
Quiero iniciar y pausar la partida
Para controlar el ritmo del juego.
```

```text
Como host
Quiero seleccionar categorias de juego
Para adaptar el contenido al tipo de grupo.
```

```text
Como host
Quiero expulsar jugadores
Para mantener una experiencia segura y agradable.
```

### Jugador

```text
Como jugador
Quiero unirme a una sala mediante codigo
Para participar rapidamente sin configuraciones complejas.
```

```text
Como jugador
Quiero votar por preguntas, retos o castigos
Para influir en la dinamica del juego.
```

```text
Como jugador
Quiero ver los resultados en tiempo real
Para saber que decision tomo el grupo.
```

```text
Como jugador
Quiero ver mi ranking
Para competir con mis amigos.
```

```text
Como jugador
Quiero completar retos
Para ganar puntos dentro de la partida.
```

### Administrador

```text
Como administrador
Quiero gestionar preguntas, retos y castigos
Para mantener el contenido actualizado.
```

```text
Como administrador
Quiero crear paquetes premium
Para monetizar contenido adicional.
```

```text
Como administrador
Quiero moderar contenido personalizado
Para evitar material ofensivo o inseguro.
```

```text
Como administrador
Quiero consultar estadisticas de uso
Para entender que categorias tienen mayor engagement.
```

## 3. Functional Requirements

### Creacion de salas

- El usuario autenticado puede crear una sala.
- El creador queda asignado como `host`.
- La sala genera un `room_code` unico de 6 caracteres.
- La sala puede tener estado `waiting`, `in_progress`, `finished` o `cancelled`.
- La sala puede definir nombre, categoria, maximo de jugadores, configuracion de votacion y privacidad.
- El sistema debe generar un QR con el codigo o link de invitacion.

### Union mediante codigo

- El jugador introduce un codigo de sala.
- El sistema valida que la sala exista, no este finalizada, no haya alcanzado el limite de jugadores y que el usuario no este duplicado.
- Al unirse, se crea un registro en `room_members`.
- Todos los jugadores reciben actualizacion realtime.

### Votaciones

- Cada ronda puede tener una o varias opciones votables.
- Los jugadores pueden votar una vez por ronda.
- El sistema debe impedir votos duplicados.
- Los votos se publican en tiempo real.
- Al terminar la votacion, se calcula el resultado ganador.
- El resultado se muestra a todos los miembros de la sala.

### Retos

- Los retos se obtienen desde la tabla `dares`.
- Pueden estar asociados a una categoria.
- Pueden tener dificultad `easy`, `medium` o `hard`.
- El jugador seleccionado debe aceptar o completar el reto.
- El host o el grupo puede validar si fue completado.

### Verdades

- Las verdades se obtienen desde la tabla `questions`.
- Pueden filtrarse por categoria, edad, nivel de intensidad o paquete.
- El jugador seleccionado responde.
- Opcionalmente, el grupo puede votar si la respuesta fue valida.

### Castigos

- Los castigos se usan cuando un jugador pierde una votacion, no completa un reto o rechaza una verdad.
- Pueden estar en la tabla `punishments`.
- Pueden ser seleccionados por votacion o aleatoriamente.
- Deben poder marcarse como completados.

### Ranking

- El ranking se calcula por sala y jugador.
- Reglas MVP:
  - Reto completado: `+10` puntos.
  - Verdad respondida: `+5` puntos.
  - Castigo completado: `+3` puntos.
  - Reto rechazado: `-5` puntos.
- El ranking se actualiza al finalizar cada ronda.
- Todos los jugadores pueden verlo en tiempo real.

### Realtime synchronization

Los cambios clave deben sincronizarse mediante Supabase Realtime:

- Jugadores unidos.
- Inicio de partida.
- Nueva ronda.
- Votos emitidos.
- Resultados.
- Ranking actualizado.
- Estado de sala.

## 4. Non-Functional Requirements

### Seguridad

- Autenticacion mediante Supabase Auth.
- Row Level Security habilitado en PostgreSQL.
- Politicas por sala para evitar acceso no autorizado.
- Validacion de host para acciones criticas.
- Edge Functions para operaciones sensibles.

### Escalabilidad

- Canales realtime separados por sala.
- Evitar canales globales innecesarios.
- Indices en campos de busqueda frecuente.
- Edge Functions desacopladas para logica de juego.
- Paginacion en rankings, historial y contenido.

### Disponibilidad

- Uso de Supabase como backend administrado.
- Manejo de reconexion en Flutter.
- Estado local temporal para evitar perdida visual durante microcortes.
- Reintentos controlados en operaciones criticas.

### Rendimiento

- Consultas filtradas por `room_id`.
- Payloads realtime pequenos.
- Suscripciones activas solo mientras el usuario esta dentro de una sala.
- Cache local de preguntas y categorias.
- Debounce en acciones de votacion.

### Compatibilidad movil

- Flutter como framework principal.
- UI optimizada para pantallas pequenas.
- Soporte Android e iOS.
- Navegacion con GoRouter.
- Estado reactivo con Riverpod.

### Proteccion de datos

- No exponer emails a otros jugadores.
- Mostrar alias o nombre publico.
- Permitir borrar cuenta.
- Moderar contenido personalizado.
- Guardar solo informacion necesaria para el juego.

## 5. Arquitectura del sistema

### Arquitectura de alto nivel

```text
[Flutter App]
    |
    | Auth / REST / Realtime
    v
[Supabase]
    |
    |-- Authentication
    |-- PostgreSQL Database
    |-- Realtime Channels
    |-- Storage
    |-- Edge Functions
    |
    v
[Admin / Content Management]
```

### Flujo de datos

```text
1. Usuario inicia sesion en Flutter.
2. Host crea sala mediante Edge Function.
3. Backend crea room, room_member y codigo unico.
4. Jugadores se unen usando codigo.
5. Flutter se suscribe al canal realtime de la sala.
6. Host inicia partida.
7. Backend crea game y primera ronda.
8. Jugadores votan.
9. Backend registra votos y calcula resultado.
10. Realtime notifica resultado y ranking actualizado.
```

### Diagrama textual

```text
Mobile Client
  - UI Flutter
  - Riverpod State
  - GoRouter Navigation
  - Supabase Client

Backend Supabase
  - Auth
  - PostgreSQL
  - Realtime
  - Edge Functions
  - Storage

Database
  - users
  - rooms
  - room_members
  - games
  - rounds
  - questions
  - dares
  - punishments
  - votes
  - rankings
```

### Servicios involucrados

- **Flutter App:** interfaz movil.
- **Supabase Auth:** autenticacion.
- **PostgreSQL:** almacenamiento principal.
- **Supabase Realtime:** sincronizacion de eventos.
- **Supabase Edge Functions:** logica transaccional.
- **Supabase Storage:** imagenes, avatares y assets de paquetes.

## 6. Diseno de Base de Datos

### `users`

| Campo | Tipo | Descripcion |
|---|---|---|
| `id` | `uuid PK` | ID del usuario, vinculado a `auth.users` |
| `username` | `text` | Nombre publico |
| `avatar_url` | `text` | URL del avatar |
| `role` | `text` | `player`, `admin` |
| `created_at` | `timestamptz` | Fecha de creacion |

Relaciones:

- `users.id` referencia `auth.users.id`.

### `rooms`

| Campo | Tipo | Descripcion |
|---|---|---|
| `id` | `uuid PK` | ID de sala |
| `host_id` | `uuid FK` | Usuario creador |
| `room_code` | `text unique` | Codigo unico |
| `name` | `text` | Nombre de sala |
| `category` | `text` | Categoria seleccionada |
| `status` | `text` | `waiting`, `in_progress`, `finished` |
| `max_players` | `int` | Limite de jugadores |
| `created_at` | `timestamptz` | Fecha de creacion |

FK:

- `host_id -> users.id`

### `room_members`

| Campo | Tipo | Descripcion |
|---|---|---|
| `id` | `uuid PK` | ID de miembro |
| `room_id` | `uuid FK` | Sala |
| `user_id` | `uuid FK` | Usuario |
| `display_name` | `text` | Nombre en sala |
| `is_host` | `boolean` | Indica si es host |
| `joined_at` | `timestamptz` | Fecha de union |

FK:

- `room_id -> rooms.id`
- `user_id -> users.id`

Unique:

- `(room_id, user_id)`

### `games`

| Campo | Tipo | Descripcion |
|---|---|---|
| `id` | `uuid PK` | ID de partida |
| `room_id` | `uuid FK` | Sala asociada |
| `status` | `text` | `active`, `paused`, `finished` |
| `current_round_id` | `uuid nullable` | Ronda actual |
| `started_at` | `timestamptz` | Inicio |
| `ended_at` | `timestamptz` | Fin |

FK:

- `room_id -> rooms.id`

### `rounds`

| Campo | Tipo | Descripcion |
|---|---|---|
| `id` | `uuid PK` | ID de ronda |
| `game_id` | `uuid FK` | Partida |
| `room_id` | `uuid FK` | Sala |
| `selected_user_id` | `uuid FK` | Jugador seleccionado |
| `type` | `text` | `truth`, `dare`, `punishment`, `vote` |
| `content_id` | `uuid` | ID de pregunta, reto o castigo |
| `status` | `text` | `pending`, `voting`, `completed` |
| `result` | `jsonb` | Resultado |
| `created_at` | `timestamptz` | Fecha |

FK:

- `game_id -> games.id`
- `room_id -> rooms.id`
- `selected_user_id -> users.id`

### `questions`

| Campo | Tipo | Descripcion |
|---|---|---|
| `id` | `uuid PK` | ID |
| `category` | `text` | Categoria |
| `content` | `text` | Texto de verdad |
| `intensity` | `text` | `low`, `medium`, `high` |
| `is_premium` | `boolean` | Premium |
| `created_by` | `uuid nullable` | Usuario/admin |
| `created_at` | `timestamptz` | Fecha |

### `dares`

| Campo | Tipo | Descripcion |
|---|---|---|
| `id` | `uuid PK` | ID |
| `category` | `text` | Categoria |
| `content` | `text` | Texto del reto |
| `difficulty` | `text` | `easy`, `medium`, `hard` |
| `is_premium` | `boolean` | Premium |
| `created_by` | `uuid nullable` | Usuario/admin |
| `created_at` | `timestamptz` | Fecha |

### `punishments`

| Campo | Tipo | Descripcion |
|---|---|---|
| `id` | `uuid PK` | ID |
| `category` | `text` | Categoria |
| `content` | `text` | Texto del castigo |
| `difficulty` | `text` | Nivel |
| `is_premium` | `boolean` | Premium |
| `created_at` | `timestamptz` | Fecha |

### `votes`

| Campo | Tipo | Descripcion |
|---|---|---|
| `id` | `uuid PK` | ID |
| `round_id` | `uuid FK` | Ronda |
| `room_id` | `uuid FK` | Sala |
| `voter_id` | `uuid FK` | Usuario que voto |
| `option_type` | `text` | `question`, `dare`, `punishment`, `player` |
| `option_id` | `uuid nullable` | ID de opcion |
| `value` | `text` | Valor del voto |
| `created_at` | `timestamptz` | Fecha |

FK:

- `round_id -> rounds.id`
- `room_id -> rooms.id`
- `voter_id -> users.id`

Unique:

- `(round_id, voter_id)`

### `rankings`

| Campo | Tipo | Descripcion |
|---|---|---|
| `id` | `uuid PK` | ID |
| `room_id` | `uuid FK` | Sala |
| `game_id` | `uuid FK` | Partida |
| `user_id` | `uuid FK` | Usuario |
| `points` | `int` | Puntos |
| `truths_answered` | `int` | Verdades respondidas |
| `dares_completed` | `int` | Retos completados |
| `punishments_completed` | `int` | Castigos completados |
| `updated_at` | `timestamptz` | Ultima actualizacion |

FK:

- `room_id -> rooms.id`
- `game_id -> games.id`
- `user_id -> users.id`

Unique:

- `(game_id, user_id)`

## 7. API Design

Las operaciones sensibles deben implementarse como Supabase Edge Functions.

### Crear sala

`POST /functions/v1/create-room`

Request:

```json
{
  "name": "Fiesta viernes",
  "category": "party",
  "max_players": 12
}
```

Response:

```json
{
  "room_id": "uuid",
  "room_code": "A7K92Q",
  "qr_value": "truthordare://room/A7K92Q",
  "status": "waiting"
}
```

### Unirse a sala

`POST /functions/v1/join-room`

Request:

```json
{
  "room_code": "A7K92Q",
  "display_name": "Carlos"
}
```

Response:

```json
{
  "room_id": "uuid",
  "member_id": "uuid",
  "status": "joined"
}
```

### Iniciar partida

`POST /functions/v1/start-game`

Request:

```json
{
  "room_id": "uuid"
}
```

Response:

```json
{
  "game_id": "uuid",
  "room_id": "uuid",
  "status": "active",
  "current_round": {
    "id": "uuid",
    "type": "truth"
  }
}
```

### Votar

`POST /functions/v1/cast-vote`

Request:

```json
{
  "room_id": "uuid",
  "round_id": "uuid",
  "option_type": "dare",
  "option_id": "uuid",
  "value": "selected"
}
```

Response:

```json
{
  "vote_id": "uuid",
  "round_id": "uuid",
  "status": "accepted"
}
```

### Obtener resultados

`GET /functions/v1/get-round-results?round_id=uuid`

Response:

```json
{
  "round_id": "uuid",
  "winner": {
    "option_type": "dare",
    "option_id": "uuid",
    "content": "Haz una imitacion durante 30 segundos"
  },
  "votes_count": 8,
  "results": [
    {
      "option_id": "uuid",
      "votes": 5
    },
    {
      "option_id": "uuid",
      "votes": 3
    }
  ]
}
```

### Obtener ranking

`GET /functions/v1/get-ranking?game_id=uuid`

Response:

```json
{
  "game_id": "uuid",
  "ranking": [
    {
      "user_id": "uuid",
      "display_name": "Ana",
      "points": 35,
      "position": 1
    },
    {
      "user_id": "uuid",
      "display_name": "Luis",
      "points": 22,
      "position": 2
    }
  ]
}
```

## 8. Realtime Design

### WebSockets

Supabase Realtime utiliza WebSockets para enviar cambios de PostgreSQL y broadcasts a los clientes conectados.

### Canales por sala

Cada sala debe tener su propio canal:

```text
room:{room_id}
```

Ejemplo:

```dart
final channel = supabase.channel('room:$roomId');
```

### Eventos principales

| Evento | Descripcion |
|---|---|
| `player_joined` | Nuevo jugador en sala |
| `player_left` | Jugador salio |
| `game_started` | Partida iniciada |
| `round_created` | Nueva ronda |
| `vote_casted` | Voto registrado |
| `round_results` | Resultado de ronda |
| `ranking_updated` | Ranking actualizado |
| `room_status_changed` | Cambio de estado |

### Implementacion recomendada

- Usar Postgres Changes para tablas como `room_members`, `rounds`, `votes` y `rankings`.
- Usar Broadcast para eventos de UI rapidos.
- Validar acciones criticas en Edge Functions.
- Suscribirse solo al canal de la sala actual.
- Cancelar suscripciones al salir de la sala.

Ejemplo conceptual:

```dart
supabase
  .channel('room:$roomId')
  .onPostgresChanges(
    event: PostgresChangeEvent.insert,
    schema: 'public',
    table: 'votes',
    filter: PostgresChangeFilter(
      type: PostgresChangeFilterType.eq,
      column: 'room_id',
      value: roomId,
    ),
    callback: (payload) {
      // Actualizar estado Riverpod
    },
  )
  .subscribe();
```

## 9. Flutter App Structure

```text
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── theme/
│   ├── utils/
│   └── config/
├── features/
│   ├── auth/
│   ├── rooms/
│   ├── lobby/
│   ├── game/
│   ├── voting/
│   ├── ranking/
│   ├── store/
│   └── admin/
├── shared/
│   ├── models/
│   ├── providers/
│   ├── extensions/
│   └── validators/
├── services/
│   ├── supabase_service.dart
│   ├── realtime_service.dart
│   ├── auth_service.dart
│   └── qr_service.dart
├── routes/
│   ├── app_router.dart
│   └── route_names.dart
├── widgets/
│   ├── app_button.dart
│   ├── app_text_field.dart
│   ├── loading_view.dart
│   └── error_view.dart
└── main.dart
```

### Responsabilidades

#### `core`

Contiene configuracion global, tema, constantes, manejo de errores y utilidades base.

#### `features`

Contiene los modulos funcionales de la aplicacion. Cada feature puede tener:

```text
data/
domain/
presentation/
providers/
```

Ejemplo:

```text
features/rooms/
├── data/
├── domain/
├── presentation/
└── providers/
```

#### `shared`

Contiene modelos, validadores, providers reutilizables y extensiones compartidas entre features.

#### `services`

Contiene integraciones externas y servicios tecnicos:

- Supabase client.
- Realtime subscriptions.
- Auth service.
- QR generation.
- Storage service.

#### `routes`

Gestiona rutas con GoRouter:

- splash
- login
- home
- create-room
- join-room
- lobby
- game
- ranking
- store
- admin

#### `widgets`

Componentes UI reutilizables y genericos.

## 10. Roadmap

### Fase 1: MVP

Objetivo: lanzar una version jugable y estable.

Incluye:

- Auth.
- Crear sala.
- Unirse por codigo.
- QR.
- Lobby realtime.
- Partida basica.
- Verdades, retos y castigos.
- Votaciones.
- Ranking.
- Categorias base.

### Fase 2: Premium

Objetivo: monetizar contenido y mejorar retencion.

Incluye:

- Suscripciones Premium.
- Paquetes de preguntas y retos.
- Categorias exclusivas.
- Avatares premium.
- Salas con mayor capacidad.
- Estadisticas avanzadas.

### Fase 3: IA generadora de retos

Objetivo: personalizar contenido.

Incluye:

- Generador de retos por contexto.
- Generador de verdades segun categoria.
- Filtros de seguridad.
- Moderacion automatica.
- Sugerencias segun historial del grupo.

### Fase 4: Escalamiento global

Objetivo: operar a gran escala.

Incluye:

- Multi-region.
- Traducciones.
- Analitica avanzada.
- Optimizacion de costos realtime.
- CDN para assets.
- Marketplace de paquetes.
- Herramientas avanzadas de administracion.

## 11. Riesgos y mitigaciones

### Moderacion de contenido

Riesgo: contenido ofensivo, sexual explicito, peligroso o inapropiado.

Mitigacion:

- Moderacion manual para contenido oficial.
- Filtros automaticos para contenido personalizado.
- Reportes de usuarios.
- Categorias con niveles de intensidad.
- Restricciones por edad si aplica.

### Usuarios toxicos

Riesgo: insultos, acoso o abuso dentro de salas.

Mitigacion:

- Host puede expulsar jugadores.
- Sistema de reportes.
- Bloqueo de usuarios.
- Modo sala privada.
- Historial minimo para investigar abuso.

### Costos de infraestructura

Riesgo: alto uso de Realtime y Edge Functions.

Mitigacion:

- Canales por sala.
- Payloads pequenos.
- Limites de jugadores por plan.
- Rate limiting.
- Optimizar consultas e indices.
- Monitorear uso por sala.

### Escalabilidad de tiempo real

Riesgo: muchas salas activas simultaneamente.

Mitigacion:

- Separar canales por `room_id`.
- Evitar broadcasts globales.
- Archivar salas finalizadas.
- Limpiar suscripciones al salir.
- Limitar frecuencia de eventos.

### Seguridad

Riesgo: manipulacion de votos, acceso indebido o acciones falsas de host.

Mitigacion:

- RLS en todas las tablas.
- Edge Functions para acciones sensibles.
- Validacion de host en backend.
- Unique constraints para votos.
- JWT validation.
- Logs de eventos criticos.

## 12. MVP Development Plan - 6 Semanas

### Semana 1: Setup y fundamentos

Objetivos:

- Crear proyecto Flutter.
- Configurar Riverpod.
- Configurar GoRouter.
- Crear proyecto Supabase.
- Configurar Auth.
- Definir tema base.
- Crear estructura del proyecto.

Entregables:

- Login y registro funcional.
- Navegacion principal.
- Supabase conectado.
- Estructura base lista.

### Semana 2: Salas y lobby

Objetivos:

- Crear tabla `rooms`.
- Crear tabla `room_members`.
- Implementar Edge Function `create-room`.
- Implementar Edge Function `join-room`.
- Crear pantalla de crear sala.
- Crear pantalla de unirse por codigo.
- Crear lobby realtime.

Entregables:

- Host crea sala.
- Jugadores se unen.
- Lista de jugadores sincronizada.
- Codigo de sala visible.

### Semana 3: Juego y rondas

Objetivos:

- Crear tablas `games` y `rounds`.
- Crear tablas `questions`, `dares`, `punishments`.
- Seed inicial de contenido.
- Implementar iniciar partida.
- Implementar seleccion de jugador.
- Implementar creacion de rondas.

Entregables:

- Host inicia partida.
- Se crea primera ronda.
- Jugadores ven la misma ronda en tiempo real.
- Contenido aparece segun categoria.

### Semana 4: Votaciones y resultados

Objetivos:

- Crear tabla `votes`.
- Implementar Edge Function `cast-vote`.
- Implementar calculo de resultados.
- Mostrar conteo de votos.
- Mostrar resultado ganador.
- Sincronizar eventos realtime.

Entregables:

- Jugadores votan una vez por ronda.
- Resultados visibles para todos.
- Validacion de votos duplicados.
- Flujo completo de ronda.

### Semana 5: Ranking y estadisticas

Objetivos:

- Crear tabla `rankings`.
- Implementar reglas de puntos.
- Actualizar ranking por ronda.
- Crear pantalla de ranking.
- Crear estadisticas basicas por jugador.

Entregables:

- Ranking en tiempo real.
- Puntos actualizados.
- Estadisticas basicas visibles.
- Finalizacion de partida.

### Semana 6: QA, seguridad y release MVP

Objetivos:

- Implementar RLS.
- Revisar Edge Functions.
- Pruebas en Android/iOS.
- Manejo de errores.
- Estados vacios y loading.
- Pulir UI.
- Preparar documentacion tecnica.
- Preparar release interno.

Entregables:

- MVP estable.
- Pruebas funcionales completas.
- Seguridad base aplicada.
- Build movil listo para beta.

## Resumen Ejecutivo

Truth or Dare App MVP debe enfocarse en una experiencia social rapida, mobile-first y sincronizada en tiempo real. La arquitectura Flutter + Supabase es adecuada para validar el producto rapidamente, con bajo costo inicial y buena capacidad de iteracion.

El MVP debe priorizar:

- Creacion y union a salas.
- Sincronizacion realtime confiable.
- Rondas de Verdad, Reto y Castigo.
- Votaciones grupales.
- Ranking basico.
- Seguridad mediante RLS y Edge Functions.

Las funcionalidades premium, IA y escalamiento global deben incorporarse despues de validar engagement, retencion y disposicion de pago.
