CREATE TABLE dagrs
(
dagr_guid varchar(255) NOT NULL PRIMARY KEY,
name varchar(255),
dagrcreationtime timestamp,
dagrdeletiontime timestamp,
has_components boolean,
deleted boolean
);