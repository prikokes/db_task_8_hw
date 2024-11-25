CREATE FUNCTION GET_YEARS_SERVICE(
    p_emp_id INTEGER
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_hire_date DATE;
    v_years NUMERIC;
BEGIN
    SELECT hire_date
    INTO v_hire_date
    FROM employees
    WHERE employee_id = p_emp_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Employee ID % does not exist', p_emp_id;
    END IF;

    v_years := EXTRACT(YEAR FROM AGE(CURRENT_DATE, v_hire_date));

    RETURN v_years;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error: %', SQLERRM;
END;
$$;