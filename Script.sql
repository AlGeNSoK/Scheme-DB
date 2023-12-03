create table if not exists Artist(
	id SERIAL primary key,
	name VARCHAR(100) not null
);

create table if not exists Genre(
	id SERIAL primary key,
	name VARCHAR(100) unique not null
);

create table if not exists Album(
	id SERIAL primary key,
	name VARCHAR(100) not null,
	year_of_release DATE
);

create table if not exists Collection(
	id SERIAL primary key,
	name VARCHAR(100) unique not null,
	year_of_release DATE
);

create table if not exists Track(
	id SERIAL primary key,
	name VARCHAR(100) not null,
	duration INTEGER check (duration > 0),
	album_id INTEGER references Album(id)
);

create table if not exists ArtistGenre(
	artist_id INTEGER references Artist(id),
	genre_id INTEGER references Genre(id),
	constraint pk primary key (artist_id, genre_id)
);

create table if not exists ArtistAlbum(
	artist_id INTEGER references Artist(id),
	album_id INTEGER references Album(id),
	constraint pk_artist_album primary key (artist_id, album_id)
);

create table if not exists CollectionTrack(
	collection_id INTEGER references Collection(id),
	track_id INTEGER references Track(id),
	constraint pk_collection_track primary key (collection_id, track_id)
);