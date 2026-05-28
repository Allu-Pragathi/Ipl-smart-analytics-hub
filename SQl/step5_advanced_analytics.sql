USE ipl_analytics;

-- QUERY 1: All-time top run scorers
SELECT
    RANK() OVER (ORDER BY SUM(batsman_runs) DESC)     AS `rank`,
    batter,
    COUNT(DISTINCT match_id)                           AS matches,
    SUM(batsman_runs)                                  AS total_runs,
    SUM(CASE WHEN batsman_runs = 6 THEN 1 ELSE 0 END) AS sixes,
    SUM(CASE WHEN batsman_runs = 4 THEN 1 ELSE 0 END) AS fours,
    ROUND(SUM(batsman_runs) * 100.0
        / NULLIF(SUM(CASE WHEN extras_type != 'wides'
                          OR extras_type IS NULL THEN 1 ELSE 0 END), 0), 2) AS strike_rate
FROM deliveries
GROUP BY batter
ORDER BY total_runs DESC
LIMIT 20;

-- QUERY 2: All-time top wicket takers
SELECT
    RANK() OVER (ORDER BY SUM(CASE
        WHEN is_wicket = 1
        AND dismissal_kind NOT IN ('run out','retired hurt','obstructing the field')
        THEN 1 ELSE 0 END) DESC
    )                                                  AS `rank`,
    bowler,
    COUNT(DISTINCT match_id)                           AS matches,
    SUM(CASE
        WHEN is_wicket = 1
        AND dismissal_kind NOT IN ('run out','retired hurt','obstructing the field')
        THEN 1 ELSE 0
    END)                                               AS wickets,
    ROUND(SUM(total_runs) * 6.0
        / NULLIF(COUNT(*), 0), 2)                      AS economy_rate
FROM deliveries
GROUP BY bowler
ORDER BY wickets DESC
LIMIT 20;

-- QUERY 3: Orange Cap — cumulative runs in a season
WITH season_runs AS (
    SELECT
        m.match_date,
        d.batter,
        SUM(d.batsman_runs) AS runs_in_match
    FROM deliveries d
    JOIN matches m ON d.match_id = m.match_id
    WHERE m.season = '2019'
    GROUP BY m.match_date, d.batter
)
SELECT
    batter,
    match_date,
    runs_in_match,
    SUM(runs_in_match) OVER (
        PARTITION BY batter
        ORDER BY match_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_runs
FROM season_runs
ORDER BY match_date, cumulative_runs DESC;

-- QUERY 4: Powerplay vs Middle vs Death overs
SELECT
    batting_team,
    SUM(CASE WHEN `over` BETWEEN 0  AND 5  THEN total_runs ELSE 0 END) AS powerplay_runs,
    SUM(CASE WHEN `over` BETWEEN 6  AND 14 THEN total_runs ELSE 0 END) AS middle_overs_runs,
    SUM(CASE WHEN `over` BETWEEN 15 AND 19 THEN total_runs ELSE 0 END) AS death_overs_runs,
    SUM(CASE WHEN `over` BETWEEN 0  AND 5
             AND is_wicket = 1 THEN 1 ELSE 0 END)                      AS powerplay_wickets,
    SUM(CASE WHEN `over` BETWEEN 15 AND 19
             AND is_wicket = 1 THEN 1 ELSE 0 END)                      AS death_wickets
FROM deliveries
GROUP BY batting_team
ORDER BY powerplay_runs DESC;

-- QUERY 5: Head-to-head MI vs CSK
SELECT
    match_id, season, match_date, venue,
    team1, team2, toss_winner, toss_decision,
    winner, result, result_margin
FROM matches
WHERE
    (team1 = 'Mumbai Indians' AND team2 = 'Chennai Super Kings')
    OR
    (team1 = 'Chennai Super Kings' AND team2 = 'Mumbai Indians')
ORDER BY match_date;

-- QUERY 6: Player of the Match leaderboard
SELECT
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `rank`,
    player_of_match,
    COUNT(*)                             AS pom_awards
FROM matches
WHERE player_of_match IS NOT NULL
GROUP BY player_of_match
ORDER BY pom_awards DESC
LIMIT 15;

-- QUERY 7: Win method per season
SELECT
    season,
    SUM(CASE WHEN result = 'runs'      THEN 1 ELSE 0 END) AS won_batting_first,
    SUM(CASE WHEN result = 'wickets'   THEN 1 ELSE 0 END) AS won_chasing,
    SUM(CASE WHEN result = 'tie'       THEN 1 ELSE 0 END) AS ties,
    SUM(CASE WHEN result = 'no result' THEN 1 ELSE 0 END) AS no_results,
    ROUND(AVG(CASE WHEN result = 'runs'
                   THEN result_margin END), 1)             AS avg_win_margin_runs,
    ROUND(AVG(CASE WHEN result = 'wickets'
                   THEN result_margin END), 1)             AS avg_win_margin_wkts
FROM matches
GROUP BY season
ORDER BY season;