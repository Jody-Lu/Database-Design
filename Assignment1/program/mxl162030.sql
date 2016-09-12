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

SELECT E2.FNAME, E2.LNAME
  FROM EMPLOYEE E2, DEPARTMENT D2, DEPENDENT DP
 WHERE D2.Dno = E2.Dno
   AND (D2.Dname, E2.Salary) IN
       (SELECT D.Dname, MIN(E.Salary)
          FROM EMPLOYEE E, DEPARTMENT D
         WHERE E.Dno = D.Dno
      GROUP BY D.Dname);

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

  SELECT D2.Dname, E2.FNAME, E2.LNAME, COUNT(P2.PNAME)
    FROM DEPARTMENT D2, PROJECT P2, EMPLOYEE E2
   WHERE P2.Dno = D2.Dno
     AND E2.Ssn = D2.MGRSSN
GROUP BY D2.Dname, E2.FNAME, E2.LNAME;

SELECT *
  FROM PROJECT;



--Create View Dep_view As -- create view
Select K.Dname, E2.FNAME, E2.LNAME, K.people, K.projects -- include mgr's name
From EMPLOYEE E2,
(Select J.Dname Dname, J.mgrssn mgrssn, J.people people, Count(*) projects -- include number of projects
From PROJECT P,
(Select D.Dname Dname, D.Dno Dno, D.mgrssn mgrssn, Count(E.Ssn) people -- Got each department's mgr's SSN and its name
From DEPARTMENT D, EMPLOYEE E
Where D.Dno = E.Dno
Group By D.Dname, D.Dno, D.mgrssn) J
Where P.Dno = J.Dno
Group By J.Dname, J.mgrssn, J.people) K
Where E2.ssn = K.mgrssn;

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

/* FOR DEBUG
  SELECT W.Pno, COUNT(W.Ssn)
    FROM WORKS_ON W
GROUP BY W.Pno;

SELECT W.PNO
  FROM WORKS_ON W;
  
SELECT P.PNAME, P.PNO
  FROM PROJECT P;
*/
/*
  SELECT P.Pname, D.Dname
    FROM PROJECT P, DEPARTMENT D, EMPLOYEE E
   WHERE P.Dno = D.Dno
     AND E.Dno = D.Dno
ORDER BY P.Pname;
*/



/*
d. A view that has the project name, controlling department name, 
number of employees, and total hours worked per week on the project 
for each project with more than one employee working on it.
*/

Create View problem_d_view As
Select K.Pname, K.Dname, K.People, J.Hours
From
(Select P.Pname Pname, D.Dname Dname, Count(E.Ssn) People
From Project P, DEPARTMENT D, EMPLOYEE E
Where P.Dno = D.Dno and E.Dno = D.Dno
Group By P.Pname, D.Dname
Having Count(E.Ssn) > 1) K,
(Select P.Pname Pname, Sum(W.HOURS) Hours
From WORKS_ON W, PROJECT P
Where W.PNO = P.PNO
Group By P.Pname) J
Where K.Pname = J.Pname;

/*
e. A view that has the employee name, employee salary, 
department that the employee works in, department manager name, 
manager salary, and average salary for the department.
*/

Select E.FNAME, E.LNAME, E.Salary, D.Dname, MGR.MGRFNAME, MGR.MGRLNAME, MGR.MGRSalary
From EMPLOYEE E, DEPARTMENT D, 
(Select E2.FNAME MGRFNAME, E2.LNAME MGRLNAME, D2.Dname Dname, E2.SALARY MGRSalary 
From EMPLOYEE E2, DEPARTMENT D2
Where E2.SSN = D2.MGRSSN) MGR
Where E.Dno = D.Dno and MGR.Dname = D.Dname

Select D.Dname
From DEPARTMENT D;



