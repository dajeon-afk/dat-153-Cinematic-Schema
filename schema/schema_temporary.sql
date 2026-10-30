CREATE SCHEMA IF NOT EXISTS schema_temporary;
-- DROP SCHEMA IF EXISTS schema_temporary;

--the temporary tables inside the schema
CREATE TABLE IF NOT EXISTS schema_temporary.name_basics (
    nconst TEXT,
    "primaryName" TEXT,
    "birthYear" TEXT,
    "deathYear" TEXT,
    "primaryProfession" TEXT,
    "knownForTitles" TEXT
);

CREATE TABLE IF NOT EXISTS schema_temporary.title_akas (
    "titleId" TEXT,
    ordering TEXT,
    title TEXT,
    region TEXT,
    language TEXT,
    types TEXT,
    attributes TEXT,
    "isOriginalTitle" TEXT
);

CREATE TABLE IF NOT EXISTS schema_temporary.title_basics (
    tconst TEXT,
    "titleType" TEXT,
    "primaryTitle" TEXT,
    "originalTitle" TEXT,
    "isAdult" TEXT,
    "startYear" TEXT,
    "endYear" TEXT,
    "runtimeMinutes" TEXT,
    genres TEXT
);

CREATE TABLE IF NOT EXISTS schema_temporary.title_crew (
    tconst TEXT,
    directors TEXT,
    writers TEXT
);

CREATE TABLE IF NOT EXISTS schema_temporary.title_episode (
    tconst TEXT,
    "parentTconst" TEXT,
    "seasonNumber" TEXT,
    "episodeNumber" TEXT
);

CREATE TABLE IF NOT EXISTS schema_temporary.title_principals (
    tconst TEXT,
    ordering TEXT,
    nconst TEXT,
    category TEXT,
    job TEXT,
    characters TEXT
);

CREATE TABLE IF NOT EXISTS schema_temporary.title_ratings (
    tconst TEXT,
    "averageRating" TEXT,
    "numVotes" TEXT
);
