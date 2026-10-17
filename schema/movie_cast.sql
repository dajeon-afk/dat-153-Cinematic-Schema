-- One row per performer per movie; character_name may be unavailable.
CREATE TABLE movie_cast (
    movie_id INTEGER NOT NULL REFERENCES movies(movie_id),
    person_id INTEGER NOT NULL REFERENCES people(person_id),
    character_name VARCHAR(250),
    PRIMARY KEY (movie_id, person_id)
);
