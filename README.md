# Modern Data Transformation Pipeline (Snowflake + dbt + Airflow)

## Overview

This repository contains a modern data transformation pipeline built using **Snowflake**, **dbt Core**, and **Apache Airflow**.

The primary focus of this project is implementing scalable **dbt-based transformation workflows** using layered data models, incremental processing, and automated orchestration.

The pipeline simulates a production-style analytics engineering workflow where raw data is transformed into analytics-ready tables inside Snowflake.

---

## Project Structure

modern-data-platform/

dbt_project/
  models/
    staging/
    intermediate/
    marts/
  snapshots/
  seeds/

airflow/
  dags/
    dbt_pipeline.py

.github/
  workflows/
    dbt_ci.yml
    

## Architecture


GitHub (PR / CI)
│
├── dbt build validation (GitHub Actions)
│
└── Merge to main
│
↓
Airflow DAG
│
↓
dbt build
│
↓
Snowflake
│
↓
Analytics-ready tables


### Components

- **Snowflake** – Data warehouse and compute layer  
- **dbt Core** – SQL transformation framework  
- **Airflow** – Pipeline orchestration  
- **GitHub Actions** – CI validation for dbt pipelines  

---

## Technology Stack

| Layer | Tool |
|------|------|
| Data Warehouse | Snowflake |
| Transformation | dbt Core |
| Orchestration | Apache Airflow |
| Version Control | Git |
| CI/CD | GitHub Actions |

---

## dbt Project Design

The dbt project follows a **layered modeling approach** to keep transformations modular and maintainable.


models/
├── staging/
├── intermediate/
└── marts/


### Staging Layer

The staging layer cleans and standardizes raw data before it is used in downstream transformations.

Example:

```sql
SELECT
    order_id,
    customer_id,
    order_date,
    amount
FROM {{ source('raw', 'orders') }}
Intermediate Layer

Intermediate models apply business logic and combine datasets.

Example:

SELECT
    o.order_id,
    c.customer_name,
    o.amount
FROM {{ ref('stg_orders') }} o
JOIN {{ ref('stg_customers') }} c
ON o.customer_id = c.customer_id

Using ref() automatically creates the dbt dependency graph and ensures models run in the correct order.

Mart Layer

The mart layer produces analytics-ready tables used for reporting and BI.

Example:

SELECT *
FROM {{ ref('int_orders_joined') }}
Incremental Models

Incremental models are used to process only new data instead of rebuilding entire tables.

Example:

{{ config(
    materialized='incremental',
    unique_key='order_id'
) }}

SELECT *
FROM {{ ref('stg_orders') }}

{% if is_incremental() %}
WHERE order_date > (SELECT MAX(order_date) FROM {{ this }})
{% endif %}

Benefits:

Faster pipeline execution

Reduced compute cost

Scalable transformations

Slowly Changing Dimension (SCD Type 2)

Historical tracking is implemented using dbt snapshots.

Example:

{% snapshot customer_snapshot %}

{{
config(
target_schema='snapshots',
unique_key='customer_id',
strategy='check',
check_cols=['name','city']
)
}}

SELECT *
FROM {{ source('raw','customers') }}

{% endsnapshot %}

dbt automatically manages:

valid_from

valid_to

is_current

Data Quality Testing

dbt tests are used to validate data integrity.

Example:

models:
  - name: stg_orders
    columns:
      - name: order_id
        tests:
          - not_null
          - unique

Run tests:

dbt test

Or run full pipeline:

dbt build
Airflow Orchestration

Airflow is used to schedule and orchestrate dbt pipelines.

Example DAG task:

run_dbt = BashOperator(
    task_id="run_dbt_build",
    bash_command="cd /dbt_project && dbt build --target prod"
)

Airflow manages:

scheduling

retries

execution monitoring

pipeline logging

CI/CD Pipeline

GitHub Actions is used to simulate a CI workflow.

Pipeline steps:

Developer creates feature branch

Pull request triggers CI

GitHub Actions runs:

dbt build --target prod

Merge allowed only if dbt build succeeds.

Security

Snowflake credentials are not stored in the repository.

Secrets are managed using GitHub Secrets.

Example:

${{ secrets.SNOWFLAKE_PASSWORD }}
Running the Project

Install dbt:

pip install dbt-snowflake

Configure profiles.yml.

Run transformations:

dbt build
Key Features Implemented

Layered dbt architecture

Incremental model processing

SCD Type 2 snapshots

Data quality testing

Airflow orchestration

CI validation with GitHub Actions

Author

Praveen Paul
Snowflake Data Engineer
