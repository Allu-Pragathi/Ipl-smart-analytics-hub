USE ipl_analytics;

LOAD DATA LOCAL INFILE 'C:/studies/sem 6/Companies Resume/Ipl-Smart-analytics-hub/Data/matches.csv'
INTO TABLE matches
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    match_id, season, city, @raw_date,
    match_type, player_of_match, venue,
    team1, team2, toss_winner, toss_decision,
    winner, result, @result_margin,
    @target_runs, @target_overs, super_over,
    method, umpire1, umpire2
)
SET
    match_date    = STR_TO_DATE(@raw_date, '%Y-%m-%d'),
    result_margin = CASE WHEN @result_margin REGEXP '^[0-9]+$'
                    THEN CAST(@result_margin AS UNSIGNED) ELSE 0 END,
    target_runs   = CASE WHEN @target_runs REGEXP '^[0-9]+$'
                    THEN CAST(@target_runs AS UNSIGNED) ELSE 0 END,
    target_overs  = CASE WHEN @target_overs REGEXP '^[0-9.]+$'
                    THEN CAST(@target_overs AS DECIMAL(5,1)) ELSE 0 END;

LOAD DATA LOCAL INFILE 'C:/studies/sem 6/Companies Resume/Ipl-Smart-analytics-hub/Data/deliveries.csv'
INTO TABLE deliveries
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    match_id, inning, batting_team, bowling_team,
    `over`, ball, batter, bowler, non_striker,
    batsman_runs, extra_runs, total_runs,
    @extras_type, is_wicket,
    @player_dismissed, @dismissal_kind, @fielder
)
SET
    extras_type      = NULLIF(@extras_type,      'NA'),
    player_dismissed = NULLIF(@player_dismissed, 'NA'),
    dismissal_kind   = NULLIF(@dismissal_kind,   'NA'),
    fielder          = NULLIF(@fielder,           'NA');

-- Verify
SELECT 'matches'    AS table_name, COUNT(*) AS total_rows FROM matches
UNION ALL
SELECT 'deliveries' AS table_name, COUNT(*) AS total_rows FROM deliveries;