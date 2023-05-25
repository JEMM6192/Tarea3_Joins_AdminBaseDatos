/*
1.Mostrar la lista de todas las peliculas indicando si esta en Idioma español o no
2.Mostrar el genero(drama, accion, terror, etc) de cada pelicula
3.Cuales son las 5 compañias productoras de peliculas que tiene mayor aceptacion (votos)
4.Mostrar una lista de las personas que participan en cada pelicula
5.Mostrar una lista con la cantidad de personas por departamento que cuenta cada compañia productora
6.Mostrar las peliculas en las que ha participado las personas como parte del movie_cast
7.Listar los paises donde estan ubicas las compañias productoras
8.Mostrar de la lista de elencos cuantas mujeres participan en una pelicula de drama
9.Mostrar la cantidad de idiomas en los que se dobla cada pelicula
10.Mostrar las 8 palabras claves mas utilizadas en las peliculas
*/

/*1.Mostrar la lista de todas las peliculas indicando si esta en Idioma español o no. */

SELECT m.title, CASE WHEN ml.language_id IS NULL THEN 'No' ELSE 'Sí' END AS Español FROM movie m
LEFT JOIN movie_languages ml ON m.movie_id = ml.movie_id AND ml.language_id IN (
    SELECT language_id FROM language WHERE language_code = 'es'
)

/*2.Mostrar el genero(drama, accion, terror, etc) de cada pelicula*/
SELECT m.title, g.genre_name FROM movie m
INNER JOIN movie_genres mg ON m.movie_id = mg.movie_id
INNER JOIN genre g ON mg.genre_id = g.genre_id


/*3.Cuales son las 5 compañias productoras de peliculas que tiene mayor aceptacion (votos) */
SELECT top 5 pc.company_name, SUM(m.vote_count) AS total_votos  FROM production_company pc
INNER JOIN movie_company mc ON pc.company_id = mc.company_id
INNER JOIN movie m ON mc.movie_id = m.movie_id
GROUP BY pc.company_name
ORDER BY total_votos DESC

/*4.Mostrar una lista de las personas que participan en cada pelicula */
SELECT m.title Titulo, p.person_name FROM movie_cast mc
INNER JOIN movie m ON mc.movie_id = m.movie_id
INNER JOIN person p ON mc.person_id = p.person_id


/*5.Mostrar una lista con la cantidad de personas por departamento que cuenta cada compañia productora*/
SELECT pc.company_name Compañia,  d.department_name Departamento, COUNT(p.person_id) AS cantidad_personas FROM movie_company mc
INNER JOIN production_company pc ON mc.company_id = pc.company_id
INNER JOIN movie_crew mcr ON mc.movie_id = mcr.movie_id
INNER JOIN department d ON mcr.department_id = d.department_id
INNER JOIN person p ON mcr.person_id = p.person_id
GROUP BY pc.company_name, d.department_name


/*6.Mostrar las peliculas en las que ha participado las personas como parte del movie_cast */
SELECT p.person_name Persona, m.title Pelicula FROM person p
INNER JOIN movie_cast mc ON p.person_id = mc.person_id
INNER JOIN movie m ON mc.movie_id = m.movie_id


/*7.Listar los paises donde estan ubicas las compañias productoras */
SELECT DISTINCT c.country_name Pais, pc2.company_name Compañia FROM production_country pc
INNER JOIN country c ON pc.country_id = c.country_id
INNER JOIN movie_company mc ON pc.movie_id = mc.movie_id
INNER JOIN production_company pc2 ON mc.company_id = pc2.company_id;


/*8.Mostrar de la lista de elencos cuantas mujeres participan en una pelicula de drama*/
SELECT m.title, COUNT(DISTINCT p.person_id) AS total_mujeres FROM movie m
INNER JOIN movie_genres mg ON m.movie_id = mg.movie_id
INNER JOIN genre g ON mg.genre_id = g.genre_id
INNER JOIN movie_cast mc ON m.movie_id = mc.movie_id
INNER JOIN person p ON mc.person_id = p.person_id
INNER JOIN gender ge ON mc.gender_id = ge.gender_id
WHERE g.genre_name = 'Drama' AND ge.gender = 'Female'
GROUP BY m.title;


/*9.Mostrar la cantidad de idiomas en los que se dobla cada pelicula*/
SELECT m.title pelicula, COUNT(DISTINCT ml.language_id) AS total_idiomas FROM movie m
INNER JOIN movie_languages ml ON m.movie_id = ml.movie_id
INNER JOIN language l ON ml.language_id = l.language_id
GROUP BY m.title;

/*10.Mostrar las 8 palabras claves mas utilizadas en las peliculas*/
SELECT top 8 k.keyword_name palabra_clave, COUNT(mk.keyword_id) AS total FROM keyword k
INNER JOIN movie_keywords mk ON k.keyword_id = mk.keyword_id
GROUP BY k.keyword_name
ORDER BY total DESC


