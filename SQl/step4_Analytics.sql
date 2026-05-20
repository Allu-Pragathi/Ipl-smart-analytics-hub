USE ipl_analytics;

CREATE OR REPLACE VIEW vw_season_summary AS
SELECT
    season,
    COUNT(*)                                                       AS total_matches,
    COUNT(DISTINCT team1)                                          AS teams_participated,
    SUM(CASE WHEN result = 'no result' THEN 1 ELSE 0 END)         AS no_result_matches,
    SUM(CASE WHEN result = 'runs'     THEN 1 ELSE 0 END)          AS won_batting_first,
    SUM(CASE WHEN result = 'wickets'  THEN 1 ELSE 0 END)          AS won_chasing
FROM matches
GROUP BY season
ORDER BY season;

CREATE OR REPLACE VIEW vw_team_record AS
SELECT
    team,
    COUNT(*)                                                       AS matches_played,
    SUM(CASE WHEN winner = team THEN 1 ELSE 0 END)                AS wins,
    SUM(CASE WHEN winner != team
             AND result != 'no result' THEN 1 ELSE 0 END)         AS losses,
    ROUND(
        SUM(CASE WHEN winner = team THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    )                                                              AS win_percentage
FROM (
    SELECT team1 AS team, match_id, winner, result FROM matches
    UNION ALL
    SELECT team2 AS team, match_id, winner, result FROM matches
) all_matches
GROUP BY team
ORDER BY win_percentage DESC;

CREATE OR REPLACE VIEW vw_batsman_stats AS
SELECT
    batter,
    COUNT(DISTINCT match_id)                                       AS matches,
    SUM(batsman_runs)                                              AS total_runs,
    ROUND(
        SUM(batsman_runs) * 100.0
        / NULLIF(SUM(CASE WHEN extras_type != 'wides'
                          OR extras_type IS NULL THEN 1 ELSE 0 END), 0), 2
    )                                                              AS strike_rate,
    SUM(CASE WHEN batsman_runs = 4 THEN 1 ELSE 0 END)             AS fours,
    SUM(CASE WHEN batsman_runs = 6 THEN 1 ELSE 0 END)             AS sixes,
    SUM(is_wicket)                                                 AS dismissals
FROM deliveries
GROUP BY batter
ORDER BY total_runs DESC;

CREATE OR REPLACE VIEW vw_bowler_stats AS
SELECT
    bowler,
    COUNT(DISTINCT match_id)                                       AS matches,
    ROUND(COUNT(*) / 6.0, 1)                                      AS overs_bowled,
    SUM(total_runs)                                                AS runs_conceded,
    SUM(CASE
        WHEN is_wicket = 1
        AND dismissal_kind NOT IN ('run out','retired hurt','obstructing the field')
        THEN 1 ELSE 0
    END)                                                           AS wickets,
    ROUND(SUM(total_runs) * 6.0 / NULLIF(COUNT(*), 0), 2)        AS economy_rate
FROM deliveries
GROUP BY bowler
ORDER BY wickets DESC;

CREATE OR REPLACE VIEW vw_venue_stats AS
SELECT
    m.venue,
    m.city,
    COUNT(*)                                                       AS matches_hosted,
    ROUND(AVG(d.match_total), 1)                                   AS avg_total_runs
FROM matches m
JOIN (
    SELECT match_id, SUM(total_runs) AS match_total
    FROM deliveries
    GROUP BY match_id
) d ON m.match_id = d.match_id
GROUP BY m.venue, m.city
ORDER BY matches_hosted DESC;

CREATE OR REPLACE VIEW vw_season_top_batsmen AS
SELECT season, batter, season_runs, rnk
FROM (
    SELECT
        m.season,
        d.batter,
        SUM(d.batsman_runs)                                        AS season_runs,
        RANK() OVER (
            PARTITION BY m.season
            ORDER BY SUM(d.batsman_runs) DESC
        )                                                          AS rnk
    FROM deliveries d
    JOIN matches m ON d.match_id = m.match_id
    GROUP BY m.season, d.batter
) ranked
WHERE rnk <= 10
ORDER BY season, rnk;

CREATE OR REPLACE VIEW vw_toss_advantage AS
SELECT
    toss_decision,
    COUNT(*)                                                       AS total_matches,
    SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END)         AS toss_winner_won,
    ROUND(
        SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    )                                                              AS win_after_toss_pct
FROM matches
WHERE result != 'no result'
GROUP BY toss_decision;

-- Verify all 6 views created
SHOW FULL TABLES WHERE Table_type = 'VIEW';