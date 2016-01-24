-- remove any records and start the id sequence back to 1
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS topics CASCADE;
DROP TABLE IF EXISTS threads CASCADE;
DROP TABLE IF EXISTS comments CASCADE;




-- documentation for psql tables http://www.postgresql.org/docs/9.3/static/ddl-constraints.html
CREATE TABLE users(
  id SERIAL PRIMARY KEY, 
  login_name VARCHAR,
  login_password_digest VARCHAR
);

CREATE TABLE topics(
 id 		SERIAL PRIMARY KEY,
 name 		VARCHAR NOT NULL
);

CREATE TABLE threads(
 id 		SERIAL PRIMARY KEY,
 title 		VARCHAR NOT NULL,
 msg 		TEXT NOT NULL,
 -- user_id 	VARCHAR REFERENCES users(id),
 username VARCHAR,
 votes 		INTEGER,
 topics_id 	INTEGER REFERENCES topics(id)
);

CREATE TABLE comments(
 id 		SERIAL PRIMARY KEY,
 msg 		TEXT NOT NULL,
 -- user_id 	VARCHAR REFERENCES users(id),
 username VARCHAR,
 date_created VARCHAR,
 thread_id  INTEGER REFERENCES threads(id)
);


-- psql -d project_forum_test -f schema.sql

-- create topics
INSERT INTO topics
  (name)
VALUES
  ('Should I get b-b-bangs?'),
  ('Bye Bye Bangs'),
  ('Styling Tricks'),
  ('Inspiration'),
  ('DIY Bangs'),
  ('Ugh oh!'),
  ('Fake It');        

-- create threads  
INSERT INTO threads
  (title, msg, username, votes, topics_id)
VALUES
  ('Need your help!','#HELLO#', 'sarah', 1000, 4),
  ('These are so perfect','*bongos*', 'hannah', 20, 7),
  ('Any suggestions?','*bongos*', 'molly', 10, 5),
  ('Need your help!','### An h3 header ### * carrots * celery * lentils', 'tanner', 100, 1),
  ('These are so perfect','*bongos*', 'sam', 3, 3),
  ('Any suggestions?','*bongos*', 'jessica', 25, 6),
  ('Need your help!','### An h3 header ### * carrots * celery * lentils', 'kayla', 33, 2),
  ('These are so perfect','*bongos*', 'jean', 11, 1),
  ('Any suggestions?','*bongos*', 'emily', 67, 7);

-- create comments
INSERT INTO comments
  (msg, username, date_created)
VALUES
  ('cool','Tanner', 10),
  ('loves it!','Pam', 11),
  ('Sweet!', 'Coco', 4);








