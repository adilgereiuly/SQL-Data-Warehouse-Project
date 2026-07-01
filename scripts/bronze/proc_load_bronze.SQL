```sql
/*
=============================================================
Procedure: Bronze Layer - Load Bronze
=============================================================
Script Purpose:
    This script defines the stored procedure 'bronze.load_bronze()'
    which loads data into the Bronze layer of the Data Warehouse.
    The procedure truncates and reloads all Bronze tables from
    their respective CSV source files, logging load duration
    for each table.

    Tables loaded:
        - bronze.crm_cust_info
        - bronze.crm_prd_info
        - bronze.crm_sales_details
        - bronze.erp_cust_az12
        - bronze.erp_loc_a101
        - bronze.erp_cat_g1v2

Usage:
    CALL bronze.load_bronze();

WARNING:
    Calling this procedure will truncate all Bronze tables before
    reloading. All existing data will be permanently deleted.

NOTE (PostgreSQL):
    File paths in COPY statements are absolute paths on the local
    machine. Update these paths if running on a different system.
*/
```


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
