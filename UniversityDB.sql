/*
1.Realizar una consulta donde pueda obtener los paises donde estan ubicadas cada universidad.
2.Conocer cuantas universidades hay en cada pais.
3.Conocer cuantos paises no tienen universidades en el ranking.
4.Mostrar los criterios de cada tipo de ranking.
5.Conocer el ranking que tiene mas criterios
6.Cual es el top de universidades de forma descendente del ano 2012 por cada criterio
7.Mostrar las 5 universidad con mas cantidades de score 100 del ranking tipo 'Center for World University Rankings'
8.Mostrar que paises se posicionaron con universidades con un score mayor a 90
9.Mostrar las universidades que utilizan los criterios del tipo ranking 'Shangai Ranking'
10.Mostrart el top 10 de las peores posiciones del tipo ranking 'Times Higher....'
*/



/*1.Realizar una consulta donde pueda obtener los paises donde estan ubicadas cada universidad.*/
SELECT u.university_name 'Universidad', c.country_name 'Pais' FROM university u 
inner join country c on u.country_id= c.id  

/*2.Conocer cuantas universidades hay en cada pais.*/
SELECT c.country_name, count(u.id) 'Cantidad de universidades' 	FROM country c
LEFT JOIN  university u on c.id= u.country_id 
GROUP by c.country_name 
ORDER BY c.country_name ASC 

/*3.Conocer cuantos paises no tienen universidades en el ranking.*/
SELECT COUNT(c.id)  'Cantidad de universidades' FROM country c
LEFT JOIN university u ON c.id = u.country_id
LEFT JOIN university_ranking_year ur ON u.id = ur.university_id
WHERE ur.university_id IS NULL;

/*4.Mostrar los criterios de cada tipo de ranking.*/
SELECT rs.system_name, rc.criteria_name FROM ranking_system rs
JOIN ranking_criteria rc ON rc.ranking_system_id = rs.id;

/*5.Conocer el ranking que tiene mas criterios*/
SELECT u.university_name, COUNT(*) AS num_criteria FROM university_ranking_year r
INNER JOIN ranking_criteria c ON r.ranking_criteria_id = c.id
INNER JOIN university u ON r.university_id = u.id
GROUP BY u.university_name
ORDER BY num_criteria DESC


/*6.Cual es el top de universidades de forma descendente del ano 2012 por cada criterio*/
SELECT rc.criteria_name, u.university_name, r.score FROM university_ranking_year r
INNER JOIN ranking_criteria rc ON r.ranking_criteria_id = rc.id
INNER JOIN university u ON r.university_id = u.id
WHERE r.year = 2012
ORDER BY rc.criteria_name, r.score DESC;

/*7.Mostrar las 5 universidad con mas cantidades de score 100 del ranking tipo 'Center for World University Rankings'*/
SELECT top 5 u.university_name, COUNT(*) AS total_score FROM university_ranking_year r
INNER JOIN ranking_criteria c ON r.ranking_criteria_id = c.id
INNER JOIN university u ON r.university_id = u.id
INNER JOIN ranking_system s ON c.ranking_system_id = s.id
WHERE r.score = 100
  AND s.system_name = 'Center for World University Rankings'
GROUP BY u.university_name
ORDER BY total_score DESC

/*8.Mostrar que paises se posicionaron con universidades con un score mayor a 90*/
SELECT DISTINCT c.country_name FROM university_ranking_year r
INNER JOIN university u ON r.university_id = u.id
INNER JOIN country c ON u.country_id = c.id
WHERE r.score > 90;

/*9.Mostrar las universidades que utilizan los criterios del tipo ranking 'Shangai Ranking'*/
SELECT u.university_name FROM university u
INNER JOIN university_ranking_year r ON u.id = r.university_id
INNER JOIN ranking_criteria c ON r.ranking_criteria_id = c.id
INNER JOIN ranking_system s ON c.ranking_system_id = s.id
WHERE s.system_name = 'Shanghai Ranking';

/*10.Mostrart el top 10 de las peores posiciones del tipo ranking 'Times Higher....'*/
SELECT top 10 u.university_name, r.score FROM university u
INNER JOIN university_ranking_year r ON u.id = r.university_id
INNER JOIN ranking_criteria c ON r.ranking_criteria_id = c.id
INNER JOIN ranking_system s ON c.ranking_system_id = s.id
WHERE s.system_name = 'Times Higher Education World University Ranking'
ORDER BY r.score ASC



/* */