#  Spotify Data Analysis Project

> A end-to-end data analysis project exploring **8,582 Spotify tracks** across **2,548 artists** and **4,869 albums** — uncovering patterns in popularity, duration, explicitness, and artist dominance using **SQL**, **Python**, and **Excel**.

---

##  Project Overview

This project simulates a real-world music analytics workflow — from raw data cleaning to advanced SQL querying, window functions, and professional Python visualizations. The dataset was explored through a **storytelling approach**, where each analysis question connects to the next like chapters in an investigation.

---

## 📂 Dataset

| Field | Details |
|-------|---------|
| **File** | `spotify_data_clean.csv` |
| **Rows** | 8,582 tracks |
| **Source** | Spotify API (cleaned) |

### Columns

| Column | Description |
|--------|-------------|
| `track_id` | Unique track identifier |
| `track_name` | Name of the track |
| `track_number` | Track position in album |
| `track_popularity` | Popularity score (0–100) |
| `explicit` | Whether track is explicit (TRUE/FALSE) |
| `artist_name` | Artist name |
| `artist_popularity` | Artist popularity score |
| `artist_followers` | Total artist followers |
| `artist_genres` | Genre tags |
| `album_id` | Unique album identifier |
| `album_name` | Album name |
| `album_release_date` | Release date |
| `album_total_tracks` | Total tracks in album |
| `album_type` | album / single / compilation |
| `track_duration_min` | Track duration in minutes |

---

## 🗂️ Project Structure

```
spotify-data-analysis/
│
├── 📄 spotify_data_clean.csv       # Cleaned dataset
├── 📄 README.md                    # Project documentation
│
├── 📁 sql/
│   ├── subquery_analysis.sql       # 10 storytelling subquery questions
│   └── window_functions.sql        # 10 window function questions
│
├── 📁 python/
│   ├── eda.py                      # Exploratory data analysis
│   ├── viz_top_artists.py          # Top 10 artists bar chart
│   ├── viz_explicit_pie.py         # Explicit vs non-explicit pie chart
│   ├── viz_popularity_hist.py      # Popularity distribution histogram
│   ├── viz_followers_scatter.py    # Followers vs popularity scatter
│   ├── viz_duration_boxplot.py     # Duration by album type box plot
│   ├── viz_top5_followers.py       # Top 5 artists by followers
│   ├── viz_tracks_over_years.py    # Music production trend line chart
│   ├── viz_explicit_grouped.py     # Explicit vs non-explicit grouped bar
│   ├── viz_duration_popularity.py  # Duration vs popularity scatter
│   ├── viz_top_albums.py           # Top 10 albums by avg popularity
│   └── viz_heatmap.py              # Correlation heatmap
│
└── 📁 outputs/
    └── *.png                       # All exported chart images
```

---

##  Tech Stack

| Tool | Usage |
|------|-------|
| ![Python](https://img.shields.io/badge/Python-3.x-blue) | Data analysis & visualization |
| ![Pandas](https://img.shields.io/badge/Pandas-2.x-lightblue) | Data manipulation |
| ![Matplotlib](https://img.shields.io/badge/Matplotlib-3.x-orange) | Charting |
| ![Seaborn](https://img.shields.io/badge/Seaborn-0.x-teal) | Statistical plots |
| ![NumPy](https://img.shields.io/badge/NumPy-1.x-yellow) | Numerical operations |
| ![SQL](https://img.shields.io/badge/SQL-MySQL-red) | Data querying |
| ![Excel](https://img.shields.io/badge/Excel-CSV-green) | Raw data source |

---

##  SQL Analysis

### 📖 Part 1 — Sub_queries Storytelling (10 Questions)

A connected investigation where each query builds on the previous one using subqueries.

| Chapter | Question |
|---------|----------|
| 1 | Who is the most popular artist on the platform? |
| 2 | What albums has the top artist released? |
| 3 | Which album had the most tracks? |
| 4 | What is the most popular track from that album? |
| 5 | Is that track above the platform average popularity? |
| 6 | Which artists share the same genre as the top artist? |
| 7 | Among rival genre artists, who releases more explicit content? |
| 8 | Which artists have above-average track duration? |
| 9 | Do the longest-duration artists also have above-average followers? |
| 10 | Who are the underrated artists — high followers but low popularity? |

```sql
-- Example: Chapter 5 — Is the track above platform average?
SELECT track_name, track_popularity,
       (SELECT ROUND(AVG(track_popularity), 2) FROM spotify_data_clean) AS platform_avg,
       CASE
           WHEN track_popularity > (SELECT AVG(track_popularity) FROM spotify_data_clean)
           THEN 'Above Average '
           ELSE 'Below Average '
       END AS status
FROM spotify_data_clean
WHERE album_name = 'reputation Stadium Tour Surprise Song Playlist'
ORDER BY track_popularity DESC
LIMIT 1;
```

---

###  Part 2 — Window Functions (10 Questions)

Advanced ranking, comparison, and movement analysis using window functions.

| Chapter | Function | Question |
|---------|----------|----------|
| 1 | `RANK()` | Global artist leaderboard |
| 2 | `RANK() + PARTITION BY` | Artist rank within genre |
| 3 | `ROW_NUMBER()` | Track order inside each album |
| 4 | `DENSE_RANK()` | Each artist's most popular track |
| 5 | `AVG() OVER` | Track performance vs artist's own average |
| 6 | `COUNT() OVER` | Running total of tracks per artist |
| 7 | `LAG()` | Previous track's popularity in album |
| 8 | `LEAD()` | Next track's popularity in album |
| 9 | `SUM() OVER` | Each track's % contribution to album popularity |
| 10 | `NTILE(4)` | Popularity tiers across all tracks |

```sql
-- Example: Chapter 9 — Track % contribution to album popularity
SELECT album_name, track_name, track_popularity,
       SUM(track_popularity) OVER (PARTITION BY album_name) AS album_total,
       ROUND(100.0 * track_popularity /
             SUM(track_popularity) OVER (PARTITION BY album_name), 2) AS pct_contribution
FROM spotify_data_clean;
```

---

## 📊 Python Visualizations

All charts use the **official Spotify color palette** for consistency:

```python
SPOTIFY_GREEN  = '#1DB954'
SPOTIFY_BLACK  = '#191414'
SPOTIFY_WHITE  = '#FFFFFF'
SPOTIFY_GRAY   = '#B3B3B3'
SPOTIFY_YELLOW = '#F6C90E'
SPOTIFY_BLUE   = '#1EAAFF'
```

### Charts Produced

| # | Chart | Type | Key Insight |
|---|-------|------|-------------|
| 1 | Top 10 Artists by Avg Popularity | Horizontal Bar | HUNTR/X leads with 93.75 avg |
| 2 | Explicit vs Non-Explicit | Pie | ~25% of tracks are explicit |
| 3 | Popularity Distribution | Histogram | Majority score between 40–70 |
| 4 | Followers vs Popularity | Scatter | Moderate positive correlation |
| 5 | Duration by Album Type | Box Plot | Singles are shorter than albums |
| 6 | Top 5 Artists by Followers | Vertical Bar | Taylor Swift leads at 145M |
| 7 | Tracks Released Over Years | Line | Peak in 2025 with 765 tracks |
| 8 | Explicit vs Non-Explicit by Format | Grouped Bar | Explicit performs better in singles |
| 9 | Duration vs Popularity | Scatter | Weak correlation (r = 0.11) |
| 10 | Top 10 Albums by Avg Popularity | Horizontal Bar | "Man I Need" tops at 95.0 |
| 11 | Correlation Heatmap | Heatmap | Artist popularity drives track success |

---

##  Key Insights

-  **Taylor Swift** dominates with **145M followers** and **324 tracks** — the most represented artist.
-  **Explicit tracks** score slightly **higher popularity** on average despite being only 25% of the catalog.
-  **Song duration has minimal impact** on popularity (r = 0.11) — listeners don't reward longer songs.
-  **Artist popularity is the strongest predictor** of track success (r = 0.47).
-  **Music production peaked in 2025** with 765 tracks — the streaming era drives continuous growth.
-  **Underrated artists** exist — high follower counts but consistently low track popularity scores.

---

##  How to Run

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/spotify-data-analysis.git
cd spotify-data-analysis
```

### 2. Install Dependencies
```bash
pip install pandas matplotlib seaborn numpy
```

### 3. Run Any Chart
```bash
python python/viz_top_artists.py
```

### 4. Run SQL Queries
Import `spotify_data_clean.csv` into MySQL / PostgreSQL and run queries from the `sql/` folder.

---

##  Sample Output

```
Total Tracks     : 8,582
Unique Artists   : 2,548
Unique Albums    : 4,869
Avg Popularity   : 52.36 / 100
Avg Duration     : 3.49 minutes
Explicit Tracks  : 2,148 (25%)
Top Artist       : Taylor Swift (145M followers)
Peak Year        : 2025 (765 tracks)
```

---

##  Author

**Arpit Mathur**
BCA Graduate | Data Analytics | Python · SQL · Power BI · Excel

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue)](https://linkedin.com/in/yourprofile)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black)](https://github.com/yourusername)

---

##  License

This project is licensed under the MIT License.

---

> *"Without data, you're just another person with an opinion."*
