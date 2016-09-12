-- Test --
Select D.Dname, E.FNAME, E.LNAME, E.Sex
From DEPARTMENT D, EMPLOYEE E
Where D.Dno = E.Dno and E.Sex = 'M';

/**************************************/
Select avg(E.Salary)
From EMPLOYEE E;

/* 1. Write following queries in SQL1.*/
-- a -- 
Select D.Dname, Count(Ssn)
From DEPARTMENT D, EMPLOYEE E
Where D.Dno = E.Dno
Group By D.Dname
Having Avg(Salary) > 30000;

-- b --
Select D2.Dname, Count(E2.Ssn)
From DEPARTMENT D2, EMPLOYEE E2,
(Select D.Dname
From DEPARTMENT D, EMPLOYEE E
Where D.Dno = E.Dno
Group By D.Dname
Having Avg(E.Salary) > 30000) J
Where D2.Dno = E2.Dno and D2.Dname = J.Dname and E2.Sex = 'M'
Group By D2.Dname;

-- c --
/*
1. Retrieve the highest Salary from each Department (J)
2. Retrieve the name whose salary equals J.Salary and Dname = J.Dname
*/
Select J.Dname, E2.FNAME, E2.LNAME
From EMPLOYEE E2, DEPARTMENT D2,
(Select D.Dname, Max(E.Salary) As S
From EMPLOYEE E, DEPARTMENT D
Where D.Dno = E.Dno
Group By D.Dname) J
Where E2.Dno = D2.Dno and D2.Dname = J.Dname and E2.Salary = J.S 
Order By J.Dname;

-- d --

Select D2.Dname, E2.FNAME, E2.LNAME, E2.Salary 
From EMPLOYEE E2, DEPARTMENT D2,
(Select D.Dname, Min(E.Salary) As S
From EMPLOYEE E, DEPARTMENT D
Where D.Dno = E.Dno
Group By D.Dname) J
Where E2.Dno = D2.Dno and D2.Dname = J.Dname and E2.Salary >= (J.S + 10000);

-- e --
Select D3.Essn
From DEPENDENT D3,
(Select E2.FNAME, E2.LNAME, E2.Ssn
From EMPLOYEE E2, DEPARTMENT D2,
(Select D.Dname, Min(E.Salary) S
From EMPLOYEE E, DEPARTMENT D
Where E.Dno = D.Dno
Group By D.Dname) J
Where E2.Dno = D2.Dno and D2.Dname = J.Dname and E2.Salary = J.S) K
Where K.Ssn = D3.Essn;

Select D3.Essn, Count(D3.Essn) N
From DEPENDENT D3
Group By D3.Essn;

/* 2.*/



