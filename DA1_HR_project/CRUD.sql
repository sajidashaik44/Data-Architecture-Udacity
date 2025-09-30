-- CRUD operations:

-- Question 1: Return a list of employees with Job Titles and Department Names

SELECT Employee.emp_nm, Job.job_title, Department.dept_nm
FROM Employee
JOIN Employee_Job ON Employee.emp_id = Employee_Job.emp_id
JOIN Job ON Employee_Job.job_id = Job.job_id
JOIN Department ON Employee_Job.dept_id = Department.dept_id;

-- Question 2: Insert Web Programmer as a new job title

INSERT INTO Job (job_title)
VALUES ('Web Programmer');

-- Question 3: Correct the job title from Web Programmer to Web Developer

UPDATE Job
SET job_title = 'Web Developer'
WHERE job_title = 'Web Programmer';

-- Question 4: Delete the job title Web Developer from the database

DELETE FROM Job
WHERE job_title = 'Web Developer';

-- Question 5: How many employees are in each department?

SELECT Department.dept_nm, COUNT(Employee.emp_id) AS num_employees
FROM Department
LEFT JOIN Employee_Job ON Department.dept_id = Employee_Job.dept_id
LEFT JOIN Employee ON Employee_Job.emp_id = Employee.emp_id
GROUP BY Department.dept_nm;

-- Question 6: Write a query that returns current and past jobs (include employee name, job title, department, manager name, start and end date for position) for employee Toni Lembeck.

SELECT Employee.emp_nm, Job.job_title, Department.dept_nm, Manager.emp_nm AS manager_name, Employee_Job.start_dt, Employee_Job.end_dt
FROM Employee
JOIN Employee_Job ON Employee.emp_id = Employee_Job.emp_id
JOIN Job ON Employee_Job.job_id = Job.job_id
JOIN Department ON Employee_Job.dept_id = Department.dept_id
LEFT JOIN Employee AS Manager ON Employee_Job.manager_id = Manager.emp_id
WHERE Employee.emp_nm = 'Toni Lembeck';

-- Question 7: Describe how you would apply table security to restrict access to employee salaries using an SQL server.
-- To restrict access to employee salaries, you can use SQL Server's built-in security features such as roles, permissions, and views.

-- Ans: 1. Create a Role: Create a role specifically for accessing employee salary information.
CREATE ROLE SalaryViewer;

-- 2. Grant Permissions: Grant select permissions on the Salary table to the SalaryViewer role.
GRANT SELECT ON Salary TO SalaryViewer;

-- 3. Create a View: Create a view that encapsulates the salary information and restricts access to only authorized users.
CREATE VIEW SalaryView AS
SELECT Employee_Job.emp_id, Salary.salary
FROM Employee_Job
JOIN Salary ON Employee_Job.salary_id = Salary.salary_id;

-- 4. Grant Access to the View: Grant select permissions on the view to the SalaryViewer role.
GRANT SELECT ON SalaryView TO SalaryViewer;

-- 5. Assign Role to Users: Assign the SalaryViewer role to users who need access to view employee salaries.
ALTER ROLE SalaryViewer ADD MEMBER [username]; -- add usernames you wish
