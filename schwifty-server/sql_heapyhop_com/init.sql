-- Copied from https://github.com/IRus/sql-nastya (docker/init.sql), which stays
-- the source of truth. Postgres runs it once, when pgdata is still empty, so
-- changes here only take effect on a fresh database.

-- Роль приложения намеренно не владеет базой и не может создавать постоянные
-- объекты. Учебные запросы работают только с временными таблицами сессии.
CREATE ROLE sql_nastya
  LOGIN
  PASSWORD 'sql_nastya'
  NOSUPERUSER
  NOCREATEDB
  NOCREATEROLE
  NOINHERIT;

REVOKE ALL ON DATABASE sql_nastya FROM PUBLIC;
GRANT CONNECT, TEMPORARY ON DATABASE sql_nastya TO sql_nastya;

REVOKE CREATE ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO sql_nastya;

-- Небольшая постоянная read-only схема для урока о полных именах таблиц.
-- Временная учебная схема тоже содержит customers, поэтому ученик должен
-- явно написать archive.customers.
CREATE SCHEMA archive AUTHORIZATION postgres;

CREATE TABLE archive.customers (
  id            INTEGER PRIMARY KEY,
  name          TEXT NOT NULL,
  city          TEXT NOT NULL,
  email         TEXT,
  registered_at DATE NOT NULL
);

INSERT INTO archive.customers (id, name, city, email, registered_at) VALUES
  (1, 'Алина Ветрова', 'Полоцк',   'alina.archive@example.com',  '2022-03-12'),
  (2, 'Максим Ильин',  'Бобруйск', 'maksim.archive@example.com', '2022-06-25'),
  (3, 'Нина Савина',   'Минск',    NULL,                         '2022-11-04');

REVOKE ALL ON SCHEMA archive FROM PUBLIC;
REVOKE ALL ON archive.customers FROM PUBLIC;
GRANT USAGE ON SCHEMA archive TO sql_nastya;
GRANT SELECT ON archive.customers TO sql_nastya;
