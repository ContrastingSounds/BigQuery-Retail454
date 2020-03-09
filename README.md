# NOTE: THIS LIBRARY IS UNDER DEVELOPMENT. 

ONLY retail454.get_date_ranges("compare_last_week_dates") IS IMPLEMENTED.

From a LookML model, the only currently working method is to create the functions within your own project from the provided SQL script.

# BigQuery Retail 4-5-4 Calendar functions

BigQuery's table partitions enable vast quantities of retail transaction data to be queried quickly and cheaply. But, they do present a challenge: table partitions are based on calendar dates. (note: BQ also offers integer partitioning. This library is intended for use with a date partitioned table).

The most common method for working with retail calendars is to join to a dedicated calendar or dates table. However, BigQuery can only prune partitions BEFORE any joins: https://cloud.google.com/bigquery/docs/querying-partitioned-tables#querying_partitioned_tables_2.

This library of functions allows you to get a date array for the most common reporting requirements.

# USAGE (IN A LOOKER LookML MOdel)

    sql_always_where:
        ${table.partition_column} IN UNNEST(retail454.get_date_ranges("compare_last_week_dates")) ;;

# Add them to your project

### Accesssing the publicly shared functions
- Add the jonwalls.retail454 dataset via the GCP Console

### Creating the functions within your own project
- In your own project, create a retail454 dataset, and tun the retail454_functions.sql script