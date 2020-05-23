DROP TABLE IF EXISTS users;

CREATE TABLE IF NOT EXISTS users (
    user_id     int(11)     NOT NULL AUTO_INCREMENT,
    login       varchar(64) NOT NULL,
    password    varchar(64) NOT NULL,
    name        varchar(64),
    UNIQUE      (login),
    PRIMARY KEY (user_id)
);

CREATE INDEX users_login_password_index ON users (login, password);

