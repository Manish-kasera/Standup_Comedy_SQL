# Indian_Standup_Comedy
![My Logo](logo.jpeg)

## Overview
This project involves a comprehensive analysis of Indian Standup Comedian's data using SQL.
The goal is to extract valuable insights and answer the business question based on the dataset.
The following README.md provide a details account of the project's objective,business problem,
solution,findings,etc.

## Objective

- Comedian popularity and Engagement.
- Trend Analysis.
- Like-to-View and Comment-to-View ratio Analysis
- Content Performance.


## Dataset

The data for this project is sourced from the Kaggle dataset:
 
 **Dataset Link :** [Standup Dataset](https://www.kaggle.com/datasets/ravineesh/indian-standup-comedian)

## Schema

```sql
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
```


## BUSINESS PROBLEM AND SOLUTION

### 1. Retrieve the names of all comedians(channel_name) in the dataset and name must be in Asceding Order.

```sql
SELECT 
  DISTINCT channel_name AS Comedian
FROM indian_standup_comedians
ORDER BY channel_name ASC;  
```

### 2. Find the total number of videos uploaded by each comedian(channel_name) and sort From highest total video to lowest .

```sql
SELECT
  channel_name AS Comedian,
  COUNT(channel_name) total_number_of_videos
FROM indian_standup_comedians
GROUP BY Comedian 
ORDER BY total_number_of_videos DESC;
```

### 3. List the channel_name ,titles of videos,number of views that have more than 10,0000 views and sort highest to lowest.

```sql
SELECT 
    channel_name,
    video_title,
    view_count
 FROM indian_standup_comedians
 WHERE view_count > 100000
 ORDER BY view_count DESC;  
```

###  4. Retrieve the videos published in 2022.

```sql
 SELECT 
  channel_name,
  video_title,
    publishedAt 
FROM indian_standup_comedians
WHERE EXTRACT(YEAR FROM publishedAt) = 2022;
```

###  5. Find the total number of likes for a all comedian's sort by highest like to lowest like

```sql
 SELECT 
    channel_name AS Comedian,
    SUM(like_count) as total_number_of_like
FROM indian_standup_comedians
GROUP BY Comedian
ORDER BY total_number_of_like DESC;
```


### 6. List comedians who have uploaded more than 100 videos sort from highest total_number of videos to lowest 

```sql
SELECT 
   channel_name AS Comedian,
   COUNT(channel_name) as total_number_of_videos
FROM indian_standup_comedians
GROUP BY channel_name
HAVING total_number_of_videos > 100
ORDER BY total_number_of_videos DESC;   
```

### 7.Show the titles of videos with a view count higher than the average view count of all videos.

```sql
 SELECT 
   video_title,
   view_count 
FROM indian_standup_comedians
WHERE 
   view_count > (SELECT ROUND(AVG(view_count),2) AS avg_view FROM indian_standup_comedians);
```

### 8. Retrieve the channel_name,video titles and like counts of the top 3 videos with the highest like-to-view ratio.

```sql
SELECT 
  channel_name AS Comedian,
  video_title,
  ROUND((like_count / view_count),2) AS like_to_view_ratio
FROM indian_standup_comedians
ORDER BY like_to_view_ratio DESC
LIMIT 3;  
```

### 9. List all videos published in the 2021 and order them by the number of views in desc.

```sql
 SELECT 
   channel_name AS Comedian,
   video_title,
   view_count
 FROM indian_standup_comedians
 WHERE EXTRACT(YEAR FROM publishedAt) = 2021 
 ORDER BY view_count DESC;  
```

### 10. Identify comedians who have more than 20 videos with over 1 million views.Sort them by total count more than 1 million view

```sql
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
```
