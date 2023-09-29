SELECT * FROM survey LIMIT 10;

SELECT question, 
       COUNT(response) AS 'Number of Responses'
FROM survey
GROUP BY 1;

SELECT * FROM quiz LIMIT 5;
SELECT * FROM home_try_on LIMIT 5;
SELECT * FROM purchase LIMIT 5;

SELECT q.user_id AS 'quiz',
       h.address IS NOT NULL AS 'is_home_try_on',
       h.number_of_pairs,
       p.product_id IS NOT NULL AS 'is_purchase'
FROM quiz AS q
LEFT JOIN home_try_on AS h 
ON q.user_id = h.user_id
LEFT JOIN purchase AS p 
ON h.user_id = p.user_id
LIMIT 10;

WITH funnel AS (SELECT q.user_id AS 'quiz',
       h.address IS NOT NULL AS 'is_home_try_on',
       h.number_of_pairs,
       p.product_id IS NOT NULL AS 'is_purchase'
FROM quiz AS q
LEFT JOIN home_try_on AS h 
ON q.user_id = h.user_id
LEFT JOIN purchase AS p 
ON h.user_id = p.user_id
)
SELECT COUNT(quiz) AS 'quiz_num',
       SUM(is_home_try_on) AS 'home_try_num',
       SUM(is_purchase) AS 'purchase_num'
FROM funnel;

WITH funnel AS (SELECT q.user_id AS 'quiz',
       h.address IS NOT NULL AS 'is_home_try_on',
       h.number_of_pairs,
       p.product_id IS NOT NULL AS 'is_purchase'
FROM quiz AS q
LEFT JOIN home_try_on AS h 
ON q.user_id = h.user_id
LEFT JOIN purchase AS p 
ON h.user_id = p.user_id
)
SELECT 1.0*SUM(is_home_try_on)/COUNT(quiz)
       AS 'try_on_conv',
       1.0*SUM(is_purchase)/SUM(is_home_try_on)
       AS 'purchase_conv'
FROM funnel;

WITH funnel AS (SELECT q.user_id AS 'quiz',
       h.address IS NOT NULL AS 'is_home_try_on',
       h.number_of_pairs AS 'number_of_pairs',
       p.product_id IS NOT NULL AS 'is_purchase'
FROM quiz AS q
LEFT JOIN home_try_on AS h 
ON q.user_id = h.user_id
LEFT JOIN purchase AS p 
ON h.user_id = p.user_id
)
SELECT number_of_pairs,
       ROUND(1.0*SUM(is_purchase)/SUM(is_home_try_on),2)
       AS 'purchase_conv'
FROM funnel
WHERE number_of_pairs IS NOT NULL
GROUP BY number_of_pairs;

SELECT style, COUNT(user_id)
FROM quiz
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;

SELECT style, COUNT(user_id)
FROM purchase
GROUP BY 1
ORDER BY 2 DESC
LIMIT 2;