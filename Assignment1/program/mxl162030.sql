-- Test --
SELECT D.Dname, E.FNAME, E.LNAME, E.Sex
  FROM DEPARTMENT D, EMPLOYEE E
 WHERE D.Dno = E.Dno
   AND E.Sex = 'M';

/**************************************/
SELECT AVG(E.Salary)
  FROM EMPLOYEE E;

/* 1. Write following queries in SQL1.*/
-- a --
  SELECT D.Dname, Count(Ssn)
    FROM DEPARTMENT D, EMPLOYEE E
   WHERE D.Dno = E.Dno
GROUP BY D.Dname
  HAVING AVG(Salary) > 30000;

-- b --

  SELECT D2.Dname, COUNT(E2.Ssn)
    FROM DEPARTMENT D2, EMPLOYEE E2
   WHERE Dname IN
         (SELECT D.Dname
            FROM DEPARTMENT D, EMPLOYEE E
           WHERE D.Dno = E.Dno
        GROUP BY D.Dname
          HAVING Avg(Salary) > 30000)
     AND D2.Dno = E2.Dno
     AND E2.SEX = 'M'
GROUP BY D2.Dname;

-- c --
/*
1. Retrieve the highest Salary from each Department (J)
2. Retrieve the name whose salary equals J.Salary and Dname = J.Dname
*/

SELECT D2.Dname, E2.FNAME, E2.LNAME
  FROM EMPLOYEE E2, DEPARTMENT D2
 WHERE (D2.Dname, E2.Salary) IN
       (SELECT D.Dname, MAX(E.Salary)
          FROM DEPARTMENT D, EMPLOYEE E
         WHERE D.Dno = E.Dno
      GROUP BY D.Dname);

-- d --

SELECT E2.FNAME, E2.LNAME
  FROM EMPLOYEE E2
 WHERE E2.Salary >=
       (SELECT MIN(E.Salary) + 1000
          FROM EMPLOYEE E);

-- e -- ****

SELECT E2.FNAME, E2.LNAME, E2.Salary, E2.Ssn
  FROM EMPLOYEE E2, DEPARTMENT D2
 WHERE D2.Dno = E2.Dno
   AND (D2.Dname, E2.Salary) IN
       (SELECT D.Dname, MIN(E.Salary)
          FROM EMPLOYEE E, DEPARTMENT D
         WHERE E.Dno = D.Dno
      GROUP BY D.Dname)
   AND (SELECT COUNT(DP.DEPNAME)
          FROM DEPENDENT DP
         WHERE DP.Essn = E2.Ssn
      GROUP BY DP.Essn) > 1;

/*
SELECT E.FNAME, E.LNAME
  FROM EMPLOYEE E
 WHERE (SELECT COUNT(*)
          FROM DEPENDENT DP
         WHERE DP.Essn = E.Ssn) > 1;

   SELECT DP.Essn, COUNT(*)
     FROM DEPENDENT DP, EMPLOYEE E
    WHERE DP.Essn = E.Ssn
 GROUP BY DP.Essn;

SELECT *
  FROM EMPLOYEE
 WHERE SSN = 333445555;
*/

/* 2.*/

/*
a. A view that has the department name,
manager name and manager salary for every department.
*/
CREATE VIEW Mgr_view As
     SELECT D.Dname, E.FNAME, E.LNAME, E.Salary
       FROM EMPLOYEE E, DEPARTMENT D
      WHERE E.Dno = D.Dno
        AND E.Ssn = D.MGRSSN;

/*
b. A view that has the department name, its manager's name,
number of employees working in that department,
and the number of projects controlled by that department (for each department).
*/

CREATE VIEW Dep_view AS
     SELECT D.Dname, E.FNAME, E.LNAME, COUNT(P.PNAME)
       FROM DEPARTMENT D, PROJECT P, EMPLOYEE E
      WHERE P.Dno = D.Dno
        AND E.Ssn = D.MGRSSN
   GROUP BY D.Dname, E.FNAME, E.LNAME;

/*
c. A view that has the project name, controlling department name,
number of employees working on the project,
and the total hours per week they work on the project (for each project).
*/

CREATE VIEW Project_view As
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

SELECT E.FNAME, E.LNAME, E.Salary, D.Dname, E1.FNAME, E1.LNAME, E1.SALARY, (SELECT AVG(E.Salary)
                                                                              FROM EMPLOYEE E
                                                                             WHERE E.Dno = D.Dno
                                                                          GROUP BY D.Dno) AS Avg_salary
  FROM EMPLOYEE E, DEPARTMENT D, EMPLOYEE E1
 WHERE E.Dno = D.Dno
   AND E1.Ssn = D.MGRSSN;




