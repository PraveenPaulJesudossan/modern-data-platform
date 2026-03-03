from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.models import Variable
from datetime import datetime

DBT_PROJECT_DIR = "/home/praveen/modern_data_platform/dbt_project/modern_retail"

# Get target dynamically from Airflow Variable
DBT_TARGET = Variable.get("dbt_target", default_var="dev")

default_args = {
    "owner": "praveen",
    "start_date": datetime(2024, 1, 1),
    "retries": 1,
}

with DAG(
    dag_id="modern_retail_dbt_pipeline",
    default_args=default_args,
    schedule_interval="@daily",
    catchup=False,
) as dag:

    dbt_deps = BashOperator(
        task_id="dbt_deps",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt deps",
    )

    dbt_freshness = BashOperator(
        task_id="dbt_source_freshness",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt source freshness --target {DBT_TARGET}",
    )

    dbt_build = BashOperator(
        task_id="dbt_build",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt build --target {DBT_TARGET}",
    )

    dbt_snapshot = BashOperator(
        task_id="dbt_snapshot",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt snapshot --target {DBT_TARGET}",
    )

    dbt_deps >> dbt_freshness >> dbt_build >> dbt_snapshot