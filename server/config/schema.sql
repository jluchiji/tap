CREATE TABLE users (
  `id`        TEXT    NOT NULL  PRIMARY KEY,
  `uname`     TEXT    NOT NULL  UNIQUE,
  `hash`      TEXT    NOT NULL,
  `auth`      TEXT    NOT NULL,
  `group`     TEXT    DEFAULT NULL,
  FOREIGN KEY(group) REFERENCES groups(id) ON DELETE SET NULL
);
CREATE UNIQUE INDEX user_uname ON users(uname);

CREATE TABLE friends (
  `id`        TEXT    NOT NULL  PRIMARY KEY,
  `ownerId`   TEXT    NOT NULL,
  `friendId`  TEXT    NOT NULL,
  `accepted`  INT     DEFAULT 0,
  FOREIGN KEY(ownerId) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY(friendId) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE(`ownerId`, `friendId`) ON CONFLICT FAIL
);
CREATE INDEX friends_owner ON friends(ownerId);

CREATE TABLE groups (
  `id`        TEXT    NOT NULL  PRIMARY KEY,
  `name`      TEXT    NOT NULL
);

CREATE TABLE user_group (
  `id`        TEXT    NOT NULL  PRIMARY KEY,
  `ownerId`   TEXT    NOT NULL,
  `groupId`   TEXT    NOT NULL,
  `accepted`  INT     DEFAULT 0,
  FOREIGN KEY(ownerId) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY(groupId) REFERENCES groups(id) ON DELETE CASCADE,
  UNIQUE(`ownerId`, `friendId`) ON CONFLICT FAIL
);
CREATE INDEX user_group_user ON user_group(ownerId);
CREATE INDEX user_group_group ON user_group(groupId);
