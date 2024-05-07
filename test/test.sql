USE test;

CREATE TABLE test (
    id INTEGER PRIMARY KEY,
    host TEXT,
    frequency INTEGER
);

INSERT INTO test VALUES
    (1, "www.mozilla.org", 1791),
    (2, "support.mozilla.org", 740),
    (7, "drive.google.com", 176911),
    (8, "kickassapp.com", 120),
    (10, "www.geogebra.org", 8319),
    (14, "www.netflix.com", 289642),
    (15, "soundcloud.com", 120);
