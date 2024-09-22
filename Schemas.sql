CREATE Database standup_db;

USE standup_db;

DROP TABLE indian_standup_comedians;

CREATE TABLE indian_standup_comedians
(
 channel_name varchar(200), 
 video_id varchar(100), 
 video_type varchar(200), 
 video_title VARCHAR(400), 
 view_count INT,  
 like_count INT, 
 dislike_count INT, 
 favoriteCount INT, 
 commentCount INT, 
 publishedAt varchar(100)
) ;
