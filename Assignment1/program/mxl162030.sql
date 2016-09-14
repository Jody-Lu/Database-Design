/* Part 1 */

/*
1. Create all the tables given in the following schema (Figure 4.6).
Define required constraints on given tables.s
Define triggered actions that will be attached to each foreign key constraint.
*/

-- Create all tables

/*
I defined the triggered actions in all foreign keys with CASCADE DELETE because,
in this schema, whenever a record is deleted, then the related records in the
database should be deleted automatically. For example, once I remove a borrower in table BORROWER,
and then the information about this borrower in table BOOK_LOANS should be deleted.
It makes sense that if the information about a borrower is not available,
we don’t have his/her records of the loan.
*/

CREATE TABLE PUBLISHERR (
  NAME         VARCHAR(15)    NOT NULL,
  Address      VARCHAR(30),
  Phone        CHAR(10),
  PRIMARY KEY(PNAME)
);


CREATE TABLE BOOK (
  Book_id         CHAR(10)     NOT NULL,
  Title           VARCHAR(20)  NOT NULL,
  Publisher_name  VARCHAR(20)  NOT NULL,
  PRIMARY KEY(Book_id),
  FOREIGN KEY(Publisher_name) REFERENCES PUBLISHER(NAME) ON DELETE CASCADE ENABLE
);


CREATE TABLE BOOK_AUTHOR (
  Book_id         CHAR(10)     NOT NULL,
  Author_name     VARCHAR(15)  NOT NULL,
  PRIMARY KEY(Book_id, Author_name),
  FOREIGN KEY(Book_id) REFERENCES BOOK(Book_id) ON DELETE CASCADE ENABLE
);


CREATE TABLE LIBRARY_BRANCH (
  Branch_id       INT          NOT NULL,
  Branch_name     VARCHAR(10),
  Address         VARCHAR(30),
  PRIMARY KEY(Branch_id)
);


CREATE TABLE BOOK_COPIES (
  Book_id         CHAR(10)     NOT NULL,
  Branch_id       INT          NOT NULL,
  No_of_copies    INT,
  PRIMARY KEY(Book_id, Branch_id),
  FOREIGN KEY(Book_id) REFERENCES BOOK(Book_id) ON DELETE CASCADE ENABLE,
  FOREIGN KEY(Branch_id) REFERENCES LIBRARY_BRANCH(Branch_id) ON DELETE CASCADE ENABLE
);


CREATE TABLE BORROWER (
  Card_no         CHAR(10)    NOT NULL,
  Name            VARCHAR(10),
  Address         VARCHAR(30),
  Phone           CHAR(10),
  PRIMARY KEY(Card_no)
);


CREATE TABLE BOOK_LOANS (
  Book_id         CHAR(10)  NOT NULL,
  Branch_id       INT       NOT NULL,
  Card_no         CHAR(10)  NOT NULL,
  Date_out        DATE,
  Due_date        DATE,
  PRIMARY KEY(Book_id, Branch_id, Card_no),
  FOREIGN KEY(Book_id) REFERENCES BOOK(Book_id) ON DELETE CASCADE ENABLE,
  FOREIGN KEY(Branch_id) REFERENCES LIBRARY_BRANCH(Branch_id) ON DELETE CASCADE ENABLE,
  FOREIGN KEY(Card_no) REFERENCES BORROWER(Card_no) ON DELETE CASCADE ENABLE
);

-- Schema change in table BOOK_LOANS

ALTER TABLE BOOK_LOANS
ADD RETURN_DATE DATE;


/*
2. Insert two imaginary tuples into each table.
*/

/* Insert data into PUBLISHER. */
INSERT INTO PUBLISHER VALUES('Tom', 'Dallas', '4693631618');
INSERT INTO PUBLISHER VALUES('John', 'Pola Auto', '1234568');


/* Insert data into BOOK. */
INSERT INTO BOOK VALUES('123', 'Hello World!', 'Tom');
INSERT INTO BOOK VALUES('456', 'Welcome SQL!', 'John');

/* Insert data into BOOK_AUTHOR. */
INSERT INTO BOOK_AUTHOR VALUES('123', 'David');
INSERT INTO BOOK_AUTHOR VALUES('456', 'Jody');

/* Insert data into LIBRARY_BRANCH. */
INSERT INTO LIBRARY_BRANCH VALUES('999', 'Plano', 'San Jose');
INSERT INTO LIBRARY_BRANCH VALUES('888', 'Richarson', 'Washington');

/* Insert data into BOOK_COPIES. */
INSERT INTO BOOK_COPIES VALUES('123', 999, 3);
INSERT INTO BOOK_COPIES VALUES('456', 888, 2);

/* Insert data into BORROWER. */
INSERT INTO BORROWER VALUES('1', 'Johnson', 'New York', '0922850');
INSERT INTO BORROWER VALUES('2', 'Jay', 'New Mechico', '091234');

/* Insert data into BOOK_LOANS. */
INSERT INTO BOOK_LOANS VALUES('123', 999, '1', TO_DATE('01-02-2016', 'MM-DD-YYYY'), TO_DATE('01-04-2016', 'MM-DD-YYYY'));
INSERT INTO BOOK_LOANS VALUES('456', 888, '2', TO_DATE('01-03-2016', 'MM-DD-YYYY'), TO_DATE('01-04-2016', 'MM-DD-YYYY'));


/*
3. Find the books that have been borrowed from Harrington Library in
last 14 days and that have not been returned yet.
*/

--FROM BOOK B, LIBRARY_BRANCH L

/*
4. For Harrington Library, increase number of copies
for the book entitled “The Ocean” by 5.
*/

UPDATE BOOK_COPIES B
INNER JOIN LIBRARY_BRANCH L ON B.Branch_id = L.Branch_id
INNER JOIN BOOK ON B.Book_id = BOOK.Book_id
SET B.No_of_copies = 5
WHERE L.Branch_name = 'Harrington'
  AND BOOK.Title = 'The Ocean';

/*
5. Delete an existing borrower from the system.
Explain how other tables are affected from this delete
based on the triggered actions you have defined at #1.
*/


/* Part 2-1 */

/*
a. For each department whose average employee salary is more than $30,000,
retrieve the department name and the number of employees working for that department.
*/

SELECT D.Dname, Count(Ssn)
FROM DEPARTMENT D, EMPLOYEE E
WHERE D.Dno = E.Dno
GROUP BY D.Dname
HAVING AVG(Salary) > 30000;

/*
b. Same as a, except output the number of male
employees instead of the number of employees.
*/

SELECT D1.Dname, COUNT(E1.Ssn)
FROM DEPARTMENT D1, EMPLOYEE E1
WHERE Dname IN
        (SELECT D.Dname
         FROM DEPARTMENT D, EMPLOYEE E
         WHERE D.Dno = E.Dno
         GROUP BY D.Dname
         HAVING Avg(Salary) > 30000)
AND D1.Dno = E1.Dno
AND E1.SEX = 'M'
GROUP BY D1.Dname;

/*
c. Retrieve the names of all employees who work in the department that
has the employee with the highest salary among all employees.
*/

SELECT D2.Dname, E2.FNAME, E2.LNAME
FROM EMPLOYEE E2, DEPARTMENT D2
WHERE (D2.Dname, E2.Salary) IN
       (SELECT D.Dname, MAX(E.Salary)
        FROM DEPARTMENT D, EMPLOYEE E
        WHERE D.Dno = E.Dno
        GROUP BY D.Dname);

/*
d. Retrieve the names of employees who make at least $10,000
more than the employee who is paid the least in the company.
*/

SELECT E2.FNAME, E2.LNAME
FROM EMPLOYEE E2
WHERE E2.Salary >=
       (SELECT (MIN(E.Salary) + 1000)
        FROM EMPLOYEE E);

/*
e. Retrieve the names of employees who is making least in their departments
and have more than one dependent. (solve using correlated nested queries)
*/

SELECT E1.FNAME, E1.LNAME, E1.Salary, E1.Ssn
FROM EMPLOYEE E1, DEPARTMENT D1
WHERE D1.Dno = E1.Dno
AND (D1.Dname, E1.Salary) IN
    (SELECT D.Dname, MIN(E.Salary)
     FROM EMPLOYEE E, DEPARTMENT D
     WHERE E.Dno = D.Dno
     GROUP BY D.Dname)
AND (SELECT COUNT(DP.DEPNAME)
     FROM DEPENDENT DP
     WHERE DP.Essn = E2.Ssn
     GROUP BY DP.Essn) > 1;


/* Part 2-2 */

/*
a. A view that has the department name,
manager name and manager salary for every department.
*/

CREATE VIEW PROBLEM_A As
SELECT D.Dname, E.FNAME, E.LNAME, E.Salary
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.Dno = D.Dno
AND E.Ssn = D.MGRSSN;

/*
b. (4) A view that has the department name, its manager's name,
"number of employees" working in that department,
and the number of projects controlled by that department (for each department).
*/

CREATE VIEW PROBLEM_B AS
SELECT *
FROM(SELECT D.Dname, E.FNAME, E.LNAME, COUNT(P.PNAME)
     FROM DEPARTMENT D, PROJECT P, EMPLOYEE E
     WHERE P.Dno = D.Dno
     AND E.Ssn = D.MGRSSN
     GROUP BY D.Dname, E.FNAME, E.LNAME)
NATURAL JOIN (SELECT D.Dname, COUNT(E.Ssn)
              FROM DEPARTMENT D, EMPLOYEE E, PROJECT P
              WHERE D.Dno = E.Dno
              GROUP BY D.Dname) K;

/*
c. A view that has the project name, controlling department name,
number of employees working on the project,
and the total hours per week they work on the project (for each project).
*/

CREATE VIEW PROBLEM_C As
SELECT P.Pname, D.Dname, COUNT(W.Ssn), SUM(W.HOURS)
FROM PROJECT P, WORKS_ON W, DEPARTMENT D
WHERE P.Pno = W.Pno
AND P.Dno = D.Dno
GROUP BY P.Pname, D.Dname;

/*
d. A view that has the project name, controlling department name,
number of employees, and total hours worked per week on the project
for each project with more than one employee working on it.
*/

CREATE VIEW PROBLEM_D AS
SELECT P.Pname, D.Dname, COUNT(W.Ssn), SUM(W.Hours)
FROM PROJECT P, WORKS_ON W, DEPARTMENT D
WHERE P.Pno = W.Pno
AND P.Dno = D.Dno
GROUP BY P.Pname, D.Dname
HAVING COUNT(W.Ssn) > 1;

/*
e. A view that has the employee name, employee salary,
department that the employee works in, department manager name,
manager salary, and average salary for the department.
*/

CREATE VIEW PROBLEM_E AS
SELECT E.FNAME, E.LNAME, E.Salary, D.Dname, E1.FNAME, E1.LNAME, E1.SALARY, (SELECT AVG(E.Salary)
                                                                            FROM EMPLOYEE E
                                                                            WHERE E.Dno = D.Dno
                                                                            GROUP BY D.Dno) AS Avg_salary
FROM EMPLOYEE E, DEPARTMENT D, EMPLOYEE E1
WHERE E.Dno = D.Dno
AND E1.Ssn = D.MGRSSN;



