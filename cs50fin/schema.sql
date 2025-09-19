-- respository
CREATE TABLE product (
    product_code VARCHAR(255) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    selling_price DECIMAL(10, 2) NOT NULL,
    import_price DECIMAL(10, 2) NOT NULL,
    unit ENUM('chai', 'vi', 'hop', 'vien', 'goi') NOT NULL,
    product_group ENUM('vat_tu', 'ha_sot_giam_dau', 'khac') NOT NULL,
    sold_out_constraint INT DEFAULT 0 NOT NULL,
    company_id INT NOT NULL,
    FOREIGN KEY (company_id) REFERENCES company(company_id)
    -- expiration_constraint DATE NOT NULL -- 
);
CREATE TABLE respository (
    product_code VARCHAR(255),
    counts INT NOT NULL,
    expiration_date DATE NOT NULL,
    batch_code VARCHAR(255) NOT NULL
);
-- companies and customers --
CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(255) NOT NULL,
    customer_email VARCHAR(255),
    customer_phone VARCHAR(20)
    -- loans DECIMAL(10, 2) NOT NULL
);
CREATE TABLE company (
    company_id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(255) NOT NULL,
    company_email VARCHAR(255) NOT NULL,
    company_phone VARCHAR(20) NOT NULL
    -- loans DECIMAL(10, 2) NOT NULL
);
-- importing --
CREATE TABLE import_receipt (
    import_id INT PRIMARY KEY AUTO_INCREMENT,
    import_date DATE DEFAULT (CURDATE()),
    company_id INT NOT NULL,
    cost DECIMAL(10, 2) NOT NULL,
    payment DECIMAL(10, 2) NOT NULL, -- how many money I have paid
    pay_date DATE DEFAULT (CURDATE()), -- deleted paid
    FOREIGN KEY (company_id) REFERENCES company(company_id)
);
CREATE TABLE importing_transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    import_id INT NOT NULL,
    product_code VARCHAR(255) NOT NULL,
    counts INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL, -- import price per unit
    expiration DATE NOT NULL,
    batch_code VARCHAR(20) NOT NULL,
    FOREIGN KEY (import_id) REFERENCES import_receipt(import_id),
    FOREIGN KEY (product_code) REFERENCES product(product_code)
);
-- selling --
CREATE TABLE selling_receipt (
    selling_id INT PRIMARY KEY AUTO_INCREMENT,
    selling_date DATE NOT NULL DEFAULT (CURDATE()),
    cost DECIMAL(10, 2) NOT NULL,
    payment DECIMAL(10, 2) NOT NULL,
    pay_date DATE DEFAULT (CURDATE()),
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE selling_transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    selling_id INT NOT NULL,
    product_code VARCHAR(255) NOT NULL,
    counts INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL, -- selling price per unit
    batch_code VARCHAR(255) NOT NULL,
    FOREIGN KEY (selling_id) REFERENCES selling_receipt(selling_id),
    FOREIGN KEY (product_code) REFERENCES product(product_code)
);

-- view --
CREATE VIEW about_to_expired AS
    SELECT product_name, expiration_date
    FROM respository
    JOIN (SELECT product_name, product_code FROM product) AS p
    ON p.product_code = respository.product_code
    WHERE expiration_date < CURDATE() + INTERVAL 1 YEAR
    ORDER BY expiration_date ASC;

CREATE VIEW expired AS
    SELECT product_name, expiration_date
    FROM respository
    JOIN (SELECT product_name, product_code FROM product) AS p
    ON p.product_code = respository.product_code
    WHERE expiration_date < CURDATE()
    ORDER BY expiration_date ASC;

CREATE VIEW out_of_stock AS
    SELECT product_name, counts
    FROM respository
    JOIN (SELECT product_name, product_code FROM product) AS p
    ON p.product_code = respository.product_code
    WHERE counts < (
        SELECT sold_out_constraint
        FROM product
        WHERE product_code = respository.product_code
    )
    ORDER BY counts ASC;


-- trigger --

-- -----------------------------------------MODIFY TRIGGER

CREATE TRIGGER update_respository_counts
AFTER INSERT ON importing_transactions
FOR EACH ROW
BEGIN
    DECLARE existing_counts INT;

    -- Check if the product with the same batch_code already exists in the respository
    SELECT counts INTO existing_counts
    FROM respository
    WHERE product_code = NEW.product_code AND batch_code = NEW.batch_code;

    IF existing_counts IS NOT NULL THEN
        -- If it exists, update the counts
        UPDATE respository
        SET counts = counts + NEW.counts,
            expiration_date = NEW.expiration
        WHERE product_code = NEW.product_code AND batch_code = NEW.batch_code;
    ELSE
        -- If it doesn't exist, insert a new record
        INSERT INTO respository (product_code, counts, expiration_date, batch_code)
        VALUES (NEW.product_code, NEW.counts, NEW.expiration, NEW.batch_code);
    END IF;
END//

CREATE TRIGGER reduce_respository_counts
AFTER INSERT ON selling_transactions
FOR EACH ROW
BEGIN
    UPDATE respository
    SET counts = counts - NEW.counts
    WHERE product_code = NEW.product_code AND batch_code = NEW.batch_code;
END;


-- index
CREATE INDEX idx_product_code ON product (product_code);
CREATE INDEX idx_product_name ON product (product_name);