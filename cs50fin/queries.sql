-- Find expired products #
SELECT * FROM expired;

-- Find products that are about to expired   #
SELECT * FROM about_to_expired;

-- Find products that are out of stock    #
SELECT * FROM out_of_stock;

-- Find products in repository and related information # 
SELECT *
FROM product
JOIN respository ON product.product_code = respository.product_code
WHERE product.product_code = 'VT121'

-- Check customers loans #
-- ########################################################__GREAT
SELECT customer_name, customer.customer_id, SUM(cost - payment) AS total_loan
FROM customer
JOIN selling_receipt ON customer.customer_id = selling_receipt.customer_id
WHERE paid = FALSE
GROUP BY customer.customer_id;

-- Check loans of a customer #
SELECT selling_id, selling_date, (cost - payment) AS loan_amount FROM selling_receipt WHERE customer_id = 1 AND paid = FALSE;
-- Check unpaid invoices #
SELECT * FROM import_receipt WHERE paid = FALSE;

-- Find products of an importing receipt #
SELECT importing_transactions.product_code, product_name, counts, price, batch_code, expiration
FROM importing_transactions
JOIN (SELECT product_code, product_name FROM product) AS p 
ON p.product_code = importing_transactions.product_code
WHERE import_id = 1;
-- Find products of a selling receipt #
SELECT selling_transactions.product_code, product_name, counts, price, batch_code
FROM selling_transactions
JOIN (SELECT product_code, product_name FROM product) AS p
ON p.product_code = selling_transactions.product_code
WHERE selling_id = 1;

-- Add new product =====> create index
INSERT INTO product (product_code, product_name, selling_price, import_price, unit, product_group, sold_out_constraint, company_id) VALUES ('TH101', 'Thermometer', 10.0, 8.0, 'vi', 'vat_tu', 10,1);
INSERT INTO product (product_code, product_name, selling_price, import_price, unit, product_group, sold_out_constraint, company_id) VALUES ('TH102', 'Thermometer2', 12.0, 10.0, 'vi', 'vat_tu', 10,1);

-- Add new company
INSERT INTO company (company_name, company_email, company_phone) VALUES ('HealthCorp', 'contact@healthcorp.com', '123-456-7890');
-- Add new customer
INSERT INTO customer (customer_name, customer_email, customer_phone) VALUES ('John Doe', 'john.doe@example.com', '098-765-4321');
-- Add new import receipt
INSERT INTO import_receipt (company_id, cost, payment, paid) VALUES (1, 1000.00, 500.00, FALSE);
INSERT INTO import_receipt (company_id, cost, payment, paid) VALUES (1, 100.00, 50.00, FALSE);

-- Add new import transaction
INSERT INTO importing_transactions (import_id, product_code, counts, price, expiration, batch_code) VALUES (1, 'TH102', 10, 10.00, '2025-9-30', 'BATCH-H-40002');
-- Add new selling receipt
INSERT INTO selling_receipt (selling_date, cost, payment, pay_date, paid, customer_id) VALUES ('2025-09-19', 20.0, 8.0, '2025-09-19', FALSE, 1);
-- Add new selling transaction
INSERT INTO selling_transactions (selling_id, product_code, counts, price, batch_code) VALUES (1, 'TH101', 2, 10.00, 'BATCH-H-40001');