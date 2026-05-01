CREATE DATABASE SPOTIFY;

USE SPOTIFY;

SELECT * FROM spotify ;

-- Q1 - How many unique artists are in the dataset?

SELECT  COUNT(DISTINCT ARTIST_NAME)
FROM SPOTIFY;

-- Q2 - What is the average track popularity across all tracks?

SELECT AVG(track_popularity) AS POPULAR_TRACK
FROM SPOTIFY;

-- Q3 - What is the longest and shortest track duration in the dataset?

SELECT MAX(track_duration_min) AS LONGEST_TRACK, MIN(track_duration_min) AS SHORTEST_TRACK
FROM SPOTIFY;

-- Q4 - Which album type (single, album, compilation) has the highest average track popularity?

SELECT AVG(track_popularity) AS HIGHEST_AVG_TRACK
FROM SPOTIFY
ORDER BY track_popularity DESC;

-- Q5 - List all artists who have more than 5 tracks in the dataset, along with their track count.

SELECT COUNT(track_name) AS TOTAL_TRACKS , artist_name
FROM SPOTIFY
GROUP BY ARTIST_NAME
HAVING TOTAL_TRACKS >= 5
ORDER BY TOTAL_TRACKS DESC;

-- Q6 - Find genres where the average artist popularity is above 70, ordered by average popularity descending.

SELECT artist_name , AVG(artist_popularity) AS Popular_artist
FROM spotify
GROUP BY artist_name
HAVING AVG(artist_popularity) > 70
ORDER BY Popular_artist DESC;

-- Q7 - For each release year, how many tracks were released 
SELECT album_release_date, COUNT(DISTINCT track_name) AS TOTAL_TRACKS
FROM SPOTIFY
GROUP BY album_release_date
ORDER BY YEAR(album_release_date);

-- Q8 - What was their average popularity? Only show years with more than 10 tracks.

SELECT 
    YEAR(album_release_date) AS release_year,
    COUNT(DISTINCT track_name) AS total_track,
    AVG(track_popularity) AS avg_popularity
FROM SPOTIFY
GROUP BY YEAR(album_release_date)
HAVING COUNT(DISTINCT track_name) > 10
ORDER BY release_year;

-- Q9 - Among albums with at least 10 tracks, which has the highest total combined track popularity?

SELECT
    album_name,
    artist_name,
    COUNT(track_id)        AS track_count,
    SUM(track_popularity)  AS total_popularity
FROM spotify
GROUP BY album_name, artist_name
HAVING COUNT(track_id) >= 10
ORDER BY total_popularity DESC;

-- Q10 - Which artist has the largest gap between their highest and lowest track popularity?

SELECT artist_name,
	   MAX(track_popularity)  AS MAX_POP,
       MIN(track_popularity)  AS MIN_POP,
       MAX(track_popularity) - MIN(track_popularity) AS GAP_POP
FROM SPOTIFY
GROUP BY ARTIST_NAME
ORDER BY GAP_POP DESC;

-- Q11 - Find artists whose average follower count exceeds the dataset-wide average follower count.

SELECT artist_name, AVG(artist_followers) AS AVG_ARTIST_FOLLOWERS
FROM SPOTIFY
GROUP BY ARTIST_NAME
HAVING AVG(artist_followers) > (
SELECT AVG(artist_followers)
FROM SPOTIFY);

-- Q12 - Compare explicit vs non-explicit tracks across average duration, average popularity, and total count.

SELECT 
	explicit,
    COUNT(*) AS TOTAL_COUNT,
    AVG(track_duration_min),
    AVG(track_popularity)
FROM SPOTIFY
GROUP BY explicit;

-- Q13 - Find the top 3 artists by follower count and what percentage of the total follower base they represent.

SELECT 
	artist_name,
    artist_followers,
    ROUND( 100* artist_followers/ (SELECT SUM(artist_followers) FROM SPOTIFY), 2) AS PERCT_OF_FOLLOWERS
    FROM SPOTIFY
    ORDER BY artist_followers DESC
    LIMIT 3;
    
    
