-- Copied from https://github.com/IRus/sql-nastya (docker/progress.sql), which stays the source of truth.
-- Синхронизация прогресса между устройствами.
--
-- Файл идемпотентен: PostgreSQL выполняет его при создании пустой базы, и его
-- же можно применить к работающей базе, где схемы app ещё нет:
--   psql "$DATABASE_URL" -f docker/progress.sql
--
-- Роль ученика sql_nastya прав на схему app не получает: иначе прогресс
-- остальных читался бы обычным SELECT прямо из урока.

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'sql_nastya_app') THEN
    CREATE ROLE sql_nastya_app
      LOGIN
      PASSWORD 'sql_nastya_app'
      NOSUPERUSER
      NOCREATEDB
      NOCREATEROLE
      NOINHERIT;
  END IF;
END
$$;

CREATE SCHEMA IF NOT EXISTS app AUTHORIZATION postgres;

-- subject — устойчивый идентификатор из токена Cloudflare Access. Одна строка
-- на ученика: отметки о пройденных уроках и черновики запросов.
CREATE TABLE IF NOT EXISTS app.progress (
  subject    TEXT PRIMARY KEY,
  email      TEXT NOT NULL DEFAULT '',
  completed  JSONB NOT NULL DEFAULT '[]'::jsonb,
  drafts     JSONB NOT NULL DEFAULT '{}'::jsonb,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

REVOKE ALL ON SCHEMA app FROM PUBLIC;
REVOKE ALL ON app.progress FROM PUBLIC;

GRANT CONNECT ON DATABASE sql_nastya TO sql_nastya_app;
GRANT USAGE ON SCHEMA app TO sql_nastya_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON app.progress TO sql_nastya_app;
