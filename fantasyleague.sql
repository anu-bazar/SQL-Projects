-- Create tables
CREATE TABLE Teams (
    TeamID INT PRIMARY KEY,
    TeamName VARCHAR(255),
    TeamColor VARCHAR(255),
    TeamMascot VARCHAR(255)
);

CREATE TABLE Players (
    PlayerID INT PRIMARY KEY,
    PlayerName VARCHAR(255),
    TeamID INT,
    Position VARCHAR(255),
    Age INT,
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);

CREATE TABLE Matches (
    MatchID INT PRIMARY KEY,
    MatchDate DATE,
    HomeTeamID INT,
    AwayTeamID INT,
    HomeTeamScore INT,
    AwayTeamScore INT,
    FOREIGN KEY (HomeTeamID) REFERENCES Teams(TeamID),
    FOREIGN KEY (AwayTeamID) REFERENCES Teams(TeamID)
);

-- Get players and their teams
SELECT
    Players.PlayerName,
    Players.Position,
    Teams.TeamName AS Team,
    Teams.TeamColor AS Color,
    Teams.TeamMascot AS Mascot
FROM
    Players
JOIN
    Teams ON Players.TeamID = Teams.TeamID;

-- Get total goals scored by each team
SELECT
    Teams.TeamName,
    SUM(Matches.HomeTeamScore) + SUM(Matches.AwayTeamScore) AS TotalGoals
FROM
    Teams
JOIN
    Matches ON Teams.TeamID = Matches.HomeTeamID OR Teams.TeamID = Matches.AwayTeamID
GROUP BY
    Teams.TeamName;

-- Get the player with the highest score in each position
SELECT
    Position,
    PlayerName,
    Age,
    TeamName
FROM
    (
        SELECT
            Position,
            PlayerName,
            Age,
            TeamName,
            ROW_NUMBER() OVER (PARTITION BY Position ORDER BY PlayerScore DESC) AS PositionRank
        FROM
            (
                SELECT
                    Players.Position,
                    Players.PlayerName,
                    Players.Age,
                    Teams.TeamName,
                    SUM(Matches.HomeTeamScore) + SUM(Matches.AwayTeamScore) AS PlayerScore
                FROM
                    Players
                JOIN
                    Teams ON Players.TeamID = Teams.TeamID
                JOIN
                    Matches ON Teams.TeamID = Matches.HomeTeamID OR Teams.TeamID = Matches.AwayTeamID
                GROUP BY
                    Players.Position,
                    Players.PlayerName,
                    Players.Age,
                    Teams.TeamName
            ) AS PlayerScores
    ) AS RankedPlayers
WHERE
    PositionRank = 1;
