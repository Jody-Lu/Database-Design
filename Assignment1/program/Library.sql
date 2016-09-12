-- 1. --

Create Table PUBLISHERR (
  NAME        VARCHAR(15)     Not NULL,
  Address      VARCHAR(30),
  Phone        CHAR(10),
  Primary Key(PNAME)
);


Create Table BOOK (
  Book_id         VARCHAR(15),
  Title           VARCHAR(30),
  Publisher_name  VARCHAR(30),
  Primary Key(Book_id),
  Foreign Key(Publisher_name) references PUBLISHER(NAME)
);


Create Table BOOK_AUTHOR (
  Book_id         VARCHAR(15),
  Author_name     VARCHAR(15),
  Primary Key(Book_id, Author_name),
  Foreign Key(Book_id) references BOOK(Book_id)
);


Create Table LIBRARY_BRANCH (
  Branch_id       VARCHAR(15),
  Branch_name     VARCHAR(30),
  Address         VARCHAR(30),
  Primary Key(Branch_id) 
);


Create Table BOOK_COPIES (
  Book_id         VARCHAR(15),
  Branch_id       VARCHAR(15),
  No_of_copies    INT,
  Primary Key(Book_id, Branch_id),
  Foreign Key(Book_id) references BOOK(Book_id),
  Foreign Key(Branch_id) references LIBRARY_BRANCH(Branch_id)
);


Create Table BORROWER (
  Card_no         INT,
  Name            VARCHAR(15),
  Address         VARCHAR(30),
  Phone           VARCHAR(15),
  Primary Key(Card_no) 
);


Create Table BOOK_LOANS (
  Book_id         VARCHAR(15),
  Branch_id       VARCHAR(15),
  Card_no         INT,
  Date_out        VARCHAR(15),
  Due_date        VARCHAR(15),
  Primary Key(Book_id, Branch_id, Card_no),
  Foreign Key(Book_id) references BOOK(Book_id),
  Foreign Key(Branch_id) references LIBRARY_BRANCH(Branch_id),
  Foreign Key(Card_no) references BORROWER(Card_no)
);

-- 2. --

/* Insert data into PUBLISHER. */
Insert Into PUBLISHER Values('Tom', 'Dallas', '4693631618');
Insert Into PUBLISHER Values('John', 'Pola Auto', '1234568');


/* Insert data into BOOK. */
Insert Into BOOK Values('123', 'Hello World!', 'Tom');
Insert Into BOOK Values('456', 'Welcome SQL!', 'John');

/* Insert data into BOOK_AUTHOR. */
Insert Into BOOK_AUTHOR Values('123', 'David');
Insert Into BOOK_AUTHOR Values('456', 'Jody');

/* Insert data into LIBRARY_BRANCH. */
Insert Into LIBRARY_BRANCH Values('999', 'Plano', 'San Jose');
Insert Into LIBRARY_BRANCH Values('888', 'Richarson', 'Washington');

/* Insert data into BOOK_COPIES. */
Insert Into BOOK_COPIES Values('123', '999', 3);
Insert Into BOOK_COPIES Values('456', '888', 2);

/* Insert data into BORROWER. */
Insert Into BORROWER Values(1, 'Johnson', 'New York', '0922850');
Insert Into BORROWER Values(2, 'Jay', 'New Mechico', '091234');

/* Insert data into BOOK_LOANS. */
Insert Into BOOK_LOANS Values('123', '999', 1, '20160102', '20160104');
Insert Into BOOK_LOANS Values('456', '888', 2, '20160102', '20160104');

