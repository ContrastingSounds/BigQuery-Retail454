# NOTE: WRITTEN WITH CURRENT_DATE() OF 2020/03/19

SELECT 
  "retail454.day_of_year(DATE(2020, 2, 2))" as test
  , retail454.day_of_year(DATE(2020, 2, 2)) as value
  , 1 as expected
  , retail454.day_of_year(DATE(2020, 2, 2)) = 1 as result
;

SELECT 
  "retail454.day_of_year(DATE(2020, 2, 3))" as test
  , retail454.day_of_year(DATE(2020, 2, 3)) as value
  , 2 as expected
  , retail454.day_of_year(DATE(2020, 2, 3)) = 2 as result
;

SELECT 
  "retail454.week_number(DATE(2020, 2, 5))" as test
  , retail454.week_number(DATE(2020, 2, 5)) as value
  , 1 as expected
  , retail454.week_number(DATE(2020, 2, 5)) = 1 as result
;

SELECT 
  "retail454.week_number(CURRENT_DATE()" as test
  , retail454.week_number(CURRENT_DATE()) as value
  , 7 as expected
  , retail454.week_number(CURRENT_DATE()) = 7 as result
;

SELECT 
  "retail454.week_number(DATE(2020, 2, 2)" as test
  , retail454.week_number(DATE(2020, 2, 2)) as value
  , 1 as expected
  , retail454.week_number(DATE(2020, 2, 2)) = 1 as result
;

SELECT 
  "retail454.week_number(DATE(2020, 3, 7))" as test
  , retail454.week_number(DATE(2020, 3, 7)) as value
  , 5 as expected
  , retail454.week_number(DATE(2020, 3, 7)) = 5 as result
;

SELECT 
  "retail454.week_start(2020, 7)" as test
  , retail454.week_start(2020, 7) as value
  , DATE(2020, 3, 15) as expected
  , retail454.week_start(2020, 7) = DATE(2020, 3, 15) as result
;

SELECT 
  "retail454.week_end(2020, 7)" as test
  , retail454.week_end(2020, 7) as value
  , DATE(2020, 3, 21) as expected
  , retail454.week_end(2020, 7) = DATE(2020, 3, 21) as result
;

