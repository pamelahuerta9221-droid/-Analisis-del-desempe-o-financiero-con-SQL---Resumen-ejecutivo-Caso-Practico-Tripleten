SELECT * 
FROM campanas
LIMIT 10;

SELECT
    v.numero_pedido,
    v.clave_producto,
    p.nombre_producto,
    pc.clave_categoria,
    COALESCE(p.precio_producto, 0)  AS precio_producto,
    COALESCE(v.cantidad_pedido, 0)  AS cantidad_pedido,
    COALESCE(p.costo_producto, 0)   AS costo_producto,
    t.pais,
    t.continente,
    v.clave_territorio,
-- Calcula  ingreso_total y costo_total
COALESCE(p.precio_producto, 0) * COALESCE(v.cantidad_pedido, 0) AS ingreso_total,
COALESCE(p.costo_producto, 0)  * COALESCE(v.cantidad_pedido, 0) AS costo_total
FROM ventas_2017 AS v
JOIN productos AS p
  ON v.clave_producto = p.clave_producto
LEFT JOIN productos_categorias AS pc
  ON p.clave_subcategoria = pc.clave_subcategoria
LEFT JOIN territorios AS t
  ON v.clave_territorio = t.clave_territorio;

SELECT
    p.pais,
    p.clave_territorio,
    SUM(p.ingresos)::integer AS ingresos,
    SUM(p.costos)::integer AS costos,
    COALESCE(SUM(c.costo_campana), 0)::integer AS costo_campana,

SUM(p.ingresos)::integer-SUM(p.costos)::integer AS beneficio_bruto,   
((SUM(p.ingresos)-SUM(p.costos)))*100/(NULLIF(SUM(p.ingresos),0)) AS margen_pct,   
((SUM(p.ingresos)-SUM(p.costos))*100.0)/(NULLIF(SUM(c.costo_campana),0))AS roi_pct 
FROM pais_ingreso_costo AS p
LEFT JOIN pais_campanas AS c
  ON p.clave_territorio = c.clave_territorio
GROUP BY
    p.pais,
    p.clave_territorio
ORDER BY
    p.clave_territorio, ingresos, costos;

SELECT 
SUM(CASE WHEN precio_producto<0 THEN 1 ELSE 0 END) AS productos_precio_no_valido
FROM productos;

