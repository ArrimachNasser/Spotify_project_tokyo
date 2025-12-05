USE spotify_project;

SELECT *
FROM artists;

SELECT *
FROM genre;

SELECT * FROM Genre ORDER BY genre_id;

SELECT *
FROM songs;

-- EXPLORATORY ANALYSIS
-- ==================================================================================
-- Top 10 LEAST Popular Songs
SELECT song_title, popularity
FROM Songs
ORDER BY popularity ASC
LIMIT 10;
-- The songs with lower popularity scores (typically 70-85).

-- Top 10 Most Popular Songs
SELECT song_title, popularity
FROM Songs
ORDER BY popularity DESC
LIMIT 10;
-- Identifies the songs with the highest popularity scores (90+).

-- JOINING SONGS AND ARTISTS
SELECT  
    s.song_title, 
    s.popularity, 
    a.artist_name 
FROM Songs s 
JOIN Artists a ON s.artist_id = a.artist_id 
ORDER BY s.popularity DESC 
LIMIT 10;
-- Replaces numeric artist_id with actual artist names.

-- JOIN Songs + Artists + Genre
SELECT  
    s.song_title, 
    s.popularity, 
    a.artist_name,
    g.genre_name,
    s.energy,
    s.danceability
FROM Songs s 
JOIN Artists a ON s.artist_id = a.artist_id 
JOIN Genre g ON s.genre_id = g.genre_id
ORDER BY s.popularity DESC 
LIMIT 10;

-- Popularity Statistics
SELECT
	ROUND(AVG(popularity), 2) as popularity_mean,
    MIN(popularity) as min_popularity,
    MAX(popularity) as max_popularity,
    ROUND(stddev(popularity), 2) as standard_deviation,
    COUNT(*) total_songs
FROM Songs;
-- The Top 50 songs of 2019 show a relatively tight distribution of popularity scores, with an average of 87.50 and a standard deviation of only 4.45. 
-- This low variability indicates that songs in the Top 50 are fairly homogeneous in terms of their success metrics, with 68% of songs falling between 83 and 92 in popularity. 
-- The range spans from 70 (position 50) to 95 (position 1), representing a 25-point spread. 
-- This narrow distribution suggests that even small differences in musical characteristics between the Top 10 and positions 40-50 may be meaningful indicators of what elevates a song from a moderate hit to a mega hit.

-- Statistics on All Musical Features
SELECT
 ROUND(AVG(energy), 2) as avg_energy,
 ROUND(AVG(danceability), 2) as avg_danceability,
 ROUND(AVG(loudness), 2) as avg_loudness,
 ROUND(AVG(liveness), 2) as avg_liveness,
 ROUND(AVG(valence), 2) as avg_valence,
 ROUND(AVG(length_ms), 2) as avg_duration,
 ROUND(AVG(bpm), 2) as avg_bpm,
 ROUND(AVG(accousticness), 2) as avg_accousticness,
 ROUND(AVG(speechiness), 2) as avg_speechiness
FROM Songs;
 -- The average Top 50 song in 2019 exhibits several consistent characteristics: high danceability (71.38), moderate energy (64.06), very loud mastering (-5.66 dB), and predominantly electronic production (acousticness: 22.16). 
 -- With an average tempo of 120 BPM and neutral valence (54.60), these songs strike a balance between being energetic enough to capture attention while remaining accessible to broad audiences. 
--  The low liveness score (14.66) confirms these are studio-polished productions rather than live recordings, reflecting modern streaming platform standards. 
 -- Notably, high danceability and competitive loudness emerge as defining features of commercial success..
 
-- Number of Songs per Genre
SELECT
    g.genre_name,
    COUNT(s.song_id) as songs_count
FROM Genre g
LEFT JOIN Songs s ON s.genre_id = g.genre_id
GROUP BY g.genre_name
ORDER BY songs_count DESC;
-- Pop dominates the Top 50 in 2019

-- Average Popularity by Genre
SELECT
	g.genre_name,
    COUNT(*) as songs_count,
    ROUND(AVG(s.popularity), 2) as popularity_mean,
    ROUND(AVG(s.energy), 2) AS energy_mean,
    MIN(popularity) as min_popularity,
    MAX(popularity) as max_popularity
FROM Songs s
JOIN Genre g ON s.genre_id = g.genre_id
GROUP BY g.genre_name
ORDER BY popularity_mean DESC;
-- Insight: Genre distribution across 5 genres

-- Pop dominates by volume (48%) but has the lowest average quality (85.50)
-- Wide range (70-95) shows high inconsistency - includes both #1 song (95) and bottom songs (70-85)

-- Rap delivers the highest quality (91.00 avg) with only 5 songs (10%)
-- Narrow range (87-94) = most consistent genre - every rap song is a strong performer

-- EDM shows second-highest quality (89.50 avg) with 4 songs (8%)
-- Consistent range (88-92) = reliable hit maker despite small presence

-- Latin maintains strong balance: 10 songs (20%) with high quality (89.40 avg)
-- Most energetic genre (74.50 avg energy)
-- Range (83-93) shows consistent performance

-- Hip Hop solid performer: 7 songs (14%) with good quality (88.00 avg)
-- Moderate energy (66.29) and consistent range (84-91)

-- Comparison collab vs single
SELECT
	CASE WHEN collaboration = 1 THEN 'Collaboration' ELSE 'Single' END as type,
	COUNT(*) as songs_count,
    ROUND(AVG(popularity), 2) as popularity_mean,
    ROUND(AVG(energy), 2) AS energy_mean,
    ROUND(AVG(danceability), 2) as avg_danceability
FROM Songs
GROUP BY Collaboration;
-- INSIGHT: Singles are MORE popular than collaborations by +1.47 points
-- Collaborations have higher energy (+4.09) and danceability (+2.36)

-- SONGS BY POPULARITY LEVEL

SELECT
	song_title,
    popularity,
    CASE	
		WHEN popularity >= 90 THEN 'Very popular'
        WHEN popularity >= 85 THEN 'popular'
        ELSE 'Less popular'
	END as popularity_level
FROM Songs
ORDER BY popularity DESC;

-- Loudness Impact on Popularity
SELECT
    CASE	
		WHEN loudness >= -5 THEN 'high loudness'
        WHEN loudness >= -7 THEN 'Loud'
        ELSE 'Low loudness'
	END as loudness_level,
    COUNT(*) as songs_count,
    ROUND(AVG(popularity), 2) as popularity_mean
FROM Songs
GROUP BY 
	CASE
		WHEN loudness >= -5 THEN 'high loudness'
        WHEN loudness >= -7 THEN 'Loud'
        ELSE 'Low loudness'
	END
ORDER BY popularity_mean DESC;

-- INSIGHTS

-- Observation 1: Low loudness songs have slightly higher popularity (87.86)
-- But the difference is minimal (0.11 points vs high loudness), With only 7 songs in this category, this could be random variation

-- Observation 2: Most songs (24 out of 50) are in "high loudness" category
-- This suggests loud production is the industry standard, But it doesn't guarantee higher popularity

-- Observation 3: The "Loud" middle category has lowest popularity (87.05)
-- But again, less than 1 point difference, Not meaningful

-- So, Loudness is NOT a key factor for chart success
