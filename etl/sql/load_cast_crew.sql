BEGIN;

DELETE FROM movie_cast;
DELETE FROM movie_crew;

-- Cast: actors and actresses only. Joins to movies and people keep foreign keys valid.
INSERT INTO movie_cast (movie_id, person_id, character_name)
SELECT DISTINCT ON (m.movie_id, p.person_id)
       m.movie_id, p.person_id,
       CASE WHEN tp.characters IN ('\N', '') THEN NULL
            ELSE replace(regexp_replace(tp.characters, '^\["|"\]$', '', 'g'), '","', ', ')
       END
FROM schema_temporary.title_principals AS tp
JOIN movies AS m ON tp.tconst ~ '^tt\d+$'
                AND m.movie_id = CAST(SUBSTRING(tp.tconst FROM 3) AS integer)
JOIN people AS p ON tp.nconst ~ '^nm\d+$'
                AND p.person_id = CAST(SUBSTRING(tp.nconst FROM 3) AS integer)
WHERE tp.category IN ('actor', 'actress')
ORDER BY m.movie_id, p.person_id;

-- Crew: everyone else, with the category as the job.
INSERT INTO movie_crew (movie_id, person_id, job)
SELECT DISTINCT m.movie_id, p.person_id, tp.category
FROM schema_temporary.title_principals AS tp
JOIN movies AS m ON tp.tconst ~ '^tt\d+$'
                AND m.movie_id = CAST(SUBSTRING(tp.tconst FROM 3) AS integer)
JOIN people AS p ON tp.nconst ~ '^nm\d+$'
                AND p.person_id = CAST(SUBSTRING(tp.nconst FROM 3) AS integer)
WHERE tp.category NOT IN ('actor', 'actress')
  AND tp.category IS NOT NULL AND tp.category <> '\N';

COMMIT;