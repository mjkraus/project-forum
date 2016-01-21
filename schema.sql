-- remove any records and start the id sequence back to 1
DROP TABLE IF EXISTS topics CASCADE;
DROP TABLE IF EXISTS threads CASCADE;
DROP TABLE IF EXISTS comments CASCADE;




-- documentation for psql tables http://www.postgresql.org/docs/9.3/static/ddl-constraints.html

CREATE TABLE topics(
 id 		SERIAL PRIMARY KEY,
 name 		VARCHAR NOT NULL
);

CREATE TABLE threads(
 id 		SERIAL PRIMARY KEY,
 title 		VARCHAR NOT NULL,
 msg 		TEXT NOT NULL,
 username 	VARCHAR,
 votes 		INTEGER,
 topics_id 	INTEGER REFERENCES topics(id)
);

CREATE TABLE comments(
 id 		SERIAL PRIMARY KEY,
 msg 		TEXT NOT NULL,
 username 	VARCHAR,
 date_created VARCHAR,
 thread_id  INTEGER REFERENCES threads(id)
);


-- psql -d project_forum_test -f schema.sql

-- create topics
INSERT INTO topics
  (name)
VALUES
  ('topic-1'),
  ('topic-2'),
  ('topic-3'),
  ('topic-4'),
  ('topic-5'),
  ('topic-6'),
  ('topic-7'),
  ('topic-8'),
  ('topic-9');        

-- create threads  
INSERT INTO threads
  (title, msg, username, votes, topics_id)
VALUES
  ('Hello','Mixtape schlitz mustache synth intelligentsia microdosing scenester marfa, sriracha cray bicycle rights ennui chartreuse cliche. Fashion axe wayfarers everyday carry celiac, helvetica you probably haven''t heard of them flexitarian.', 'Michael', 0, 4),
  ('Goodbye','Neutra actually williamsburg, truffaut normcore beard viral semiotics umami try-hard DIY.', 'Hannah', 5, 8),
  ('Something','Neutra actually williamsburg, truffaut normcore beard viral semiotics umami try-hard DIY.', 'Molly', 10, 5);

-- create comments
INSERT INTO comments
  (msg, username, date_created)
VALUES
  ('cool','Tanner', 10),
  ('loves it!','Pam', 11),
  ('Sweet!', 'Coco', 4);








