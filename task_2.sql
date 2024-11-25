CREATE OR REPLACE PROCEDURE ADD_JOB_HIST(
    p_emp_id INTEGER,
    p_new_job_id VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_old_job_id VARCHAR;
    v_old_dept_id INTEGER;
    v_hire_date DATE;
    v_min_salary INTEGER;
    v_end_date DATE;
BEGIN
    SELECT job_id, department_id, hire_date
    INTO v_old_job_id, v_old_dept_id, v_hire_date
    FROM employees
    WHERE employee_id = p_emp_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Error %', SQLERRM;
    END IF;

    v_end_date := CURRENT_DATE - INTERVAL '1 day';

    SELECT min_salary
    INTO v_min_salary
    FROM jobs
    WHERE job_id = p_new_job_id;

    INSERT INTO job_history (
        employee_id,
        start_date,
        end_date,
        job_id,
        department_id
    ) VALUES (
        p_emp_id,
        v_hire_date,
        v_end_date,
        v_old_job_id,
        v_old_dept_id
    );

    UPDATE employees
    SET hire_date = CURRENT_DATE,
        job_id = p_new_job_id,
        salary = v_min_salary + 500
    WHERE employee_id = p_emp_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error: %', SQLERRM;
END;
$$;