CREATE PROCEDURE UPD_JOBSAL(
    p_job_id VARCHAR,
    p_min_salary INTEGER,
    p_max_salary INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_job_exists INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_job_exists
    FROM jobs
    WHERE job_id = p_job_id;

    IF v_job_exists = 0 THEN
        RAISE EXCEPTION 'Error %',SQLERRM;
    END IF;

    IF p_max_salary < p_min_salary THEN
        RAISE EXCEPTION 'Error %', SQLERRM;
    END IF;

    UPDATE jobs
    SET min_salary = p_min_salary,
        max_salary = p_max_salary
    WHERE job_id = p_job_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error: %', SQLERRM;
END;
$$;