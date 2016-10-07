create database yourdiskdb;   
use yourdiskdb;
---
###All User's gets stored in APP_USER table###

create table APP_USER (
id BIGINT NOT NULL AUTO_INCREMENT,  
sso_id VARCHAR(30) NOT NULL,  
password VARCHAR(100) NOT NULL,  
first_name VARCHAR(30) NOT NULL,  
last_name  VARCHAR(30) NOT NULL,  
email VARCHAR(30) NOT NULL,  
PRIMARY KEY (id),  
UNIQUE (sso_id)  
);
   
###USER_PROFILE table contains all possible roles ###

create table USER_PROFILE(  
   id BIGINT NOT NULL AUTO_INCREMENT,  
   type VARCHAR(30) NOT NULL,  
   PRIMARY KEY (id),  
   UNIQUE (type)  
);
   
###JOIN TABLE for MANY-TO-MANY relationship###

CREATE TABLE APP_USER_USER_PROFILE (  
    user_id BIGINT NOT NULL,  
    user_profile_id BIGINT NOT NULL,  
    PRIMARY KEY (user_id, user_profile_id),  
    CONSTRAINT FK_APP_USER FOREIGN KEY (user_id) REFERENCES APP_USER (id),  
    CONSTRAINT FK_USER_PROFILE FOREIGN KEY (user_profile_id) REFERENCES USER_PROFILE (id)  
);  

###USER_DOCUMENT table contains all user documents ###

CREATE TABLE user_document (  
id bigint(20) NOT NULL AUTO_INCREMENT,  
user_id bigint(20) NOT NULL,  
is_folder tinyint(1) DEFAULT NULL,  
name varchar(100) COLLATE utf8_unicode_ci NOT NULL,  
type varchar(100) COLLATE utf8_unicode_ci NOT NULL,  
glyphicon varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,  
document_link varchar(100) COLLATE utf8_unicode_ci NOT NULL,  
size int(11) DEFAULT '0',  
files_counter int(11) DEFAULT '0',  
parent_folder_id int(11) DEFAULT '0',  
  PRIMARY KEY (id),  
  KEY document_user (user_id),  
  CONSTRAINT document_user FOREIGN KEY (user_id) REFERENCES app_user (id) ON DELETE CASCADE ON UPDATE CASCADE  
);  
  
###Populate USER_PROFILE Table ###

INSERT INTO USER_PROFILE(type)    
VALUES ('USER');

INSERT INTO USER_PROFILE(type)  
VALUES ('ADMIN');  
  
INSERT INTO USER_PROFILE(type)  
VALUES ('DBA');  
  
  
###Populate one Admin User which will further create other users for the application using GUI ###

INSERT INTO APP_USER(sso_id, password, first_name, last_name, email)  
VALUES ('admin','$2a$10$pOEgkVsH/J0t5k5h/3npXeAliJJp6eJIEXLmTgcK1eouiqBZTLsfe', 'admin','admin','admin@admin.com');  
  
  
###Populate JOIN Table ###

INSERT INTO APP_USER_USER_PROFILE (user_id, user_profile_id)  
  SELECT user.id, profile.id FROM app_user user, user_profile profile  
  where user.sso_id='sam' and profile.type='ADMIN';  
 
###Create persistent_logins Table used to store rememberme related stuff###

CREATE TABLE persistent_logins (  
    username VARCHAR(64) NOT NULL,  
    series VARCHAR(64) NOT NULL,  
    token VARCHAR(64) NOT NULL,  
    last_used TIMESTAMP NOT NULL,  
    PRIMARY KEY (series)  
);


