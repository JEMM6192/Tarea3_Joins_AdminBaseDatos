/*
1.Mostrar la lista de juegos con el genero
2.Mostrar la lista de juegos que tiene cada Plataforma
3.Mostrar los juegos lanzados antes del año 2000
4.Mostrar los juegos mas vendidos en Europa
5.Mostrar los juegos con ventas menores al 0.5 de la plataforma Wii durante la decada del 2000
6.Mostrar la lista de juegos de PlayStation
7.Cuales son los 5 generos de juego que mas se venden en Europa
8.Que editores tienen mejor presencia en el mercado de ventas de Norte America
9.Que editor genera mas juegos de accion
10.Cantidad de juegos de estrategia desarrollados por Microsoft
*/

/*1.Mostrar la lista de juegos con el genero*/
SELECT g.game_name juegos, g2.genre_name genero  FROM game g
inner join genre g2 on g.genre_id=g2.id


/*2.Mostrar la lista de juegos que tiene cada Plataforma*/
SELECT p.platform_name Plataforma, g.game_name juego FROM platform p
JOIN game_platform gp ON gp.platform_id = p.id
JOIN game g ON g.id = gp.game_publisher_id

/*3.Mostrar los juegos lanzados antes del año 2000*/
SELECT g.game_name Juego, gp.release_year año FROM game g
JOIN game_platform gp ON g.id = gp.game_publisher_id
WHERE gp.release_year < 2000
ORDER BY gp.release_year DESC

/*4.Mostrar los juegos mas vendidos en Europa */
SELECT g.game_name jueo, SUM(rs.num_sales) AS total_ventas FROM game_platform gp
JOIN game g ON g.id = gp.game_publisher_id
JOIN region_sales rs ON rs.game_platform_id = gp.id
JOIN region r ON r.id = rs.region_id
WHERE r.region_name = 'Europe'
GROUP BY g.game_name
ORDER BY total_ventas DESC


/*5.Mostrar los juegos con ventas menores al 0.5 de la plataforma Wii durante la decada del 2000 */
SELECT g.game_name juego, rs.num_sales Numero_Ventas FROM game_platform gp
JOIN game g ON g.id = gp.game_publisher_id
JOIN region_sales rs ON rs.game_platform_id = gp.id
JOIN region r ON r.id = rs.region_id
WHERE gp.platform_id = (SELECT id FROM platform WHERE platform_name = 'Wii')
AND gp.release_year >= 2000 AND gp.release_year < 2010
AND r.region_name = 'Europe'
AND rs.num_sales < 0.5

/*6.Mostrar la lista de juegos de PlayStation */
SELECT g.game_name Juego, p.platform_name Plataforma FROM game_platform gp
JOIN game g ON g.id = gp.game_publisher_id
JOIN platform p ON p.id = gp.platform_id
WHERE p.platform_name IN ('PS','PS2', 'PS3', 'PS4')


/*7. Cuales son los 5 generos de juego que mas se venden en Europa */
SELECT TOP 5 gen.genre_name Generos, SUM(rs.num_sales) AS total_ventas
FROM game g
JOIN game_platform gp ON gp.id = g.id
JOIN region_sales rs ON rs.game_platform_id = gp.id
JOIN region r ON r.id = rs.region_id
JOIN genre gen ON gen.id = g.genre_id
WHERE r.region_name = 'Europe'
GROUP BY gen.genre_name
ORDER BY total_ventas DESC;

/* 8.Que editores tienen mejor presencia en el mercado de ventas de Norte America */
SELECT p.publisher_name Editor, SUM(rs.num_sales) AS total_ventas
FROM game_publisher gp
JOIN publisher p ON gp.publisher_id = p.id
JOIN game_platform gpf ON gpf.id = gp.game_id
JOIN region_sales rs ON rs.game_platform_id = gpf.id
JOIN region r ON r.id = rs.region_id
JOIN platform pl ON pl.id = gpf.platform_id
WHERE r.region_name = 'North America'
GROUP BY p.publisher_name
ORDER BY total_ventas DESC;

/*9.Que editor genera mas juegos de accion */
SELECT TOP 1 p.publisher_name Editor, COUNT(g.genre_id) AS total_juegos_accion
FROM game_publisher gp
JOIN publisher p ON gp.publisher_id = p.id
JOIN game g ON g.id = gp.game_id
JOIN genre gr ON gr.id = g.genre_id
WHERE gr.genre_name = 'Action'
GROUP BY p.publisher_name
ORDER BY  total_juegos_accion DESC;

/*10.Cantidad de juegos de estrategia desarrollados por Microsoft */
SELECT COUNT(*) AS total_juegos_estrategia
FROM game g
JOIN game_publisher gp ON gp.game_id = g.id
JOIN publisher p ON p.id = gp.publisher_id
WHERE p.publisher_name = 'Microsoft Game Studios' AND g.genre_id = (SELECT id FROM genre WHERE genre_name = 'Strategy');


