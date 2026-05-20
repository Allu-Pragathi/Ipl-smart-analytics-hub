-- ============================================================
--  IPL SMART ANALYTICS HUB
--  Step 3: Data Cleaning & Standardization
--  Tool   : MySQL Workbench 8.0
-- ============================================================

USE ipl_analytics;

-- ============================================================
--  3A. DATA QUALITY CHECKS
-- ============================================================
SELECT
    SUM(CASE WHEN winner IS NULL THEN 1 ELSE 0 END)          AS null_winners,
    SUM(CASE WHEN match_date IS NULL THEN 1 ELSE 0 END)       AS null_dates,
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END)             AS null_city,
    SUM(CASE WHEN player_of_match IS NULL THEN 1 ELSE 0 END)  AS null_pom
FROM matches;

SELECT MIN(season) AS first_season, MAX(season) AS last_season,
       COUNT(DISTINCT season) AS total_seasons
FROM matches;

-- ============================================================
--  3B. DISABLE SAFE UPDATE MODE
-- ============================================================
SET SQL_SAFE_UPDATES = 0;

-- ============================================================
--  3C. FIX TEAM NAMES
-- ============================================================

-- Delhi Daredevils → Delhi Capitals (renamed 2019)
UPDATE matches SET team1       = 'Delhi Capitals' WHERE team1       LIKE '%Daredevils%';
UPDATE matches SET team2       = 'Delhi Capitals' WHERE team2       LIKE '%Daredevils%';
UPDATE matches SET winner      = 'Delhi Capitals' WHERE winner      LIKE '%Daredevils%';
UPDATE matches SET toss_winner = 'Delhi Capitals' WHERE toss_winner LIKE '%Daredevils%';
UPDATE deliveries SET batting_team = 'Delhi Capitals' WHERE batting_team LIKE '%Daredevils%';
UPDATE deliveries SET bowling_team = 'Delhi Capitals' WHERE bowling_team LIKE '%Daredevils%';

-- Kings XI Punjab → Punjab Kings (renamed 2021)
UPDATE matches SET team1       = 'Punjab Kings' WHERE team1       LIKE '%Kings XI%';
UPDATE matches SET team2       = 'Punjab Kings' WHERE team2       LIKE '%Kings XI%';
UPDATE matches SET winner      = 'Punjab Kings' WHERE winner      LIKE '%Kings XI%';
UPDATE matches SET toss_winner = 'Punjab Kings' WHERE toss_winner LIKE '%Kings XI%';
UPDATE deliveries SET batting_team = 'Punjab Kings' WHERE batting_team LIKE '%Kings XI%';
UPDATE deliveries SET bowling_team = 'Punjab Kings' WHERE bowling_team LIKE '%Kings XI%';

-- Rising Pune Supergiants → Rising Pune Supergiant
UPDATE matches SET team1       = 'Rising Pune Supergiant' WHERE team1       LIKE '%Supergiants%';
UPDATE matches SET team2       = 'Rising Pune Supergiant' WHERE team2       LIKE '%Supergiants%';
UPDATE matches SET winner      = 'Rising Pune Supergiant' WHERE winner      LIKE '%Supergiants%';
UPDATE matches SET toss_winner = 'Rising Pune Supergiant' WHERE toss_winner LIKE '%Supergiants%';
UPDATE deliveries SET batting_team = 'Rising Pune Supergiant' WHERE batting_team LIKE '%Supergiants%';
UPDATE deliveries SET bowling_team = 'Rising Pune Supergiant' WHERE bowling_team LIKE '%Supergiants%';

-- Royal Challengers Bangalore → Royal Challengers Bengaluru
UPDATE matches SET team1       = 'Royal Challengers Bengaluru' WHERE team1       LIKE '%Bangalore%';
UPDATE matches SET team2       = 'Royal Challengers Bengaluru' WHERE team2       LIKE '%Bangalore%';
UPDATE matches SET winner      = 'Royal Challengers Bengaluru' WHERE winner      LIKE '%Bangalore%';
UPDATE matches SET toss_winner = 'Royal Challengers Bengaluru' WHERE toss_winner LIKE '%Bangalore%';
UPDATE deliveries SET batting_team = 'Royal Challengers Bengaluru' WHERE batting_team LIKE '%Bangalore%';
UPDATE deliveries SET bowling_team = 'Royal Challengers Bengaluru' WHERE bowling_team LIKE '%Bangalore%';

-- ============================================================
--  3D. FIX NULL CITIES
-- ============================================================
UPDATE matches
SET city = CASE
    WHEN venue LIKE '%Wankhede%'          THEN 'Mumbai'
    WHEN venue LIKE '%Eden Gardens%'      THEN 'Kolkata'
    WHEN venue LIKE '%Chinnaswamy%'       THEN 'Bengaluru'
    WHEN venue LIKE '%Feroz Shah Kotla%'  THEN 'Delhi'
    WHEN venue LIKE '%Arun Jaitley%'      THEN 'Delhi'
    WHEN venue LIKE '%Chepauk%'           THEN 'Chennai'
    WHEN venue LIKE '%Rajiv Gandhi%'      THEN 'Hyderabad'
    WHEN venue LIKE '%Sawai Mansingh%'    THEN 'Jaipur'
    WHEN venue LIKE '%Brabourne%'         THEN 'Mumbai'
    WHEN venue LIKE '%Dubai%'             THEN 'Dubai'
    WHEN venue LIKE '%Abu Dhabi%'         THEN 'Abu Dhabi'
    WHEN venue LIKE '%Sharjah%'           THEN 'Sharjah'
    WHEN venue LIKE '%Narendra Modi%'     THEN 'Ahmedabad'
    WHEN venue LIKE '%DY Patil%'          THEN 'Mumbai'
    WHEN venue LIKE '%Ekana%'             THEN 'Lucknow'
    ELSE city
END
WHERE city IS NULL OR city = '';

-- ============================================================
--  3E. RE-ENABLE SAFE MODE
-- ============================================================
SET SQL_SAFE_UPDATES = 1;

-- ============================================================
--  3F. VERIFY
-- ============================================================
SELECT COUNT(*) AS still_null_city FROM matches WHERE city IS NULL;

SELECT DISTINCT team1 AS team FROM matches
UNION
SELECT DISTINCT team2 FROM matches
ORDER BY team;