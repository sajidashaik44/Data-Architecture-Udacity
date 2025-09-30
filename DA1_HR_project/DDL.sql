-- Create the Location table
CREATE TABLE Location (
    loc_id SERIAL PRIMARY KEY,
    loc_nm VARCHAR(50)
);

-- Create the State table
CREATE TABLE State (
    state_id SERIAL PRIMARY KEY,
    state_nm VARCHAR(2),
    loc_id INT,
    FOREIGN KEY (loc_id) REFERENCES Location(loc_id)
);

-- Create the City table
CREATE TABLE City (
    city_id SERIAL PRIMARY KEY,
    city_nm VARCHAR(50),
    state_id INT,
    FOREIGN KEY (state_id) REFERENCES State(state_id)
);

-- Create the Address table
CREATE TABLE Address (
    addr_id SERIAL PRIMARY KEY,
    addr_nm VARCHAR(100),
    city_id INT,
    FOREIGN KEY (city_id) REFERENCES City(city_id)
);

-- Create the Education table
CREATE TABLE Education (
    educ_id SERIAL PRIMARY KEY,
    educ_lv VARCHAR(50)
);

-- Create the Employee table
CREATE TABLE Employee (
    emp_id VARCHAR(10) PRIMARY KEY,
    emp_nm VARCHAR(50),
    email VARCHAR(100),
    hire_dt DATE,
    addr_id INT,
    educ_id INT,
    FOREIGN KEY (addr_id) REFERENCES Address(addr_id),
    FOREIGN KEY (educ_id) REFERENCES Education(educ_id)
);

-- Create the Department table
CREATE TABLE Department (
    dept_id SERIAL PRIMARY KEY,
    dept_nm VARCHAR(50)
);

-- Create the Job table
CREATE TABLE Job (
    job_id SERIAL PRIMARY KEY,
    job_title VARCHAR(100)
);

-- Create the Salary table
CREATE TABLE Salary (
    salary_id SERIAL PRIMARY KEY,
    salary INT
);

-- Create the Employee_Job table
CREATE TABLE Employee_Job (
    dept_id INT,
    emp_id VARCHAR(10),
    job_id INT,
    manager_id VARCHAR(10),
    start_dt DATE,
    end_dt DATE,
    salary_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id),
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id),
    FOREIGN KEY (job_id) REFERENCES Job(job_id),
    FOREIGN KEY (manager_id) REFERENCES Employee(emp_id),
    FOREIGN KEY (salary_id) REFERENCES Salary(salary_id)
);
