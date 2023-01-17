SELECT *
FROM DEV_WH.MARTS.WP_UKDVUG_DOWNLOADS
;


create or replace view DEV_WH.MARTS.WP_UKDVUG_DOWNLOADS(
	POST,
	TOTAL,
	POST_YEAR,
	POST_MONTH,
	YEAR_MONTH
) as (
;    




WITH get_data AS (

SELECT DISTINCT post_content,
                date_part(year, post_date :: date) AS post_year,
    date_part(month, post_date :: date) AS post_month,
    date_part(year, post_date :: date) || lpad(date_part(month, post_date :: date),2,0) AS post_yearmonth
    FROM DEV_WH.RAW_VAULT.sat_wp_ug_downloads AS a
    LEFT OUTER JOIN DEV_WH.RAW_VAULT.hub_ug_posts AS b
    ON a.POST_HK = b.POST_HK
    WHERE post_parent = '0'
    AND post_type ilike '%wpcf7s%'
    AND post_author = '0'
    AND post_content ILIKE '%title%'
    AND post_content NOT ILIKE '%subscriber%'
    AND POST_CONTENT ILIKE '%RISK%'

),



get_titles AS (

SELECT *, regexp_replace(regexp_substr(post_content, 'UKDVUG.*((.|\n)*?)Download'), 'UKDVUG', ' ') AS titles
  FROM get_data

),

format_text AS (

SELECT *, rtrim(regexp_replace(titles, '&quot;',' '),'Download') AS text
  FROM get_titles

)

SELECT titles AS post
--         COUNT(text) AS total,

--          MAX(post_year) AS post_year,
--         MAX(post_month) AS post_month,
--          MIN(post_yearmonth::INTEGER) AS year_month
         FROM format_text
GROUP BY titles
-- ORDER BY year_month DESC
    ;
  );
  
  
  
create or replace view DEV_WH.MARTS.WP_UKDVUG_DOWNLOADS_MONTHLY(
	POST_COUNT,
	POST_YEAR,
	POST_MONTH,
	YEAR_MONTH
) as (
    ;

WITH get_post AS (
  SELECT DISTINCT
    post_content,

    date_part(year, post_date :: DATE) AS post_year,
    date_part(month, post_date :: DATE) AS post_month,
    date_part(year, post_date :: DATE) || lpad(date_part(month, post_date :: date),2,0) AS post_yearmonth

    FROM DEV_WH.RAW_VAULT.sat_wp_ug_downloads AS a
    LEFT OUTER JOIN DEV_WH.RAW_VAULT.hub_ug_posts AS b
    ON a.POST_HK = b.POST_HK
    WHERE
    post_parent = '0'
    AND post_type LIKE '%wpcf7s%'
    AND post_author = '0'
    AND lower(post_content) LIKE '%title%'
    AND lower(post_content) NOT LIKE '%subscriber%'
    AND POST_CONTENT ILIKE '%RISK%'
)



SELECT
  count(c.post_content) AS post_count,
  MAX(c.post_year) AS post_year,
  MAX(c.post_month) AS post_month,
  MAX(c.post_yearmonth) AS year_month
FROM
  get_post AS c

GROUP BY
  c.post_yearmonth
ORDER BY  c.post_yearmonth ASC
  ;
    
    
WITH get_post AS (
  SELECT distinct
    post_content as x,
    post_date,
    date_part(year, post_date :: date) as post_year,
    date_part(month, post_date :: date) as post_month

 


    FROM DEV_WH.RAW_VAULT.sat_wp_ug_downloads AS a
    --LEFT OUTER JOIN DEV_WH.RAW_VAULT.hub_ug_posts AS b
    --ON a.POST_HK = b.POST_HK
    WHERE
    a.post_parent = '0'
    AND a.post_type like '%wpcf7s%'
    AND a.post_author = '0'
    AND lower(a.post_content) like '%title%'
    and lower(post_content) not like '%subscriber%'
  and lower(post_content) not like '%subscribing%'
    
    and date_part(year, post_date :: date) = 2019
    and date_part(month, post_date :: date) = 7



)

 

//select x from get_post
//where post_date between '2019-12-01' and '2019-12-30';
//group by x ;
//

 

select

  count(x) AS post_count,
  min(c.post_year) AS post_year,
  min(c.post_month) AS post_month

 

from
  get_post as c

 

group by
  c.post_year, c.post_month
order by c.post_year, c.post_month asc;


