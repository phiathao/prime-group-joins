
--1.	Get all customers and their addresses.

SELECT "customers"."id", "first_name", "last_name", "address_type", "street", "city", "state", "zip" 
FROM "customers" 
JOIN "addresses" ON "addresses"."customer_id" = "customers"."id";

--2.	Get all orders and their line items (orders, quantity and product).

SELECT  "orders"."id", "order_date", "description", "unit_price"
FROM "orders" 
JOIN "line_items" ON "line_items"."order_id" = "orders"."id"
JOIN "products" ON "products"."id" = "line_items"."product_id";

--3.	Which warehouses have cheetos?

SELECT "warehouse"."warehouse" 
FROM "warehouse"
JOIN "warehouse_product" ON "warehouse_product"."warehouse_id" = "warehouse"."id"
JOIN "products" ON "products"."id" = "warehouse_product"."product_id"
WHERE "description" ILIKE '%cheetos%';

--4.    Which warehouses have diet pepsi?

SELECT "warehouse"."warehouse" 
FROM "warehouse"
JOIN "warehouse_product" ON "warehouse_product"."warehouse_id" = "warehouse"."id"
JOIN "products" ON "products"."id" = "warehouse_product"."product_id"
WHERE "description" ILIKE '%diet pepsi%';

--5.    Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.

SELECT CONCAT("first_name", "last_name") AS "customer", COUNT("address_id") AS "number_of_order" 
FROM "customers"
JOIN "addresses" ON "addresses".customer_id = "customers".id
JOIN "orders" ON "orders".address_id = "addresses".id
GROUP BY "customer";

--6.    How many customers do we have?

SELECT COUNT(*) FROM "customers";

--7.    How many products do we carry?

SELECT COUNT(*) FROM "products";

--8.    What is the total available on-hand quantity of diet pepsi?

SELECT SUM("on_hand") AS "total" FROM "warehouse_product"
JOIN "products" ON "products".id = "warehouse_product".product_id
WHERE "description" ILIKE '%diet pepsi%';

--9.    How much was the total cost for each order?
SELECT "orders"."id", SUM("line_items"."quantity" * "products"."unit_price")
FROM "line_items"
JOIN "products" ON "products"."id" = "line_items"."product_id"
JOIN "orders" ON "line_items"."order_id" = "orders"."id"
GROUP BY "orders"."id"
ORDER BY "orders"."id" ASC;

--10.   How much has each customer spent in total?
SELECT CONCAT("first_name", "last_name") AS "customer", SUM("line_items"."quantity" * "products"."unit_price") as "total"
FROM "customers"
JOIN "addresses" ON "addresses".customer_id = "customers".id
JOIN "orders" ON "orders".address_id = "addresses".id
JOIN "line_items" ON "line_items".order_id = "orders".id
JOIN "products" ON "products".id = "line_items".product_id
GROUP BY "customer";


SELECT CONCAT("first_name", "last_name") AS "customer", SUM(ISNULL("line_items"."quantity" * "products"."unit_price"), 0) as "total"
FROM "customers"
JOIN "addresses" ON "addresses".customer_id = "customers".id
JOIN "orders" ON "orders".address_id = "addresses".id
JOIN "line_items" ON "line_items".order_id = "orders".id
JOIN "products" ON "products".id = "line_items".product_id
GROUP BY "customer";