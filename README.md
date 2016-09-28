mySQL initialize:

create database relzetdb; use relzetdb;
CREATE TABLE app_user
(
    id BIGINT(20) PRIMARY KEY NOT NULL AUTO_INCREMENT,
    sso_id VARCHAR(30) NOT NULL,
    password VARCHAR(100) NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    email VARCHAR(30) NOT NULL
);
CREATE UNIQUE INDEX sso_id ON app_user (sso_id);
CREATE TABLE app_user_user_profile
(
    user_id BIGINT(20) NOT NULL,
    user_profile_id BIGINT(20) NOT NULL,
    CONSTRAINT `PRIMARY` PRIMARY KEY (user_id, user_profile_id),
    CONSTRAINT FK_APP_USER FOREIGN KEY (user_id) REFERENCES app_user (id),
    CONSTRAINT FK_USER_PROFILE FOREIGN KEY (user_profile_id) REFERENCES user_profile (id)
);
CREATE INDEX FK_USER_PROFILE ON app_user_user_profile (user_profile_id);
CREATE TABLE persistent_logins
(
    username VARCHAR(64) NOT NULL,
    series VARCHAR(64) PRIMARY KEY NOT NULL,
    token VARCHAR(64) NOT NULL,
    last_used TIMESTAMP DEFAULT 'CURRENT_TIMESTAMP' NOT NULL
);
CREATE TABLE user_document
(
    id BIGINT(20) PRIMARY KEY NOT NULL AUTO_INCREMENT,
    user_id BIGINT(20) NOT NULL,
    folder TINYINT(1),
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    type VARCHAR(100) NOT NULL,
    glyphicon VARCHAR(100),
    content LONGBLOB NOT NULL,
    size INT(11) DEFAULT '0',
    files_counter INT(11) DEFAULT '0',
    CONSTRAINT document_user FOREIGN KEY (user_id) REFERENCES app_user (id)
);
CREATE INDEX document_user ON user_document (user_id);
CREATE TABLE user_profile
(
    id BIGINT(20) PRIMARY KEY NOT NULL AUTO_INCREMENT,
    type VARCHAR(30) NOT NULL
);
CREATE UNIQUE INDEX type ON user_profile (type);
