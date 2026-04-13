-- 1. High Stockout Risk Warehouses
SELECT 
    Warehouse_ID,
    SUM(Inventory_gap) AS total_inventory_gap,
    round(avg(Stockout_Probability),0) AS avg_stockout_prob
FROM clean_supply_chain
GROUP BY Warehouse_ID
HAVING AVG(Stockout_Probability) > 1 
   AND SUM(Inventory_gap) < 0
ORDER BY avg_stockout_prob DESC;

-- 2. warehouse with delivery_delays
SELECT 
    Warehouse_ID,
    round(AVG(Delivery_delay),0) AS avg_delay,
    round(AVG(Lead_Time_Days),0) AS avg_lead_time,
    round(AVG(Shipping_Time_Days),0) AS avg_shipping_time
FROM clean_supply_chain
GROUP BY Warehouse_ID
HAVING AVG(Delivery_delay) > (
    SELECT AVG(Delivery_delay) FROM clean_supply_chain
)
ORDER BY avg_delay DESC;

-- 3. Warehouses with low sales and high cost
SELECT 
    Warehouse_ID,
    SUM(Total_logistic_cost) AS total_cost,
    SUM(Monthly_Sales) AS total_sales
FROM clean_supply_chain
GROUP BY Warehouse_ID
HAVING SUM(Total_logistic_cost) > (
    SELECT AVG(Total_logistic_cost) FROM clean_supply_chain
)
AND SUM(Monthly_Sales) < (
    SELECT AVG(Monthly_Sales) FROM clean_supply_chain
)
ORDER BY total_cost DESC;

-- 4. Warehouse Capacity Utilization Analysis
SELECT 
    Warehouse_ID,
    round(AVG(Current_Stock),0) AS avg_stock,
    round(AVG(Warehouse_Capacity),0) AS avg_capacity,
    (AVG(Current_Stock) * 100.0 / AVG(Warehouse_Capacity)) AS utilization_percent
FROM clean_supply_chain
GROUP BY Warehouse_ID
ORDER BY utilization_percent DESC;

-- 5.Demand vs Inventory Imbalance
SELECT 
    Product_Category,
    SUM(Demand_Forecast) AS total_demand,
    SUM(Current_Stock) AS total_stock,
    SUM(Inventory_gap) AS total_gap
FROM clean_supply_chain
GROUP BY Product_Category
HAVING SUM(Inventory_gap) <> 0
ORDER BY total_gap ASC;

-- 6 Profitability Analysis by Product & Warehouse
SELECT 
    Warehouse_ID,
    Product_Category,
    SUM(Monthly_Sales) AS total_sales,
    SUM(Total_logistic_cost) AS total_cost,
    (SUM(Monthly_Sales) - SUM(Total_logistic_cost)) AS profit
FROM clean_supply_chain 
GROUP BY Warehouse_ID, Product_Category
HAVING (SUM(Monthly_Sales) - SUM(Total_logistic_cost)) < 0
ORDER BY profit ASC;

-- 7.Supplier Performance Analysis
SELECT 
    Supplier_ID,
    round(AVG(Lead_Time_Days),0)AS avg_lead_time,
    round(AVG(Delivery_delay),0) AS avg_delay,
    round(AVG(Shipping_Time_Days),0) AS avg_shipping_time
FROM clean_supply_chain
GROUP BY Supplier_ID
HAVING AVG(Delivery_delay) > (
    SELECT AVG(Delivery_delay) FROM clean_supply_chain
)
ORDER BY avg_delay DESC;