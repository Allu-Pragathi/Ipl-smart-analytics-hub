CREATE DATABASE IF NOT EXISTS ipl_analytics;
USE ipl_analytics;

CREATE TABLE matches (
    match_id         INT           PRIMARY KEY,
    season           VARCHAR(10),
    city             VARCHAR(100),
    match_date       DATE,
    match_type       VARCHAR(50),
    player_of_match  VARCHAR(100),
    venue            VARCHAR(150),
    team1            VARCHAR(100),
    team2            VARCHAR(100),
    toss_winner      VARCHAR(100),
    toss_decision    VARCHAR(10),
    winner           VARCHAR(100),
    result           VARCHAR(20),
    result_margin    INT           DEFAULT 0,
    target_runs      INT           DEFAULT 0,
    target_overs     FLOAT         DEFAULT 0,
    super_over       VARCHAR(5),
    method           VARCHAR(10),
    umpire1          VARCHAR(100),
    umpire2          VARCHAR(100)
);

CREATE TABLE deliveries (
    match_id          INT,
    inning            INT,
    batting_team      VARCHAR(100),
    bowling_team      VARCHAR(100),
    `over`            INT,
    ball              INT,
    batter            VARCHAR(100),
    bowler            VARCHAR(100),
    non_striker       VARCHAR(100),
    batsman_runs      INT           DEFAULT 0,
    extra_runs        INT           DEFAULT 0,
    total_runs        INT           DEFAULT 0,
    extras_type       VARCHAR(20),
    is_wicket         INT           DEFAULT 0,
    player_dismissed  VARCHAR(100),
    dismissal_kind    VARCHAR(50),
    fielder           VARCHAR(100)
);

CREATE INDEX idx_matches_season       ON matches(season);
CREATE INDEX idx_matches_winner       ON matches(winner);
CREATE INDEX idx_matches_city         ON matches(city);
CREATE INDEX idx_deliveries_match_id  ON deliveries(match_id);
CREATE INDEX idx_deliveries_batter    ON deliveries(batter);
CREATE INDEX idx_deliveries_bowler    ON deliveries(bowler);
CREATE INDEX idx_deliveries_bat_team  ON deliveries(batting_team);
CREATE INDEX idx_deliveries_bowl_team ON deliveries(bowling_team);

SHOW TABLES;
