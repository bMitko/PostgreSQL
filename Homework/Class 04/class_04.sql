-- 1. Get movies by rating (table-valued function)

CREATE OR REPLACE FUNCTION get_movies_by_rating(movie_rating mpaa_rating)
RETURNS TABLE (
	movie_id INTEGER,
	title VARCHAR,
	rating VARCHAR
)
AS
$$
	BEGIN
		RETURN QUERY
		SELECT
			m.movie_id,
			m.title,
			m.rating::VARCHAR
		FROM movies m
		WHERE m.rating = movie_rating;
	END;
$$
LANGUAGE plpgsql

-- Testing
SELECT * FROM get_movies_by_rating('PG-13')
SELECT * FROM get_movies_by_rating('R')


-- 2. Get director's filmography (table-valued function) 

CREATE OR REPLACE FUNCTION get_director_filmography(director INTEGER)
RETURNS TABLE (
	director_id INTEGER,
	director_fullname VARCHAR,
	filmography VARCHAR
)
AS
$$
	BEGIN
		RETURN QUERY
		SELECT 
			d.director_id,
			(d.first_name || ' ' || d.last_name)::VARCHAR as director_fullname,
			STRING_AGG(m.title, ', ')::VARCHAR as filmography
		FROM directors d
		JOIN movies m ON d.director_id = m.director_id
		WHERE d.director_id = director 
		GROUP BY d.director_id;
	END;
$$
LANGUAGE plpgsql

-- Testing
SELECT * FROM get_director_filmography(1)
SELECT * FROM get_director_filmography(4)
SELECT * FROM get_director_filmography(10)


-- 3. Calculate actor's age

CREATE OR REPLACE FUNCTION calculate_actor_age(born DATE)
RETURNS INTEGER
AS
$$
	DECLARE
		cur_year INTEGER := EXTRACT (YEAR FROM CURRENT_DATE);
		cur_month INTEGER := EXTRACT (MONTH FROM CURRENT_DATE);
		cur_day INTEGER := EXTRACT (DAY FROM CURRENT_DATE);
		born_year INTEGER := EXTRACT (YEAR FROM BORN);
		born_month INTEGER := EXTRACT (MONTH FROM BORN);
		born_day INTEGER := EXTRACT (DAY FROM BORN);
	BEGIN 
		IF (cur_month > born_month) THEN
			RETURN (cur_year - born_year);
		ELSE 
			IF (cur_month = born_month) THEN
				IF (cur_day > born_day) THEN
					RETURN ((cur_year - born_year) - 1);
				ELSE 
					RETURN (cur_year - born_year);
				END IF;
			ELSE 
				RETURN ((cur_year - born_year)- 1);
			END IF;
		END IF;
	END;
$$
LANGUAGE plpgsql

-- Testing 
SELECT
	(a.first_name || ' ' || a.last_name) as actor_fullname,
	a.birth_date,
	calculate_actor_age(a.birth_date) as age
FROM actors a
WHERE a.birth_date IS NOT NULL


-- 4. Check if actor has won awards

CREATE OR REPLACE FUNCTION has_won_awards(actor_id_f INTEGER)
RETURNS TEXT
AS
$$
	DECLARE 
		award INTEGER;
	BEGIN 
		SELECT
			a.actor_id,
			aa.award_id INTO award
		FROM awards  
		JOIN actor_awards aa ON awards.award_id = aa.award_id
		FULL JOIN actors a ON aa.actor_id = a.actor_id
		WHERE aa.actor_id = actor_id_f;
		
		IF award IS NOT NULL THEN
		RETURN 'Yes';
		ELSE 
		RETURN 'No';
		END IF;
	END;
$$
LANGUAGE plpgsql

-- Table for comparison
SELECT
	a.actor_id,
	a.first_name || ' ' || a.last_name as actor_fullname,
	aa.award_id 
FROM awards 
JOIN actor_awards aa ON awards.award_id = aa.award_id
FULL JOIN actors a ON aa.actor_id = a.actor_id
ORDER BY a.actor_id ASC

-- Testing
SELECT
	-- a.actor_id,
	a.first_name || ' ' || a.last_name as actor_fullname,
	has_won_awards(a.actor_id) as award
FROM actors a