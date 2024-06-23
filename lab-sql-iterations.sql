-- 1.Write a query to find what is the total business done by each store.
SELECT s.store_id, SUM(p.amount) AS total_business
FROM store s
JOIN inventory i ON s.store_id = i.store_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY s.store_id
ORDER BY s.store_id;

-- 2.Convert the previous query into a stored procedure.
DELIMITER $$

CREATE PROCEDURE GetTotalBusinessByStore()
BEGIN
    SELECT s.store_id, SUM(p.amount) AS total_business
    FROM store s
    JOIN inventory i ON s.store_id = i.store_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    JOIN payment p ON r.rental_id = p.rental_id
    GROUP BY s.store_id
    ORDER BY s.store_id;
END $$

DELIMITER ;

-- 3.Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

DELIMITER $$

CREATE PROCEDURE GetTotalSalesByStore(IN storeId INT)
BEGIN
    SELECT s.store_id, SUM(p.amount) AS total_sales
    FROM store s
    JOIN inventory i ON s.store_id = i.store_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    JOIN payment p ON r.rental_id = p.rental_id
    WHERE s.store_id = storeId
    GROUP BY s.store_id;
END $$

DELIMITER ;

-- 4.Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). Call the stored procedure and print the results.

DELIMITER $$

CREATE PROCEDURE GetTotalSalesByStore(IN storeId INT)
BEGIN
    DECLARE total_sales_value FLOAT;
    
    SELECT SUM(p.amount) INTO total_sales_value
    FROM store s
    JOIN inventory i ON s.store_id = i.store_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    JOIN payment p ON r.rental_id = p.rental_id
    WHERE s.store_id = storeId;
    
    SELECT total_sales_value AS total_sales;
END $$

DELIMITER ;

-- 5.In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.

DELIMITER $$

CREATE PROCEDURE calculate_sales(IN storeId INT)
BEGIN
    DECLARE total_sales_value FLOAT;
    DECLARE flag VARCHAR(10); -- New variable for the flag
    
    SELECT SUM(p.amount) INTO total_sales_value
    FROM store s
    JOIN inventory i ON s.store_id = i.store_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    JOIN payment p ON r.rental_id = p.rental_id
    WHERE s.store_id = storeId;
    
    -- Set the flag based on the total sales value
    IF total_sales_value > 30000 THEN
        SET flag = 'green_flag';
    ELSE
        SET flag = 'red_flag';
    END IF;
    
    -- Return the total sales value and the flag
    SELECT total_sales_value AS total_sales, flag;
END $$

DELIMITER ;

SHOW PROCEDURE STATUS LIKE 'GetTotalSalesByStore';
DROP PROCEDURE IF EXISTS GetTotalSalesByStore;

