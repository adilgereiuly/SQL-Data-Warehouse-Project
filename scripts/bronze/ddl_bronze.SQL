/*
=============================================================
DDL: Bronze Layer Tables and Load Procedure
=============================================================
Script Purpose:
    This script defines the Bronze layer schema objects for the
    Data Warehouse. It creates the raw staging tables for both
    CRM and ERP source systems, and defines the stored procedure
    'bronze.load_bronze()' which truncates and reloads all Bronze
    tables from their respective CSV source files.

Usage:
    Run table creation while connected to 'datawarehouse'.
    Execute the load procedure with: CALL bronze.load_bronze();

WARNING:
    Calling bronze.load_bronze() will truncate all Bronze tables
    and reload them from source files. All existing data in these
    tables will be permanently deleted.

NOTE (PostgreSQL):
    File paths in COPY statements are absolute paths on the local
    machine. Update these paths if running on a different system.
*/



CREATE TABLE IF NOT EXISTS bronze.crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE
);

CREATE TABLE IF NOT EXISTS bronze.crm_prd_info (
    prd_id INT,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE
);

CREATE TABLE IF NOT EXISTS bronze.crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);

CREATE TABLE IF NOT EXISTS bronze.erp_cust_az12 (
    cid VARCHAR(50),
    bdate DATE,
    gen VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS bronze.erp_loc_a101 (
    cid VARCHAR(50),
    cntry VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS bronze.erp_cat_g1v2 (
    id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenance VARCHAR(50)
);

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
    start_time TIMESTAMPTZ;
    end_time TIMESTAMPTZ;
    total_start TIMESTAMPTZ;
    total_end TIMESTAMPTZ;
BEGIN
    total_start := CLOCK_TIMESTAMP();
    RAISE NOTICE '=======================';
    RAISE NOTICE 'Loading Bronze Layer...';
    RAISE NOTICE '=======================';

    RAISE NOTICE '---------------------';
    RAISE NOTICE 'Loading CRM Tables...';
    RAISE NOTICE '---------------------';

    start_time := CLOCK_TIMESTAMP();
    RAISE NOTICE '>> Truncating bronze.crm_cust_info';
    TRUNCATE TABLE bronze.crm_cust_info;
    RAISE NOTICE '>> Inserting into bronze.crm_cust_info';
    COPY bronze.crm_cust_info
    FROM '/Users/orynbassar/Documents/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
    WITH (FORMAT CSV, HEADER TRUE);
    end_time := CLOCK_TIMESTAMP();
    RAISE NOTICE 'Load completed in % seconds', EXTRACT(EPOCH FROM (end_time - start_time));

    start_time := CLOCK_TIMESTAMP();
    RAISE NOTICE '>> Truncating bronze.crm_prd_info';
    TRUNCATE TABLE bronze.crm_prd_info;
    RAISE NOTICE '>> Inserting into bronze.crm_prd_info';
    COPY bronze.crm_prd_info
    FROM '/Users/orynbassar/Documents/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
    WITH (FORMAT CSV, HEADER TRUE);
    end_time := CLOCK_TIMESTAMP();
    RAISE NOTICE 'Load completed in % seconds', EXTRACT(EPOCH FROM (end_time - start_time));

    start_time := CLOCK_TIMESTAMP();
    RAISE NOTICE '>> Truncating bronze.crm_sales_details';
    TRUNCATE TABLE bronze.crm_sales_details;
    RAISE NOTICE '>> Inserting into bronze.crm_sales_details';
    COPY bronze.crm_sales_details
    FROM '/Users/orynbassar/Documents/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
    WITH (FORMAT CSV, HEADER TRUE);
    end_time := CLOCK_TIMESTAMP();
    RAISE NOTICE 'Load completed in % seconds', EXTRACT(EPOCH FROM (end_time - start_time));

    RAISE NOTICE '---------------------';
    RAISE NOTICE 'Loading ERP tables...';
    RAISE NOTICE '---------------------';

    start_time := CLOCK_TIMESTAMP();
    RAISE NOTICE '>> Truncating bronze.erp_cust_az12';
    TRUNCATE TABLE bronze.erp_cust_az12;
    RAISE NOTICE '>> Inserting into bronze.erp_cust_az12';
    COPY bronze.erp_cust_az12
    FROM '/Users/orynbassar/Documents/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv'
    WITH (FORMAT CSV, HEADER TRUE);
    end_time := CLOCK_TIMESTAMP();
    RAISE NOTICE 'Load completed in % seconds', EXTRACT(EPOCH FROM (end_time - start_time));

    start_time := CLOCK_TIMESTAMP();
    RAISE NOTICE '>> Truncating bronze.erp_loc_a101';
    TRUNCATE TABLE bronze.erp_loc_a101;
    RAISE NOTICE '>> Inserting into bronze.erp_loc_a101';
    COPY bronze.erp_loc_a101
    FROM '/Users/orynbassar/Documents/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv'
    WITH (FORMAT CSV, HEADER TRUE);
    end_time := CLOCK_TIMESTAMP();
    RAISE NOTICE 'Load completed in % seconds', EXTRACT(EPOCH FROM (end_time - start_time));

    start_time := CLOCK_TIMESTAMP();
    RAISE NOTICE '>> Truncating bronze.erp_cat_g1v2';
    TRUNCATE TABLE bronze.erp_cat_g1v2;
    RAISE NOTICE '>> Inserting into bronze.erp_cat_g1v2';
    COPY bronze.erp_cat_g1v2
    FROM '/Users/orynbassar/Documents/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv'
    WITH (FORMAT CSV, HEADER TRUE);
    end_time := CLOCK_TIMESTAMP();
    RAISE NOTICE 'Load completed in % seconds', EXTRACT(EPOCH FROM (end_time - start_time));

    total_end := CLOCK_TIMESTAMP();
    RAISE NOTICE 'Bronze layer loaded in % seconds', EXTRACT(EPOCH FROM (total_end - total_start));

    EXCEPTION
        WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
        RAISE;

END;
$$;









