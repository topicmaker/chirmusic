-- delete　
DROP TRIGGER trig_after_insert_twiitunes_music;
DROP TRIGGER trig_after_insert_twiitunes_tweet;
DROP TRIGGER trig_after_insert_twiitunes_favorite;
DROP TABLE twiitunes_music;
DROP TABLE twiitunes_tweet;
DROP TABLE twiitunes_favorite;


-- create　
CREATE TABLE twiitunes_music(
    id INTEGER PRIMARY KEY,
    itunes_trackid TEXT UNIQUE,
    itunes_trackname TEXT,
    itunes_artistname TEXT,
    itunes_artistid TEXT,
    itunes_collectionname TEXT,
    itunes_collectionid TEXT,
    itunes_trackviewurl TEXT,
    itunes_previewurl TEXT,
    itune_artworkurl100 TEXT,
    shorten_url TEXT,
    play_count INTEGER DEFAULT 0,
    updated_on DATE DEFAULT CURRENT_TIMESTAMP,
    created_on DATE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE twiitunes_tweet(
    id INTEGER PRIMARY KEY,
    twiitunes_music INTEGER NOT NULL,
    account_name TEXT NOT NULL,
    description TEXT,
    ratings INTEGER DEFAULT 0,
    updated_on DATE DEFAULT CURRENT_TIMESTAMP,
    created_on DATE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (twiitunes_music) REFERENCES twiitunes_music(id)
);

CREATE TABLE twiitunes_favorite(
    id INTEGER PRIMARY KEY,
    twiitunes_music INTEGER NOT NULL,
    account_name TEXT NOT NULL,
    updated_on DATE DEFAULT CURRENT_TIMESTAMP,
    created_on DATE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (twiitunes_music) REFERENCES twiitunes_music(id)
);

CREATE TRIGGER trig_after_insert_twiitunes_music AFTER INSERT ON twiitunes_music
BEGIN
  UPDATE twiitunes_music SET updated_on=datetime('now', 'localtime') WHERE id=NEW.id;
  UPDATE twiitunes_music SET created_on=datetime('now', 'localtime') WHERE id=NEW.id;
END;

CREATE TRIGGER trig_after_insert_twiitunes_tweet AFTER INSERT ON twiitunes_tweet
BEGIN
  UPDATE twiitunes_tweet SET updated_on=datetime('now', 'localtime') WHERE id=NEW.id;
  UPDATE twiitunes_tweet SET created_on=datetime('now', 'localtime') WHERE id=NEW.id;
END;

CREATE TRIGGER trig_after_insert_twiitunes_favorite AFTER INSERT ON twiitunes_favorite
BEGIN
  UPDATE twiitunes_favorite SET updated_on=datetime('now', 'localtime') WHERE id=NEW.id;
  UPDATE twiitunes_favorite SET created_on=datetime('now', 'localtime') WHERE id=NEW.id;
END;

-- test data
--INSERT INTO twiitunes_music (itunes_trackId) VALUES ('000001');
--INSERT INTO twiitunes_music (itunes_trackId) VALUES ('000002');

