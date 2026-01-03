-- Part 2: Creating a database --
DROP TABLE IF EXISTS type;
DROP TABLE IF EXISTS move;
DROP TABLE IF EXISTS region;
DROP TABLE IF EXISTS difficulty;
DROP TABLE IF EXISTS location;
DROP TABLE IF EXISTS pokémonSpecies;
DROP TABLE IF EXISTS pokémon;
DROP TABLE IF EXISTS pokémonMove;
DROP TABLE IF EXISTS trainer;
DROP TABLE IF EXISTS pokémonTrainer;
DROP TABLE IF EXISTS gym;
DROP TABLE IF EXISTS battle;
DROP TABLE IF EXISTS battleTrainer;
DROP TABLE IF EXISTS tournament;
DROP TABLE IF EXISTS tournamentParticipation;

DROP SCHEMA IF EXISTS Pokémon;
CREATE SCHEMA Pokémon;
USE Pokémon;

CREATE TABLE type (
	typeID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name VARCHAR(25) NOT NULL
);

CREATE TABLE move (
	moveID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) UNIQUE NOT NULL,
    type VARCHAR(25) NOT NULL,
    power INT,
    accuracy FLOAT,
    category VARCHAR(25) NOT NULL,
    uses INT NOT NULL,
    description VARCHAR(100)
);

CREATE TABLE region (
	regionID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name VARCHAR(25) NOT NULL
);

CREATE TABLE difficulty (
	difficultyID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name VARCHAR(25) NOT NULL
);

CREATE TABLE location (
	locationID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name VARCHAR(25) NOT NULL
);

CREATE TABLE pokémonSpecies (
	pokémonSpeciesID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    pokédexNo INT UNIQUE NOT NULL,
    species VARCHAR(25) NOT NULL,
    type1ID INT NOT NULL,
    type2ID INT,
    level INT,
    healthPower INT NOT NULL,
    attack INT NOT NULL,
    defense INT NOT NULL,
    CONSTRAINT FK_pokémonSpecies_type1 FOREIGN KEY (type1ID) REFERENCES type(typeID),
    CONSTRAINT FK_pokémonSpecies_type2 FOREIGN KEY (type2ID) REFERENCES type(typeID)
);

CREATE TABLE pokémon (
	pokémonID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    captureDate DATE NOT NULL,
    nickname VARCHAR(25),
    pokémonSpeciesID INT NOT NULL,
    CONSTRAINT FK_pokémon_pokémonspecies FOREIGN KEY (pokémonSpeciesID) REFERENCES pokémonSpecies(pokémonSpeciesID)
);

CREATE TABLE pokémonMove (
	pokémonSpeciesID INT NOT NULL,
    moveID INT NOT NULL,
    CONSTRAINT PK_pokémonMove PRIMARY KEY (pokémonSpeciesID, moveID),
    CONSTRAINT FK_pokémonMove_pokémonSpecies FOREIGN KEY (pokémonSpeciesID) REFERENCES pokémonSpecies(pokémonSpeciesID),
    CONSTRAINT FK_pokémonMove_move FOREIGN KEY (moveID) REFERENCES move(moveID)
);

CREATE TABLE trainer (
	trainerID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    firstName VARCHAR(25) NOT NULL,
    surname VARCHAR(25) NOT NULL,
    dateOfBirth DATE NOT NULL,
    regionID INT NOT NULL,
	trainerRank VARCHAR(25) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    phoneNo VARCHAR(25) UNIQUE,
    CONSTRAINT AK_trainer UNIQUE (firstName, surname, dateOfBirth),
    CONSTRAINT FK_trainer_region FOREIGN KEY (regionID) REFERENCES region(regionID)
);

CREATE TABLE pokémonTrainer (
	pokémonTrainerID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    pokémonID INT NOT NULL,
    trainerID INT NOT NULL,
    dateAcquired DATE,
    CONSTRAINT FK_pokémonTrainer_pokémon FOREIGN KEY (pokémonID) REFERENCES pokémon(pokémonID),
    CONSTRAINT FK_pokémonTrainer_trainer FOREIGN KEY (trainerID) REFERENCES trainer(trainerID)
);

CREATE TABLE gym (
	gymID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name VARCHAR(25),
    regionID INT NOT NULL,
    leaderID INT,
    locationID INT NOT NULL,
    badge VARCHAR(25) NOT NULL,
    difficultyID INT NOT NULL,
    establishedYear YEAR NOT NULL,
    CONSTRAINT AK_gym UNIQUE (name, establishedYear),
    CONSTRAINT FK_gym_region FOREIGN KEY (regionID) REFERENCES region(regionID),
    CONSTRAINT FK_gym_trainer FOREIGN KEY (leaderID) REFERENCES trainer(trainerID),
    CONSTRAINT FK_gym_location FOREIGN KEY (locationID) REFERENCES location(locationID),
    CONSTRAINT FK_gym_difficulty FOREIGN KEY (difficultyID) REFERENCES difficulty(difficultyID)
);

CREATE TABLE battle (
	battleID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    date DATETIME UNIQUE NOT NULL,
    locationID INT NOT NULL,
    duration TIME,
    weather VARCHAR(25),
    format VARCHAR(25),
    CONSTRAINT FK_battle_location FOREIGN KEY (locationID) REFERENCES location(locationID)
);

CREATE TABLE battleTrainer (
	battleTrainerID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	trainerID INT NOT NULL,
    battleID INT NOT NULL,
    isWinner BOOL NOT NULL,
    CONSTRAINT FK_battleTrainer_trainer FOREIGN KEY (trainerID) REFERENCES trainer(trainerID),
    CONSTRAINT FK_battleTrainer_battleID FOREIGN KEY (battleID) REFERENCES battle(battleID)
);

CREATE TABLE tournament (
	tournamentID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    locationID INT NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    prize VARCHAR(25),
    CONSTRAINT AK_tournament UNIQUE (name, startDate),
    CONSTRAINT FK_tournament_location FOREIGN KEY (locationID) REFERENCES location(locationID)
);

CREATE TABLE tournamentParticipation (
	participationID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    trainerID INT NOT NULL,
    tournamentID INT NOT NULL,
    result VARCHAR(25) NOT NULL,
    CONSTRAINT FK_tournamentParticipation_trainer FOREIGN KEY (trainerID) REFERENCES trainer(trainerID),
    CONSTRAINT FK_tournamentParticipation_tournament FOREIGN KEY (tournamentID) REFERENCES tournament(tournamentID)
);

-- Part 3: Fill in the data --
INSERT INTO type (name)
VALUES
	('Normal'),
    ('Fire'),
    ('Water'),
    ('Electric'),
    ('Grass'),
    ('Ice'),
    ('Fighting'),
    ('Poison'),
    ('Ground'),
    ('Flying'),
    ('Psychic'),
    ('Bug'),
    ('Rock'),
    ('Ghost'),
    ('Dragon'),
    ('Dark'),
    ('Steel'),
    ('Fairy');
    
INSERT INTO region (name)
VALUES
	('Kanto'),
    ('Johto'),
    ('Hoenn'),
    ('Sinnoh'),
    ('Unova'),
    ('Kalos'),
    ('Alola'),
    ('Galar'),
    ('Paldea'),
    ('Orre'),
    ('Fiore'),
    ('Almia'),
    ('Ransei'),
    ('Pasio'),
    ('Sevii Islands');
    
INSERT INTO difficulty (name)
VALUES
	('Beginner'),
    ('Easy'),
    ('Normal'),
    ('Intermediate'),
    ('Challenging'),
    ('Hard'),
    ('Expert'),
    ('Elite'),
    ('Champion'),
    ('Legendary'),
    ('Novice'),
    ('Advanced'),
    ('Master'),
    ('Extreme'),
    ('Impossible');
    
-- Kanto
INSERT INTO location (name) VALUES
    ('Pallet Town'),
    ('Cerulean City'),
    ('Lavender Town');

-- Johto
INSERT INTO location (name) VALUES
    ('New Bark Town'),
    ('Goldenrod City'),
    ('Ecruteak City');

-- Hoenn
INSERT INTO location (name) VALUES
    ('Littleroot Town'),
    ('Slateport City'),
    ('Fortree City');

-- Sinnoh
INSERT INTO location (name) VALUES
    ('Twinleaf Town'),
    ('Jubilife City'),
    ('Hearthome City');

-- Unova
INSERT INTO location (name) VALUES
    ('Nuvema Town'),
    ('Castelia City'),
    ('Nimbasa City');

-- Kalos
INSERT INTO location (name) VALUES
    ('Vaniville Town'),
    ('Lumiose City'),
    ('Shalour City');

-- Alola
INSERT INTO location (name) VALUES
    ('Iki Town'),
    ('Hau’oli City'),
    ('Heahea City');

-- Galar
INSERT INTO location (name) VALUES
    ('Postwick'),
    ('Motostoke'),
    ('Hammerlocke');

-- Paldea
INSERT INTO location (name) VALUES
    ('Mesagoza'),
    ('Cortondo'),
    ('Artazon');

-- Orre
INSERT INTO location (name) VALUES
    ('Agate Village'),
    ('Phenac City'),
    ('Pyrite Town');

-- Fiore
INSERT INTO location (name) VALUES
    ('Fiore Academy'),
    ('Fall City'),
    ('Lilycove Grove');

-- Almia
INSERT INTO location (name) VALUES
    ('Almia Town'),
    ('Techno City'),
    ('Great Canyon');

-- Ransei
INSERT INTO location (name) VALUES
    ('Chizu'),
    ('Osaka Castle'),
    ('Shirogane');

-- Pasio
INSERT INTO location (name) VALUES
    ('Pasio City'),
    ('Idol Hall'),
    ('Trainer Stadium');

-- Sevii Islands
INSERT INTO location (name) VALUES
    ('One Island'),
    ('Two Island'),
    ('Sevii Port');
    
INSERT INTO move (name, type, power, accuracy, category, uses, description)
VALUES
    ('Tackle', 'Normal', 40, 100, 'Physical', 35, 'A basic physical attack.'),
    ('Flamethrower', 'Fire', 90, 100, 'Special', 15, 'A powerful stream of fire.'),
    ('Hydro Pump', 'Water', 110, 80, 'Special', 5, 'Blast water at high pressure.'),
    ('Thunderbolt', 'Electric', 90, 100, 'Special', 15, 'A strong electric attack.'),
    ('Vine Whip', 'Grass', 45, 100, 'Physical', 25, 'Strikes the opponent with vines.'),
    ('Ice Beam', 'Ice', 90, 100, 'Special', 10, 'Fires a chilling beam.'),
    ('Psychic', 'Psychic', 90, 100, 'Special', 10, 'Uses psychic power to attack.'),
    ('Shadow Ball', 'Ghost', 80, 100, 'Special', 15, 'Throws a shadowy blob at the opponent.'),
    ('Dragon Claw', 'Dragon', 80, 100, 'Physical', 15, 'Slashes the opponent with sharp claws.'),
    ('Rock Slide', 'Rock', 75, 90, 'Physical', 10, 'Large rocks slide down onto the opponent.'),
    ('Earthquake', 'Ground', 100, 100, 'Physical', 10, 'Causes an earthquake to damage all.'),
    ('Air Slash', 'Flying', 75, 95, 'Special', 15, 'Cuts the enemy with a blade of wind.'),
    ('Iron Tail', 'Steel', 100, 75, 'Physical', 15, 'Attacks with a hard metal tail.'),
    ('Dark Pulse', 'Dark', 80, 100, 'Special', 15, 'Emits a wave of dark energy.'),
    ('Moonblast', 'Fairy', 95, 100, 'Special', 10, 'Blasts a powerful fairy energy wave.');
    
INSERT INTO pokémonSpecies (pokédexNo, species, type1ID, type2ID, level, healthPower, attack, defense)
VALUES
    (1, 'Bulbasaur', 5, 8, 5, 45, 49, 49),
    (4, 'Charmander', 2, NULL, 5, 39, 52, 43),
    (7, 'Squirtle', 3, NULL, 5, 44, 48, 65),
    (25, 'Pikachu', 3, NULL, 5, 35, 55, 40),
    (39, 'Jigglypuff', 1, 15, 5, 115, 45, 20),
    (52, 'Meowth', 1, NULL, 5, 40, 45, 35),
    (133, 'Eevee', 1, NULL, 5, 55, 55, 50),
    (150, 'Mewtwo', 11, NULL, 70, 106, 110, 90),
    (6, 'Charizard', 2, 10, 36, 78, 84, 78),
    (94, 'Gengar', 14, 8, 25, 60, 65, 60),
    (149, 'Dragonite', 15, 10, 55, 91, 134, 95),
    (131, 'Lapras', 3, 6, 25, 130, 85, 80),
    (143, 'Snorlax', 1, NULL, 30, 160, 110, 65),
    (59, 'Arcanine', 2, NULL, 30, 90, 110, 80),
    (248, 'Tyranitar', 13, 17, 55, 100, 134, 110);
    
INSERT INTO pokémon (captureDate, nickname, pokémonSpeciesID)
VALUES
    ('2025-01-10', 'Bulby', 1),
    ('2025-01-12', 'Char', 2),
    ('2025-01-15', 'Squirt', 3),
    ('2025-01-20', 'Sparky', 4),
    ('2025-01-22', 'Puffy', 5),
    ('2025-01-25', 'Meow', 6),
    ('2025-02-01', 'Eevee', 7),
    ('2025-02-05', 'MewtwoX', 8),
    ('2025-02-10', 'Flame', 9),
    ('2025-02-12', 'Gengy', 10),
    ('2025-02-15', 'Drago', 11),
    ('2025-02-18', 'Lap', 12),
    ('2025-02-20', 'Snorl', 13),
    ('2025-02-25', 'Arca', 14),
    ('2025-02-28', 'Tyra', 15);
    
INSERT INTO trainer (firstName, surname, dateOfBirth, regionID, trainerRank, email, phoneNo)
VALUES
    ('Ash', 'Ketchum', '1990-05-22', 1, 'Beginner', 'ash.ketchum@email.com', '123-456-7890'),
    ('Misty', 'Waterflower', '1991-07-01', 1, 'Intermediate', 'misty@email.com', '234-567-8901'),
    ('Brock', 'Stone', '1989-11-03', 1, 'Gym Leader', 'brock@email.com', '345-678-9012'),
    ('Gary', 'Oak', '1990-08-15', 1, 'Elite', 'gary.oak@email.com', '456-789-0123'),
    ('Dawn', 'Berlitz', '1992-03-20', 4, 'Beginner', 'dawn@email.com', '567-890-1234'),
    ('May', 'Maple', '1991-10-10', 3, 'Intermediate', 'may@email.com', '678-901-2345'),
    ('Max', 'Maple', '1995-02-18', 3, 'Beginner', 'max@email.com', '789-012-3456'),
    ('Serena', 'Fontaine', '1992-06-25', 6, 'Intermediate', 'serena@email.com', '890-123-4567'),
    ('Clemont', 'Citron', '1990-09-05', 6, 'Gym Leader', 'clemont@email.com', '901-234-5678'),
    ('Kiawe', 'Lava', '1991-12-12', 7, 'Gym Leader', 'kiawe@email.com', '012-345-6789'),
    ('Lillie', 'Lily', '1993-01-15', 7, 'Beginner', 'lillie@email.com', '123-456-7891'),
    ('Hop', 'Smith', '1992-07-18', 8, 'Intermediate', 'hop@email.com', '234-567-8902'),
    ('Marnie', 'Rock', '1993-11-22', 8, 'Gym Leader', 'marnie@email.com', '345-678-9013'),
    ('Gloria', 'Rose', '1994-03-10', 9, 'Beginner', 'gloria@email.com', '456-789-0124'),
    ('Victor', 'Cruz', '1988-05-30', 10, 'Elite', 'victor@email.com', '567-890-1235');
    
INSERT INTO pokémonTrainer (pokémonID, trainerID, dateAcquired)
VALUES
    (1, 1, '2025-01-10'),
    (2, 1, '2025-01-12'),
    (3, 2, '2025-01-15'),
    (4, 2, '2025-01-20'),
    (5, 3, '2025-01-22'),
    (6, 3, '2025-01-25'),
    (7, 4, '2025-02-01'),
    (8, 4, '2025-02-05'),
    (9, 5, '2025-02-10'),
    (10, 5, '2025-02-12'),
    (11, 6, '2025-02-15'),
    (12, 6, '2025-02-18'),
    (13, 7, '2025-02-20'),
    (14, 7, '2025-02-25'),
    (15, 8, '2025-02-28');
    
INSERT INTO gym (name, regionID, leaderID, locationID, badge, difficultyID, establishedYear)
VALUES
    ('Pewter Gym', 1, 3, 1, 'Boulder Badge', 1, 1997),
    ('Cerulean Gym', 1, 2, 2, 'Cascade Badge', 2, 1997),
    ('Vermilion Gym', 1, 4, 3, 'Thunder Badge', 2, 1997),
    ('Celadon Gym', 1, 1, 4, 'Rainbow Badge', 3, 1997),
    ('Saffron Gym', 1, 5, 5, 'Marsh Badge', 3, 1997),
    ('Violet Gym', 2, 6, 6, 'Fog Badge', 1, 1998),
    ('Goldenrod Gym', 2, 7, 7, 'Plain Badge', 2, 1998),
    ('Ecruteak Gym', 2, 8, 8, 'Storm Badge', 3, 1998),
    ('Rustboro Gym', 3, 9, 9, 'Stone Badge', 1, 2000),
    ('Mauville Gym', 3, 10, 10, 'Dynamo Badge', 2, 2000),
    ('Hearthome Gym', 4, 11, 11, 'Relic Badge', 2, 2001),
    ('Sunyshore Gym', 4, 12, 12, 'Beacon Badge', 3, 2001),
    ('Nimbasa Gym', 5, 13, 13, 'Bolt Badge', 2, 2010),
    ('Driftveil Gym', 5, 14, 14, 'Mine Badge', 1, 2010),
    ('Hammerlocke Gym', 8, 15, 15, 'Tower Badge', 3, 2019);
    
INSERT INTO battle (date, locationID, duration, weather, format)
VALUES
    ('2025-03-01 10:00:00', 1, '00:30:00', 'Sunny', 'Single'),
    ('2025-03-02 14:00:00', 2, '00:45:00', 'Rain', 'Double'),
    ('2025-03-03 16:30:00', 3, '00:25:00', 'Sunny', 'Single'),
    ('2025-03-04 12:00:00', 4, '00:50:00', 'Fog', 'Double'),
    ('2025-03-05 09:00:00', 5, '00:35:00', 'Windy', 'Single'),
    ('2025-03-06 11:00:00', 6, '00:40:00', 'Rain', 'Single'),
    ('2025-03-07 15:00:00', 7, '01:00:00', 'Sunny', 'Double'),
    ('2025-03-08 13:30:00', 8, '00:20:00', 'Snow', 'Single'),
    ('2025-03-09 10:15:00', 9, '00:55:00', 'Sunny', 'Double'),
    ('2025-03-10 14:45:00', 10, '00:30:00', 'Windy', 'Single'),
    ('2025-03-11 09:30:00', 11, '00:40:00', 'Rain', 'Single'),
    ('2025-03-12 16:00:00', 12, '00:50:00', 'Sunny', 'Double'),
    ('2025-03-13 10:00:00', 13, '00:35:00', 'Fog', 'Single'),
    ('2025-03-14 15:15:00', 14, '00:45:00', 'Snow', 'Double'),
    ('2025-03-15 12:00:00', 15, '00:25:00', 'Sunny', 'Single');
    
INSERT INTO battleTrainer (trainerID, battleID, isWinner)
VALUES
    (1, 1, TRUE),
    (2, 1, FALSE),
    (3, 2, TRUE),
    (4, 2, FALSE),
    (5, 3, TRUE),
    (6, 3, FALSE),
    (7, 4, TRUE),
    (8, 4, FALSE),
    (9, 5, TRUE),
    (10, 5, FALSE),
    (11, 6, TRUE),
    (12, 6, FALSE),
    (13, 7, TRUE),
    (14, 7, FALSE),
    (15, 8, TRUE),
    (1, 8, FALSE),
    (2, 9, TRUE),
    (3, 9, FALSE),
    (4, 10, TRUE),
    (5, 10, FALSE),
    (6, 11, TRUE),
    (7, 11, FALSE),
    (8, 12, TRUE),
    (9, 12, FALSE),
    (10, 13, TRUE),
    (11, 13, FALSE),
    (12, 14, TRUE),
    (13, 14, FALSE),
    (14, 15, TRUE),
    (15, 15, FALSE);
    
INSERT INTO tournament (name, locationID, startDate, endDate, prize)
VALUES
    ('Kanto Regional', 1, '2025-06-01', '2025-06-03', 'Trophy & Coins'),
    ('Johto Invitational', 2, '2025-06-05', '2025-06-07', 'Rare Candy Pack'),
    ('Hoenn Open', 3, '2025-06-10', '2025-06-12', 'Legendary Token'),
    ('Sinnoh Championship', 4, '2025-06-15', '2025-06-17', 'Battle Points'),
    ('Unova Cup', 5, '2025-06-20', '2025-06-22', 'Master Ball'),
    ('Kalos Classic', 6, '2025-06-25', '2025-06-27', 'Trophy & Coins'),
    ('Alola Challenge', 7, '2025-07-01', '2025-07-03', 'Rare Candy Pack'),
    ('Galar League', 8, '2025-07-05', '2025-07-07', 'Legendary Token'),
    ('Johto Masters', 2, '2025-07-10', '2025-07-12', 'Battle Points'),
    ('Kanto Elite', 1, '2025-07-15', '2025-07-17', 'Master Ball'),
    ('Sinnoh Open', 4, '2025-07-20', '2025-07-22', 'Trophy & Coins'),
    ('Hoenn Championship', 3, '2025-07-25', '2025-07-27', 'Rare Candy Pack'),
    ('Unova Invitational', 5, '2025-08-01', '2025-08-03', 'Legendary Token'),
    ('Kalos Masters', 6, '2025-08-05', '2025-08-07', 'Battle Points'),
    ('Alola League', 7, '2025-08-10', '2025-08-12', 'Master Ball');
    
INSERT INTO tournamentParticipation (trainerID, tournamentID, result)
VALUES
    (1, 1, 'Winner'),
    (2, 1, 'Runner-up'),
    (3, 2, 'Semi-finalist'),
    (4, 2, 'Quarter-final'),
    (5, 3, 'Winner'),
    (6, 3, 'Runner-up'),
    (7, 4, 'Winner'),
    (8, 4, 'Runner-up'),
    (9, 5, 'Winner'),
    (10, 5, 'Runner-up'),
    (11, 6, 'Winner'),
    (12, 6, 'Runner-up'),
    (13, 7, 'Winner'),
    (14, 7, 'Runner-up'),
    (15, 8, 'Winner'),
    (1, 8, 'Runner-up'),
    (2, 9, 'Winner'),
    (3, 9, 'Runner-up'),
    (4, 10, 'Winner'),
    (5, 10, 'Runner-up'),
    (6, 11, 'Winner'),
    (7, 11, 'Runner-up'),
    (8, 12, 'Winner'),
    (9, 12, 'Runner-up'),
    (10, 13, 'Winner'),
    (11, 13, 'Runner-up'),
    (12, 14, 'Winner'),
    (13, 14, 'Runner-up'),
    (14, 15, 'Winner'),
    (15, 15, 'Runner-up');
    
-- Part 4: Where & Scalar Functions --
-- Query 1 --
SELECT UPPER(name) AS MoveName, power
FROM move
WHERE power > 80
ORDER BY power DESC;

-- Query 2 --
SELECT species
FROM pokémonSpecies
WHERE species NOT LIKE '%a%'
ORDER BY species ASC;

-- Query 3 --
SELECT DISTINCT name
FROM type
WHERE typeID IN (2, 3, 5);

-- Query 4 --
SELECT nickname, captureDate
FROM pokémon
WHERE YEAR(captureDate) = 2025 AND MONTH(captureDate) BETWEEN 2 AND 2
ORDER BY captureDate DESC;

-- Query 5 --
SELECT 
    name AS GymName,
    COALESCE(leaderID, 0) AS LeaderID, badge
FROM gym
WHERE leaderID IS NOT NULL AND establishedYear > 2000
ORDER BY establishedYear DESC;

-- Part 5: Joins --
-- Query 1 --
SELECT p.nickname, s.species
FROM pokémon p
JOIN pokémonSpecies s 
ON p.pokémonSpeciesID = s.pokémonSpeciesID;

-- Query 2 --
SELECT t.firstName, t.surname, tor.name AS TournamentName, tp.result
FROM trainer t
JOIN tournamentParticipation tp
ON t.trainerID = tp.trainerID
JOIN tournament tor
ON tp.tournamentID = tor.tournamentID
WHERE tor.startDate BETWEEN '2025-06-01' AND '2025-06-30';

-- Query 3 --
SELECT g.name AS GymName, r.name AS RegionName
FROM gym g
LEFT JOIN region r ON g.regionID = r.regionID
ORDER BY g.name;

-- Query 4 --
SELECT DATE(b.date) AS BattleDate, l.name AS LocationName, b.duration
FROM battle b
RIGHT JOIN location l ON b.locationID = l.locationID
WHERE b.duration > '00:30:00'
ORDER BY b.duration DESC;

-- Query 5 -- 
SELECT b.battleID, DATE(b.date) AS BattleDate, t.firstName AS TrainerFirstName, t.surname AS TrainerSurname, l.name AS LocationName, g.name AS GymName
FROM battle b
JOIN battleTrainer bt ON b.battleID = bt.battleID
JOIN trainer t ON bt.trainerID = t.trainerID
LEFT JOIN location l ON b.locationID = l.locationID
RIGHT JOIN gym g ON l.locationID = g.locationID
WHERE g.regionID = 1
ORDER BY b.date DESC;

-- Part 6: Subqueries --
-- Query 1 (Single-row subquery) --
SELECT name, power
FROM move
WHERE power > (
    SELECT power
    FROM move
    WHERE name = 'Thunderbolt'
);

-- Query 2 (Multiple-row subquery) --
SELECT firstName, surname, trainerRank
FROM trainer
WHERE trainerRank IN (
	SELECT trainerRank
    FROM trainer
    WHERE trainerRank = 'Gym Leader' OR trainerRank = 'Elite'
);

-- Query 3 (Double key subquery) --
SELECT firstName, surname, trainerRank, YEAR(dateOfBirth) AS BirthYear
FROM trainer
WHERE (trainerRank, YEAR(dateOfBirth)) IN (
	SELECT trainerRank, YEAR(dateOfBirth)
	FROM trainer
	WHERE firstName = 'Serena'
);
    
-- Query 4 (Nested subquery) --
SELECT name, power, category
FROM move
WHERE category = (
    SELECT category
    FROM move
    WHERE name = (
        SELECT name
        FROM move
        WHERE name = 'Tackle'
    )
);

-- Query 5 (Subquery in the select) --
SELECT t.firstName, t.surname,
   (SELECT g.name 
    FROM gym g
    WHERE g.leaderID = t.trainerID) AS GymLed
FROM trainer t
ORDER BY t.surname;

-- Part 7: Set Functions --
-- Query 1 (COUNT) --
SELECT COUNT(*) AS TotalPokemon
FROM pokémon;

-- Query 2 (AVG) --	
SELECT species, defense
FROM pokémonSpecies
WHERE defense > (
	SELECT AVG(defense)
	FROM pokémonSpecies
);

-- Part 8: Correlated  Subqueries --
-- Query 1 --
SELECT t.trainerID, t.firstName,
    (SELECT COUNT(*)
     FROM pokémonTrainer pt
     WHERE pt.trainerID = t.trainerID) AS NumPokemon
FROM trainer t
ORDER BY t.firstName;

-- Query 2 --
SELECT p.pokémonID, ps.species,
    (SELECT COUNT(*)
     FROM pokémonTrainer pt
     WHERE pt.pokémonID = p.pokémonID) AS NumTrainers
FROM pokémon p
JOIN pokémonSpecies ps ON p.pokémonSpeciesID = ps.pokémonSpeciesID
ORDER BY p.pokémonID;

-- Query 3 --
SELECT p.pokémonID, ps.species, ps.attack
FROM pokémon p
JOIN pokémonSpecies ps ON p.pokémonSpeciesID = ps.pokémonSpeciesID
WHERE ps.attack > (
    SELECT AVG(ps2.attack)
    FROM pokémonSpecies ps2
    WHERE ps2.type1ID = ps.type1ID
);

-- Part 9: Group By --
-- Query 1 --
SELECT t.name AS TypeName, AVG(ps.level) AS AvgLevel
FROM pokémonSpecies ps
JOIN type t ON ps.type1ID = t.typeID
GROUP BY t.name;

-- Query 2 --
SELECT r.name AS RegionName, t.trainerRank, COUNT(tp.tournamentID) AS NumTournaments
FROM tournamentParticipation tp
JOIN trainer t ON tp.trainerID = t.trainerID
JOIN region r ON t.regionID = r.regionID
GROUP BY r.name, t.trainerRank;

-- Query 3 --
SELECT DAYNAME(date) AS DayOfWeek, COUNT(battleID) AS NumBattles, AVG(TIME_TO_SEC(duration)) AS AvgDurationSeconds
FROM battle
GROUP BY DAYNAME(date);

-- Query 4 --
SELECT t.firstName, t.surname, COUNT(tp.tournamentID) AS NumTournaments
FROM tournamentParticipation tp
JOIN trainer t ON tp.trainerID = t.trainerID
GROUP BY t.trainerID
HAVING COUNT(tp.tournamentID) > 1;

-- Query 5 --
SELECT t.firstName, t.surname, AVG(ps.level) AS AvgLevel
FROM pokémonTrainer pt
JOIN trainer t ON pt.trainerID = t.trainerID
JOIN pokémon p ON pt.pokémonID = p.pokémonID
JOIN pokémonSpecies ps ON p.pokémonSpeciesID = ps.pokémonSpeciesID
GROUP BY t.trainerID
HAVING AVG(ps.level) > 20;