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
