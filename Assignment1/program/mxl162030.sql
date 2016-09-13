/* Part 2-1*/

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
       (SELECT MIN(E.Salary) + 1000
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


/* Part 2-2*/

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




