USE SPOTIFY;

-- Q1 - First, you want to know the most popular artist on the platform.

SELECT
	artist_name, MAX(artist_popularity)
    FROM SPOTIFY
    GROUP BY artist_name;
    
-- Q2 - Now that you know the top artist, find all albums they have released.

SELECT DISTINCT album_name, album_release_date, album_type
FROM SPOTIFY
WHERE artist_name = ( 
	SELECT artist_name
	FROM SPOTIFY
	ORDER BY artist_popularity DESC
    LIMIT 1
);

-- Q3 - Among all their albums, which one had the most tracks?

SELECT album_name, album_total_tracks
FROM SPOTIFY
WHERE album_total_tracks = (SELECT MAX(album_total_tracks)
FROM SPOTIFY)
ORDER BY album_total_tracks DESC;

-- Q4 - From that biggest album, find the single most popular track.

SELECT track_popularity, track_name, track_duration_min
FROM SPOTIFY
WHERE album_id = (SELECT album_id 
					FROM SPOTIFY
                    GROUP BY album_id
                    ORDER BY COUNT(track_id) DESC
                    LIMIT 1)
ORDER BY track_popularity DESC
LIMIT 1;

-- Q4 - You wonder — is this track's popularity actually above the platform average?

SELECT 
    track_popularity, track_id, artist_name
FROM SPOTIFY
WHERE album_id = (
        SELECT album_id 
        FROM SPOTIFY
        GROUP BY album_id
        ORDER BY COUNT(track_id) DESC
        LIMIT 1
    )
AND track_popularity = (
        SELECT MAX(track_popularity)
        FROM SPOTIFY
        WHERE album_id = (
            SELECT album_id
            FROM SPOTIFY
            GROUP BY album_id
            ORDER BY COUNT(track_id) DESC
            LIMIT 1
        )
    )
AND track_popularity > (
        SELECT AVG(track_popularity)
        FROM SPOTIFY
    );
    
-- Q5 - You now look for other artists who share the same genre as the top artist.

SELECT DISTINCT artist_name, artist_genres, artist_popularity
FROM SPOTIFY
WHERE artist_genres = (
    SELECT artist_genres
    FROM SPOTIFY
    ORDER BY artist_popularity DESC
    LIMIT 1
)
AND artist_name != (
    SELECT artist_name
    FROM SPOTIFY
    ORDER BY artist_popularity DESC
    LIMIT 1
);
-- No other artist has that exact same genre string, so the result is empty.

-- Q6 - Among rival genre artists, which ones release more explicit content?

SELECT artist_name,
       COUNT(*) AS total_tracks,
       COUNT(NULLIF(explicit, 'FALSE')) AS explicit_tracks
FROM SPOTIFY
WHERE artist_genres LIKE '%pop%'
AND artist_name != (
    SELECT artist_name
    FROM SPOTIFY
    ORDER BY artist_popularity DESC
    LIMIT 1
)
GROUP BY artist_name
ORDER BY explicit_tracks DESC;

-- Q7 - Curious if longer songs are a power move — find artists whose avg duration beats the platform average.

SELECT artist_name,
		ROUND(AVG(track_duration_min), 2) AS AVG_DURATION
	FROM SPOTIFY
GROUP BY artist_name
HAVING AVG_DURATION > (SELECT AVG(track_duration_min)
FROM SPOTIFY)
ORDER BY AVG_DURATION DESC;

-- Q8 - Check if the longest-avg-duration artist also has above-average followers.

SELECT artist_name, artist_followers,
		(SELECT AVG(artist_followers) 
        FROM SPOTIFY) AS AVG_FOLLOWERS,
        CASE
			WHEN artist_followers > (SELECT AVG(artist_popularity) FROM SPOTIFY)
            THEN 'ABOVE AVERAGE'
            ELSE 'BELOW AVERAGE'
		END AS follower_status
FROM SPOTIFY
WHERE artist_name = (SELECT artist_name
					FROM SPOTIFY
                    GROUP BY artist_name
                    ORDER BY AVG(artist_followers) DESC
                    LIMIT 1)
LIMIT 1;

-- Q9 - Finally, you search for underrated artists —
-- high followers but low track popularity — the ones the algorithm forgot.

SELECT artist_name, artist_followers,
		max(track_popularity) AS BEST_TRACKS
        FROM SPOTIFY
GROUP BY artist_name, artist_followers
HAVING artist_followers > (SELECT AVG(artist_followers) FROM SPOTIFY)
AND MAX(track_popularity) > (SELECT AVG(track_popularity) AS SPOTIFY)
ORDER BY artist_followers DESC;
