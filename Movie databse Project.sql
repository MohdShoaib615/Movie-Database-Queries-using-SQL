
select * from actors limit 2;
select * from director limit 2;
select * from genres limit 2;
select * from movie limit 2;
select * from movie_cast limit 2;
select * from movie_direction limit 2;
select * from movie_genres limit 2;
select * from rating limit 2;
select * from reviewer limit 2;

-------------------------------------------------------------------------------------------------------------------


-- Ques 1. Write a SQL query to find the actors who were cast in the movie 'Annie Hall'.
-- Return actor first name, last name and role.


ANSWER:-

select * from actors where act_id in (
select act_id from movie_cast where mov_id in (
select mov_id from movie where mov_title='Annie Hall'));   # Role is not coming here


OR by using joins also:-- # Since we cant fetch role in above method

select act_fname,act_lname,role 
from actors a 
inner join movie_cast mc on a.act_id=mc.act_id 
inner join movie m on mc.mov_id=m.mov_id 
where mov_title="Annie Hall"; 




-- Ques 2. write a SQL query to find the director who directed a movie that casted a role for 'Alice Harford'. 
-- Return director first name, last name and movie title.

select * from movie where mov_id in(
select mov_id from movie_cast where role='Alice Harford');

select * from director where 
dir_id in (select dir_id from movie_direction where mov_id in (select mov_id from movie_cast where role='Alice Harford'));

select dir_fname,dir_lname,role from director d inner join movie_direction md on d.dir_id=md.dir_id inner join movie_cast mc on md.mov_id=mc.mov_id where role='Alice Harford';

select dir_fname, dir_lname, mov_title from movie_direction md
inner join
(select * from movie where mov_id in (
select mov_id from movie_cast where role = 'Alice Harford')) abc
on abc.mov_id = md.mov_id
inner join director d
on d.dir_id = md.dir_id;



-- Q3  List all actors' first names and last names along with their genders.

select act_fname,act_lname,act_gender from actors;


- Q4 Show the titles and release dates of all movies.

select mov_title, mov_dt_rel from movie;



-- Q5 Find the total number of actors in the database.

select count(*) from actors;





-- Q6 Display the names of all directors.

select concat(dir_fname," " ,dir_lname) as 'director_name' from director;


-- Q7 List the movies with their titles and their corresponding directors' first names and last names.

select mov_title,concat(dir_fname," ",dir_lname) as director_name
from director d 
inner join movie_direction md on d.dir_id=md.dir_id
inner join movie m on m.mov_id=md.mov_id;


OR 


select mov_title,concat(dir_fname," ",dir_lname) as director_name from 
movie m
inner join movie_direction md on md.mov_id=m.mov_id
inner join director d on d.dir_id=md.dir_id;


-- Q8 How many movies are there for each genre? Show the genre titles and the number of movies.


select gen_title,count(gen_title) as total_movie
from genres g
inner join movie_genres mg
on g.gen_id=mg.gen_id group by gen_title 
order by total_movie;


OR  

select gen_title,numbers
from
(select gen_id, count(*) as numbers from movie_genres group by gen_id) abc
inner join genres g on g.gen_id=abc.gen_id
order by numbers;

OR

select gen_title,count(*) number
from genres g inner join movie_genres mg on g.gen_id=mg.gen_id group by gen_title order by number;

-- Q9 Retrieve the movies that have a release year after 1990.

select mov_title,mov_year from movie where mov_year>1990 order by mov_year;

OR

select year(mov_dt_rel) from movie where year(mov_dt_rel)>2003 order by year(mov_dt_rel);

OR 
select date_format(mov_dt_rel,"%Y") from movie where date_format(mov_dt_rel,"%Y")>2003 order by date_format(mov_dt_rel,"%Y");



-- Q10 Find the average runtime (in minutes) of all movies.

select round(avg(mov_time),2) as "average run time"  from movie;


-- Q11 Group all the movies by its month of release.

select monthname(mov_dt_rel) as month_, count(*) as total_release from movie group by month_ order by total_release;


-- Q12 Show the movie title and the names of its actors for all movies.

select mov_title,concat(act_fname," ",act_lname) as actor_name from actors a inner join movie_cast mc on a.act_id=mc.act_id inner join movie m on mc.mov_id=m.mov_id;


-- Q13 List the movies along with the total number of ratings and the average rating for each movie.



SELECT m.mov_id, m.mov_title, COUNT(r.rev_id) AS total_ratings, AVG(r.rev_stars) AS average_rating
FROM movie m
inner JOIN rating r ON m.mov_id = r.mov_id
GROUP BY m.mov_id, m.mov_title;


-- Q14 Find the names of reviewers who haven't provided their names (empty string).

select * 
from reviewer 
where rev_name IS NULL OR rev_name = '';


-- Q15 Retrieve the movie title, director's first name, and director's last name for all movies.

select m.mov_title,d.dir_fname,d.dir_lname 
from movie m 
inner join movie_direction md on md.mov_id=m.mov_id 
inner join director d on d.dir_id=md.dir_id;


-- Q16 Show the names of reviewers and the number of reviews they have given.

select rev_name,num_o_ratings from rating rg inner join reviewer rr on rg.rev_id=rr.rev_id;

select rev_name,count(*) ratings from rating rg inner join reviewer rr on rg.rev_id=rr.rev_id group by rev_name order by ratings desc;



-- Q17 List the names of actors who starred in the movie "Vertigo."

select m.mov_title,concat(a.act_fname," ",a.act_lname) as actor_name from actors a inner join movie_cast mc on a.act_id=mc.act_id inner join movie m on m.mov_id=mc.mov_id where mov_title="Vertigo";



-- Q18 Find the movie title and release date for all movies released in the UK.

select mov_title, mov_dt_rel from movie where mov_rel_country="UK";


-- Q19 Display the movie titles and the number of ratings for movies with more than 500,000 ratings.

select m.mov_title,r.num_o_ratings from movie m inner join rating r on r.mov_id=m.mov_id where num_o_ratings>500000 order by num_o_ratings;


-- Q20 Find all movies released on the 25th day of any month.

select mov_title,mov_dt_rel from movie where day(mov_dt_rel)=25;

OR  

SELECT mov_title, mov_dt_rel
FROM movie
WHERE DATE_FORMAT(mov_dt_rel, '%d') = '25';


-- Q21 List the average rating for each movie along with the reviewer's name, excluding movies with no reviews.



SELECT m.mov_title, r.rev_name, AVG(rt.rev_stars) AS average_rating
FROM movie m
LEFT JOIN rating rt ON m.mov_id = rt.mov_id
JOIN reviewer r ON rt.rev_id = r.rev_id
GROUP BY m.mov_title, r.rev_name
HAVING rev_name != "" order by average_rating;


-- Q22 Show the movie title and the name of the director for all movies directed by "Christopher Nolan."

select m.mov_title,concat(d.dir_fname," ",d.dir_lname)  from movie m inner join movie_direction md on m.mov_id=md.mov_id inner join director d on d.dir_id=md.dir_id where concat(d.dir_fname," ",d.dir_lname)="Christopher Nolan" ; 

OR-----------

select m.mov_title,concat(d.dir_fname," ",d.dir_lname) as dir_name
from movie m 
inner join movie_direction md on m.mov_id=md.mov_id 
inner join director d on d.dir_id=md.dir_id 
having dir_name="Christopher Nolan"; 


-- Ques 23. Write a SQL query to find who directed a movie that casted a role as ‘Sean Maguire’. 
-- Return director first name, last name and movie title.

select concat(dir_fname," ",dir_lname) as director_name from director where dir_id in (select dir_id from movie_direction where mov_id in (select mov_id from (select * from movie_cast where role="Sean maguire")as mov_id));


OR---
 but in above query, we are not getting the movie name.



select d.dir_fname,d.dir_lname, m.mov_title 
from movie_cast mc 
inner join movie_direction md on mc.mov_id=md.mov_id 
inner join director d on d.dir_id=md.dir_id 
inner join movie m on m.mov_id=mc.mov_id
where role="Sean Maguire";





-- Ques 24. Write a SQL query to find the actors who have not acted in any movie between 1990 and 2000 (Begin and end values are included.). 
-- Return actor first name, last name, movie title and release year. 


SELECT a.act_fname, a.act_lname, m.mov_title, m.mov_year
FROM actors a
CROSS JOIN movie m
LEFT JOIN movie_cast mc ON a.act_id = mc.act_id AND m.mov_id = mc.mov_id
WHERE m.mov_year not BETWEEN 1990 AND 2000 
order by m.mov_year;
