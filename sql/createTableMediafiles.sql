CREATE TABLE mediafiles
(
media_guid varchar(255) NOT NULL PRIMARY KEY,
dagr_guid varchar(255) REFERENCES dagrs (dagr_guid),
name varchar(255),
filetype varchar(255)
);