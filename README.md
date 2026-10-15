 # Maven-s-Pizza-Challenge
Análisis de pizzería 🍕
Para iniciar el análisis se toman data set de Kaggle.com; Para el "Maven Pizza Chanllenge", donde se solicita asumir el rol de consultor BI contratado por Plato´s pizza, pizzería de inspiración griega ubicada en nueva Jersey.
La cual la misión es ayudar al restaurante a utilizar sus datos para mejorar sus operaciones.
Requiere para ello contestar las siguientes preguntas:
➜¿Qué días y en qué horarios tenemos mayor afluencia?

CODIGO CONSULTA SQL: 
SELECT 
    c2 AS dia,
    substr(c3, 1, 2) AS hora,
    COUNT(*) AS total_ordenes
FROM orders
WHERE c1 != 'order_id'
GROUP BY dia, hora
ORDER BY total_ordenes DESC
LIMIT 14;

RESULTADO: 
<img width="204" height="303" alt="image" src="https://github.com/user-attachments/assets/08031b28-f47d-4c7e-b97c-f6db9e5603d0" />

En este se muestran los 14 días principales con mayor afluencia.

CODIGO CONSULTA SQL: 
SELECT 
    substr(c3, 1, 2) AS hora,
    COUNT(*) AS total_ordenes
FROM orders
WHERE c1 != 'order_id'
GROUP BY hora
ORDER BY total_ordenes DESC;


RESULTADO DE LA CONSULTA:
<img width="161" height="320" alt="image" src="https://github.com/user-attachments/assets/3a39242d-7b8f-4ef2-800b-81f0392030ba" />
En este se muestra las hora con mayor afluencias.

➜¿Cuántas pizzas preparamos durante los periodos de mayor demanda?
 CODIGO A CONSULTAR SQL: 
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

AQUI SE MUESTRA EL RESULTADO DEL CODIGO: 
<img width="130" height="318" alt="image" src="https://github.com/user-attachments/assets/d3ad963a-3386-467f-a8d3-ed3d1f9515d3" />


Donde el resulta muestra donde en el periodo de mayor demanda se producen 6776 pizzas.

➜¿Cuáles son nuestras pizzas más vendidas y cuáles las menos vendidas?
CONSULTA SQL PARA LA PIZZA MAS VENDIDA ES:
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
ORDER BY total_vendidas DESC;

COMO RESULTADO ES:
The Classic Deluxe Pizza con 2453 piezas vendidas. 🥇🍕🍕🍕
<img width="446" height="59" alt="image" src="https://github.com/user-attachments/assets/51986ca3-c440-4a8e-896d-8413fc67d2ba" />


Y PARA LA CONSULTA DE LA PIZZAS MENOS VENDIDA ES, CODIGO SQL: 
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

EL CUAL EL RESULTADO ES EL SIGUIENTE LA PIZZA CON MENOS VENTAS ES:
The Brie Carre Pizza ⛔️🍕
<img width="464" height="59" alt="image" src="https://github.com/user-attachments/assets/ce3f2849-40c3-4c1a-be8e-3b9cc4206c24" />

➜¿Cuál es el valor promedio de nuestros pedidos?
CONSULTA SQL:

SELECT 
    ROUND(SUM(CAST(od.c4 AS REAL) * CAST(p.c4 AS REAL)) / COUNT(DISTINCT od.c2), 2) AS ticket_promedio
FROM order_details od
JOIN pizzas p 
    ON od.c3 = p.c1
WHERE od.c4 != 'quantity'
  AND p.c1 != 'pizza_id';

  RESULTADO DE LA CONSULTA SU TICKET PROMEDIO ES: 38.31
  <img width="166" height="68" alt="image" src="https://github.com/user-attachments/assets/7b561fbd-05fb-484f-8c9a-5d84b0d1be2b" />

➜¿Qué tan bien estamos aprovechando nuestra capacidad de aforo?
CODIGO CONSULTA SQL:

  WITH ordenes_por_hora_dia AS (
    SELECT 
        c2 AS fecha,
        substr(c3, 1, 2) AS hora,
        COUNT(*) AS total_ordenes
    FROM orders
    WHERE c1 != 'order_id'
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

RESULTADO DE LA CONSULTA: 
<img width="704" height="326" alt="image" src="https://github.com/user-attachments/assets/89095b26-25df-4d63-81fe-143b5b2209e6" />

De acuerdo a este resultado se demuetsra previo a los resultados que la oupacion en promedio es saludable.


CONCLUSIONES:
Estrategia para el menú:
Promoción cruzada: Crear paquetes (combo familiar) combinando una de las más populares con una de baja rotación a un precio atractivo para inducir la prueba.
Optimización de carta: Si tras una campaña la pizza menos vendida no levanta volumen, la recomendación operativa es retirarla del menú para reducir costos de inventario y espacio en refrigeración.

Estrategia de Optimización de Capacidad: Diversificación de Canales (Off-Premise)Problema identificado: La capacidad instalada de 15 mesas presenta picos de saturación operativa de hasta 126.7% durante las horas punta (13:00 y 19:00 hrs), generando cuellos de botella y posibles pérdidas de venta en salón.   Propuesta estratégica: Implementar canales de venta externos como Pickup / Curbside (recogida en tienda) y Delivery (entrega a domicilio) mediante integraciones digitales.Impacto operativo y financiero:Descompresión del salón: Desvía el volumen excedente fuera de las mesas físicas, reduciendo tiempos de espera y garantizando una experiencia óptima para los comensales en sitio.Incremento en facturación: Maximiza la rentabilidad por metro cuadrado y eleva el volumen global de ventas sin requerir una inversión de capital en ampliación física del local.Eficiencia laboral: Permite redistribuir y profesionalizar al personal de cocina y empaque, generando nuevos roles operativos especializados en despacho rápido.

