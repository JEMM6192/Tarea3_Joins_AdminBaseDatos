/*
1.Mostrar la lista de los ganadores de medalla de oro en eventos de Futbol, Baloncesto y Golf
2.Cuales son los eventos que se jugaron en el año 2000
3.Cuales son las 20 principales ciudades donde se han jugado mas Olimpiadas
4.Liste los paises no tienen ningun participante en las ultimas 10 olimpiadas
5.liste los 5 paises que mas ganan medallas de oro, plata y bronce
6.El evento con mayor cantidad de personas participando
7.Liste los deportes que en todas las olimpiadas siempre se llevan a cabo
8.Muestre la comparacion de la cantidad de veces entre los dos generos(M,F) que ganado medallas de cualquier tipo
9.Cual es la altura y peso que mas es mas frecuente en los participantes del deporte de Boxeo
10.Muestre los participantes menores de edad que participan en las olimpiadas
*/

/*1.Mostrar la lista de los ganadores de medalla de oro en eventos de Futbol, Baloncesto y Golf*/
SELECT p.full_name Ganadores, e.event_name Evento, s.sport_name Deporte
FROM competitor_event ce
INNER JOIN event e ON ce.event_id = e.id
INNER JOIN sport s ON e.sport_id = s.id
INNER JOIN medal m ON ce.medal_id = m.id
INNER JOIN games_competitor gc ON ce.competitor_id = gc.id
INNER JOIN games g ON gc.games_id = g.id
INNER JOIN person p ON gc.person_id = p.id
WHERE m.medal_name = 'Gold'
  AND s.sport_name IN ('Football', 'Basketball', 'Golf');

/*2.Cuales son los eventos que se jugaron en el año 2000 */
SELECT e.event_name Evento , s.sport_name Deporte FROM event e
INNER JOIN sport s ON e.sport_id = s.id
INNER JOIN games_competitor gc ON e.id = gc.id
INNER JOIN games g ON gc.games_id = g.id
WHERE g.games_year = 2000;

/* 3.Cuales son las 20 principales ciudades donde se han jugado mas Olimpiadas */
SELECT top 20 c.city_name Ciudad, COUNT(DISTINCT g.id) AS total_olimpiadas
FROM city c JOIN games_city gc ON c.id = gc.city_id
JOIN games g ON gc.games_id = g.id
GROUP BY c.city_name
ORDER BY total_olimpiadas DESC

/* 4.Liste los paises no tienen ningun participante en las ultimas 10 olimpiadas */

SELECT r.region_name Pais FROM noc_region r
LEFT JOIN person_region pr ON r.id = pr.region_id
LEFT JOIN games_competitor gc ON pr.person_id = gc.person_id
LEFT JOIN games g ON gc.games_id = g.id
WHERE g.games_year >= (SELECT MAX(games_year) FROM games) - 9
AND pr.person_id IS NULL


/* 5.liste los 5 paises que mas ganan medallas de oro, plata y bronce */
SELECT top 5 noc_region.region_name pais, COUNT(medal.id) AS total_medallas FROM competitor_event
JOIN medal ON competitor_event.medal_id = medal.id
JOIN games_competitor ON competitor_event.competitor_id = games_competitor.id
JOIN person ON games_competitor.person_id = person.id
JOIN person_region ON person.id = person_region.person_id
JOIN noc_region ON person_region.region_id = noc_region.id
WHERE medal.medal_name IN ('Gold', 'Silver', 'Bronze')
GROUP BY noc_region.region_name
ORDER BY total_medallas  DESC


/*6.El evento con mayor cantidad de personas participando*/
SELECT TOP 1 event.event_name Evento, COUNT(DISTINCT games_competitor.person_id) AS total_participantes FROM event
INNER JOIN competitor_event ON event.id = competitor_event.event_id
INNER JOIN games_competitor ON competitor_event.competitor_id = games_competitor.id
GROUP BY event.event_name
ORDER BY total_participantes DESC



/*7.Liste los deportes que en todas las olimpiadas siempre se llevan a cabo*/
SELECT s.sport_name Deporte FROM sport s
INNER JOIN event e ON s.id = e.sport_id
INNER JOIN competitor_event ce ON e.id = ce.event_id
INNER JOIN games_competitor gc ON ce.competitor_id = gc.person_id
INNER JOIN games g ON gc.games_id = g.id
GROUP BY s.sport_name
HAVING COUNT(DISTINCT g.season) = (SELECT COUNT(DISTINCT season) FROM games)


/* 8.Muestre la comparacion de la cantidad de veces entre los dos generos(M,F) que ganado medallas de cualquier tipo */
SELECT person.gender Generos, COUNT(DISTINCT competitor_event.medal_id) AS total_medallas FROM person
INNER JOIN games_competitor ON person.id = games_competitor.person_id
INNER JOIN competitor_event ON games_competitor.id = competitor_event.competitor_id
GROUP BY person.gender;

/* 9.Cual es la altura y peso que mas es mas frecuente en los participantes del deporte de Boxeo*/
SELECT top 1p.height Altura, p.weight Peso, COUNT(*) AS frecuencia FROM person p
INNER JOIN games_competitor gc ON p.id = gc.person_id
INNER JOIN competitor_event ce ON gc.id = ce.competitor_id
INNER JOIN event e ON ce.event_id = e.id
INNER JOIN sport s ON e.sport_id = s.id
WHERE s.sport_name = 'Boxing'
GROUP BY p.height, p.weight
ORDER BY frecuencia DESC

/* 10.Muestre los participantes menores de edad que participan en las olimpiadas */
SELECT p.full_name Nombre, gc.age Edad FROM person p
INNER JOIN games_competitor gc ON p.id = gc.person_id
INNER JOIN games g ON gc.games_id = g.id
WHERE gc.age < 18

