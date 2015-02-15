PRAGMA foreign_keys=ON;
BEGIN TRANSACTION;
CREATE TABLE users (
  `id`        TEXT    NOT NULL  PRIMARY KEY,
  `uname`     TEXT    NOT NULL  UNIQUE,
  `hash`      TEXT    NOT NULL,
  `auth`      TEXT    NOT NULL
);
INSERT INTO "users" VALUES('U01','User_01','$2a$10$2j2KVFFUQKPs2ncZw9boCOUvpkOG1Y8KPxdq8hQV6YktIo2GsEPpq','AUTH_01');
INSERT INTO "users" VALUES('U02','User_02','$2a$10$2j2KVFFUQKPs2ncZw9boCOUvpkOG1Y8KPxdq8hQV6YktIo2GsEPpq','AUTH_02');
INSERT INTO "users" VALUES('U03','User_03','$2a$10$2j2KVFFUQKPs2ncZw9boCOUvpkOG1Y8KPxdq8hQV6YktIo2GsEPpq','AUTH_03');
INSERT INTO "users" VALUES('U04','User_04','$2a$10$2j2KVFFUQKPs2ncZw9boCOUvpkOG1Y8KPxdq8hQV6YktIo2GsEPpq','AUTH_04');
CREATE TABLE friends (
  `id`        TEXT    NOT NULL  PRIMARY KEY,
  `ownerId`   TEXT    NOT NULL,
  `friendId`  TEXT    NOT NULL,
  `accepted`  INT     DEFAULT 0,
  FOREIGN KEY(ownerId) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY(friendId) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE(`ownerId`, `friendId`) ON CONFLICT FAIL
);
INSERT INTO "friends" VALUES('F01','U01','U02',1);
INSERT INTO "friends" VALUES('F02','U01','U03',0);
CREATE TABLE groups (
  `id`        TEXT    NOT NULL  PRIMARY KEY,
  `name`      TEXT    NOT NULL
);
INSERT INTO "groups" VALUES('G01','Group_01');
INSERT INTO "groups" VALUES('G02','Group_02');
CREATE TABLE user_group (
  `id`        TEXT    NOT NULL  PRIMARY KEY,
  `ownerId`   TEXT    NOT NULL,
  `groupId`   TEXT    NOT NULL,
  `accepted`  INT     DEFAULT 0,
  FOREIGN KEY(ownerId) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY(groupId) REFERENCES groups(id) ON DELETE CASCADE
);
INSERT INTO "user_group" VALUES('M01','U01','G01',1);
INSERT INTO "user_group" VALUES('M02','U02','G02',1);
INSERT INTO "user_group" VALUES('M03','U03','G03',0);
INSERT INTO "user_group" VALUES('M04','U02','G02',0);
INSERT INTO "user_group" VALUES('M05','U03','G02',0);
INSERT INTO "user_group" VALUES('M06','U04','G02',1);
CREATE UNIQUE INDEX user_uname ON users(uname);
CREATE INDEX friends_owner ON friends(ownerId);
CREATE INDEX user_group_user ON user_group(ownerId);
CREATE INDEX user_group_group ON user_group(groupId);
COMMIT;
