DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS requests;
DROP TABLE IF EXISTS people;
DROP TABLE IF EXISTS businesses;
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id int NOT NULL AUTO_INCREMENT,
    email varchar(255) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (email)
);

CREATE TABLE people (
    id int NOT NULL AUTO_INCREMENT,
    user_id int NOT NULL,
    first_name varchar(100) NOT NULL,
    last_name varchar(100) NOT NULL,
    phone_number varchar(100) NOT NULL,
    zip_code varchar(100) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE businesses (
    id int NOT NULL AUTO_INCREMENT,
    user_id int NOT NULL,
    company_name varchar(200) NOT NULL,
    company_url varchar(200) NOT NULL,
    company_description varchar(320) NOT NULL,
    phone_number varchar(100) NOT NULL,
    address varchar(300) NOT NULL,
    zip_code varchar(100) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE appointments (
    id int NOT NULL AUTO_INCREMENT,
    business_id int NOT NULL,
    person_id int NOT NULL,
    title varchar(255) NOT NULL,
    description varchar(255),
    date datetime,
    created_at datetime,
    PRIMARY KEY (id),
    FOREIGN KEY (business_id) REFERENCES businesses(id)
);

CREATE TABLE posts (
    id int NOT NULL AUTO_INCREMENT,
    business_id int NOT NULL,
    title varchar(255) NOT NULL,
    description varchar(255),
    created_at datetime,
    PRIMARY KEY (id),
    FOREIGN KEY (business_id) REFERENCES businesses(id)
);

CREATE TABLE requests (
    id int NOT NULL AUTO_INCREMENT,
    person_id int NOT NULL,
    title varchar(255) NOT NULL,
    description varchar(255),
    created_at datetime,
    PRIMARY KEY (id),
    FOREIGN KEY (person_id) REFERENCES people(id)
);

CREATE TABLE messages (
    id int NOT NULL AUTO_INCREMENT,
    sender_user_id int NOT NULL,
    recipient_user_id int NOT NULL,
    subject varchar(255),
    text text,
    created_at datetime,
    PRIMARY KEY (id),
    FOREIGN KEY (sender_user_id) REFERENCES users(id),
    FOREIGN KEY (recipient_user_id) REFERENCES users(id)
);

-- People
INSERT INTO users (email) VALUES ("Joshy@gmail.com");
INSERT INTO people (user_id, first_name, last_name, phone_number, zip_code)
VALUES (LAST_INSERT_ID(), "Josh", "Young", "111-222-3333", "11112");

INSERT INTO users (email) VALUES ("Tfish@gmail.com");
INSERT INTO people (user_id, first_name, last_name, phone_number, zip_code)
VALUES (LAST_INSERT_ID(), "Trevor", "Fisher", "222-333-4444", "11113");

INSERT INTO users (email) VALUES ("Cjacobs@gmail.com");
INSERT INTO people (user_id, first_name, last_name, phone_number, zip_code)
VALUES (LAST_INSERT_ID(), "Cory", "Jacobs", "123-456-7897", "11122");

INSERT INTO users (email) VALUES ("Kfutz@gmail.com");
INSERT INTO people (user_id, first_name, last_name, phone_number, zip_code)
VALUES (LAST_INSERT_ID(), "Kyle", "Fultz", "123-456-7898", "11133");

-- Businesses
INSERT INTO users (email) VALUES ("Tomshvac@gmail.com");
INSERT INTO businesses (user_id, company_name, company_url, company_description, phone_number, address, zip_code)
VALUES (LAST_INSERT_ID(), "Tom's HVAC", "Tomshvac.com", "We have an amazing team of HVAC Technicians that will help keep your home comfortable!", "123-456-7894", "216 N Walnut St, Bloomington, IN", "47404");

INSERT INTO users (email) VALUES ("Kostasplumbing@gmail.com");
INSERT INTO businesses (user_id, company_name, company_url, company_description, phone_number, address, zip_code)
VALUES (LAST_INSERT_ID(), "Kosta's Plumbing", "Kostasplumbing.com", "All of your plumbing needs!", "123-456-7893", "301 E 3rd St, Bloomington, IN", "47401"); 

INSERT INTO users (email) VALUES ("Artieselectric@gmail.com");
INSERT INTO businesses (user_id, company_name, company_url, company_description, phone_number, address, zip_code)
VALUES (LAST_INSERT_ID(), "Artie's Electric", "Artieselectric.com", "If you are having any issues with lighting or electricity in your home, then contact us!", "123-456-7892", "480 N Morton St, Bloomington, IN", "47404");

INSERT INTO users (email) VALUES ("Elispainting@gmail.com");
INSERT INTO businesses (user_id, company_name, company_url, company_description, phone_number, address, zip_code)
VALUES (LAST_INSERT_ID(), "Eli's Painting", "Elispainting.com", "Specialize in painting exterior and interior homes.", "123-456-7891", "1402 N Walnut St, Bloomington, IN", "47404");

INSERT INTO users (email) VALUES ("Roofguys@gmail.com");
INSERT INTO businesses (user_id, company_name, company_url, company_description, phone_number, address, zip_code)
VALUES (LAST_INSERT_ID(), "Roof Guys", "Roofguys.com", "We are a amazing roofing company!", "123-456-7890", "3900 Farmer Ave, Bloomington, IN", "47403");


-- Posts
INSERT INTO posts (business_id, title, description, created_at)
VALUES (1, "AC Units Available", "As we prepare for the hot summer, make sure to get a new air conditioning unit installed by us!", NOW());

INSERT INTO posts (business_id, title, description, created_at)
VALUES (2, "50% off leaky sinks!", "Leaky sinks are annoying and we can fix them for a low price! We are currently doing half off sink fixes!", NOW());

INSERT INTO posts (business_id, title, description, created_at)
VALUES (3, "Discounts on outdoor lighting!", "We will be running discounts on outdoor lighting all summer long!", NOW());

INSERT INTO posts (business_id, title, description, created_at)
VALUES (4, "New colors available!", "We have updated our color selections to include a whole new magnitude of colors and shades!", NOW());

INSERT INTO posts (business_id, title, description, created_at)
VALUES (5, "New roofing materials", "Make your roof look amazing with our new premium roofing materials!", NOW());

-- Requests
INSERT INTO requests (person_id, title, description, created_at)
VALUES (1, "Hole in roof!", "I have a hole in my roof that I need fixed. Please contact me to schedule an appointment.", NOW());

INSERT INTO requests (person_id, title, description, created_at)
VALUES (2, "Repainting house", "We have recently purchased a new house and have decided to repaint it a different color. Please contact me about setting up an appointment.", NOW());

INSERT INTO requests (person_id, title, description, created_at)
VALUES (3, "Shower light out", "I have a shower light that has gone out that I need repaired. I believe it is an electrical issue. Please contact me if you can assist.", NOW());

-- Messages
INSERT INTO messages (sender_user_id, recipient_user_id, subject, text, created_at)
VALUES (1, 2, "Message 1", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis facilisis elit vitae tincidunt consequat.", NOW());

INSERT INTO messages (sender_user_id, recipient_user_id, subject, text, created_at)
VALUES (1, 3, "Message 2", "Vestibulum at dolor nec nisl efficitur elementum. Maecenas vehicula metus quam, dictum consectetur tortor imperdiet ac.", NOW());

INSERT INTO messages (sender_user_id, recipient_user_id, subject, text, created_at)
VALUES (2, 1, "Message 3", "Nulla accumsan pharetra neque, sed dictum ipsum. Suspendisse nec dolor non lacus dapibus imperdiet ac rhoncus mi. Etiam eu mauris eu dui semper mollis.", NOW());

INSERT INTO messages (sender_user_id, recipient_user_id, subject, text, created_at)
VALUES (3, 1, "Message 4", "Sed auctor metus vitae ipsum luctus aliquam. Proin urna nisl, vehicula nec tellus et, iaculis lacinia nisl.", NOW());

INSERT INTO messages (sender_user_id, recipient_user_id, subject, text, created_at)
VALUES (4, 1, "Message 5", "Cras ligula erat, dictum et bibendum nec, convallis at massa. Nulla massa leo, imperdiet et turpis pulvinar, interdum dignissim sapien.", NOW());