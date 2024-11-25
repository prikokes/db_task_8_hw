CREATE FUNCTION check_sal_range_func()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_emp_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_emp_count
    FROM employees e
    WHERE e.job_id = NEW.job_id
    AND (e.salary < NEW.min_salary OR e.salary > NEW.max_salary);

    IF v_emp_count > 0 THEN
        RAISE EXCEPTION 'Error: %', SQLERRM;
    END IF;

    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER check_sal_range
BEFORE UPDATE OF min_salary, max_salary ON jobs
FOR EACH ROW
EXECUTE FUNCTION check_sal_range_func();