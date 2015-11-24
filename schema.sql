-- If you want to run this schema repeatedly you'll need to drop
-- the table before re-creating it. Note that you'll lose any
-- data if you drop and add a table:

DROP TABLE IF EXISTS vacations;
DROP TABLE IF EXISTS comments;

-- Define your schema here:

CREATE TABLE vacations (
  id SERIAL PRIMARY KEY,
  destination VARCHAR(255) NOT NULL
);

CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  body VARCHAR(255) NOT NULL,
  vacation_id INTEGER NOT NULL REFERENCES vacations
);
