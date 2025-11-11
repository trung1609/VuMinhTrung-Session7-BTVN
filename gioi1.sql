create table gioi1.post
(
    post_id    serial primary key,
    user_id    int not null,
    content    text,
    tags       text[],
    created_at timestamp default current_timestamp,
    is_public  boolean   default true
);

create table gioi1.post_like
(
    user_id  int not null,
    post_id  int not null,
    liked_at timestamp default current_timestamp,
    primary key (user_id, post_id)
);

insert into gioi1.post (user_id, content, tags, is_public)
values (1, 'Hello World!', array ['intro', 'first_post'], true),
       (2, 'Learning SQL is fun.', array ['sql', 'database'], true),
       (3, 'Private post example.', array ['private'], false),
       (1, 'Another public post.', array ['public', 'update'], true),
       (2, 'Exploring arrays in PostgreSQL.', array ['arrays', 'postgresql'], true);

insert into gioi1.post_like (user_id, post_id)
values (2, 1),
       (3, 1),
       (1, 2),
       (3, 2),
       (1, 4);

create index idx_post on gioi1.post (is_public, lower(content));

explain analyse
select *
from gioi1.post
where is_public = true
  and content ilike '%post%';


create index idx_tags on gioi1.post using gin (tags);

explain analyse
select *
from gioi1.post
where tags @> array ['sql'];


create index idx_post_recent_public on gioi1.post (is_public, created_at desc) where post.is_public = true;
explain analyse
select *
from gioi1.post
where is_public = true
  and created_at >= now() - interval '7 days';

create index idx_user on gioi1.post (user_id, created_at desc );
explain analyse select p.user_id, pl.post_id, p.created_at from gioi1.post_like  pl join gioi1.post p on pl.post_id = p.post_id
group by pl.post_id, p.user_id, p.created_at


