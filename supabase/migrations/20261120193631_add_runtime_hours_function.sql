CREATE OR REPLACE FUNCTION public.fn_runtime_hours(
    runtime_minutes INTEGER
)
RETURNS NUMERIC
LANGUAGE SQL
IMMUTABLE
AS $$
    SELECT ROUND(runtime_minutes / 60.0, 2);
$$;



