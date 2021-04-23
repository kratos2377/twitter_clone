

 CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


CREATE TABLE users (
    user_uid UUID NOT NULL PRIMARY KEY,
    user_real_name VARCHAR(200) NOT NULL,
    user_name VARCHAR(200) NOT NULL UNIQUE,
    password TEXT NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    bio VARCHAR(200) DEFAULT '',
    photoUrl TEXT NOT NULL DEFAULT 'https://media.istockphoto.com/vectors/default-profile-picture-avatar-photo-placeholder-vector-illustration-vector-id1214428300?s=612x612'
);

CREATE TABLE tweets (
    tweet_user_id UUID NOT NULL,
    user_tweets jsonb[]
);

CREATE TABLE friends_details(
    user_id UUID,
    followers UUID[] DEFAULT '{}',
    following UUID[] DEFAULT '{}'
);


CREATE TABLE hashtags(
    hash_name text,
    number_of_tweets int DEFAULT 1
);




