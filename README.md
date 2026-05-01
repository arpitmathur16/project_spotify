# Spotify Data Analysis Project

A end-to-end data analysis project exploring 8,582 Spotify tracks across 2,548 artists
and 4,869 albums — uncovering patterns in popularity, duration, explicitness, and artist
dominance using SQL, Python, and Excel.

---

## Project Overview

This project simulates a real-world music analytics workflow — from raw data cleaning to
advanced SQL querying, window functions, and professional Python visualizations built in
Jupyter Notebook. The dataset was explored through a storytelling approach, where each
analysis question connects to the next like chapters in an investigation — starting from
who rules the platform, down to which artists the algorithm has forgotten.

---

## Dataset

| Field        | Details                      |
|--------------|------------------------------|
| File         | spotify_data_clean.csv       |
| Total Rows   | 8,582 tracks                 |
| Source       | Spotify API (cleaned)        |

### Column Reference

| Column               | Description                              |
|----------------------|------------------------------------------|
| track_id             | Unique track identifier                  |
| track_name           | Name of the track                        |
| track_number         | Track position inside the album          |
| track_popularity     | Popularity score (0 to 100)              |
| explicit             | Whether track is explicit (TRUE / FALSE) |
| artist_name          | Artist name                              |
| artist_popularity    | Artist-level popularity score            |
| artist_followers     | Total number of artist followers         |
| artist_genres        | Genre tags associated with the artist    |
| album_id             | Unique album identifier                  |
| album_name           | Name of the album                        |
| album_release_date   | Release date of the album                |
| album_total_tracks   | Total tracks inside the album            |
| album_type           | album / single / compilation             |
| track_duration_min   | Track duration in minutes                |

---

## Project Structure

```
spotify-data-analysis/
│
├── spotify_data_clean.csv            # Cleaned dataset (attach when running on Colab)
├── README.md                         # Project documentation
│
├── sql/
│   ├── subquery_analysis.sql         # 10 storytelling subquery questions
│   └── window_functions.sql          # 10 window function questions
│
├── notebooks/
│   └── spotify_analysis.ipynb        # Full analysis notebook (run on Google Colab)
│
├── python/
│   ├── viz_top_artists.py            # Top 10 artists by avg popularity
│   ├── viz_explicit_pie.py           # Explicit vs non-explicit share
│   ├── viz_popularity_hist.py        # Popularity distribution histogram
│   ├── viz_followers_scatter.py      # Followers vs popularity scatter
│   ├── viz_duration_boxplot.py       # Duration by album type box plot
│   ├── viz_top5_followers.py         # Top 5 artists by follower count
│   ├── viz_tracks_over_years.py      # Music production trend line chart
│   ├── viz_explicit_grouped.py       # Explicit vs non-explicit grouped bar
│   ├── viz_duration_popularity.py    # Duration vs popularity scatter
│   ├── viz_top_albums.py             # Top 10 albums by avg popularity
│   └── viz_heatmap.py                # Correlation heatmap
│
└── outputs/
    └── *.png                         # All exported chart images
```

---

## Tech Stack

| Tool        | Version  | Usage                         |
|-------------|----------|-------------------------------|
| Python      | 3.x      | Data analysis & visualization |
| Pandas      | 2.x      | Data manipulation             |
| Matplotlib  | 3.x      | Charting & plotting           |
| Seaborn     | 0.x      | Statistical visualizations    |
| NumPy       | 1.x      | Numerical computation         |
| SQL         | MySQL    | Data querying & aggregation   |
| Excel / CSV | --       | Raw data source               |

---

## How to Run the Notebook on Google Colab

This project is designed to run on Google Colab without any local setup required.

Step 1 — Open Google Colab
```
https://colab.research.google.com
```

Step 2 — Upload the Notebook
- Click "File" > "Upload Notebook"
- Select `spotify_analysis.ipynb` from your local machine

Step 3 — Attach the Dataset
- Once the notebook is open, run the following cell first:

```python
from google.colab import files
uploaded = files.upload()    # Upload spotify_data_clean.csv when prompted
```

Step 4 — Load the Data
```python
import pandas as pd
df = pd.read_csv('spotify_data_clean.csv')
```

Step 5 — Run All Cells
- Click "Runtime" > "Run All"

Note: Make sure spotify_data_clean.csv is uploaded before running any analysis cells.
All required libraries (Pandas, Matplotlib, Seaborn, NumPy) are pre-installed on Colab.

---

## SQL Analysis

### Part 1 — Subquery Storytelling (10 Questions)

A connected investigation where each query builds on the answer of the previous one using
subqueries — structured as chapters of a story.

| Chapter | Question                                                              |
|---------|-----------------------------------------------------------------------|
| 1       | Who is the most popular artist on the platform?                       |
| 2       | What albums has the top artist released?                              |
| 3       | Which of their albums had the most tracks?                            |
| 4       | What is the most popular track from that biggest album?               |
| 5       | Is that track above the platform average popularity?                  |
| 6       | Which artists share the same genre as the top artist?                 |
| 7       | Among rival genre artists, who releases more explicit content?        |
| 8       | Which artists have an above-average track duration?                   |
| 9       | Do the longest-duration artists also have above-average followers?    |
| 10      | Who are the underrated artists — high followers but low popularity?   |

```sql
-- Chapter 5: Is the crown jewel above platform average?
SELECT track_name, track_popularity,
       (SELECT ROUND(AVG(track_popularity), 2) FROM spotify_data_clean) AS platform_avg,
       CASE
           WHEN track_popularity > (SELECT AVG(track_popularity) FROM spotify_data_clean)
           THEN 'Above Average'
           ELSE 'Below Average'
       END AS status
FROM spotify_data_clean
WHERE album_name = 'reputation Stadium Tour Surprise Song Playlist'
ORDER BY track_popularity DESC
LIMIT 1;
```

```sql
-- Chapter 10: Underrated artists — high followers, low max popularity
SELECT artist_name, artist_followers,
       MAX(track_popularity) AS best_track_popularity
FROM spotify_data_clean
GROUP BY artist_name, artist_followers
HAVING artist_followers > (SELECT AVG(artist_followers) FROM spotify_data_clean)
AND MAX(track_popularity) < (SELECT AVG(track_popularity) FROM spotify_data_clean)
ORDER BY artist_followers DESC;
```

---

### Part 2 — Window Functions (10 Questions)

Advanced analysis using ranking, running totals, lag/lead comparisons, and bucketing —
all without collapsing rows.

| Chapter | Window Function         | Question                                          |
|---------|-------------------------|---------------------------------------------------|
| 1       | RANK()                  | Global artist leaderboard by popularity           |
| 2       | RANK() + PARTITION BY   | Artist rank within their own genre                |
| 3       | ROW_NUMBER()            | Sequential track order inside each album          |
| 4       | DENSE_RANK()            | Each artist's single most popular track           |
| 5       | AVG() OVER              | How far each track is from its artist's average   |
| 6       | COUNT() OVER            | Running total of tracks per artist over time      |
| 7       | LAG()                   | Popularity of the previous track in the album     |
| 8       | LEAD()                  | Popularity of the next track in the album         |
| 9       | SUM() OVER              | Each track's percentage contribution to album     |
| 10      | NTILE(4)                | Splitting all tracks into 4 popularity tiers      |

```sql
-- Chapter 9: Track percentage contribution to album popularity
SELECT album_name, track_name, track_popularity,
       SUM(track_popularity) OVER (PARTITION BY album_name) AS album_total,
       ROUND(100.0 * track_popularity /
             SUM(track_popularity) OVER (PARTITION BY album_name), 2) AS pct_contribution
FROM spotify_data_clean;
```

```sql
-- Chapter 10: Popularity tiers using NTILE
SELECT track_name, artist_name, track_popularity,
       NTILE(4) OVER (ORDER BY track_popularity DESC) AS popularity_tier
FROM spotify_data_clean;
```

---

## Python Visualizations

All charts are built using the official Spotify color palette for visual consistency.

```python
SPOTIFY_GREEN  = '#1DB954'
SPOTIFY_BLACK  = '#191414'
SPOTIFY_WHITE  = '#FFFFFF'
SPOTIFY_GRAY   = '#B3B3B3'
SPOTIFY_YELLOW = '#F6C90E'
SPOTIFY_BLUE   = '#1EAAFF'
```

### Chart Summary

| No. | Chart Title                              | Type             | Key Insight                                 |
|-----|------------------------------------------|------------------|---------------------------------------------|
| 1   | Top 10 Artists by Avg Track Popularity   | Horizontal Bar   | HUNTR/X leads with 93.75 average score      |
| 2   | Explicit vs Non-Explicit Content Share   | Pie              | 25% of all tracks are explicit              |
| 3   | Track Popularity Distribution            | Histogram        | Majority of tracks score between 40 and 70  |
| 4   | Artist Followers vs Track Popularity     | Scatter          | Moderate positive correlation exists        |
| 5   | Track Duration by Album Type             | Box Plot         | Singles are shorter than albums on average  |
| 6   | Top 5 Artists by Follower Count          | Vertical Bar     | Taylor Swift leads with 145 million         |
| 7   | Music Production Volume Over Years       | Line             | Peak in 2025 with 765 tracks released       |
| 8   | Explicit vs Non-Explicit by Album Format | Grouped Bar      | Explicit tracks perform better in singles   |
| 9   | Track Duration vs Popularity             | Scatter + Color  | Very weak correlation (r = 0.11)            |
| 10  | Top 10 Albums by Avg Track Popularity    | Horizontal Bar   | Man I Need tops the chart at 95.0           |
| 11  | Feature Correlation Heatmap              | Heatmap          | Artist popularity is the strongest driver   |

---

## Key Findings

- Taylor Swift dominates the dataset with 145 million followers and 324 tracks — the most
  represented artist by a significant margin.

- Explicit tracks score slightly higher in average popularity despite representing only
  25 percent of the total catalog, suggesting listeners engage more with bold content.

- Song duration has minimal impact on track popularity with a correlation of only 0.11,
  meaning longer songs do not necessarily perform better.

- Artist popularity is the strongest predictor of track success with a correlation of 0.47,
  confirming that an artist's brand drives their music's performance more than any other factor.

- Music production peaked in 2025 with 765 tracks released, reflecting the continued growth
  of the streaming era and low barriers to publishing.

- A segment of underrated artists exists in the data — artists with above-average follower
  counts whose best tracks still fall below the platform's average popularity score.

---

## Quick Stats

```
Total Tracks          :  8,582
Unique Artists        :  2,548
Unique Albums         :  4,869
Average Popularity    :  52.36 out of 100
Average Duration      :  3.49 minutes
Explicit Tracks       :  2,148  (approx. 25%)
Top Artist            :  Taylor Swift  (145M followers)
Peak Release Year     :  2025  (765 tracks)
```

---

## Author

Arpit Mathur
BCA Graduate — Specialization in Artificial Intelligence
Skills: Python, SQL, Excel, Power BI, Data Analytics

LinkedIn: https://www.linkedin.com/in/arpit-mathur16

---

## License

This project is licensed under the MIT License.
Feel free to use, modify, and distribute with attribution.

---

"Without data, you are just another person with an opinion." 
