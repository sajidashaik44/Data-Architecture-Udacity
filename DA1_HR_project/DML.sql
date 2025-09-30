-- 1. Insert into Location
INSERT INTO Location (loc_nm)
SELECT DISTINCT location FROM proj_stg;

-- 2. Insert into State
INSERT INTO State (state_nm, loc_id)
SELECT DISTINCT proj_stg.state, Location.loc_id
FROM proj_stg
JOIN Location ON proj_stg.location = Location.loc_nm;

-- 3. Insert into City
INSERT INTO City (city_nm, state_id)
SELECT DISTINCT proj_stg.city, State.state_id
FROM proj_stg
JOIN State ON proj_stg.state = State.state_nm;

-- 4. Insert into Address
INSERT INTO Address (addr_nm, city_id)
SELECT DISTINCT proj_stg.address, City.city_id
FROM proj_stg
JOIN City ON proj_stg.city = City.city_nm;

-- 5. Insert into Education
INSERT INTO Education (educ_lv)
SELECT DISTINCT education_lvl FROM proj_stg;


-- 6. Insert into Employee
INSERT INTO Employee (emp_id, emp_nm, email, hire_dt, addr_id, educ_id)
SELECT DISTINCT Emp_ID, Emp_NM, email, hire_dt, Address.addr_id, Education.educ_id
FROM proj_stg
JOIN Address ON proj_stg.address = Address.addr_nm
JOIN City ON proj_stg.city = City.city_nm
JOIN State ON proj_stg.state = State.state_nm
JOIN Location ON proj_stg.location = Location.loc_nm
JOIN Education ON proj_stg.education_lvl = Education.educ_lv;

-- Insert into Department table
INSERT INTO Department (dept_nm)
SELECT DISTINCT department_nm FROM proj_stg;

-- Insert into Job table
INSERT INTO Job (job_title)
SELECT DISTINCT job_title FROM proj_stg;

-- Insert into Salary table
INSERT INTO Salary (salary)
SELECT DISTINCT salary FROM proj_stg;

-- Insert into Employee_Job table
INSERT INTO Employee_Job (dept_id, emp_id, job_id, manager_id, start_dt, end_dt, salary_id)
SELECT Department.dept_id, Employee.emp_id, Job.job_id, Manager.emp_id, start_dt, end_dt, Salary.salary_id FROM proj_stg
JOIN Department ON proj_stg.department_nm = Department.dept_nm
JOIN Employee ON proj_stg.Emp_ID = Employee.emp_id
JOIN Job ON proj_stg.job_title = Job.job_title
JOIN Employee AS Manager ON proj_stg.manager = Manager.emp_nm
JOIN Salary ON proj_stg.salary = Salary.salary;
