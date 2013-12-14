CREATE TABLE annotations
(
media_guid varchar(255) REFERENCES mediafiles (media_guid),
annotation varchar
);