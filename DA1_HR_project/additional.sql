-- stand alone suggestion -1

CREATE VIEW vw_employee_attributes AS
SELECT 
    Employee.emp_id AS Emp_ID,
    Employee.emp_nm AS Emp_NM,
    Employee.email,
    Employee.hire_dt,
    Address.addr_nm AS address,
    City.city_nm AS city,
    State.state_nm AS state,
    Location.loc_nm AS location,
    Education.educ_lv AS education_lvl,
    Department.dept_nm,
    Job.job_title,
    Manager.emp_nm AS manager,
    Employee_Job.start_dt,
    Employee_Job.end_dt,
    Salary.salary
FROM Employee
JOIN Employee_Job ON Employee.emp_id = Employee_Job.emp_id
JOIN Job ON Employee_Job.job_id = Job.job_id
JOIN Department ON Employee_Job.dept_id = Department.dept_id
LEFT JOIN Employee AS Manager ON Employee_Job.manager_id = Manager.emp_id
JOIN Salary ON Employee_Job.salary_id = Salary.salary_id
JOIN Address ON Employee.addr_id = Address.addr_id
JOIN City ON Address.city_id = City.city_id
JOIN State ON City.state_id = State.state_id
JOIN Location ON State.loc_id = Location.loc_id
JOIN Education ON Employee.educ_id = Education.educ_id;


SELECT * FROM vw_employee_attributes;

-- stand alone suggestion - 2

CREATE OR REPLACE FUNCTION sp_get_employee_jobs(emp_name VARCHAR(50))
RETURNS TABLE (
    employee_name VARCHAR(50),
    job_title VARCHAR(100),
    department VARCHAR(50),
    manager_name VARCHAR(50),
    start_dt DATE,
    end_dt DATE
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        e.emp_nm AS employee_name,
        j.job_title,
        d.dept_nm AS department,
        m.emp_nm AS manager_name,
        ej.start_dt,
        ej.end_dt
    FROM
        Employee e
        JOIN Employee_Job ej ON e.emp_id = ej.emp_id
        JOIN Job j ON ej.job_id = j.job_id
        JOIN Department d ON ej.dept_id = d.dept_id
        LEFT JOIN Employee m ON ej.manager_id = m.emp_id
    WHERE
        e.emp_nm = sp_get_employee_jobs.emp_name;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM sp_get_employee_jobs('Toni Lembeck');

-- stand alone suggestion - 3

-- Create a new user role named 'NoMgr':
CREATE ROLE NoMgr LOGIN;

-- Grant the necessary permissions to access the database:
GRANT CONNECT ON DATABASE postgres TO NoMgr;
GRANT USAGE ON SCHEMA public TO NoMgr;

-- Grant SELECT permissions on all tables except the Salary table:
GRANT SELECT ON TABLE Location TO NoMgr;
GRANT SELECT ON TABLE State TO NoMgr;
GRANT SELECT ON TABLE City TO NoMgr;
GRANT SELECT ON TABLE Address TO NoMgr;
GRANT SELECT ON TABLE Education TO NoMgr;
GRANT SELECT ON TABLE Employee TO NoMgr;
GRANT SELECT ON TABLE Department TO NoMgr;
GRANT SELECT ON TABLE Job TO NoMgr;
GRANT SELECT ON TABLE Employee_Job TO NoMgr;

-- Revoke SELECT permission on the Salary table:
REVOKE SELECT ON TABLE Salary FROM NoMgr;



-- Revoke SELECT permission on the Salary table:
REVOKE SELECT ON TABLE Salary FROM NoMgr;
