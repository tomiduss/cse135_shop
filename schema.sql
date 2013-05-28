CREATE TABLE shop_user(
	ID SERIAL PRIMARY KEY,
	username text NOT NULL UNIQUE,
	owner boolean NOT NULL,
	age integer NOT NULL,
	state text,
	CONSTRAINT positive_age CHECK (age >= 0)
);

CREATE TABLE category
(
	ID SERIAL PRIMARY KEY,
	category_name text NOT NULL,
	description text	
);

CREATE TABLE product
(
	SKU integer PRIMARY KEY,
	name text NOT NULL,
	list_price integer NOT NULL,
	categoryID integer REFERENCES category (ID) NOT NULL   
	CONSTRAINT positive_price CHECK (list_price >= 0)
);

CREATE TABLE cart (
	ID SERIAL PRIMARY KEY,
	userID integer REFERENCES shop_user(ID),
	productSKU integer REFERENCES product(SKU)
);

CREATE TABLE purchase (
	ID SERIAL PRIMARY KEY,
	userID integer REFERENCES shop_user(ID),
	productSKU integer REFERENCES product(SKU),
	purchase_date timestamp NOT NUll
);