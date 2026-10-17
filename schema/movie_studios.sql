-- Many-to-many link: movies may have multiple production studios.
CREATE TABLE movie_studios (
    movie_id INTEGER NOT NULL REFERENCES movies(movie_id),
    studio_id INTEGER NOT NULL REFERENCES studios(studio_id),
    PRIMARY KEY (movie_id, studio_id)
);
