### Markdown# 🍕 Maven's Pizza Challenge — Sales & Operational Efficiency Analysis

## 📌 Contexto del Negocio
Proyecto desarrollado a partir del dataset de **Kaggle** para el reto comercial *"Maven Pizza Challenge"*. 

El objetivo es asumir el rol de consultor BI para **Plato's Pizza** (restaurante de inspiración griega ubicado en Nueva Jersey) y transformar sus registros históricos en decisiones tácticas de negocio mediante **SQL (SQLite)** para la extracción/transformación de datos y **Power BI** para el modelado relacional y visualización interactiva.

---

## 📊 Dashboard Interactivo (Power BI)

<p align="center">
  <img width="900" alt="Dashboard Preview" src="https://github.com/user-attachments/assets/601511c1-9b17-409a-b9b3-45e781b78358" />
</p>

### Métricas Principales (KPIs)
* **Ventas Totales:** $817.86K
* **Volumen Total:** 50K pizzas producidas
* **Pedidos Únicos:** 21K órdenes registradas
* **Ticket Promedio (AOV):** $38.31

---

## 🛠️ Arquitectura y Modelo Relacional

El modelo en Power BI se estructuró siguiendo un esquema relacional optimizado:
* **`orders` (1)** $\rightarrow$ **`order_details` ($\ast$)** mediante `order_id`[cite: 5, 6]
* **`pizzas` (1)** $\rightarrow$ **`order_details` ($\ast$)** mediante `pizza_id`[cite: 5, 6]
* **`pizza_types` (1)** $\rightarrow$ **`pizzas` ($\ast$)** mediante `pizza_type_id`[cite: 5, 6]

### Fórmulas DAX Destacadas
```dax
Total Ventas = 
SUMX(order_details, order_details[quantity] * RELATED(pizzas[price]))

1. Promedio Pedidos por Hora = 
DIVIDE([Total Pedidos], DISTINCTCOUNT(orders[date]), 0)
🔍 Análisis Técnico con SQL1. ¿Qué días y en qué horarios tenemos mayor afluencia?Top días con mayor afluencia combinada:SQLSELECT 
    c2 AS dia,
    substr(c3, 1, 2) AS hora,
    COUNT(*) AS total_ordenes
FROM orders
WHERE c1 != 'order_id'
GROUP BY dia, hora
ORDER BY total_ordenes DESC
LIMIT 14;
Concentración general por hora:SQLSELECT 
    substr(c3, 1, 2) AS hora,
    COUNT(*) AS total_ordenes
FROM orders
WHERE c1 != 'order_id'
GROUP BY hora
ORDER BY total_ordenes DESC;

2. ¿Cuántas pizzas preparamos durante los periodos de mayor demanda?
SQL
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

Hallazgo: En el intervalo pico del mediodía (12:00–13:00 hrs) la cocina alcanza su volumen máximo, registrando 6,776 pizzas producidas.

3. ¿Cuáles son nuestras pizzas más y menos vendidas?Top Pizzas Más Vendidas (Mayor rotación):
SQL
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
🥇 The Classic Deluxe Pizza: 2,453 unidades vendidas.Top Pizzas Menos Vendidas (Menor rotación):SQLSELECT 
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
⛔️ The Brie Carre Pizza: Menor salida del catálogo (490 unidades).

   4. ¿Cuál es el valor promedio de nuestros pedidos (Ticket Promedio - AOV)?
SQL
SELECT 
    ROUND(SUM(od.quantity * p.price) / COUNT(DISTINCT od.order_id), 2) AS ticket_promedio
FROM order_details od
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id;
Ticket Promedio Resultante: $38.31 por pedido[cite: 8, 11].5. ¿Qué tan bien estamos aprovechando el aforo físico? (15 mesas / 60 asientos)SQLWITH ordenes_por_hora_dia AS (
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

💡 Diagnóstico Operativo (Insights)Patrón Bimodal: La demanda se concentra en dos bloques definidos: almuerzo (12:00–13:00 hrs) y cena (17:00–19:00 hrs).   Capacidad Promedio vs. Picos Críticos: En promedio, el establecimiento opera a niveles saludables (43%–47% de ocupación, ~7 mesas ocupadas). No obstante, en jornadas pico las órdenes alcanzan hasta 19 pedidos/hora, generando una sobresaturación del 126.7% frente a las 15 mesas disponibles.   Concentración de Ventas: The Classic Deluxe (2,453 uds), The Barbecue Chicken (2,432 uds) y The Hawaiian (2,422 uds) encabezan la preferencia, mientras que The Brie Carre muestra un rendimiento rezagado frente al resto de la carta[cite: 11].🚀 Recomendaciones Estratégicas de NegocioDesacoplamiento de Aforo (Estrategia Off-Premise):Implementar canales de Pickup / Curbside (recogida programada en tienda) y Delivery (entrega a domicilio). Esto permite monetizar los picos de demanda superiores al 100% de aforo sin requerir expansión en metros cuadrados ni saturar el área de mesas.   Reestructuración Operativa y Empleabilidad:La apertura de canales para llevar justifica turnos de trabajo enfocados exclusivamente en empaque y despacho exprés durante las horas pico (12:00–14:00 y 18:00–20:00 hrs), agilizando la rotación de cocina sin comprometer el servicio en sala.Ingeniería de Menú (Menu Engineering):Diseñar promociones cruzadas (combos familiares) combinando una pizza líder con productos de baja rotación (The Brie Carre) para incentivar su consumo[cite: 11]. Si el volumen no repunta, retirarla del menú para reducir la merma de ingredientes perecederos exclusivos.Monetización de Horas Valle:Aprovechar la capacidad ociosa entre las 14:00 y 16:00 hrs mediante promociones de consumo exclusivo en mesa (happy hours o descuentos para oficinas locales).

📂 Estructura del RepositorioPlaintext├── assets/                  # Capturas del dashboard y resultados
├── data/                    # Archivos CSV fuente (Kaggle)
├── scripts/                 # Consultas SQL (.sql)
├── pizza_sales_bi.pbix      # Archivo fuente de Power BI Desktop
└── README.md                # Documentación del proyecto
