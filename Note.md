**Foreign Key**

1. To enforce the relationship between two tables.

```sql
CREATE TABLE track(
  trackid     INTEGER, 
  trackname   TEXT, 
  trackartist INTEGER,
  FOREIGN KEY(trackartist) REFERENCES artist(artistid)
);
```
If you insert a value into ``trackartist`` that is not exists in ``artistid``, you will receive error.  

**View (virtual table)**

1. A view contains rows and columns, just like a real table. The fields in a view are fields from one or more real tables in the database.
2. You can add SQL functions, WHERE, and JOIN statements to a view and present the data as if the data were coming from one single table.
3. Restrict accesssing ability to data.
4. Summarize data, used to generate result.

**Create View**

From **Single table** or **multiple table** or **anther view**.

```sql
Create View view_name As
Select column1, column2
From table_name
Where [condition] (optional)
```
**With Check** condition

To ensure that all UPDATE and INSERTs satisfy the condition(s) in the view definition.

```sql
CREATE VIEW CUSTOMERS_VIEW AS
SELECT name, age
FROM  CUSTOMERS
WHERE age IS NOT NULL
WITH CHECK OPTION;
```
For example,

```sql
CREATE VIEW CUSTOMERS_VIEW AS
SELECT name, age
FROM  CUSTOMERS
WHERE age IS NOT NULL
WITH CHECK OPTION;
```
The WITH CHECK OPTION in this case should deny the entry of any NULL values in the view's AGE column, because the view is defined by data that does not have a NULL value in the AGE column.


##Three Main Way to Combine Tables
**To combine the information seperated in different tables.**

**1. Join**

A glue that puts the database back together.

Ex:

```sql
SELECT  Person.FirstName,
        Person.LastName,
        PersonPhone.PhoneNumber
 FROM   Person.Person
        INNER JOIN Person.PersonPhone
        ON Person.BusinessEntityID = 
           PersonPhone.BusinessEntityID
           
           
```

**2. Union**

A UNION is used to combine the rows of two or more queries into one result. UNION is called a **Set Operator**.

**Conditions:**

1. Same number of columns.
2. data type of each column must be compatible.

Ex:

```sql
SELECT C.Name
FROM   Production.ProductCategory AS C
UNION
SELECT S.Name
FROM   Production.ProductSubcategory AS S
```

**Others:**

1. **INTERSECT:** You can use this to only return row that are common between two tables. 
2. **EXCEPT:** You can use this to return rows that exist on one table, but aren’t found in another.

**3. Sub Queries**

1. SELECT clause
2. WHERE clause
3. HANING
