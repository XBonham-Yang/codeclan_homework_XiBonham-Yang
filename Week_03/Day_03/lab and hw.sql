/*Question 1.
How many employee records are lacking both a grade and salary?
*/
SELECT count(id) AS miss_g_s
FROM employees 
WHERE grade  IS NULL AND salary IS NULL;

/*Question 2.
Produce a table with the two following fields (columns):
the department
the employees full name (first and last name)
Order your resulting table alphabetically by department, and then by last name
*/
SELECT department,
concat(first_name, ' ', last_name) AS full_name
FROM employees
ORDER BY department, last_name;



/*Question 3.
Find the details of the top ten highest paid employees who have a last_name beginning with ‘A’.
*/
SELECT *
FROM employees 
WHERE last_name  LIKE 'A%'
ORDER BY salary 
LIMIT 10;


/*Question 4.
Obtain a count by department of the employees who started work with the corporation in 2003.
*/
SELECT count(id), department 
FROM employees
WHERE start_date <= '2003-12-31' AND start_date  >= '2003-01-01'
GROUP BY department;


/*Question 5.
Obtain a table showing department, fte_hours and the number of employees in each department who work each fte_hours pattern. 
Order the table alphabetically by department, and then in ascending order of fte_hours.
Hint
You need to GROUP BY two columns here.
*/
SELECT department, fte_hours, count(id)
FROM employees
GROUP BY department, fte_hours;

/*Question 6.
Provide a breakdown of the numbers of employees enrolled, not enrolled, and with unknown enrollment status in the corporation pension scheme.
*/
SELECT count(id) AS num, pension_enrol 
FROM employees 
GROUP BY pension_enrol; 


/*Question 7.
Obtain the details for the employee with the highest salary in the ‘Accounting’ department who is not enrolled in the pension scheme?
*/
SELECT *
FROM employees 
WHERE department = 'Accounting' AND pension_enrol = FALSE 
ORDER BY salary 
LIMIT 1;


/*Question 8.
Get a table of country, number of employees in that country, 
and the average salary of employees in that country for any countries in which 
more than 30 employees are based. Order the table by average salary descending.

Hints
A HAVING clause is needed to filter using an aggregate function.
You can pass a column alias to ORDER BY.
*/
SELECT country, 
count(id), 
avg(salary)
FROM employees 
GROUP BY country
HAVING count(id) > 30 
ORDER BY avg(salary) DESC NULLS LAST;

--- problem here 

/*Question 9.
11. Return a table containing each employees first_name, last_name, full-time equivalent hours (fte_hours), salary, 
and a new column effective_yearly_salary which should contain fte_hours multiplied by salary. 
Return only rows where effective_yearly_salary is more than 30000.
*/
SELECT 
first_name, 
last_name, 
fte_hours,
salary, 
(fte_hours * salary) AS effective_yearly_salary
FROM employees
GROUP BY first_name, last_name, fte_hours, salary 
HAVING fte_hours * salary >= 30000; 


/*Question 10
Find the details of all employees in either Data Team 1 or Data Team 2
Hint
name is a field in table `teams
*/
SELECT*
FROM employees AS e 
INNER JOIN teams AS t ON t.id = e.team_id 
WHERE t."name" = 'Data Team 1' OR t."name"  = 'Data Team 2';


/*
Question 11
Find the first name and last name of all employees who lack a local_tax_code.
Hint
local_tax_code is a field in table pay_details, and first_name and last_name are fields in table employees
*/
SELECT e.first_name, e.last_name 
FROM employees  AS e 
INNER JOIN pay_details AS p ON p.id = e.pay_detail_id 
WHERE p.local_tax_code  IS NULL;

/*
Question 12.
The expected_profit of an employee is defined as (48 * 35 * charge_cost - salary) * fte_hours,
where charge_cost depends upon the team to which the employee belongs. Get a table showing expected_profit for each employee.

Hints
charge_cost is in teams, while salary and fte_hours are in employees, so a join will be necessary
You will need to change the type of charge_cost in order to perform the calculation
*/
SELECT (48*35*CAST(t.charge_cost AS int) - e.salary)* e.fte_hours AS expected_profit, 
e.first_name , e.last_name 
FROM employees  AS e
INNER JOIN teams  AS t ON t.id  = e.team_id;


/*
Question 13. [Tough]
Find the first_name, last_name and salary of the lowest paid employee in Japan 
who works the least common full-time equivalent hours across the corporation.”
Hint
You will need to use a subquery to calculate the mode
*/
SELECT first_name , last_name ,salary 
FROM employees 
WHERE country = 'Japan' 
AND fte_hours = (SELECT fte_hours
                 FROM employees 
                 GROUP BY fte_hours
                 HAVING count(id) = (
                 SELECT count(id)
                 FROM employees 
                 GROUP BY fte_hours
                 ORDER BY count(id) ASC NULLS LAST
                 LIMIT 1))
ORDER BY salary ASC NULLS LAST 
LIMIT 1;



/*Question 14.
Obtain a table showing any departments in which there are two or more employees 
lacking a stored first name. Order the table in descending order of the number of employees lacking a first name, 
and then in alphabetical order by department.
*/

SELECT count(id), department 
FROM employees 
WHERE first_name IS NULL 
GROUP BY department
HAVING count(id) >= 2
ORDER BY count(id) DESC, department;




/*Question 15. [Bit tougher]
Return a table of those employee first_names shared by more than one employee, 
together with a count of the number of times each first_name occurs. 
Omit employees without a stored first_name from the table. Order the table descending by count, and then alphabetically by first_name.
*/
SELECT
first_name, count(id)
FROM employees 
WHERE first_name IS NOT NULL 
GROUP BY first_name
HAVING count(id) > 1
ORDER BY first_name;

/*Question 16. [Tough]
Find the proportion of employees in each department who are grade 1.
Hints
Think of the desired proportion for a given department as the number of employees in that department who are grade 1, 
divided by the total number of employees in that department.

You can write an expression in a SELECT statement, e.g. grade = 1. This would result in BOOLEAN values.
If you could convert BOOLEAN to INTEGER 1 and 0, you could sum them. The CAST() function lets you convert data types.
In SQL, an INTEGER divided by an INTEGER yields an INTEGER. To get a REAL value, 
you need to convert the top, bottom or both sides of the division to REAL.
*/

SELECT 
round(CAST(sum(CAST(grade = 1 AS int)) AS NUMERIC)/ CAST(count(department) AS NUMERIC),2 )AS rate, department 
FROM employees 
GROUP BY department;



/*Question 1. [Tough]
Get a list of the id, first_name, last_name, department, salary and fte_hours of employees in the largest department. 
Add two extra columns showing the ratio of each employee’s salary to that department’s average salary, 
and each employee’s fte_hours to that department’s average fte_hours.
*/
WITH avg_sal AS (SELECT avg(salary)
                 FROM employees 
                 WHERE department = (SELECT department
                    FROM employees
                    GROUP BY department
                    HAVING count(id) = (
                    SELECT count(id)
                    FROM employees 
                    GROUP BY department 
                    ORDER BY count(id) DESC NULLS LAST 
                    LIMIT 1)
                    )
),
avg_fte AS (SELECT avg(fte_hours)
                 FROM employees 
                 WHERE department = (SELECT department
                    FROM employees
                    GROUP BY department
                    HAVING count(id) = (
                    SELECT count(id)
                    FROM employees 
                    GROUP BY department 
                    ORDER BY count(id) DESC NULLS LAST 
                    LIMIT 1)
                    ))
SELECT
id,first_name ,last_name,department,salary, 
fte_hours/(SELECT* FROM avg_fte) AS fte_rate, 
salary/(SELECT*FROM avg_sal) AS sal_rate
FROM employees 
WHERE department = (SELECT department
                    FROM employees
                    GROUP BY department
                    HAVING count(id) = (
                    SELECT count(id)
                    FROM employees 
                    GROUP BY department 
                    ORDER BY count(id) DESC NULLS LAST 
                    LIMIT 1)
                    )
GROUP BY id, first_name, last_name, salary;
  
                    


WITH biggest_dept_details(name, avg_salary, avg_fte_hours) AS (
  SELECT 
     department,
     AVG(salary),
     AVG(fte_hours)
  FROM employees
  GROUP BY department
  ORDER BY COUNT(id) DESC NULLS LAST
  LIMIT 1
)

-- can do more than one col 
/*
 [Extension - really tough! - how could you generalise your query 
to be able to handle the fact that two or more departments may be tied in their counts of employees. 
In that case, we probably don’t want to arbitrarily return details for employees in just one of these departments].
Hints
Writing a CTE to calculate the name, average salary and average fte_hours of the l
argest department is an efficient way to do this.
Another solution might involve combining a subquery with window functions
*/


/*Question 2.
Have a look again at your table for MVP question 6. 
It will likely contain a blank cell for the row relating to employees with ‘unknown’ pension enrollment status. 
This is ambiguous: it would be better if this cell contained ‘unknown’ or something similar. Can you find a way to do this, 
perhaps using a combination of COALESCE() and CAST(), or a CASE statement?

Hints
COALESCE() lets you substitute a chosen value for NULLs in a column, e.g. COALESCE(text_column, 'unknown') 
would substitute 'unknown' for every NULL in text_column. The substituted value has to match the data type of the 
column otherwise PostgreSQL will return an error.
CAST() let’s you change the data type of a column, 
e.g. CAST(boolean_column AS VARCHAR) will turn TRUE values in boolean_column into text 'true', FALSE to text 'false', 
and will leave NULLs as NULL
*/
SELECT count(id) AS num, pension_enrol,
COALESCE(CAST(pension_enrol AS varchar), 'unknow') AS pen_text
FROM employees 
GROUP BY pension_enrol; 

/*
 * Question 3. Find the first name, last name, email address and start date of all the employees 
 *who are members of the ‘Equality and Diversity’ committee. Order the member employees 
 *by their length of service in the company, longest first.
*/
SELECT e.first_name ,
e.last_name,
e.email, e.start_date,
now()-e.start_date AS len
FROM employees AS e 
INNER JOIN employees_committees  AS ec ON ec.employee_id  = e.id 
INNER JOIN committees AS c ON c.id = ec.committee_id 
WHERE c."name"  = 'Equality and Diversity'
ORDER BY len desc;


/*Question 4. [Tough!]
Use a CASE() operator to group employees who are members of committees 
into salary_class of 'low' (salary < 40000) or 'high' (salary >= 40000). 
A NULL salary should lead to 'none' in salary_class. Count the number of committee members in each salary_class.
Hints
You likely want to count DISTINCT() employees in each salary_class
You will need to GROUP BY salary_class
*/
SELECT CASE
    WHEN e.salary < 40000 THEN 'low'
    WHEN e.salary >=  40000 THEN 'high'
    ELSE 'none' 
    END AS salary_class,
    count(DISTINCT(e.id)) 
FROM employees AS e 
INNER JOIN employees_committees AS ec ON ec.employee_id = e.id 
GROUP BY salary_class;


SELECT 
  CASE 
    WHEN e.salary < 40000 THEN 'low'
    WHEN e.salary IS NULL THEN 'none'
    ELSE 'high' 
  END AS salary_class,
  COUNT(DISTINCT(e.id)) AS num_committee_members
FROM employees AS e INNER JOIN employees_committees AS ec
ON e.id = ec.employee_id
INNER JOIN committees AS c
ON ec.committee_id = c.id
GROUP BY salary_class






