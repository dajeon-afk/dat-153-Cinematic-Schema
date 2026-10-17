-- Job is part of the key so a person can hold multiple crew roles on one movie.
CREATE TABLE movie_crew (
    movie_id INTEGER NOT NULL REFERENCES movies(movie_id),
    person_id INTEGER NOT NULL REFERENCES people(person_id),
    job VARCHAR(150) NOT NULL,
    PRIMARY KEY (movie_id, person_id, job)
);
