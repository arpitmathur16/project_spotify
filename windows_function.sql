USE SPOTIFY;

-- Q1 - Before anything, you want a global leaderboard 
-- rank every artist by their popularity.

SELECT artist_name, artist_popularity,
RANK() OVER(ORDER BY artist_popularity DESC) AS popularity_rank
FROM SPOTIFY;

-- Q2 - Global rank is fine, but who is the king inside each genre?

SELECT artist_name, artist_genres, artist_popularity,
RANK() OVER(PARTITION BY artist_genres ORDER BY artist_popularity DESC) AS genre_rank
FROM SPOTIFY;

-- Q3 - Now zoom into albums — assign a row number to each track as
--  it appears in an album.

SELECT album_name, track_name, track_number,
ROW_NUMBER() OVER(PARTITION BY album_name ORDER BY track_number) AS TRACK_POSITION
FROM SPOTIFY;

-- Q4 - For every artist, flag which of their tracks
--  sits at position #1 by popularity.

SELECT track_popularity, artist_name, track_name,
DENSE_RANK() OVER(PARTITION BY artist_name ORDER BY track_popularity DESC) AS TRACK_RANK
FROM spotify;

-- Q5 - You want to know — is each track performing above
--  or below that artist's own average?

SELECT artist_name, track_name, track_popularity,
ROUND(AVG(track_popularity) OVER(PARTITION BY artist_name), 2) AS ARTIST_AVG,
track_popularity - ROUND(AVG(track_popularity) OVER(PARTITION BY artist_name), 2) AS GAP
FROM SPOTIFY;

-- Q6 - As you scroll through an artist's discography,
-- how many tracks have been counted so far?

SELECT artist_name, track_name, album_name,
COUNT(*) OVER(PARTITION BY album_name ORDER BY album_release_date DESC) AS RUNNING_TRACK_COUNT
FROM SPOTIFY;

-- Q7 - For each track, look back — what was the popularity of the track
-- that came before it in the same album?

SELECT album_name, track_name, track_popularity, 
LAG(track_popularity) OVER (PARTITION BY album_name ORDER BY track_number) AS PREV_TRACK_POPULARITY
FROM SPOTIFY;

-- Q8 - Flip it — for each track, 
-- what is the popularity of the next track in the album?

SELECT album_name, track_number, track_popularity, artist_name,
LEAD(track_popularity) OVER (PARTITION BY album_name ORDER BY track_number) AS NEXT_TRACK_POPULARITY
FROM SPOTIFY;

-- Q9 - What Percent of Popularity Does Each Track Hold in Its Album?

SELECT album_name, track_name, track_popularity,
SUM(track_popularity) OVER(PARTITION BY album_name) AS ALBUM_TOTAL_POPULARITY,
ROUND(100.0 * track_popularity / SUM(track_popularity) OVER (PARTITION BY album_name), 2) AS PCT_CONTRIBUTION
FROM SPOTIFY;

-- Q10 - Finally, divide all tracks into 4 equal groups — 
-- from the least to the most popular. Who sits in the elite tier?

SELECT track_name, artist_name, track_popularity,
NTILE(4) OVER(ORDER BY track_popularity DESC) AS POPULARITY_TIER
FROM SPOTIFY;
