/*
1.Mostrar una lista de los libros con el autor e idiomas del libro
2.Obtener la cantidad de compras que ha realizado un cliente
3.Listar los 5 libros mas vendidos
4.Mostrar los paises donde se ha utilizado el tipo de envio Express
5.Mostrar los libros que sus ordenes se han cancelado
6.Mostrar el pais donde tiene mas influencia cada autor de libro
7.Mostrar los clientes que han retornado o devuelto libros
8.Mostrar la cantidad de libros y el titulo del libro que se han entregado satisfactoriamente
9.Mostrar la lista de los clientes mas frecuentes
10.Mostrar el mes en el que mas pedidos de libros se realizan
*/

/*1 1.Mostrar una lista de los libros con el autor e idiomas del libro*/
SELECT b.title Libro, a.author_name Autor, bl.language_name Idioma FROM book b
JOIN book_author ba ON b.book_id = ba.book_id
JOIN author a ON ba.author_id = a.author_id
JOIN book_language bl ON b.language_id = bl.language_id;

/*2.Obtener la cantidad de compras que ha realizado un cliente */
SELECT COUNT(*) AS Compras FROM cust_order co
JOIN order_line ol ON co.order_id = ol.order_id
WHERE co.customer_id = 1;

/*3.Listar los 5 libros mas vendidos */
SELECT top 5 b.title Libro, COUNT(ol.book_id) 'total_vendidos' FROM book b
INNER JOIN order_line ol ON b.book_id = ol.book_id
GROUP BY b.title
ORDER BY total_vendidos DESC


/*4.Mostrar los paises donde se ha utilizado el tipo de envio Express */
SELECT DISTINCT c.country_name Paises FROM country c
INNER JOIN address a ON c.country_id = a.country_id
INNER JOIN customer_address ca ON a.address_id = ca.address_id
INNER JOIN cust_order co ON ca.customer_id = co.customer_id
INNER JOIN shipping_method sm ON co.shipping_method_id = sm.method_id
WHERE sm.method_name = 'Express';

/*5.Mostrar los libros que sus ordenes se han cancelado*/
SELECT b.title Libros FROM book b
INNER JOIN order_line ol ON b.book_id = ol.book_id
INNER JOIN cust_order co ON ol.order_id = co.order_id
INNER JOIN order_history oh ON co.order_id = oh.order_id
INNER JOIN order_status os ON oh.status_id = os.status_id
WHERE os.status_value = 'Cancelled';


/6.*Mostrar el pais donde tiene mas influencia cada autor de libro */
SELECT a.author_name, c.country_name
FROM author a
INNER JOIN book_author ba ON a.author_id = ba.author_id
INNER JOIN book b ON ba.book_id = b.book_id
INNER JOIN publisher p ON b.publisher_id = p.publisher_id
INNER JOIN address ad ON p.publisher_id = ad.address_id
INNER JOIN country c ON ad.country_id = c.country_id
GROUP BY a.author_name, c.country_name


/*7.Mostrar los clientes que han retornado o devuelto libros */
SELECT c.first_name, c.last_name, COUNT(*) AS cantidad_libros FROM customer c
INNER JOIN cust_order co ON c.customer_id = co.customer_id
INNER JOIN order_history oh ON co.order_id = oh.order_id
INNER JOIN order_status os ON oh.status_id = os.status_id
WHERE os.status_value = 'Returned'
GROUP BY c.first_name, c.last_name
ORDER BY cantidad_libros DESC


/*8.Mostrar la cantidad de libros y el titulo del libro que se han entregado satisfactoriamente*/
SELECT COUNT(*) AS cantidad_libros, b.title FROM book b
INNER JOIN order_line ol ON b.book_id = ol.book_id
INNER JOIN cust_order co ON ol.order_id = co.order_id
INNER JOIN order_history oh ON co.order_id = oh.order_id
INNER JOIN order_status os ON oh.status_id = os.status_id
WHERE os.status_value = 'Delivered'
GROUP BY b.title
ORDER BY cantidad_libros DESC

/*9.Mostrar la lista de los clientes mas frecuentes*/
SELECT c.first_name, c.last_name, COUNT(*) AS cantidad_pedidos
FROM customer c
INNER JOIN cust_order co ON c.customer_id = co.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY cantidad_pedidos DESC

/*10.Mostrar el mes en el que mas pedidos de libros se realizan*/
SELECT MONTH(co.order_date) AS mes, COUNT(*) AS cantidad_pedidos FROM cust_order co
GROUP BY MONTH(co.order_date)
ORDER BY cantidad_pedidos DESC




