/* Tabel Owners */
CREATE TABLE OWNERS 
(   Owner_ID NUMBER(4),
    Name VARCHAR2(25),
    Phone VARCHAR2(15),
    Address VARCHAR2(200)
);

/* Tabel Customers */
CREATE TABLE CUSTOMERS
(   Customer_ID NUMBER(5),
    Customer_Name VARCHAR2(25),
    Customer_Phone VARCHAR2(15),
    Customer_Address VARCHAR2(200),
    Customer_Email VARCHAR2(50)
);

/* Tabel Products */
CREATE TABLE PRODUCTS
(   Product_ID NUMBER(5),
    Owner_ID NUMBER(5),
    Item_Name VARCHAR2(25),
    Item_Type VARCHAR2(25),
    Available_Service NUMBER(3)
);

/* Tabel Prices */
CREATE TABLE PRICES
(   Start_Date DATE DEFAULT SYSDATE,
    End_Date DATE,
    Price NUMBER(10,2),
    Product_ID NUMBER(5)
);

/* Tabel Order */
CREATE TABLE ORDERS
(   Order_ID NUMBER(5),
    Customer_ID NUMBER(5),
    Order_Date TIMESTAMP DEFAULT SYSTIMESTAMP,
    Order_Type VARCHAR2(25),
    Order_Status VARCHAR2(25)
);

/* Tabel Payment */
CREATE TABLE PAYMENTS
(   payment_id NUMBER(5),
    payment_date DATE DEFAULT SYSDATE,
    payment_method_id NUMBER(2),
    amount NUMBER(10,2),
    order_id NUMBER(5),
    payment_status VARCHAR2(10)
);

/* Tabel Payment_Method */
CREATE TABLE PAYMENT_METHODS
(   payment_method_id NUMBER(2),
    method_name VARCHAR2(25),
    credit_card_number VARCHAR2(16),
    description VARCHAR2(1000)
);

/* Tabel Order_Item */
CREATE TABLE ORDER_ITEMS
(   Order_Item_ID NUMBER(5),
    Order_ID NUMBER(5),
    Product_ID NUMBER(5),
    Quantity NUMBER(3)
);

/* Tabel Special_Product */
CREATE TABLE SPECIAL_PRODUCTS 
(   Special_Product_ID NUMBER(5),
    Product_ID        NUMBER(5),
    Order_Date        DATE DEFAULT SYSDATE,
    Customer_ID       NUMBER(5)
);

/* Tabel Shipment */
CREATE TABLE SHIPMENTS 
(   Shipment_ID    NUMBER(2),
    Order_ID       NUMBER(5),
    Shipment_Type  VARCHAR2(20)
);

/* Tabel Report */
CREATE TABLE REPORTS 
(   Report_ID      NUMBER(5),
    Order_ID       NUMBER(5),
    Product_ID     NUMBER(5),
    Customer_ID    NUMBER(5),
    Report_Date    DATE DEFAULT SYSDATE,
    Payment_ID     NUMBER(5)
);

/* Constraint OWNERS */
ALTER TABLE OWNERS
ADD CONSTRAINT owners_ow_id_pk PRIMARY KEY (Owner_ID);

ALTER TABLE OWNERS
MODIFY(Name CONSTRAINT owners_nm_nn NOT NULL, 
       Phone CONSTRAINT owners_phn_nn NOT NULL, 
       Address CONSTRAINT owners_addrss_nn NOT NULL);

/* Constraint CUSTOMERS */
ALTER TABLE CUSTOMERS
ADD CONSTRAINT customers_cstmr_id_pk PRIMARY KEY (Customer_ID);

ALTER TABLE CUSTOMERS
ADD CONSTRAINT customers_phone_email_uk UNIQUE (customer_email, customer_phone);

/* Constraint PRODUCTS */
ALTER TABLE PRODUCTS
ADD CONSTRAINT pr_product_id_pk PRIMARY KEY (Product_ID);

ALTER TABLE PRODUCTS
ADD CONSTRAINT pr_ow_id_fk FOREIGN KEY(Owner_ID) 
REFERENCES OWNERS(Owner_ID) ON DELETE CASCADE;

ALTER TABLE PRODUCTS
MODIFY (owner_id CONSTRAINT pr_owner_id_nn NOT NULL,
        item_name CONSTRAINT pr_item_name_nn NOT NULL,
        item_type CONSTRAINT pr_item_typee_nn NOT NULL,
        available_service CONSTRAINT pr_avb_service_nn NOT NULL);

ALTER TABLE PRODUCTS
ADD CONSTRAINT item_type_chk CHECK (item_type IN ('Regular', 'Special'));

ALTER TABLE PRODUCTS
ADD CONSTRAINT pr_itm_nm_uk UNIQUE (Item_Name);

/* Constraint PRICES */
ALTER TABLE PRICES
ADD CONSTRAINT price_start_date_pk PRIMARY KEY (Start_Date);

ALTER TABLE PRICES
ADD CONSTRAINT price_product_id_fk FOREIGN KEY(Product_ID) 
REFERENCES PRODUCTS(Product_ID) ON DELETE CASCADE;

ALTER TABLE PRICES
MODIFY (price CONSTRAINT price_price_nn NOT NULL,
        product_id CONSTRAINT price_product_id_nn NOT NULL);

ALTER TABLE PRICES
ADD CONSTRAINT end_date_chk CHECK (End_Date > Start_Date);

/* Constraint ORDERS */
ALTER TABLE orders
ADD CONSTRAINT orders_id_pk PRIMARY KEY (order_id);

ALTER TABLE orders
ADD CONSTRAINT orders_cust_id_fk FOREIGN KEY (customer_id) 
REFERENCES customers (customer_id) ON DELETE CASCADE;

ALTER TABLE orders
MODIFY (customer_id CONSTRAINT orders_cust_id_nn NOT NULL,
        order_date CONSTRAINT orders_date_nn NOT NULL,
        order_type CONSTRAINT orders_type_nn NOT NULL,
        order_status CONSTRAINT orders_status_nn NOT NULL);

ALTER TABLE orders
ADD CONSTRAINT orders_type_chk CHECK (order_type IN ('Online', 'In-Person'));

ALTER TABLE orders
ADD CONSTRAINT orders_status_chk CHECK (order_status IN ('Deliverred', 'Accepted', 'Cancelled'));

/* Constraint PAYMENT */
ALTER TABLE payments
ADD CONSTRAINT payments_id_pk PRIMARY KEY (payment_id);

ALTER TABLE payments
ADD CONSTRAINT payments_method_id_fk FOREIGN KEY (payment_method_id)
REFERENCES payment_methods (payment_method_id) ON DELETE CASCADE;

ALTER TABLE payments
ADD CONSTRAINT payments_order_id_fk FOREIGN KEY (order_id)
REFERENCES orders (order_id) ON DELETE CASCADE;

ALTER TABLE payments
MODIFY (payment_date CONSTRAINT payments_date_nn NOT NULL,
        payment_method_id CONSTRAINT payments_method_id_nn NOT NULL,
        amount CONSTRAINT payments_amount_nn NOT NULL,
        order_id CONSTRAINT payments_order_id_nn NOT NULL,
        payment_status CONSTRAINT payments_status_nn NOT NULL);

ALTER TABLE payments
ADD CONSTRAINT payments_status_chk CHECK (payment_status IN ('Completed', 'Failed', 'Pending'));

/* Constraint PAYMENT_METHODS */
ALTER TABLE payment_methods
ADD CONSTRAINT pay_methods_id_pk PRIMARY KEY (payment_method_id);

ALTER TABLE payment_methods
MODIFY (method_name CONSTRAINT pay_method_name_nn NOT NULL);

ALTER TABLE payment_methods
ADD CONSTRAINT pay_methods_ccn_uk UNIQUE (credit_card_number); 

/* Constraint ORDER_ITEMS */
ALTER TABLE ORDER_ITEMS
ADD CONSTRAINT order_item_id_pk PRIMARY KEY (Order_Item_ID);

ALTER TABLE ORDER_ITEMS
ADD CONSTRAINT order_id_fk FOREIGN KEY(Order_ID) 
REFERENCES ORDERS(Order_ID) ON DELETE CASCADE;

ALTER TABLE ORDER_ITEMS
MODIFY (order_id CONSTRAINT oi_order_id_nn NOT NULL,
        product_id CONSTRAINT oi_product_id_nn NOT NULL,
        quantity CONSTRAINT oi_quantity_nn NOT NULL);

/* Constraint SPECIAL_PRODUCTS */
ALTER TABLE SPECIAL_PRODUCTS
ADD CONSTRAINT special_products_pk PRIMARY KEY (Special_Product_ID)

ALTER TABLE SPECIAL_PRODUCTS
ADD CONSTRAINT sp_product_id_fk FOREIGN KEY (Product_ID) REFERENCES PRODUCTS (Product_ID) ON DELETE CASCADE;

ALTER TABLE SPECIAL_PRODUCTS
ADD CONSTRAINT sp_customer_id_fk FOREIGN KEY (Customer_ID) REFERENCES CUSTOMERS (Customer_ID) ON DELETE CASCADE;

ALTER TABLE SPECIAL_PRODUCTS
MODIFY (Product_ID CONSTRAINT sp_pi_nn NOT NULL);

ALTER TABLE SPECIAL_PRODUCTS
MODIFY (Order_Date CONSTRAINT sp_oi_nn NOT NULL);

ALTER TABLE SPECIAL_PRODUCTS
MODIFY (Customer_id CONSTRAINT sp_ci_nn NOT NULL);

/* Constraint SHIPMENTS */
ALTER TABLE SHIPMENTS
ADD CONSTRAINT shipment_id_pk PRIMARY KEY (Shipment_ID);

ALTER TABLE SHIPMENTS
ADD CONSTRAINT sp_order_id_fk FOREIGN KEY (Order_ID) REFERENCES ORDERS (Order_ID) ON DELETE CASCADE;

ALTER TABLE SHIPMENTS
ADD CONSTRAINT chk_shipment_type CHECK (Shipment_Type IN ('Courier', 'In-House'));

ALTER TABLE SHIPMENTS
MODIFY (Shipment_ID CONSTRAINT s_si_nn NOT NULL);

ALTER TABLE SHIPMENTS
MODIFY (Order_ID CONSTRAINT s_oi_nn NOT NULL);

ALTER TABLE SHIPMENTS
MODIFY (Shipment_Type CONSTRAINT s_st_nn NOT NULL);

/* Constraint REPORTS */
ALTER TABLE REPORTS
ADD CONSTRAINT reports_id_pk PRIMARY KEY (Report_ID);

ALTER TABLE REPORTS
ADD CONSTRAINT rp_order_id_fk FOREIGN KEY (Order_ID) REFERENCES ORDERS(Order_ID) ON DELETE CASCADE;

ALTER TABLE REPORTS
ADD CONSTRAINT rp_product_id_fk FOREIGN KEY (Product_ID) REFERENCES PRODUCTS (Product_ID) ON DELETE CASCADE;

ALTER TABLE REPORTS
ADD CONSTRAINT rp_customer_id_fk FOREIGN KEY (Customer_ID) REFERENCES CUSTOMERS (Customer_ID) ON DELETE CASCADE;

ALTER TABLE REPORTS
ADD CONSTRAINT rp_payment_id_fk FOREIGN KEY (Payment_id) REFERENCES PAYMENTS(Payment_id) ON DELETE CASCADE;

ALTER TABLE REPORTS
MODIFY (Order_ID CONSTRAINT rp_oi_nn NOT NULL);

ALTER TABLE REPORTS
MODIFY (Product_ID CONSTRAINT rp_pi_nn NOT NULL);

ALTER TABLE REPORTS
MODIFY (Customer_ID CONSTRAINT rp_ci_nn NOT NULL);

ALTER TABLE REPORTS
MODIFY (Report_Date CONSTRAINT rp_rp_nn NOT NULL);

ALTER TABLE REPORTS
MODIFY (Payment_id CONSTRAINT rp_pyi_nn NOT NULL);

/* Create View*/
CREATE OR REPLACE VIEW view_menus AS
SELECT 
    P.Product_ID AS "ID",
    P.Item_Name AS "Product",
    PR.Price AS "Price",
    P.Available_Service AS "Available Service"
FROM 
    PRODUCTS P
JOIN 
    PRICES PR ON P.Product_ID = PR.Product_ID;

CREATE OR REPLACE VIEW view_orders AS
SELECT 
    O.Order_ID AS "ID",
    O.Order_Type AS "Type",
    TO_CHAR(O.Order_Date, 'YYYY-MM-DD') AS "Order Date",
    O.Customer_ID AS "Customer ID",
    P.Item_Name AS "Item Name",
    PR.Price AS "Price",
    OI.Quantity AS "Quantity",
    PAY.amount AS "Total"
FROM 
    ORDERS O
JOIN 
    ORDER_ITEMS OI ON O.Order_ID = OI.Order_ID
JOIN 
    PRODUCTS P ON OI.Product_ID = P.Product_ID
JOIN 
    PRICES PR ON P.Product_ID = PR.Product_ID
JOIN 
    PAYMENTS PAY ON O.Order_ID = PAY.order_id;

CREATE OR REPLACE VIEW view_payments AS
SELECT 
    PAY.payment_id AS "Payment ID",
    TO_CHAR(PAY.Payment_Date, 'YYYY-MM-DD') AS "Date",
    PAY.order_id AS "Order ID",
    O.Customer_id,
    PM.method_name AS "Method",
    PM.credit_card_number AS "Credit Card Number",
    PAY.payment_status AS "Payment Status"
FROM 
    PAYMENT_METHODS PM
JOIN 
    PAYMENTS PAY ON PM.payment_method_id = PAY.payment_method_id
JOIN
    ORDERS O ON PAY.Order_id = O.Order_id
JOIN 
    customers C ON O.Customer_ID = C.Customer_ID;

CREATE VIEW view_special_orders AS
SELECT 
    SP.Special_Product_ID AS "ID",
    OI.Order_ID AS "Order ID",
    P.Item_Name AS "Item Name",
    OI.Quantity AS "Quantity",
TO_CHAR(SP.Order_Date, 'YYYY-MM-DD') AS "Date"
FROM 
    SPECIAL_PRODUCTS SP
JOIN 
    ORDER_ITEMS OI ON SP.Product_ID = OI.Product_ID
JOIN 
    PRODUCTS P ON OI.Product_ID = P.Product_ID;

CREATE OR REPLACE VIEW view_reports
AS SELECT report_id, report_date, order_id, customer_id
FROM reports;

CREATE OR REPLACE VIEW view_sales_per_day AS
SELECT 
    TO_CHAR(payment_date, 'YYYY-MM-DD') AS sale_date, 
    COUNT(payment_id) AS total_transactions, 
    SUM(amount) AS total_sales
FROM 
    payments 
GROUP BY TO_CHAR(payment_date, 'YYYY-MM-DD');

/* Create Sequence*/
CREATE SEQUENCE owner_id_sq
   INCREMENT BY 1
   START WITH 1000
   MAXVALUE 9999
   NOCYCLE
   NOCACHE;

CREATE SEQUENCE customer_id_sq
   INCREMENT BY 1
   START WITH 1
   MAXVALUE 99999
   NOCYCLE
   NOCACHE;

CREATE SEQUENCE order_id_sq
  INCREMENT BY 1
  START WITH 10
  MAXVALUE 99999
  CYCLE
  NOCACHE;

CREATE SEQUENCE order_item_id_sq
  INCREMENT BY 1
  START WITH 100
  MAXVALUE 99999
  CYCLE
  NOCACHE;

CREATE SEQUENCE product_id_sq
  INCREMENT BY 1
  START WITH 10
  MAXVALUE 99
  NOCYCLE
  NOCACHE;

CREATE SEQUENCE payment_id_sq
  INCREMENT BY 1
  START WITH 1000
  MAXVALUE 9999
  CYCLE
  NOCACHE;

CREATE SEQUENCE special_product_id_sq
INCREMENT BY 1
START WITH 1
MAXVALUE 99999
NOCYCLE
NOCACHE;

CREATE SEQUENCE shipment_id_seq
INCREMENT BY 1
START WITH 1
MAXVALUE 99
NOCYCLE
NOCACHE;

CREATE SEQUENCE report_id_seq
INCREMENT BY 1
START WITH 10000
MAXVALUE 99999
NOCACHE
NOCYCLE;


/* TRIGGER for Amount in Payment Table */

create or replace TRIGGER trg_calculate_payment_amount
BEFORE INSERT ON PAYMENTS
FOR EACH ROW
DECLARE
    v_price NUMBER(10,2);
    v_quantity NUMBER(3);
BEGIN
    -- Get the quantity from ORDER_ITEMS
    SELECT oi.Quantity
    INTO v_quantity
    FROM ORDER_ITEMS oi
    WHERE oi.Order_ID = :NEW.order_id;

    -- Get the price from PRICES
    SELECT p.Price
    INTO v_price
    FROM PRICES p 
    JOIN ORDER_ITEMS oi ON p.Product_ID = oi.Product_ID
    WHERE oi.Order_ID = :NEW.order_id
    AND p.Start_Date <= SYSDATE
    AND (p.End_Date IS NULL OR p.End_Date >= SYSDATE)
    AND ROWNUM = 1; -- Assuming there's one price for the product

    -- Calculate and set the amount
    :NEW.amount := v_price * v_quantity;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        :NEW.amount := 0; -- Handle case where no price or quantity is found
END;

/* Insert  data */
INSERT INTO OWNERS (Owner_ID, Name, Phone, Address)
VALUES (owner_id_sq.NEXTVAL, 'Siti Makmuria', '082187659870', 'Jalan Mahang 3, Pandau Jaya, Kec. Siak Hulu, Kab.Kampar, Riau');

INSERT INTO CUSTOMERS (Customer_ID)
VALUES (customer_id_sq.NEXTVAL);

INSERT INTO CUSTOMERS (Customer_ID, Customer_Name, Customer_Phone, Customer_Address, Customer_Email)
VALUES (customer_id_sq.NEXTVAL, 'Rahmad Ramadhan', '081312345678', 'Jl.Mahang', 'Rrama@gmail.com' );

INSERT INTO CUSTOMERS (Customer_ID, Customer_Name, Customer_Phone, Customer_Address, Customer_Email)
VALUES (customer_id_sq.NEXTVAL, 'Lisana Sidka', '081323456781', 'Jl.Tebing', 'Lsidk@gmail.com' );

INSERT INTO CUSTOMERS (Customer_ID)
VALUES (customer_id_sq.NEXTVAL);

INSERT INTO CUSTOMERS (Customer_ID)
VALUES (customer_id_sq.NEXTVAL);

INSERT INTO CUSTOMERS (Customer_ID, Customer_Name, Customer_Phone, Customer_Address, Customer_Email)
VALUES (customer_id_sq.NEXTVAL, 'Fattahul Fahmi', '081334567812', 'Jl.Ujung', 'Ffahm@gmail.com' );

INSERT INTO CUSTOMERS (Customer_ID, Customer_Name, Customer_Phone, Customer_Address, Customer_Email)
VALUES (customer_id_sq.NEXTVAL, 'Amna Ariria', '081345678123', 'Jl.Siak', 'Aarir@gmail.com' );

INSERT INTO PRODUCTS (Product_ID, Owner_ID, Item_Name, Item_Type, Available_Service)
VALUES (product_id_sq.NEXTVAL, 1000, 'Nasi Uduk', 'Special', 35);

INSERT INTO PRODUCTS (Product_ID, Owner_ID, Item_Name, Item_Type, Available_Service)
VALUES (product_id_sq.NEXTVAL, 1000, 'Mie Ayam', 'Regular', 35);

INSERT INTO PRODUCTS (Product_ID, Owner_ID, Item_Name, Item_Type, Available_Service)
VALUES (product_id_sq.NEXTVAL, 1000, 'Seblak', 'Regular', 35);

INSERT INTO PRODUCTS (Product_ID, Owner_ID, Item_Name, Item_Type, Available_Service)
VALUES (product_id_sq.NEXTVAL, 1000, 'Lontong Sayur', 'Regular', 35);

INSERT INTO PRODUCTS (Product_ID, Owner_ID, Item_Name, Item_Type, Available_Service)
VALUES (product_id_sq.NEXTVAL, 1000, 'Somai', 'Regular', 35);

INSERT INTO PRODUCTS (Product_ID, Owner_ID, Item_Name, Item_Type, Available_Service)
VALUES (product_id_sq.NEXTVAL, 1000, 'Cilok', 'Regular', 35);

SELECT * FROM owners;

INSERT INTO PRICES (Start_Date, End_Date, Price, Product_ID)
VALUES (SYSDATE, NULL, 10000, 12);

INSERT INTO PRICES (Start_Date, End_Date, Price, Product_ID)
VALUES (SYSDATE, NULL, 10000, 14);

INSERT INTO PRICES (Start_Date, End_Date, Price, Product_ID)
VALUES (SYSDATE, NULL, 15000, 15);

INSERT INTO PRICES (Start_Date, End_Date, Price, Product_ID)
VALUES (SYSDATE, NULL, 10000, 16);

INSERT INTO PRICES (Start_Date, End_Date, Price, Product_ID)
VALUES (SYSDATE, NULL, 5000, 17);

INSERT INTO PRICES (Start_Date, End_Date, Price, Product_ID)
VALUES (SYSDATE, NULL, 5000, 13);

SELECT * FROM products;

INSERT INTO ORDERS (Order_ID, Customer_ID, Order_Date, Order_Type, Order_Status)
VALUES (order_id_sq.NEXTVAL, 1, SYSTIMESTAMP, 'Online', 'Deliverred');

INSERT INTO ORDERS (Order_ID, Customer_ID, Order_Date, Order_Type, Order_Status)
VALUES (order_id_sq.NEXTVAL, 2, SYSTIMESTAMP, 'In-Person', 'Accepted');

INSERT INTO ORDERS (Order_ID, Customer_ID, Order_Date, Order_Type, Order_Status)
VALUES (order_id_sq.NEXTVAL, 3, SYSTIMESTAMP, 'Online', 'Cancelled');

INSERT INTO ORDERS (Order_ID, Customer_ID, Order_Date, Order_Type, Order_Status)
VALUES (order_id_sq.NEXTVAL, 4, SYSTIMESTAMP, 'In-Person', 'Deliverred');

INSERT INTO ORDERS (Order_ID, Customer_ID, Order_Date, Order_Type, Order_Status)
VALUES (order_id_sq.NEXTVAL, 5, SYSTIMESTAMP, 'Online', 'Accepted');

INSERT INTO ORDERS (Order_ID, Customer_ID, Order_Date, Order_Type, Order_Status)
VALUES (order_id_sq.NEXTVAL, 6, SYSTIMESTAMP, 'In-Person', 'Cancelled');

INSERT INTO ORDERS (Order_ID, Customer_ID, Order_Date, Order_Type, Order_Status)
VALUES (order_id_sq.NEXTVAL, 7, SYSTIMESTAMP, 'Online', 'Deliverred');

SELECT * FROM customers;

SELECT * FROM orders;

INSERT INTO PAYMENTS (payment_id, payment_method_id, order_id, payment_status) 
VALUES (payment_id_sq.NEXTVAL, 2, 12, 'Completed');

INSERT INTO PAYMENTS (payment_id, payment_method_id, order_id, payment_status) 
VALUES (payment_id_sq.NEXTVAL, 1, 13, 'Completed');

INSERT INTO PAYMENTS (payment_id, payment_method_id, order_id, payment_status) 
VALUES (payment_id_sq.NEXTVAL, 3, 14, 'Completed');

INSERT INTO PAYMENT_METHODS (payment_method_id, method_name, credit_card_number, description)
VALUES (1, 'Cash', 'N/A', 'Pembayaran dilakukan secara tunai');

INSERT INTO PAYMENT_METHODS (payment_method_id, method_name, credit_card_number, description)
VALUES (2, 'Bank Transfer', '1234567890', 'Pembayaran dilakukan melalui transfer bank');

INSERT INTO PAYMENT_METHODS (payment_method_id, method_name, credit_card_number, description)
VALUES (3, 'E-Wallet', '4567890123', 'Pembayaran melalui E-Wallet seperti GoPay, OVO, dll.');

INSERT INTO ORDER_ITEMS (Order_item_ID,Order_ID, Product_ID, Quantity)
VALUES (order_item_id_sq.NEXTVAL, 12, 12, 23);

INSERT INTO ORDER_ITEMS (Order_item_ID,Order_ID, Product_ID, Quantity)
VALUES (order_item_id_sq.NEXTVAL, 12, 12, 23);

INSERT INTO ORDER_ITEMS (Order_item_ID,Order_ID, Product_ID, Quantity)
VALUES (order_item_id_sq.NEXTVAL, 13, 13, 15);

INSERT INTO ORDER_ITEMS (Order_item_ID,Order_ID, Product_ID, Quantity)
VALUES (order_item_id_sq.NEXTVAL, 14, 14, 8);

INSERT INTO ORDER_ITEMS (Order_item_ID,Order_ID, Product_ID, Quantity)
VALUES (order_item_id_sq.NEXTVAL, 15, 15, 8);

INSERT INTO ORDER_ITEMS (Order_item_ID,Order_ID, Product_ID, Quantity)
VALUES (order_item_id_sq.NEXTVAL, 16, 16, 10);

INSERT INTO SPECIAL_PRODUCTS (Special_Product_ID, Product_ID, Order_Date, Customer_ID) 
VALUES (special_product_id_sq.NEXTVAL, 12, SYSDATE, 1);

INSERT INTO SPECIAL_PRODUCTS (Special_Product_ID, Product_ID, Order_Date, Customer_ID) 
VALUES (special_product_id_sq.NEXTVAL, 14, SYSDATE, 2);

INSERT INTO SPECIAL_PRODUCTS (Special_Product_ID, Product_ID, Order_Date, Customer_ID) 
VALUES (special_product_id_sq.NEXTVAL, 15, SYSDATE, 3);

INSERT INTO SPECIAL_PRODUCTS (Special_Product_ID, Product_ID, Order_Date, Customer_ID) 
VALUES (special_product_id_sq.NEXTVAL, 16, SYSDATE, 4);

INSERT INTO SHIPMENTS (Shipment_ID, Order_ID, Shipment_Type)
VALUES (shipment_id_seq.NEXTVAL, 12, 'In-House');

INSERT INTO SHIPMENTS (Shipment_ID, Order_ID, Shipment_Type)
VALUES (shipment_id_seq.NEXTVAL, 13, 'In-House');

INSERT INTO SHIPMENTS (Shipment_ID, Order_ID, Shipment_Type)
VALUES (shipment_id_seq.NEXTVAL, 14, 'In-House');

INSERT INTO REPORTS (Report_ID, Order_ID, Product_ID, Customer_ID, Report_Date, Payment_ID)
VALUES (report_id_seq.NEXTVAL, 12, 12, 1, SYSDATE, 1001)

/* Create Index */

CREATE INDEX idx_orders_customer_id ON ORDERS (Customer_ID);

CREATE INDEX idx_prices_product_id ON PRICES (Product_ID);

CREATE INDEX idx_pr_id_it_nm ON PRODUCTS (Product_ID, Item_Name);

CREATE INDEX idx_order_items_order_id ON ORDER_ITEMS (Order_ID);

CREATE INDEX idx_order_items_product_id ON ORDER_ITEMS (Product_ID);

CREATE INDEX idx_payments_method_id ON PAYMENTS (Payment_Method_ID);

CREATE INDEX idx_payments_order_id ON PAYMENTS (Order_ID);

CREATE INDEX idx_rp_date ON REPORTS(Report_Date);

CREATE INDEX idx_sp_product_id ON SPECIAL_PRODUCTS (Product_ID);

/* Create Synonim */
CREATE PUBLIC SYNONYM kel2_vm
FOR View_Menus;

CREATE PUBLIC SYNONYM kel2_vo
FOR View_Orders;

CREATE SYNONYM kel2_vp
FOR View_Payments;

CREATE SYNONYM kel_2vr
FOR View_REPORTS;

CREATE SYNONYM kel2_vspd
FOR View_Sales_Per_Day;

CREATE PUBLIC SYNONYM kel2_vso
FOR View_Special_Orders;


GRANT ACCES FOR CREATE SYNONYM

SQL> connect system/system@XE (username database)
SQL> GRANT CREATE PUBLIC SYNONYM TO KEL2(username apex);