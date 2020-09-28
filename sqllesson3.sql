drop database if exists snet1509;
create database snet1509;
use snet1509;

drop table if exists users;
create table users(
	id serial primary key, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	name varchar(50),
	surname varchar(50),
	email varchar(120) unique,
	phone bigint,
	gender char(1),
	birthday date,
	hometown varchar(50),
	photo_id bigint unsigned,
	pass char(50),
	created_at datetime default current_timestamp,
	-- soft delete ('РјСЏРіРєРѕРµ' СѓРґР°Р»РµРЅРёРµ)
	-- is_deleted bool
	-- deleted_at datetime
	index(phone),
	index(email),
	index(name, surname)
);

drop table if exists messages;
create table messages(
	id serial primary key,
	from_user_id bigint unsigned not null,
	to_user_id bigint unsigned not null,
	body text,
	is_read bool default 0,
	created_at datetime default current_timestamp,
	foreign key (from_user_id) references users (id),
	foreign key (to_user_id) references users (id)
);

drop table if exists friend_requests;
create table friend_requests(
	-- id serial primary key,
	initiator_user_id bigint unsigned not null,
	target_user_id bigint unsigned not null,
	status enum('requested', 'approved', 'unfriended', 'declined') default 'requested',
	requested_at datetime default now(),
	confirmed_at datetime default current_timestamp on update current_timestamp,
	primary key(initiator_user_id, target_user_id),
	foreign key (initiator_user_id) references users (id),
	foreign key (target_user_id) references users (id)
);

alter table friend_requests add index(initiator_user_id);

drop table if exists communities;
create table communities(
	id serial primary key,
	name varchar(150),
	index communities_name_idx (name)
);


drop table if exists users_communities;
create table users_communities(
	user_id bigint unsigned not null,
	community_id bigint unsigned not null,
	is_admin bool default 0,
	primary key(user_id, community_id),
	foreign key (user_id) references users (id),
	foreign key (community_id) references communities (id)
);

drop table if exists posts;
create table posts(
	id serial primary key,
	user_id bigint unsigned not null,
	body text,
	metadata json,
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,
	foreign key (user_id) references users (id)
);

drop table if exists comments;
create table comments (
	id serial primary key,
	user_id bigint unsigned not null,
	post_id bigint unsigned not null,
	body text,
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,
	foreign key (user_id) references users (id),
	foreign key (post_id) references posts (id)
);

drop table if exists photos;
create table photos (
	id serial primary key,
	user_id bigint unsigned not null,
	description text,
	filename varchar(250),
	foreign key (user_id) references users (id)
);

drop table if exists likes;
create table likes (
	id serial primary key,
	from_user_id bigint unsigned not null,
    to_object_id bigint unsigned not null,
	foreign key (to_object_id) references photo (id),
	foreign key (to_object_id) references users (id),
	foreign key (to_object_id) references posts (id)
);	