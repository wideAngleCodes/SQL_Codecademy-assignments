-- Campaigns and sources used by CoolTshirts!
select distinct utm_campaign, distinct utm_source
from page_visits;

select count(distinct utm_source),count(distinct utm_campaign)
from page_visits;

-- Campaign and source relation
select distinct utm_campaign, utm_source
from page_visits;

-- Pages on the website
select distinct page_name
from page_visits;

-- USER JOURNEY: first-touch-query
WITH first_touch AS
( SELECT user_id,
      MIN(timestamp) as first_touch_at
  FROM page_visits
  GROUP BY user_id
)
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
    pv.utm_campaign,
    count(utm_campaign)
FROM first_touch as 'ft'
JOIN page_visits as 'pv'
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
GROUP BY utm_campaign
ORDER BY 5 DESC;

-- USER JOURNEY: last-touch-query
WITH last_touch AS 
( SELECT user_id,
  MAX(timestamp) as last_touch_at
  FROM page_visits
  GROUP BY user_id
  ),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source,
       lt_attr.utm_campaign,
       COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

-- USER JOURNEY: Purchases
SELECT count( user_id), page_name
FROM page_visits
WHERE page_name like '%purchase%';
-- OR Alternative code
SELECT count( user_id), page_name
FROM page_visits
WHERE page_name = '4 - purchase';

-- USER JOURNEY: last touch Purchases by each campaign
WITH last_touch AS 
(SELECT user_id,
  MAX(timestamp) as last_touch_at
  FROM page_visits
  WHERE page_name = '4 - purchase'
  GROUP BY user_id
),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source,
       lt_attr.utm_campaign,
       COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;
