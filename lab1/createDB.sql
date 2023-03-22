DROP TABLE IF EXISTS look_pattern;
DROP TABLE IF EXISTS sailor;
DROP TABLE IF EXISTS crack;
DROP TABLE IF EXISTS pattern;
DROP TABLE IF EXISTS ice;
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS sea;






CREATE TABLE sea
(
	SEA_ID serial PRIMARY KEY,
	SEA_NAME varchar(20) NOT NULL,
	OCEAN_NAME varchar(20) NOT NULL
);

CREATE TABLE ice
(
	ICE_ID serial PRIMARY KEY,
	ICE_TEMP float4,
	ICE_FRAGIlITY integer,
	SEA_ID integer REFERENCES sea(SEA_ID) NOT NULL
);

CREATE TABLE pattern
(
	PATTERN_ID serial PRIMARY KEY,
	PATTERN_CREATEDATE date NOT NULL,
	ICE_ID integer REFERENCES ice(ICE_ID) NOT NULL
);

CREATE TABLE crack
(
	CRACK_ID serial PRIMARY KEY,
	CRACK_CREATEDATA date NOT NULL,
	PATTERN_ID integer REFERENCES pattern(PATTERN_ID)
);

CREATE TABLE person
(
	PERSON_ID serial PRIMARY KEY,
	PERSON_NAME varchar(20) NOT NULL,
	PERSON_BIRTHDAY date NOT NULL,
	PERSON_GENDER char(1) CHECK(PERSON_GENDER = 'M' OR PERSON_GENDER = 'W')
);

CREATE TABLE sailor
(
	SEA_ID integer REFERENCES sea(SEA_ID),
	PERSON_ID integer REFERENCES person(PERSON_ID),
	
	CONSTRAINT SAILOR_PK PRIMARY KEY (SEA_ID, PERSON_ID)
);

CREATE TABLE look_pattern
(
	PATTERN_ID integer REFERENCES pattern(PATTERN_ID),
	PERSON_ID integer REFERENCES person(PERSON_ID),
	LOOK_TIME timestamp NOT NULL,
	
	CONSTRAINT LOOK_PATTERN_PK PRIMARY KEY (PATTERN_ID, PERSON_ID)
);

INSERT INTO sea
VALUES
(1, 'Берингово море', 'Тихий океан'),
(2, 'Балтийское море', 'Атлантический океан'),
(3, 'Красное море', 'Индийский океан');

INSERT INTO ice
VALUES
(1, -2.0, 2, 1),
(2, -3.4, 5, 1),
(3, -10.9, 8, 2),
(4, -7.1, 6, 2),
(5, -25.2, 10, 3);

INSERT INTO pattern
VALUES
(1, '1798-04-21', 1),
(2, '2001-06-05', 1),
(3, '1235-11-12', 2),
(4, '1485-12-01', 3);

INSERT INTO crack
VALUES
(1, '1798-04-22', 1),
(2, '1800-02-01', 1),
(3, '2003-01-01', 2),
(4, '2004-01-02', 2),
(5, '1486-02-02', 3),
(6, '1653-05-01', 4);

INSERT INTO person
VALUES
(1, 'Den', '2005-04-21', 'M'),
(2, 'Levi', '2000-12-12', 'M'),
(3, 'Katya', '2005-06-22', 'W');

INSERT INTO sailor
VALUES
(1,1),
(1,2),
(2,3);

INSERT INTO look_pattern
VALUES
(2, 1, '1999-01-08 04:05:06');