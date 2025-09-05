# Design Document

By Nguyen Bich Uyen

Video overview: // link

## Scope

The database for Pharmacy management includes all entities necessary to facilitate the process of tracking importing and selling receipts, status of products in repository and loans of company and customer. The database's scope include:

* Products, including detailed information of every products that sold by the pharmacy
* Respository, including number of each product and its expiration date
* Customer, including customer name and contact
* Company, including company name and contact
* import_receipt, including basic information about the pharmacy importing receipts
* importing_transactions, including more detailed about the products in importing receipts
* selling_receipt, including basic information about the pharmacy selling receipts
* selling_transactions, including more detailed about the products in selling receipts

Out of scope are elements like ...

## Functional Requirements

This database will support:

* Tracking all expired, about to expired, and sold out products
* Tracking products in respository
* Tracking receipt loans
* Tracking customers and companies

Note that in this iteration, the system will not support students responding to comments.

## Representation

Entities are captured in SQLite tables with the following schema.

### Entities

The database includes the following entities:

#### Product

The `product` table includes:

* `product_code`, which specifies the unique code for the product as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `product_name`, which specifies the product's name as `VARCHAR` with limited length (255), given `VARCHAR(255)` is appropriate for medical product name.
* `selling_price`, which specifies the product's selling price as `DECIMAL(10,2)`. 
* `import_price`, which specifies the product's import price as `DECIMAL(10,2)`. 
* `unit`, which specifies the unit of product to count as `ENUM()`, including 'chai', 'vi', 'hop', 'vien', 'goi'.
* `product_group`, which specifies the group of the product as `ENUM()`, including 'vat_tu', 'ha_sot_giam_dau', 'khac'.
* `sold_out_constraint`, which specifies the smallest number of products avalable in respoitory as `INTEGER`, helping to alert before products are out of stock. The default value of this field is 0.
* `company_id`, which specifies the `id` of the `company` that provides the products, in `INTEGER`. This is a foreign key, respresenting the `company_id` field in `company` table

All columns in the `product` table are required, and hence should have the `NOT NULL` constraint applied. No other constraints are necessary.

#### Respository

The `respository` table includes:

* `product_code`, which specifies the code of the productc as `VARCHAR` with maximum 255 characters. This is a foreign key, represents `product_code` in the `product` table 
* `counts`, which specifies the number of the products avalable in respository as`INT`
* `expiration_date`, which specifies the expiration date of the product as `DATE`
* `batch_code`, which specifies the batch code of the product as `VARCHAR(255)`, helping to identify the exact product and batch

All columns in the `respository` table are required and hence should have the `NOT NULL` constraint applied. No other constraints are necessary.

#### Customer

The `customer` table includes:

* `customer_id`, which specifies unique id of the customer as `INT`.  This column thus has the `PRIMARY KEY` constraint applied.
* `customer_name`, which specifies the customer's name as `VARCHAR(255)`. The length 255 is enough for a normal name. This field must not be `NULL`.
* `customer_email`, which specifies the customer's email as `VARCHAR(255)`
* `customer_phone`, which specifies the customer's phone number as `VARCHAR(20)`

#### Company

The `company` table includes:

* `company_id`, which specifies the unique ID of the company as `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `company_name`, which specifies the name of the company as `VARCHAR(255)`. The 255 length is enough for a normal company name. This field must not be `NULL`
* `company_email`, which specifies the email of the company as  `VARCHAR(255)`
* `company_phone`, which specifies the phone number of the company as `VARCHAR(20)`

#### Import_receipt

The `import_receipt` table includes:

* `import_id`, which specifies the unique id of the importing receipt as  `INT`.  This column thus has the `PRIMARY KEY` constraint applied.
* `import_date`, which specifies the imported date as `DATE`. This column has default value `CURDATE()`.
* `company_id`, which specifies the id of the company that provide imported products. 
* `cost`, which specifies the total cost of the receipt as `DECIMAL(10, 2)`
* `payment`, which specifies the paid amount of the receipt as `DECIMAL(10, 2)`, this must not be `NULL`
* `pay_date`, which specifies the lastest paid date as `DATE`. This has default value `CURDATE()`

All columns are required and hence have the `NOT NULL` constraint applied where a `PRIMARY KEY` or `FOREIGN KEY` constraint is not.

#### Importing_transactions

The `importing_transactions` table include:

* `transaction_id`, which specifies the unique id of the transaction as `INT`. This column thus has the `PRIMARY KEY` constraint applied.
* `import_id`, which specifies the id of the import receipt that the transaction belong to as `INT`
* `product_code`, which specifies the unique code of the imported product as `VARCHAR(255)`, helping to identify other imformations related to the product.
* `counts`, which specifies the number of the product imported as `INT`
* `price`, which specifies the imported price of one unit of the product as `DECIMAL(10, 2)`
* `expiration`, which specifies the expiration date of the product as `DATE`
* `batch_code`, which specifies the batch code of the product as `VARCHAR(20)`

All columns are required and hence have the `NOT NULL` constraint applied where a `PRIMARY KEY` or `FOREIGN KEY` constraint is not.

#### Selling_receipt

The `selling_receipt` table includes:

* `selling_id`, which specifies the unique id of the selling receipt as  `INT`.  This column thus has the `PRIMARY KEY` constraint applied.
* `selling_date`, which specifies the imported date as `DATE`. This column has default value `CURDATE()`.
* `customer_id`, which specifies the id of the customer that purchased products. 
* `cost`, which specifies the total cost of the receipt as `DECIMAL(10, 2)`
* `payment`, which specifies the paid amount of the receipt as `DECIMAL(10, 2)`, this must not be `NULL`
* `pay_date`, which specifies the lastest paid date as `DATE`. This has default value `CURDATE()`

All columns are required and hence have the `NOT NULL` constraint applied where a `PRIMARY KEY` or `FOREIGN KEY` constraint is not.

#### Selling_transactions

The `selling_transactions` table include:

* `transaction_id`, which specifies the unique id of the transaction as `INT`. This column thus has the `PRIMARY KEY` constraint applied.
* `selling_id`, which specifies the id of the selling receipt that the transaction belong to as `INT`
* `product_code`, which specifies the unique code of the product as `VARCHAR(255)`, helping to identify other imformations related to the product.
* `counts`, which specifies the number of the product sold as `INT`
* `price`, which specifies the sold price of one unit of the product as `DECIMAL(10, 2)`
* `batch_code`, which specifies the batch code of the product as `VARCHAR(20)`

All columns are required and hence have the `NOT NULL` constraint applied where a `PRIMARY KEY` or `FOREIGN KEY` constraint is not.

### Relationships

The below entity relationship diagram describes the relationships among the entities in the database.

![ER Diagram](https://mermaid.ink/img/pako:eNp9UsGOgjAQ_ZVmzmBEQKQ3g2RDokIAD25ITANVSaQ1tSTrov--FQWzrtnppTPzZt5rZxrIeUEBg67rGZOlPFCMoj0RFcnPqCKM7GhFmcxYC6BiVpKdIFXGkLIoDmcrL0WXC9J1dGlQ7CdRmARpGK8xKtkd5YWLaLpcP1FdGUZHwYs6p3dcsIjCON3EvucHUYquvIVf-nqM-PYtsm98jwfLj00aT5fJ1EuDcJmgm5T8UBe_eP6ger6HvCedt0rScOHHDyLeoMSfz28NOgXqJbXI9-T0oHjN9wq7xH_63mJe1XW_kbHnQQg02ImyACxFTTWoqJrjzYXmls1A7tU0M8DqWtAtqQ8yg4xdVdmRsE_Oq65S8Hq3B7wlh5Py6mNBJH2Mvo8KygoqPF4zCXhkWk7bBXADX8q3xwPHGjnOxHBGE8uybA3OgMcDy3YNa-Ia9sixh_bkqsF3yzscuKZpGGPTGZuuMtPVgBal5GJx39B2Ua8_csfN-Q?type=png)

As detailed by the diagram:

https://mermaid.live/edit#pako:eNp9UsGOgjAQ_ZVmzmBEQKQ3g2RDokIAD25ITANVSaQ1tSTrov--FQWzrtnppTPzZt5rZxrIeUEBg67rGZOlPFCMoj0RFcnPqCKM7GhFmcxYC6BiVpKdIFXGkLIoDmcrL0WXC9J1dGlQ7CdRmARpGK8xKtkd5YWLaLpcP1FdGUZHwYs6p3dcsIjCON3EvucHUYquvIVf-nqM-PYtsm98jwfLj00aT5fJ1EuDcJmgm5T8UBe_eP6ger6HvCedt0rScOHHDyLeoMSfz28NOgXqJbXI9-T0oHjN9wq7xH_63mJe1XW_kbHnQQg02ImyACxFTTWoqJrjzYXmls1A7tU0M8DqWtAtqQ8yg4xdVdmRsE_Oq65S8Hq3B7wlh5Py6mNBJH2Mvo8KygoqPF4zCXhkWk7bBXADX8q3xwPHGjnOxHBGE8uybA3OgMcDy3YNa-Ia9sixh_bkqsF3yzscuKZpGGPTGZuuMtPVgBal5GJx39B2Ua8_csfN-Q

* One company produce zero to many products sold by the pharmacy. One product can have one to many batch stored in respository. Each record of respository is related to only one product with one unique batch code.
* One company can have zero to many importing receipt, and one importing receipt can belong to only one company. One importing receipt include one to many importing transactions, each importing transaction is related to one product. One product can appeared in many transactions.
* One customer can purchase zero to many selling receipts. One selling receipt includes one to many selling transactions, each of which related to one product. One product can be bought many times or have not been purchased any time as it is new, thus can be related to zero to many transactions.

## Optimizations

Per the typical queries in `queries.sql`, it is common for users of the database to access all submissions submitted by any particular student. For that reason, indexes are created on the `first_name`, `last_name`, and `github_username` columns to speed the identification of students by those columns.

Similarly, it is also common practice for a user of the database to concerned with viewing all students who submitted work to a particular problem. As such, an index is created on the `name` column in the `problems` table to speed the identification of problems by name.

## Limitations



