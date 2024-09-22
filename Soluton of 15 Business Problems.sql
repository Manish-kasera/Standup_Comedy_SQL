
-- 1. Retrieve the names of all comedians(channel_name) in the dataset 
-- and name must be in Asceding Order.

SELECT 
  DISTINCT channel_name AS Comedian
FROM indian_standup_comedians
ORDER BY channel_name ASC;  


-- 2. Find the total number of videos uploaded by each comedian(channel_name)
-- and sort From highest total video to lowest .
SELECT
  channel_name AS Comedian,
  COUNT(channel_name) total_number_of_videos
FROM indian_standup_comedians
GROUP BY Comedian 
ORDER BY total_number_of_videos DESC;


-- 3. List the channel_name ,titles of videos,number of views that have more than 10,0000 views
-- and sort highest to lowest.
 SELECT 
    channel_name,
    video_title,
    view_count
 FROM indian_standup_comedians
 WHERE view_count > 100000
 ORDER BY view_count DESC;  


-- 4. Retrieve the videos published in 2022.
 SELECT 
  channel_name,
  video_title,
    publishedAt 
FROM indian_standup_comedians
WHERE EXTRACT(YEAR FROM publishedAt) = 2022;

-- 5. Find the total number of likes for a all comedian's .
-- sort by highest like to lowest like
 SELECT 
    channel_name AS Comedian,
    SUM(like_count) as total_number_of_like
FROM indian_standup_comedians
GROUP BY Comedian
ORDER BY total_number_of_like DESC;



-- 6. List comedians who have uploaded more than 100 videos sort from highest total_number of videos to lowest

SELECT 
   channel_name AS Comedian,
   COUNT(channel_name) as total_number_of_videos
FROM indian_standup_comedians
GROUP BY channel_name
HAVING total_number_of_videos > 100
ORDER BY total_number_of_videos DESC;   


-- 7.Show the titles of videos with a view count higher than the average view count of all videos.
 SELECT 
   video_title,
   view_count 
FROM indian_standup_comedians
WHERE 
   view_count > (SELECT ROUND(AVG(view_count),2) AS avg_view FROM indian_standup_comedians);


-- 8. Retrieve the channel_name,video titles and like counts of the top 3 videos with the highest like-to-view ratio.
SELECT 
  channel_name AS Comedian,
  video_title,
  ROUND((like_count / view_count),2) AS like_to_view_ratio
FROM indian_standup_comedians
ORDER BY like_to_view_ratio DESC
LIMIT 3;  


-- 9. List all videos published in the 2021 and order them by the number of views in desc.
 SELECT 
   channel_name AS Comedian,
   video_title,
   view_count
 FROM indian_standup_comedians
 WHERE EXTRACT(YEAR FROM publishedAt) = 2021 
 ORDER BY view_count DESC;  


-- 10. Identify comedians who have more than 20 videos with over 1 million views.Sort them by total count more than 1 million view
WITH  comedian_views AS
(
SELECT 
  channel_name AS Comedian,
  view_count
FROM indian_standup_comedians
WHERE view_count > 1000000
)

SELECT 
  Comedian,
  COUNT(Comedian) as total_count_more_than_1_million_view
FROM comedian_views
GROUP BY Comedian
HAVING total_count_more_than_1_million_view > 20
ORDER BY total_count_more_than_1_million_view DESC;  



-- 11. Which comedian and its video title has the highest like-to-view ratio for their most recent video, and what is the ratio?
 WITH comedian_latest_video AS
 ( 
   SELECT 
     channel_name,
     video_title,
     like_count,
     view_count,
     publishedAt,
     RANK() OVER(
     PARTITION BY channel_name
     ORDER BY publishedAt DESC) as ranka
   FROM indian_standup_comedians
 )

 SELECT  
   channel_name,
   video_title,
   like_count / view_count as like_to_view_ratio
 FROM comedian_latest_video
 WHERE ranka = 1
 ORDER BY like_to_view_ratio DESC
 LIMIT 1;




-- 12. Identify comedians who have a higher total comment count in 2021 compared to 2020.
 WITH comedian_2021_comments AS
 (
   SELECT 
     channel_name AS Comedian,
   SUM(commentCount) AS total_comments_2021
   FROM indian_standup_comedians
   WHERE EXTRACT(YEAR FROM publishedAt) = 2021
   GROUP BY channel_name
 ),

 comedian_2020_comments AS
 (
   SELECT 
     channel_name AS Comedian,
   SUM(commentCount) AS total_comments_2020
   FROM indian_standup_comedians
   WHERE EXTRACT(YEAR FROM publishedAt) = 2020
   GROUP BY channel_name
 )
   
-- SELECT 
--   Comedian,
--   total_comments_2021
-- FROM  comedian_2021_comments AS C1
-- WHERE total_comments_2021 > 
-- (SELECT 
--    total_comments_2020 
-- FROM comedian_2020_comments AS C2
-- WHERE C1.Comedian  = C2.Comedian);

-- OR 
SELECT  
   C1.Comedian,
   total_comments_2021,
   total_comments_2020 
FROM comedian_2021_comments AS C1
INNER JOIN comedian_2020_comments AS C2
ON C1.Comedian = C2.Comedian
WHERE total_comments_2021 > total_comments_2020;




-- 13. For each comedian, calculate the average number of likes per video and 
-- compare it with the overall average of all comedians. List those who exceed the overall average.

WITH avg_like_all_comedian AS
(
  SELECT 
    AVG(like_count) AS overall_avg_all_comedian
  FROM indian_standup_comedians  
),

avg_like_each_comedian AS
(
SELECT 
  channel_name as Comedian,
  AVG(like_count) AS avg_like_per_video
FROM indian_standup_comedians 
GROUP BY Comedian
)

SELECT * FROM avg_like_each_comedian 
WHERE avg_like_per_video > (SELECT overall_avg_all_comedian FROM avg_like_all_comedian);




-- 14. Find the comedian who consistently gained more views over time 
-- (i.e., whose videos have an increasing view count trend over successive uploads).


 WITH ranked_videos AS (
    SELECT 
     channel_name AS Comedian, 
     video_title, 
     view_count, 
     publishedAt,
   ROW_NUMBER() OVER (
     PARTITION BY channel_name 
     ORDER BY publishedAt) AS video_rank
    FROM indian_standup_comedians
),

view_trend AS (
    SELECT 
      rv1.Comedian, 
      rv1.video_rank, 
      rv1.view_count, 
      rv2.view_count AS prev_view_count
    FROM ranked_videos rv1
    LEFT JOIN ranked_videos rv2
    ON rv1.Comedian = rv2.Comedian 
    AND rv1.video_rank = rv2.video_rank + 1
    WHERE rv2.view_count IS NOT NULL
)
SELECT Comedian
FROM view_trend
GROUP BY Comedian
HAVING COUNT(*) = SUM(CASE WHEN view_count > prev_view_count THEN 1 ELSE 0 END);

-- For checking purpose
-- SELECT 
--      channel_name AS Comedian, 
--      video_title, 
--      view_count, 
--      publishedAt,
-- 	 ROW_NUMBER() OVER (
--      PARTITION BY channel_name 
--      ORDER BY publishedAt) AS video_rank
-- FROM indian_standup_comedians
-- WHERE channel_name = 'Saurav Mehta';




-- 15. Determine the top 5 comedians who have shown the greatest improvement 
-- in like-to-view ratio from their earliest to latest video.

WITH Comedian_latest_video AS
(
  SELECT
    channel_name AS Comedian,
    (like_count/view_count) AS latest_like_to_view_ratio, 
    publishedAt,
    RANK() OVER(
    PARTITION BY channel_name
    ORDER BY publishedAt DESC) as ranka1
  FROM indian_standup_comedians
),

Comedian_earliest_video AS
(
  SELECT
    channel_name AS Comedian,
    (like_count/view_count) AS earliest_like_to_view_ratio, 
    publishedAt,
    RANK() OVER(
    PARTITION BY channel_name
    ORDER BY publishedAt ASC) as ranka2
  FROM indian_standup_comedians
)

SELECT 
   C1.Comedian,
   (latest_like_to_view_ratio - earliest_like_to_view_ratio) as ratio_improvement
FROM  Comedian_latest_video AS C1
INNER JOIN Comedian_earliest_video AS C2
ON C1.Comedian = C2.Comedian
AND ranka1 = 1 AND ranka2 = 1
ORDER BY ratio_improvement DESC
LIMIT 5;

