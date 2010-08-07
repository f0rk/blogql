DROP TABLE posts;
DROP SEQUENCE post_id_seq;

CREATE SEQUENCE post_id_seq;

CREATE TABLE posts (
    id INTEGER NOT NULL PRIMARY KEY DEFAULT nextval('post_id_seq'),
    datetime TIMESTAMP NOT NULL,
    year INTEGER NOT NULL,
    month INTEGER NOT NULL,
    title TEXT NOT NULL,
    urltitle VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    author TEXT NOT NULL
);
