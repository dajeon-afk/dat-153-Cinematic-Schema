# schema/

One `.sql` file per table, named after the table it creates (for example, `customer.sql` holds `CREATE TABLE customer` and its constraints, nothing else).

This folder records your **initial** schema from Sprint 03. After your first deployment, don't edit these files. Every later change goes into a new migration file under `supabase/migrations/`.
