-- Sets modified_at to the current time on every UPDATE.
-- Shared by every table in the public schema.
CREATE FUNCTION fn_set_modified_at()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.modified_at = now();
    RETURN NEW;
END;
$$;

ALTER TABLE genres
    ADD COLUMN created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    ADD COLUMN modified_at TIMESTAMPTZ NOT NULL DEFAULT now();
CREATE TRIGGER tr_genres_set_modified_at
BEFORE UPDATE ON genres
FOR EACH ROW EXECUTE FUNCTION fn_set_modified_at();

ALTER TABLE movie_cast
    ADD COLUMN created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    ADD COLUMN modified_at TIMESTAMPTZ NOT NULL DEFAULT now();
CREATE TRIGGER tr_movie_cast_set_modified_at
BEFORE UPDATE ON movie_cast
FOR EACH ROW EXECUTE FUNCTION fn_set_modified_at();

ALTER TABLE movie_crew
    ADD COLUMN created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    ADD COLUMN modified_at TIMESTAMPTZ NOT NULL DEFAULT now();
CREATE TRIGGER tr_movie_crew_set_modified_at
BEFORE UPDATE ON movie_crew
FOR EACH ROW EXECUTE FUNCTION fn_set_modified_at();

ALTER TABLE movie_genres
    ADD COLUMN created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    ADD COLUMN modified_at TIMESTAMPTZ NOT NULL DEFAULT now();
CREATE TRIGGER tr_movie_genres_set_modified_at
BEFORE UPDATE ON movie_genres
FOR EACH ROW EXECUTE FUNCTION fn_set_modified_at();

ALTER TABLE movie_studios
    ADD COLUMN created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    ADD COLUMN modified_at TIMESTAMPTZ NOT NULL DEFAULT now();
CREATE TRIGGER tr_movie_studios_set_modified_at
BEFORE UPDATE ON movie_studios
FOR EACH ROW EXECUTE FUNCTION fn_set_modified_at();

ALTER TABLE movies
    ADD COLUMN created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    ADD COLUMN modified_at TIMESTAMPTZ NOT NULL DEFAULT now();
CREATE TRIGGER tr_movies_set_modified_at
BEFORE UPDATE ON movies
FOR EACH ROW EXECUTE FUNCTION fn_set_modified_at();

ALTER TABLE people
    ADD COLUMN created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    ADD COLUMN modified_at TIMESTAMPTZ NOT NULL DEFAULT now();
CREATE TRIGGER tr_people_set_modified_at
BEFORE UPDATE ON people
FOR EACH ROW EXECUTE FUNCTION fn_set_modified_at();

ALTER TABLE ratings
    ADD COLUMN created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    ADD COLUMN modified_at TIMESTAMPTZ NOT NULL DEFAULT now();
CREATE TRIGGER tr_ratings_set_modified_at
BEFORE UPDATE ON ratings
FOR EACH ROW EXECUTE FUNCTION fn_set_modified_at();

ALTER TABLE reviews
    ADD COLUMN created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    ADD COLUMN modified_at TIMESTAMPTZ NOT NULL DEFAULT now();
CREATE TRIGGER tr_reviews_set_modified_at
BEFORE UPDATE ON reviews
FOR EACH ROW EXECUTE FUNCTION fn_set_modified_at();

ALTER TABLE studios
    ADD COLUMN created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    ADD COLUMN modified_at TIMESTAMPTZ NOT NULL DEFAULT now();
CREATE TRIGGER tr_studios_set_modified_at
BEFORE UPDATE ON studios
FOR EACH ROW EXECUTE FUNCTION fn_set_modified_at();