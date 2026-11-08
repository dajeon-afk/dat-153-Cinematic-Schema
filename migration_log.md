# Migration Log

A running record of every schema change made to the live Supabase database after the initial deployment. Add a new entry each time you create a migration, newest at the bottom.

## 2026-10-21: Initial deployment

- **Migration file:** `supabase/migrations/20261021202441_initial_schema.sql`
- **What changed:** Created and successfully tested the initial database schema containing all 10 tables in the JupyterHub TEST database (cinematic_test).(every table in `schema/`).
- **Why:** To build a data base structure on data relating to movies.

## 2026-11-05: Add metadata columns and modified_at triggers

- **Migration file:** `supabase/migrations/20261105150057_add_metadata_columns.sql`
- **What changed:** Added `created_at` and `modified_at` (TIMESTAMPTZ, NOT NULL, default `now()`) to all 10 tables in `public`: genres, movie_cast, movie_crew, movie_genres, movie_studios, movies, people, ratings, reviews, studios. Created one shared trigger function, `fn_set_modified_at()`, which sets `modified_at` to `now()`. Attached a `tr_<table>_set_modified_at` BEFORE UPDATE trigger to each table, 10 in total.
- **Why:** Every production table now shows when the row was first created and changed. 
- **Verification:** Pushed to TEST. The assignment's checker query returned 0 rows, so every table has both columns. A test row inserted into `genres` and then updated kept the same `created_at`, and `modified_at` advanced. The test row was deleted afterward. 