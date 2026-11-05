BEGIN;

-- Rerunnable: clear children first, then people.
DELETE FROM movie_cast;
DELETE FROM movie_crew;
DELETE FROM people;

-- nm0000001 -> 1, the same ID rule used for movies (tt0000009 -> 9).
INSERT INTO people (person_id, name)
SELECT DISTINCT ON (nb.nconst)
       CAST(SUBSTRING(nb.nconst FROM 3) AS integer),
       nb."primaryName"
FROM schema_temporary.name_basics AS nb
WHERE nb.nconst ~ '^nm\d+$'
  AND nb."primaryName" IS NOT NULL
  AND nb."primaryName" <> '\N'
  AND nb.nconst IN (
      SELECT tp.nconst
      FROM schema_temporary.title_principals AS tp
      JOIN movies AS m
        ON m.movie_id = CASE WHEN tp.tconst ~ '^tt\d+$'
                             THEN CAST(SUBSTRING(tp.tconst FROM 3) AS integer) END
  )
ORDER BY nb.nconst;

COMMIT;