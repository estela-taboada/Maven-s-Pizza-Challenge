-- 1. ¿Qué días y en qué horarios tenemos mayor afluencia?
-- Top días con mayor afluencia combinada:

SELECT 
    c2 AS dia,
    substr(c3, 1, 2) AS hora,
    COUNT(*) AS total_ordenes
FROM orders
WHERE c1 != 'order_id'
GROUP BY dia, hora
ORDER BY total_ordenes DESC
LIMIT 14;

-- Concentración general por hora:

SELECT 
    substr(c3, 1, 2) AS hora,
    COUNT(*) AS total_ordenes
FROM orders
WHERE c1 != 'order_id'
GROUP BY hora
ORDER BY total_ordenes DESC;

-- 2. ¿Cuántas pizzas preparamos durante los periodos de mayor demanda?

SELECT 
    substr(o.c3, 1, 2) AS hora,
    SUM(CAST(d.c4 AS INTEGER)) AS total_pizzas
FROM orders o
JOIN order_details d 
    ON o.c1 = d.c2
WHERE o.c1 != 'order_id' 
  AND d.c4 != 'quantity'
GROUP BY hora
ORDER BY total_pizzas DESC;

-- 3. ¿Cuáles son nuestras pizzas más y menos vendidas?Top Pizzas Más Vendidas (Mayor rotación):

SELECT 
    pt.name AS nombre_pizza,
    SUM(od.quantity) AS total_vendidas
FROM order_details od
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt 
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY nombre_pizza
ORDER BY total_vendidas DESC;

---🥇 The Classic Deluxe Pizza: 2,453 unidades vendidas.Top Pizzas Menos Vendidas (Menor rotación):

SELECT 
    pt.c2 AS nombre_pizza,
    SUM(CAST(od.c4 AS INTEGER)) AS total_vendidas
FROM order_details od
JOIN pizzas p 
    ON od.c3 = p.c1
JOIN pizza_types pt 
    ON p.c2 = pt.c1
WHERE od.c4 != 'quantity'
  AND p.c1 != 'pizza_id'
GROUP BY nombre_pizza
ORDER BY total_vendidas ASC;

---⛔️ The Brie Carre Pizza: Menor salida del catálogo (490 unidades).

   4. ¿Cuál es el valor promedio de nuestros pedidos (Ticket Promedio - AOV)?

SELECT 
    ROUND(SUM(od.quantity * p.price) / COUNT(DISTINCT od.order_id), 2) AS ticket_promedio
FROM order_details od
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id;
Ticket Promedio Resultante: $38.31 por pedido[cite: 8, 11].5. ¿Qué tan bien estamos aprovechando el aforo físico? (15 mesas / 60 asientos)

WITH ordenes_por_hora_dia AS (
    SELECT 
        date AS fecha,
        substr(time, 1, 2) AS hora,
        COUNT(*) AS total_ordenes
    FROM orders
    GROUP BY fecha, hora
)
SELECT 
    hora,
    ROUND(AVG(total_ordenes), 1) AS promedio_mesas_ocupadas,
    MAX(total_ordenes) AS pico_maximo_mesas,
    ROUND((AVG(total_ordenes) / 15.0) * 100, 1) AS pct_ocupacion_promedio,
    ROUND((MAX(total_ordenes) / 15.0) * 100, 1) AS pct_ocupacion_maxima
FROM ordenes_por_hora_dia
GROUP BY hora
ORDER BY promedio_mesas_ocupadas DESC;
