CREATE TABLE keywords
(
dagr_guid varchar(255) REFERENCES dagrs (dagr_guid),
keyword varchar(255)
);