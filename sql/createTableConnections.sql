CREATE TABLE connections
(
parent_guid varchar(255) REFERENCES dagrs (dagr_guid),
child_guid varchar(255)
);