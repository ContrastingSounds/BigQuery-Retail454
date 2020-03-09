-- GET YEAR VALUES

CREATE OR REPLACE FUNCTION retail454.year(input DATE) AS (
    CASE 
        WHEN input < DATE('2014-02-02') THEN 2013
        WHEN input < DATE('2015-02-01') THEN 2014
        WHEN input < DATE('2016-01-31') THEN 2015
        WHEN input < DATE('2017-01-29') THEN 2016
        WHEN input < DATE('2018-02-04') THEN 2017
        WHEN input < DATE('2019-02-03') THEN 2018
        WHEN input < DATE('2020-02-02') THEN 2019
        ELSE 2020 
    END
);


CREATE OR REPLACE FUNCTION retail454.year_start(input INT64) AS (
    CASE 
        WHEN input = 2014 THEN DATE('2014-02-02') 
        WHEN input = 2015 THEN DATE('2015-02-01') 
        WHEN input = 2016 THEN DATE('2016-01-31') 
        WHEN input = 2017 THEN DATE('2017-01-29') 
        WHEN input = 2018 THEN DATE('2018-02-04') 
        WHEN input = 2019 THEN DATE('2019-02-03') 
        WHEN input = 2020 THEN DATE('2020-02-02') 
        ELSE DATE('2020-02-02')
    END
);


-- GET DAY OF PERIOD VALUES

CREATE OR REPLACE FUNCTION retail454.day_of_week(input DATE) AS (
    EXTRACT(DAYOFWEEK FROM input)
);


CREATE OR REPLACE FUNCTION retail454.day_of_year(input DATE) AS (
    DATE_DIFF(input, retail454.year_start(retail454.year(input)), DAY)
);


-- GET WEEK VALUES

CREATE OR REPLACE FUNCTION retail454.week_number(input DATE) AS (
    CAST(retail454.day_of_year(input) / 7 AS INT64) + 1
);


CREATE OR REPLACE FUNCTION retail454.week_start(year INT64, week INT64) AS (
    DATE_ADD(retail454.year_start(year), INTERVAL ((week - 1) * 7) DAY)
);


CREATE OR REPLACE FUNCTION retail454.week_end(year INT64, week INT64) AS (
    DATE_ADD(retail454.week_start(year, week), INTERVAL 6 DAY)
);


CREATE OR REPLACE FUNCTION retail454.month_number(input DATE) AS (
    CASE -- 4-5-4 monthly schedule
        WHEN retail454.week_number(input) BETWEEN 1 AND 4 THEN 1    -- 4 weeks
        WHEN retail454.week_number(input) BETWEEN 5 AND 9 THEN 2    -- 5 weeks
        WHEN retail454.week_number(input) BETWEEN 10 AND 13 THEN 3  -- 4 weeks

        WHEN retail454.week_number(input) BETWEEN 14 AND 17 THEN 4  -- 4 weeks
        WHEN retail454.week_number(input) BETWEEN 18 AND 22 THEN 5  -- 5 weeks
        WHEN retail454.week_number(input) BETWEEN 23 AND 26 THEN 6  -- 4 weeks

        WHEN retail454.week_number(input) BETWEEN 27 AND 30 THEN 7  -- 4 weeks
        WHEN retail454.week_number(input) BETWEEN 31 AND 35 THEN 8  -- 5 weeks
        WHEN retail454.week_number(input) BETWEEN 36 AND 39 THEN 9  -- 4 weeks

        WHEN retail454.week_number(input) BETWEEN 40 AND 43 THEN 10 -- 4 weeks
        WHEN retail454.week_number(input) BETWEEN 44 AND 48 THEN 11 -- 5 weeks
        WHEN retail454.week_number(input) BETWEEN 49 AND 53 THEN 12 -- 4 weeks 
          -- (5 weeks during 4-5-4 leap years, in which case we add the final week, 53, into a 4-5-5 month)
    END
);


-- GET MONTH VALUES

CREATE OR REPLACE FUNCTION retail454.month_start(year INT64, month INT64) AS (
    DATE_ADD(
        retail454.year_start(year)
        , INTERVAL
            CASE month
              WHEN  1 THEN ( 0 +  0) * 7
              WHEN  2 THEN ( 0 +  4) * 7
              WHEN  3 THEN ( 0 +  9) * 7
              WHEN  4 THEN ( 0 + 13) * 7
              WHEN  5 THEN (13 +  4) * 7
              WHEN  6 THEN (13 +  9) * 7
              WHEN  7 THEN (13 + 13) * 7
              WHEN  8 THEN (26 +  4) * 7
              WHEN  9 THEN (26 +  5) * 7
              WHEN 10 THEN (26 + 13) * 7
              WHEN 11 THEN (39 +  4) * 7
              WHEN 12 THEN (39 +  9) * 7
            END
        DAY
    )
);


CREATE OR REPLACE FUNCTION retail454.month_end(year INT64, month INT64) AS (
    DATE_ADD(
        retail454.month_start(year, month)
        , INTERVAL
            CASE month
              WHEN  1 THEN (4 * 7) - 1
              WHEN  2 THEN (5 * 7) - 1
              WHEN  3 THEN (4 * 7) - 1

              WHEN  4 THEN (4 * 7) - 1
              WHEN  5 THEN (5 * 7) - 1
              WHEN  6 THEN (4 * 7) - 1

              WHEN  7 THEN (4 * 7) - 1
              WHEN  8 THEN (5 * 7) - 1
              WHEN  9 THEN (4 * 7) - 1

              WHEN 10 THEN (4 * 7) - 1
              WHEN 11 THEN (5 * 7) - 1
              WHEN 12 THEN (4 * 7) - 1
            END
        DAY
    )
);


CREATE OR REPLACE FUNCTION retail454.quarter_number(input DATE) AS (
    CASE
        WHEN retail454.month_number(input) BETWEEN 1 AND 3 THEN 1
        WHEN retail454.month_number(input) BETWEEN 4 AND 6 THEN 2
        WHEN retail454.month_number(input) BETWEEN 7 AND 9 THEN 3
        WHEN retail454.month_number(input) BETWEEN 10 AND 12 THEN 4
    END
);


-- GET DATE RANGES

CREATE OR REPLACE FUNCTION retail454.last_week_dates() AS (
    CASE 
        WHEN retail454.week_number(CURRENT_DATE()) > 1
          THEN GENERATE_DATE_ARRAY(
                retail454.week_start(
                  retail454.year(CURRENT_DATE()), 
                  retail454.week_number(CURRENT_DATE()) - 1
                ),
                retail454.week_end(
                  retail454.year(CURRENT_DATE()), 
                  retail454.week_number(CURRENT_DATE()) - 1
                )
               )
        
        WHEN retail454.week_number(CURRENT_DATE()) = 1
          THEN GENERATE_DATE_ARRAY(
                retail454.week_start(
                  retail454.year(CURRENT_DATE()) - 1, 
                  52
                ),
                retail454.week_end(
                  retail454.year(CURRENT_DATE()) - 1, 
                  52
                )
               )
        
        ELSE NULL
    END
);


CREATE OR REPLACE FUNCTION retail454.last_week_last_year_dates() AS (
    CASE 
        WHEN retail454.week_number(CURRENT_DATE()) > 1
          THEN GENERATE_DATE_ARRAY(
                retail454.week_start(
                  retail454.year(CURRENT_DATE()) - 1, 
                  retail454.week_number(CURRENT_DATE()) - 1
                ),
                retail454.week_end(
                  retail454.year(CURRENT_DATE()) - 1, 
                  retail454.week_number(CURRENT_DATE()) - 1
                )
               )
        
        WHEN retail454.week_number(CURRENT_DATE()) = 1
          THEN GENERATE_DATE_ARRAY(
                retail454.week_start(
                  retail454.year(CURRENT_DATE()) - 2, 
                  52
                ),
                retail454.week_end(
                  retail454.year(CURRENT_DATE()) - 2, 
                  52
                )
               )
        
        ELSE NULL
    END
);


CREATE OR REPLACE FUNCTION retail454.last_month_dates() AS (
    CASE 
        WHEN retail454.month_number(CURRENT_DATE()) > 1
          THEN GENERATE_DATE_ARRAY(
                retail454.month_start(
                  retail454.year(CURRENT_DATE()), 
                  retail454.month_number(CURRENT_DATE()) - 1
                ),
                retail454.month_end(
                  retail454.year(CURRENT_DATE()), 
                  retail454.month_number(CURRENT_DATE()) - 1
                )
               )
        
        WHEN retail454.month_number(CURRENT_DATE()) = 1
          THEN GENERATE_DATE_ARRAY(
                retail454.month_start(
                  retail454.year(CURRENT_DATE()) - 1, 
                  12
                ),
                retail454.month_end(
                  retail454.year(CURRENT_DATE()) - 1, 
                  12
                )
               )
        
        ELSE NULL
    END
);


CREATE OR REPLACE FUNCTION retail454.last_month_last_year_dates() AS (
    CASE 
        WHEN retail454.month_number(CURRENT_DATE()) > 1
          THEN GENERATE_DATE_ARRAY(
                retail454.month_start(
                  retail454.year(CURRENT_DATE()) - 1, 
                  retail454.month_number(CURRENT_DATE()) - 1
                ),
                retail454.month_end(
                  retail454.year(CURRENT_DATE()) - 1, 
                  retail454.month_number(CURRENT_DATE()) - 1
                )
               )
        
        WHEN retail454.month_number(CURRENT_DATE()) = 1
          THEN GENERATE_DATE_ARRAY(
                retail454.month_start(
                  retail454.year(CURRENT_DATE()) - 2, 
                  12
                ),
                retail454.month_end(
                  retail454.year(CURRENT_DATE()) - 2, 
                  12
                )
               )
        
        ELSE NULL
    END
);


CREATE OR REPLACE FUNCTION retail454.compare_last_week_dates() AS (
    retail454.last_week_dates()
    ||
    retail454.last_week_last_year_dates()
);


CREATE OR REPLACE FUNCTION retail454.get_date_ranges(func STRING) AS (
    CASE func
        WHEN "compare_last_week_dates" THEN retail454.compare_last_week_dates()
        ELSE retail454.compare_last_week_dates()
    END
);