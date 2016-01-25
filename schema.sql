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
 -- date_created VARCHAR,
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
  ('Uh oh!');        

-- create threads  
INSERT INTO threads
  (title, msg, username, votes, topics_id)
VALUES
  ('My fringe is in my eyes','#HELLO Im trying to grow out my bangs, but they are at that length where they are always in my eyes. **HELP!** Any ideas? ![me](https://s-media-cache-ak0.pinimg.com/736x/31/57/64/315764d91a5e819c0e5eb6f0772417b1.jpg)', 'emily', 100, 2),
  ('These are so perfect','I need to cut my bangs **IMMEDIATELY** ![inspiration](http://97.74.65.162/wp-content/uploads-c/2011/11/BANG-BOOM-POW-3.jpg)', 'hannah', 20, 4),
  ('I need your opinion','Hello! Im growing out my bangs and worried about how they will turn out. So I took a photo at home beforehand.![opinion](http://upload.enewsworld.net/News/Contents/20140408/70012029.jpg)', 'sarah', 1000, 2),
  ('What do you think?','Should I get bangs? Im worried about the upkeep. ![me](https://ak-hdl.buzzfed.com/static/2015-10/26/10/enhanced/webdr07/grid-cell-27450-1445871496-6.jpg)', 'emily', 105, 1),
  ('This is how I trim my bangs','![tape fringe](https://itshannabrooks.files.wordpress.com/2011/07/tape.png)', 'sam', 200, 5),
  ('HELP!!','**HELP** I cut my bangs myself, do they look ok? ![my bangs](http://4.bp.blogspot.com/-zIZM5kAuZA8/Ty1gWGZrxII/AAAAAAAAAsk/C7VZCmx6JTw/s1600/bangs2.png)', 'jessica', 25, 6),
  ('This is the cool style in Japan','Who doesnt want to show her love for her fringe? ![heart bangs](https://i.kinja-img.com/gawker-media/image/upload/xsncq17zr38kjqhjzx9k.png)', 'kayla', 33, 3),
  ('Should I do it?','I think I am ready to get bangs. What style should I go for? ![me](https://intothegloss.com/wp-content/uploads3/2014/02/mackenzie-2-613x481.jpg)', 'jean', 11, 1),
  ('Love these','What do you think? ![perfection](http://www.prettydesigns.com/wp-content/uploads/2013/12/Bella-Thorne-Long-Hairstyle-Hair-Knot-with-Slightly-Side-Bangs.jpg)', 'emily', 67, 4);

-- create comments
INSERT INTO comments
  (msg, username, thread_id)
VALUES
  ('Clip them up','Elizabeth', 1),
  ('try a headband','Mary', 1),
  ('try clipping them to the side with a bobby pin. Always cute','Kim', 1),
  ('AGREE!','Bliss', 2),
  ('I want those!','Lauren', 2),
  ('I think you look great either way!','Hannah', 3),
  ('I am going to miss your fringe','kelsey', 3),
  ('ALWAYS SAY YES TO FRINGE!','Laura', 4),
  ('Obviously!','tegan', 4),
  ('HAHA! Love it!','Laura', 5),
  ('GREAT IDEA!','tegan', 5),
  ('OMG! LOL!','megan', 5),
  ('They are perfect!','tegan', 6),
  ('How did you get them so perfect?','jenny', 6),
  ('Adorable!','kim', 7),
  ('Showing the love!','Liz', 7),
  ('TOO CUTE!','ainsley', 7),
  ('side bangs for sure','marcia', 8),
  ('I agree. Side bangs.','michelle', 8),
  ('LOVE! LOVE! LOVE!','ashley', 9),
  ('me too!!','jessica', 9);



