CREATE TABLE metadatas
(
dagr_guid varchar(255) REFERENCES dagrs (dagr_guid),
filetype varchar(255),
filesizebytes integer,
creationtime timestamp,
lastmodifiedtime timestamp,
deletiontime timestamp,
has_components boolean,
creationauthor varchar(255)
);