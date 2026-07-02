---

## 🔧 Tech Stack

- **Database**: PostgreSQL
- **IDE**: DataGrip
- **Version Control**: Git / GitHub

---

## 🚀 Getting Started

**Prerequisites**: PostgreSQL installed and running locally.

1. Clone the repository
2. Connect to your PostgreSQL instance and run `scripts/init_database.sql` (Step 1 while connected to `postgres`, Step 2 while connected to `datawarehouse`) to create the database and schemas
3. Run `scripts/bronze/ddl_bronze.sql` to create Bronze tables
4. Run `scripts/bronze/proc_load_bronze.sql` and call `CALL bronze.load_bronze();` — update the file paths in the COPY statements to match your local machine
5. Run `scripts/silver/ddl_silver.sql` to create Silver tables
6. Run `scripts/silver/proc_load_silver.sql` and call `CALL silver.load_silver();`
7. Run `scripts/gold/ddl_gold.sql` to create Gold views

---

## 📊 Data Model

The Gold layer implements a Star Schema with:

- `gold.dim_customers` — Customer dimension integrating CRM and ERP customer/location data
- `gold.dim_product` — Product dimension integrating CRM product and ERP category data
- `gold.fact_sales` — Sales fact table with order, shipping, and pricing metrics

---

## 📋 Data Sources

Two source systems provided as CSV files:

- **CRM** — Customer info, product info, sales transactions
- **ERP** — Customer demographics, location data, product categories

---

## ⚠️ Notes

- File paths in COPY statements are absolute and will need updating if running on a different machine
---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
