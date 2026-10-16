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

DASHBOARD INTERACTIVO 
<img width="1150" height="618" alt="image" src="https://github.com/user-attachments/assets/601511c1-9b17-409a-b9b3-45e781b78358" />

# 🍕 Pizza Sales & Operational Efficiency Analysis

## 📌 Descripción del Proyecto
Este proyecto analiza el rendimiento comercial y la capacidad operativa de una pizzería utilizando **SQL (SQLite)** para la extracción y transformación de datos, y **Power BI** para el modelado relacional y la visualización interactiva.

El objetivo principal es diagnosticar el comportamiento de la demanda, identificar los productos de mayor y menor impacto en el menú, y evaluar la utilización del aforo físico (15 mesas / 60 asientos) para proponer soluciones de negocio basadas en datos.

---

## 📊 Dashboard Interactivo (Power BI)

*(Agrega aquí tu captura de pantalla guardada en tu carpeta de imágenes)*
![Dashboard Preview](assets/dashboard_preview.png)

### Métricas Principales (KPIs)
* **Ventas Totales:** $817.86K
* **Volumen Total:** 50K pizzas producidas[cite: 11]
* **Pedidos Únicos:** 21K órdenes registradas[cite: 11]
* **Ticket Promedio (AOV):** $38.31[cite: 8, 11]

---

## 🛠️ Modelo de Datos y Arquitectura

El modelo en Power BI se estructuró siguiendo un esquema relacional optimizado:
* **`orders` (1)** $\rightarrow$ **`order_details` ($\ast$)** mediante `order_id`[cite: 5, 6]
* **`pizzas` (1)** $\rightarrow$ **`order_details` ($\ast$)** mediante `pizza_id`[cite: 5, 6]
* **`pizza_types` (1)** $\rightarrow$ **`pizzas` ($\ast$)** mediante `pizza_type_id`[cite: 5, 6]

---

## 🔍 Consultas SQL Clave

### 1. Demanda y Ocupación de Mesas por Hora
Evalúa el promedio de órdenes por hora y el pico máximo alcanzado en comparación con las 15 mesas físicas disponibles:

```sql
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
2. Top Pizzas Más y Menos VendidasIdentifica el volumen acumulado por sabor conectando las tablas de transacciones y catálogo:   SQLSELECT 
    pt.name AS nombre_pizza,
    SUM(od.quantity) AS total_vendidas
FROM order_details od
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt 
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY nombre_pizza
ORDER BY total_vendidas DESC;
3. Cálculo de Ticket Promedio (AOV)SQLSELECT 
    ROUND(SUM(od.quantity * p.price) / COUNT(DISTINCT od.order_id), 2) AS ticket_promedio
FROM order_details od
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id;
📈 Fórmulas DAX DestacadasIngreso Total:Code snippetTotal Ventas = SUMX(order_details, order_details[quantity] * RELATED(pizzas[price]))
Demanda Promedio por Hora (para visualización de aforo):Code snippetPromedio Pedidos por Hora = DIVIDE([Total Pedidos], DISTINCTCOUNT(orders[date]), 0)
💡 Hallazgos Principales (Insights)Patrón Bimodal de Demanda: Existen dos ventanas críticas de consumo: el almuerzo (12:00–13:00 hrs) y la cena (17:00–19:00 hrs).   Saturación en Picos Extremos: Aunque el aforo promedio se mantiene en niveles saludables (~45% a 47%, equivalente a ~7 mesas ocupadas), los picos diarios alcanzan hasta 19 órdenes por hora, representando un 126.7% de ocupación frente a las 15 mesas disponibles[cite: 4].   Concentración de Menú:Productos Estrella: The Classic Deluxe (2,453 uds), The Barbecue Chicken (2,432 uds) y The Hawaiian Pizza (2,422 uds) lideran la rotación física.   Baja Rotación: The Brie Carre Pizza se posiciona como el producto con menor demanda del catálogo[cite: 11].🚀 Recomendaciones Estratégicas de NegocioDesacoplamiento de Capacidad (Canales Off-Premise): Implementar opciones de recogida en tienda (Pickup / Takeout) y entrega a domicilio (Delivery). Esto permite capturar la demanda excedente durante las horas de sobreocupación (>120%) sin saturar el salón comedor ni requerir inversiones en ampliación física[cite: 4].Optimización de Costos y Menú: Evaluar los ingredientes de baja rotación (como el queso brie). Se sugiere integrarlos en promociones cruzadas con las pizzas líderes o retirarlos de la carta regular para reducir riesgos de merma por caducidad.Activación de Horas Valle: Diseñar incentivos de consumo en salón entre las 14:00 y 16:00 hrs (donde la ocupación promedio desciende), rentabilizando los costos fijos de las mesas desocupadas.   📂 Estructura del RepositorioPlaintext├── assets/                  # Capturas del dashboard y diagramas
├── data/                    # Archivos CSV fuente
├── scripts/                 # Consultas SQL (.sql)
├── pizza_sales_bi.pbix      # Archivo fuente de Power BI
└── README.md                # Documentación del proyecto
