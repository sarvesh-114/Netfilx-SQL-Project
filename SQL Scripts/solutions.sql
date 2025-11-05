-- Netflix Data Analysis using SQL
-- Solutions of 15 business problems
-- 1. Count the number of movies and Tv Shows

select count(type) as Total_Movies
from netflix
where type = 'Movie'

select count(type) as Total_TV_Shows
from netflix
where type = 'TV Show'

-- or

select type, count(*) as total_content
from netflix
group by type

-- 2. Common rating for both type
select type, rating from (select
type,
rating,
count(*) as total_count,
rank() over(partition by type order by count(*) desc) as ranks
from netflix
group by 1, 2) as s1 where ranks = 1

-- list all the movies released in specific year
select type, title, release_year
from netflix
where type = 'Movie' and release_year in (2020, 2021)

-- list top 5 countries who has mpst content on linked in
select unnest(string_to_array(country, ',')) as country, count(*) as total_content
from netflix
group by country
order by total_content desc
limit 5

-- Identify the logest movie
select *
from netflix 
where type = 'Movie'
and duration = (select max(duration) from netflix)

--find the content that added in last 5 years
select *
from netflix
where to_date(date_added, 'Month DD, YYYY') >= current_date - interval '5 years';

-- find all movies TVshows directed by rajiv chikala
select type, title, unnest(string_to_array(director, ',')) as director
from netflix
where director = 'Rajiv Chilaka'

-- TV Shows with more than 5 seasons
select *
from netflix
where type = 'TV Shows'
and split_part(duration, ' ', 1):: numeric > 5 

-- count the number of conten items based on the genre
select unnest(string_to_array(listed_in, ',')) as genre, count(*) as total_content
from netflix
group by genre
order by total_content desc;

--Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!
select
extract(year from to_date(date_added, 'Month DD, YYYY')) as year, 
count(*),
round(count(*)::numeric / (select count(*) from netflix where country = 'India')::numeric * 100, 0) as Average_content
from netflix
where country = 'India'
group by year;

--List all movies that are documentaries
select type, title, unnest(string_to_array(listed_in, ',')) as genre
from netflix
where type = 'Movie' and listed_in = 'Documentaries'

-- Find all content without a director
select * from netflix 
where director is null

--Find how many movies actor 'Salman Khan' appeared in last 10 years
select count(*)
from netflix
where casts like '%Salman Khan%' and
to_date(date_added, 'Month DD, YYYY') >= current_date - interval '10 years';

Question 15:
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/


SELECT 
    category,
	TYPE,
    COUNT(*) AS content_count
FROM (
    SELECT 
		*,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY 1,2
ORDER BY 2




-- End of reports
