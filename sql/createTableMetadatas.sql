CREATE TABLE metadatas
(
dagr_guid varchar(255) REFERENCES dagrs (dagr_guid),
filetype varchar(255),
filesizebytes integer,
filecreationtime timestamp,
lastmodifiedtime timestamp,
creationauthor varchar(255)
);