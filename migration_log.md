# Migration Log

A running record of every schema change made to the live Supabase database after the initial deployment. Add a new entry each time you create a migration, newest at the bottom.

## 2026-10-21: Initial deployment

- **Migration file:** `supabase/migrations/20261021202441_initial_schema.sql`
- **What changed:** Created and successfully tested the initial database schema containing all 10 tables in the JupyterHub TEST database (cinematic_test).(every table in `schema/`).
- **Why:** To build a data base structure on data relating to movies.

## 2026-11-05: Add metadata columns and modified_at triggers

- **Migration file:** `supabase/migrations/<TIMESTAMP>_add_metadata_columns.sql`
- **What changed:** Added `created_at` and `modified_at` (TIMESTAMPTZ, NOT NULL, default `now()`) to all 10 tables in `public`: genres, movie_cast, movie_crew, movie_genres, movie_studios, movies, people, ratings, reviews, studios. Created one shared trigger function, `fn_set_modified_at()`, and attached a `tr_<table>_set_modified_at` BEFORE UPDATE trigger to each table.
- **Why:** Every production table should be able to answer "when did this row show up, and when did it last change?" The migration was applied before any data was loaded, so `created_at` reflects when each row was actually inserted, not when the migration ran. A trigger is needed for `modified_at` because a column default can't update itself on every change.
- **Verification:** Pushed to TEST (`cinema`). The assignment's checker query returned 0 rows. A test row inserted into `genres` and then updated kept the same `created_at`, and `modified_at` advanced. The test row was deleted afterward. PROD push: pending.