
-- Sprint 05: View for comparing movie ratings by genre
-- Each row represents one movie-genre-rating combination.

CREATE VIEW public.vw_top_rated_movies_by_genre
WITH (security_invoker = true)
AS
SELECT
    g.genre_name,
    m.movie_id,
    m.title,
    m.release_date,
    r.rating_source,
    r.rating_value
FROM public.movies AS m
JOIN public.movie_genres AS mg
    ON m.movie_id = mg.movie_id
JOIN public.genres AS g
    ON mg.genre_id = g.genre_id
JOIN public.ratings AS r
    ON m.movie_id = r.movie_id;

CREATE OR REPLACE FUNCTION public.fn_runtime_hours(
    runtime_minutes INTEGER
)
RETURNS NUMERIC
LANGUAGE SQL
IMMUTABLE
AS $$
    SELECT ROUND(runtime_minutes / 60.0, 2);
$$;

