-- CREATE 　
CREATE TABLE twiitunes_account(
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,      --twitter_user_id
    twitter_screen_name TEXT,
    twitter_profile_image_url TEXT,
    updated_on TIMESTAMP DEFAULT now(),
    created_on TIMESTAMP DEFAULT now()
);


CREATE TABLE twiitunes_music(
    id SERIAL NOT NULL PRIMARY KEY,
    itunes_trackid TEXT NOT NULL UNIQUE,
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
    updated_on TIMESTAMP DEFAULT now(),
    created_on TIMESTAMP DEFAULT now()
);
CREATE INDEX idx_twiitunes_music_co ON twiitunes_music(created_on);


CREATE TABLE twiitunes_tweet(
    id SERIAL PRIMARY KEY,
    twiitunes_music INTEGER NOT NULL REFERENCES twiitunes_music(id) on delete cascade,
    twiitunes_account INTEGER NOT NULL REFERENCES twiitunes_account(id) on delete cascade,
    description TEXT,
    ratings INTEGER DEFAULT 0,
    updated_on TIMESTAMP DEFAULT now(),
    created_on TIMESTAMP DEFAULT now()
);
CREATE INDEX idx_twiitunes_tweet_tm_ta ON twiitunes_tweet(twiitunes_music, twiitunes_account);
CREATE INDEX idx_twiitunes_tweet_co ON twiitunes_tweet(created_on);


--CREATE TABLE twiitunes_favorite(
--    id SERIAL PRIMARY KEY,
--    twiitunes_music INTEGER NOT NULL REFERENCES twiitunes_music(id) on delete cascade,
--    twiitunes_account INTEGER NOT NULL REFERENCES twiitunes_account(id) on delete cascade,
--    updated_on TIMESTAMP DEFAULT now(),
--    created_on TIMESTAMP DEFAULT now()
--);
--CREATE INDEX idx_twiitunes_favorite_tm_ta ON twiitunes_favorite(twiitunes_music, twiitunes_account);
--CREATE INDEX idx_twiitunes_favorite_co ON twiitunes_favorite(created_on);

