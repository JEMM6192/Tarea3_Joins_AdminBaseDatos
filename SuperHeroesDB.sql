/*
1.Mostrar una lista de los superpoderes que tiene cada Super Heroe
2.Mostrar la cantidad de superpoderes con los que cuenta cada Super Heroe
3.Mostrar los diez superpoderes que es mas frecuente en cada Super Heroe
4.Mostrar los diez superpoderes que es mas frecuente en cada Super Heroe
5.Mostrar los Super Heroes que no cuentan con el Atributo de Intelligence
6.Mostrar los Super Heroes que cuentan con tres o 5 Atributos
7.Mostrar la lista de las mujeres que son Super Heroes
8.Mostrar la lista de los colores de como se identifca un Super Heroe (color de ojos, traje y pelo)
9.Mostrar la lista de Super Heroe indicando su origen (race) y cantidad de superpoderes
10.Mostrar la cantidad de superheroes que tienen un papel de Superheroe Bueno(alignment) agrupado por cada editor(publisher)
*/


/*1.Mostrar una lista de los superpoderes que tiene cada Super Heroe*/
SELECT s.superhero_name AS Superheroe, sp.power_name AS SuperPoder FROM superhero s
INNER JOIN hero_power hp ON s.id = hp.hero_id
INNER JOIN superpower sp ON hp.power_id = sp.id;


/*2.Mostrar la cantidad de superpoderes con los que cuenta cada Super Heroe*/
SELECT s.superhero_name AS Superheroe, COUNT(sp.id) AS cantidad_superpoderes FROM superhero s
LEFT JOIN hero_power hp ON s.id = hp.hero_id
LEFT JOIN superpower sp ON hp.power_id = sp.id
GROUP BY s.id, s.superhero_name;


/*4.Mostrar los diez superpoderes que es mas frecuente en cada Super Heroe*/
SELECT TOP 10 superhero.superhero_name, superpower.power_name, COUNT(*) as power_count
FROM superhero
INNER JOIN hero_power ON superhero.id = hero_power.hero_id
INNER JOIN superpower ON hero_power.power_id = superpower.id
GROUP BY superhero.superhero_name, superpower.power_name
ORDER BY superhero.superhero_name, power_count DESC;


/*5.Mostrar los Super Heroes que no cuentan con el Atributo de Intelligence*/
SELECT s.superhero_name FROM superhero s
LEFT JOIN hero_attribute ha ON s.id = ha.hero_id
LEFT JOIN attribute a ON ha.attribute_id = a.id AND a.attribute_name = 'Intelligence'
WHERE a.id IS NULL;



/*6.Mostrar los Super Heroes que cuentan con tres o 5 Atributos*/
SELECT s.superhero_name
FROM superhero s
JOIN hero_attribute ha ON s.id = ha.hero_id
GROUP BY s.id, s.superhero_name
HAVING COUNT(ha.attribute_id) = 3 OR COUNT(ha.attribute_id) = 5;
--

/*7.Mostrar la lista de las mujeres que son Super Heroes*/
SELECT s.superhero_name FROM superhero s
INNER JOIN gender g ON s.gender_id = g.id
WHERE g.gender = 'Female';



/*8.Mostrar la lista de los colores de como se identifca un Super Heroe (color de ojos, traje y pelo)*/
SELECT s.superhero_name AS SuperHeroe, ec.colour AS Color_Ojos, hc.colour AS Color_Pelo, sc.colour AS Color_Traje FROM superhero s
INNER JOIN colour ec ON s.eye_colour_id = ec.id
INNER JOIN colour hc ON s.hair_colour_id = hc.id
INNER JOIN colour sc ON s.skin_colour_id = sc.id;


/*9.Mostrar la lista de Super Heroe indicando su origen (race) y cantidad de superpoderes*/
SELECT s.superhero_name, r.race Origen, COUNT(hp.power_id) Cantidad_Poderes FROM superhero s
INNER JOIN race  r ON s.race_id = r.id
LEFT JOIN hero_power hp ON s.id = hp.hero_id
GROUP BY s.id, s.superhero_name, r.race;


/*10.Mostrar la cantidad de superheroes que tienen un papel de Superheroe Bueno(alignment) agrupado por cada editor(publisher)*/
SELECT p.publisher_name, COUNT(s.id) AS cantidad_superhero FROM superhero s
INNER JOIN alignment a ON s.alignment_id = a.id
INNER JOIN publisher p ON s.publisher_id = p.id
WHERE a.alignment = 'Good'
GROUP BY p.publisher_name;
