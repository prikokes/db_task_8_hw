CREATE OR REPLACE FUNCTION GET_JOB_COUNT(p_emp_id INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_count INTEGER;
    v_exists INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_exists
    FROM employees
    WHERE employee_id = p_emp_id;

    IF v_exists = 0 THEN
        RAISE EXCEPTION 'Employee ID % does not exist', p_emp_id;
    END IF;

    SELECT COUNT(DISTINCT job_id)
    INTO v_count
    FROM (
        SELECT job_id
        FROM job_history
        WHERE employee_id = p_emp_id
        UNION
        SELECT job_id
        FROM employees
        WHERE employee_id = p_emp_id
    ) jobs;

    RETURN v_count;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error: %', SQLERRM;
END;
$$;