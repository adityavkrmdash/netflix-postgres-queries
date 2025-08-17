-- 15 Business problems

-- 1. Count the number of Movies and TV Shows

SELECT type, COUNT(show_id) as total_count
FROM netflix
GROUP BY type;

-- 2. Find the most commom rating for movies and TV shows
SELECT type,rating
FROM

(SELECT type, rating, COUNT(*),
RANK() OVER(PARTITION BY type ORDER BY COUNT(rating) DESC) as ranking
FROM netflix
GROUP BY 1,2
) as t1
WHERE ranking = 1;

-- 3. List all movies released in a specific year (e.g., 2020)

SELECT * FROM netflix
WHERE
type = 'Movie'
AND
release_year = 2020;

-- 4. Find the top 5 countries with the most content on Netflix

SELECT 
UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
COUNT(*) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 5. Identify the longest movie

SELECT * FROM netflix
WHERE
type = 'Movie'
AND
duration = (SELECT MAX(duration) from netflix);

-- 6. Find content added in the last 5 year

SELECT * FROM netflix
WHERE 
TO_DATE(date_added,'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- 7. Find all the movies/TV shows by director 'James Mangold'

SELECT * FROM netflix
WHERE director LIKE '%James Mangold%';

-- 8. List all TV shows with more than 5 seasons

SELECT * FROM netflix
WHERE 
type = 'TV Show'
AND 
SPLIT_PART(duration,' ',1)::numeric > 2;

--9. Count the number of content items in each genre

SELECT  
UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
COUNT(*) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC;

-- 10. Find each year and the average numbers of content released by India on netflix.
-- return top 5 year with highesh avg content release

SELECT 
EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY')) AS year,
COUNT(*),
COUNT(*)::numeric/(SELECT COUNT(*) from netflix WHERE country = 'India')::numeric * 100 as avg_content
FROM netflix
WHERE country = 'India'
GROUP BY 1;

--11. List all the movies that are documentaries 

SELECT * FROM netflix 
WHERE 
listed_in ILIKE '%Documentaries%';

--12. Find all content without a director

SELECT * FROM netflix
WHERE 
director IS NULL;

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years

SELECT * from netflix
WHERE casts
ILIKE '%Salman Khan%'
AND 
release_year > EXTRACT(YEAR FROM (CURRENT_DATE)) - 10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India

SELECT
UNNEST(STRING_TO_ARRAY(casts,',')) as new_cast,
COUNT(*) AS mov_count
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY mov_count DESC
LIMIT 10;

-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field,
-- Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many item fall into 
-- category


WITH new_table AS (
SELECT *,
CASE
WHEN
description ILIKE '%kill%'
OR
description ILIKE '%violence%' THEN 'Bad'
ELSE 'Good'
END category
FROM netflix
)

SELECT category, COUNT(*) 
FROM new_table 
GROUP BY 1;
























