CREATE TABLE kha1.book (
                      book_id SERIAL PRIMARY KEY,
                      title VARCHAR(255),
                      author VARCHAR(100),
                      genre VARCHAR(50),
                      price DECIMAL(10,2),
                      description TEXT,
                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO kha1.book (title, author, genre, price, description)
VALUES
    ('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 12.99, 'A classic novel of racism and injustice.'),
    ('1984', 'George Orwell', 'Dystopian', 14.50, 'A story about totalitarianism and surveillance.'),
    ('The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', 10.99, 'A tale of wealth, love, and the American dream.'),
    ('The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 15.00, 'Bilbo Baggins embarks on an unexpected journey.'),
    ('The Catcher in the Rye', 'J.D. Salinger', 'Literature', 11.75, 'A story about teenage alienation and identity.');

create index idx_author on kha1.book(author);

create index idx_genre on kha1.book(genre);

explain analyse select *
from kha1.book where author like '%Rowling%';

explain analyse select *
from kha1.book where genre = 'Fantasy';

CREATE EXTENSION IF NOT EXISTS pg_trgm;
create index idx_title on kha1.book USING GIN(title gin_trgm_ops);

explain analyse select *
from kha1.book where title ilike '%Hobbit%';

create index idx_description on kha1.book using gin(description gin_trgm_ops);
explain analyse select * from kha1.book where title ilike '%embarks%';

cluster kha1.book using idx_genre;

