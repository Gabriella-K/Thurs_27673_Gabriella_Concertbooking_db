-- 1. CONCERT TABLE (Parent)
CREATE TABLE concert (
    concert_id NUMBER PRIMARY KEY,
    concert_name VARCHAR2(200) NOT NULL,
    artist_name VARCHAR2(150) NOT NULL,
    venue VARCHAR2(150) NOT NULL,
    concert_date DATE NOT NULL,
    concert_time VARCHAR2(10),
    total_seats NUMBER NOT NULL CHECK (total_seats > 0),
    base_price NUMBER(10,2) NOT NULL CHECK (base_price >= 0),
    genre VARCHAR2(50),
    city VARCHAR2(50) DEFAULT 'Kigali',
    created_date DATE DEFAULT SYSDATE,
    CONSTRAINT chk_rwanda_city CHECK (city IN ('Kigali', 'Huye', 'Musanze', 'Rubavu', 'Nyagatare'))
);


-- 2. CUSTOMER TABLE
CREATE TABLE customer (
    customer_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(100) NOT NULL,
    last_name VARCHAR2(100) NOT NULL,
    email VARCHAR2(150) UNIQUE NOT NULL,
    phone VARCHAR2(20) NOT NULL,
    district VARCHAR2(50),
    province VARCHAR2(50),
    registration_date DATE DEFAULT SYSDATE,
    loyalty_points NUMBER DEFAULT 0,
    CONSTRAINT chk_rwanda_province CHECK (province IN ('Kigali City', 'Eastern', 'Western', 'Northern', 'Southern'))
);


-- 3. RWANDA_HOLIDAY TABLE
CREATE TABLE rwanda_holiday (
    holiday_id NUMBER PRIMARY KEY,
    holiday_name VARCHAR2(100) NOT NULL,
    holiday_date DATE NOT NULL,
    holiday_type VARCHAR2(30) DEFAULT 'Public'
);


-- 4. TICKET TABLE
CREATE TABLE ticket (
    ticket_id NUMBER PRIMARY KEY,
    concert_id NUMBER NOT NULL,
    seat_number VARCHAR2(10) NOT NULL,
    seat_type VARCHAR2(30) DEFAULT 'Standard',
    current_price NUMBER(10,2) NOT NULL,
    status VARCHAR2(20) DEFAULT 'available' CHECK (status IN ('available', 'booked', 'reserved')),
    discount_applied VARCHAR2(3) DEFAULT 'No',
    created_date DATE DEFAULT SYSDATE,
    last_updated DATE DEFAULT SYSDATE,
    CONSTRAINT fk_ticket_concert FOREIGN KEY (concert_id) REFERENCES concert(concert_id),
    CONSTRAINT chk_seat_type CHECK (seat_type IN ('VIP', 'Premium', 'Standard', 'Economy'))
);


-- 5. BOOKING TABLE
CREATE TABLE booking (
    booking_id NUMBER PRIMARY KEY,
    ticket_id NUMBER NOT NULL,
    customer_id NUMBER NOT NULL,
    booking_date DATE DEFAULT SYSDATE,
    booking_time TIMESTAMP DEFAULT SYSTIMESTAMP,
    final_price NUMBER(10,2) NOT NULL,
    payment_method VARCHAR2(30) DEFAULT 'Momo',
    booking_status VARCHAR2(20) DEFAULT 'confirmed' CHECK (booking_status IN ('confirmed', 'cancelled', 'pending')),
    CONSTRAINT fk_booking_ticket FOREIGN KEY (ticket_id) REFERENCES ticket(ticket_id),
    CONSTRAINT fk_booking_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);


-- 6. PRICING_LOG TABLE
CREATE TABLE pricing_log (
    log_id NUMBER PRIMARY KEY,
    ticket_id NUMBER NOT NULL,
    old_price NUMBER(10,2),
    new_price NUMBER(10,2),
    change_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    change_reason VARCHAR2(200),
    changed_by VARCHAR2(100) DEFAULT 'System',
    CONSTRAINT fk_log_ticket FOREIGN KEY (ticket_id) REFERENCES ticket(ticket_id)
);


-- 7. AUDIT_LOG TABLE
CREATE TABLE audit_log (
    audit_id NUMBER PRIMARY KEY,
    user_action VARCHAR2(50) NOT NULL,
    table_name VARCHAR2(50) NOT NULL,
    record_id NUMBER,
    action_timestamp TIMESTAMP DEFAULT SYSTIMESTAMP,
    user_id VARCHAR2(100),
    ip_address VARCHAR2(50),
    details VARCHAR2(500)
);


-- Create indexes
CREATE INDEX idx_ticket_concert ON ticket(concert_id);
CREATE INDEX idx_ticket_status ON ticket(status);
CREATE INDEX idx_booking_customer ON booking(customer_id);
CREATE INDEX idx_booking_date ON booking(booking_date);
CREATE INDEX idx_concert_date ON concert(concert_date);


BEGIN
    CREATE SEQUENCE seq_concert_id START WITH 1 INCREMENT BY 1;
    CREATE SEQUENCE seq_customer_id START WITH 1 INCREMENT BY 1;
    CREATE SEQUENCE seq_ticket_id START WITH 1 INCREMENT BY 1;
    CREATE SEQUENCE seq_booking_id START WITH 1 INCREMENT BY 1;
    CREATE SEQUENCE seq_log_id START WITH 1 INCREMENT BY 1;
    CREATE SEQUENCE seq_holiday_id START WITH 1 INCREMENT BY 1;
    CREATE SEQUENCE seq_audit_id START WITH 1 INCREMENT BY 1;
    
    


-- A. INSERT 15 RWANDA CONCERTS

    INSERT INTO concert VALUES (seq_concert_id.NEXTVAL, 'Kigali Jazz Festival', 'Local Jazz Band', 'Kigali Convention Centre', DATE '2025-03-15', '18:00', 1500, 25000, 'Jazz', 'Kigali', SYSDATE);
    INSERT INTO concert VALUES (seq_concert_id.NEXTVAL, 'Umuganda Community Show', 'The Ben', 'Petit Stade Remera', DATE '2025-03-20', '14:00', 5000, 10000, 'Rwandan Pop', 'Kigali', SYSDATE);
    INSERT INTO concert VALUES (seq_concert_id.NEXTVAL, 'Huye Music Fest 2025', 'Knowless Butera', 'Huye Stadium', DATE '2025-04-10', '16:00', 3000, 8000, 'Hip Hop', 'Huye', SYSDATE);
    INSERT INTO concert VALUES (seq_concert_id.NEXTVAL, 'Musanze Cultural Night', 'Traditional Dancers', 'Musanze Stadium', DATE '2025-04-25', '15:00', 2000, 5000, 'Traditional', 'Musanze', SYSDATE);
    INSERT INTO concert VALUES (seq_concert_id.NEXTVAL, 'Lake Kivu Sunset Concert', 'Rutayisire', 'Serena Hotel Rubavu', DATE '2025-05-01', '17:00', 800, 30000, 'R&B', 'Rubavu', SYSDATE);
    INSERT INTO concert VALUES (seq_concert_id.NEXTVAL, 'Kwita Izina Celebration', 'Bruce Melodie', 'Kigali Arena', DATE '2025-05-10', '19:00', 10000, 15000, 'Pop', 'Kigali', SYSDATE);
    INSERT INTO concert VALUES (seq_concert_id.NEXTVAL, 'Independence Day Concert', 'Multiple Artists', 'Amahoro Stadium', DATE '2025-07-01', '10:00', 25000, 5000, 'Various', 'Kigali', SYSDATE);
    INSERT INTO concert VALUES (seq_concert_id.NEXTVAL, 'Gospel Power Night', 'Bahati', 'Christian Life Assembly', DATE '2025-06-15', '18:00', 3000, 12000, 'Gospel', 'Kigali', SYSDATE);
    INSERT INTO concert VALUES (seq_concert_id.NEXTVAL, 'Nyagatare Agri-Show', 'Local Folk Artists', 'Nyagatare Stadium', DATE '2025-08-20', '14:00', 1500, 3000, 'Folk', 'Nyagatare', SYSDATE);
    INSERT INTO concert VALUES (seq_concert_id.NEXTVAL, 'Kigali Fashion Week Finale', 'DJ Pius', 'Kigali Marriott', DATE '2025-09-05', '20:00', 600, 50000, 'Electronic', 'Kigali', SYSDATE);
    INSERT INTO concert VALUES (seq_concert_id.NEXTVAL, 'Christmas Carols Night', 'Kigali Choir', 'Kigali Genocide Memorial', DATE '2025-12-24', '19:00', 2000, 0, 'Choral', 'Kigali', SYSDATE);
    INSERT INTO concert VALUES (seq_concert_id.NEXTVAL, 'New Years Eve Bash', 'DJ Marnaud', 'Radisson Blu', DATE '2025-12-31', '22:00', 1000, 40000, 'Club', 'Kigali', SYSDATE);
    INSERT INTO concert VALUES (seq_concert_id.NEXTVAL, 'Huye University Festival', 'Student Artists', 'UR Huye Campus', DATE '2025-10-01', '15:00', 5000, 2000, 'Youth', 'Huye', SYSDATE);
    INSERT INTO concert VALUES (seq_concert_id.NEXTVAL, 'Musanze Gorilla Festival', 'Rwandan Stars', 'Volcanoes National Park', DATE '2025-11-15', '16:00', 3000, 10000, 'Various', 'Musanze', SYSDATE);
    INSERT INTO concert VALUES (seq_concert_id.NEXTVAL, 'Rubavu Beach Festival', 'Beach DJs Collective', 'Lake Kivu Beach', DATE '2025-12-20', '12:00', 5000, 15000, 'Beach', 'Rubavu', SYSDATE);
    



-- B. INSERT 20 RWANDA CUSTOMERS

    INSERT INTO customer VALUES (seq_customer_id.NEXTVAL, 'Eric', 'Maniraho', 'eric.maniraho@gmail.com', '0788123456', 'Nyarugenge', 'Kigali City', SYSDATE, 50);
    INSERT INTO customer VALUES (seq_customer_id.NEXTVAL, 'Alice', 'Uwase', 'alice.uwase@yahoo.com', '0788234567', 'Gasabo', 'Kigali City', SYSDATE, 120);
    INSERT INTO customer VALUES (seq_customer_id.NEXTVAL, 'David', 'Habimana', 'david.habimana@outlook.com', '0788345678', 'Kicukiro', 'Kigali City', SYSDATE, 80);
    INSERT INTO customer VALUES (seq_customer_id.NEXTVAL, 'Marie', 'Mukamana', 'marie.mukamana@gmail.com', '0728456789', 'Huye', 'Southern', SYSDATE, 30);
    INSERT INTO customer VALUES (seq_customer_id.NEXTVAL, 'Jean', 'Ndagijimana', 'jean.ndagi@gmail.com', '0738567890', 'Musanze', 'Northern', SYSDATE, 200);
    INSERT INTO customer VALUES (seq_customer_id.NEXTVAL, 'Chantal', 'Ineza', 'chantal.ineza@yahoo.com', '0788678901', 'Rubavu', 'Western', SYSDATE, 90);
    INSERT INTO customer VALUES (seq_customer_id.NEXTVAL, 'Peter', 'Twahirwa', 'peter.twa@gmail.com', '0728789012', 'Nyagatare', 'Eastern', SYSDATE, 40);
    INSERT INTO customer VALUES (seq_customer_id.NEXTVAL, 'Grace', 'Umutoni', 'grace.umu@outlook.com', '0788890123', 'Gasabo', 'Kigali City', SYSDATE, 180);
    INSERT INTO customer VALUES (seq_customer_id.NEXTVAL, 'Samuel', 'Mugisha', 'samuel.mugisha@gmail.com', '0738901234', 'Nyarugenge', 'Kigali City', SYSDATE, 60);
    INSERT INTO customer VALUES (seq_customer_id.NEXTVAL, 'Sophie', 'Nyirahabimana', 'sophie.nyira@gmail.com', '0788012345', 'Kicukiro', 'Kigali City', SYSDATE, 150);
    INSERT INTO customer VALUES (seq_customer_id.NEXTVAL, 'Emmanuel', 'Niyonzima', 'emma.niyo@gmail.com', '0728123456', 'Huye', 'Southern', SYSDATE, 70);
    INSERT INTO customer VALUES (seq_customer_id.NEXTVAL, 'Annette', 'Murekatete', 'annette.mure@gmail.com', '0788234567', 'Musanze', 'Northern', SYSDATE, 110);
    INSERT INTO customer VALUES (seq_customer_id.NEXTVAL, 'Patrick', 'Rutayisire', 'patrick.ruta@yahoo.com', '0738345678', 'Rubavu', 'Western', SYSDATE, 95);
    INSERT INTO customer VALUES (seq_customer_id.NEXTVAL, 'Diane', 'Mukunzi', 'diane.muku@gmail.com', '0788456789', 'Nyagatare', 'Eastern', SYSDATE, 85);
    INSERT INTO customer VALUES (seq_customer_id.NEXTVAL, 'Robert', 'Nshuti', 'robert.nshuti@outlook.com', '0728567890', 'Gasabo', 'Kigali City', SYSDATE, 220);
    INSERT INTO customer VALUES (seq_customer_id.NEXTVAL, 'Clarisse', 'Uwamahoro', 'clarisse.uwa@gmail.com', '0788678901', 'Nyarugenge', 'Kigali City', SYSDATE, 75);
    INSERT INTO customer VALUES (seq_customer_id.NEXTVAL, 'Innocent', 'Mugabo', 'innocent.mugabo@yahoo.com', '0738789012', 'Kicukiro', 'Kigali City', SYSDATE, 130);
    INSERT INTO customer VALUES (seq_customer_id.NEXTVAL, 'Vestine', 'Mukandayisenga', 'vestine.muka@gmail.com', '0788890123', 'Huye', 'Southern', SYSDATE, 45);
    INSERT INTO customer VALUES (seq_customer_id.NEXTVAL, 'Alex', 'Nsengimana', 'alex.nsengi@outlook.com', '0728901234', 'Musanze', 'Northern', SYSDATE, 100);
    INSERT INTO customer VALUES (seq_customer_id.NEXTVAL, 'Josiane', 'Uwimana', 'josiane.uwi@gmail.com', '0788012345', 'Rubavu', 'Western', SYSDATE, 65);
    
    

-- C. INSERT 10 RWANDA HOLIDAYS

    INSERT INTO rwanda_holiday VALUES (seq_holiday_id.NEXTVAL, 'New Years Day', DATE '2025-01-01', 'Public');
    INSERT INTO rwanda_holiday VALUES (seq_holiday_id.NEXTVAL, 'Heroes Day', DATE '2025-02-01', 'Public');
    INSERT INTO rwanda_holiday VALUES (seq_holiday_id.NEXTVAL, 'Good Friday', DATE '2025-04-18', 'Public');
    INSERT INTO rwanda_holiday VALUES (seq_holiday_id.NEXTVAL, 'Easter Monday', DATE '2025-04-21', 'Public');
    INSERT INTO rwanda_holiday VALUES (seq_holiday_id.NEXTVAL, 'Labour Day', DATE '2025-05-01', 'Public');
    INSERT INTO rwanda_holiday VALUES (seq_holiday_id.NEXTVAL, 'Independence Day', DATE '2025-07-01', 'Public');
    INSERT INTO rwanda_holiday VALUES (seq_holiday_id.NEXTVAL, 'Liberation Day', DATE '2025-07-04', 'Public');
    INSERT INTO rwanda_holiday VALUES (seq_holiday_id.NEXTVAL, 'Assumption Day', DATE '2025-08-15', 'Public');
    INSERT INTO rwanda_holiday VALUES (seq_holiday_id.NEXTVAL, 'Christmas Day', DATE '2025-12-25', 'Public');
    INSERT INTO rwanda_holiday VALUES (seq_holiday_id.NEXTVAL, 'Boxing Day', DATE '2025-12-26', 'Public');
    



INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (1, 1, 'A-01', 'VIP', 62500, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (2, 1, 'A-02', 'VIP', 62500, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (3, 1, 'A-03', 'VIP', 62500, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (4, 1, 'B-01', 'Premium', 45000, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (5, 1, 'B-02', 'Premium', 45000, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (6, 1, 'B-03', 'Premium', 45000, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (7, 1, 'C-01', 'Standard', 25000, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (8, 1, 'C-02', 'Standard', 25000, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (9, 1, 'D-01', 'Economy', 17500, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (10, 1, 'D-02', 'Economy', 17500, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (11, 2, 'A-01', 'Premium', 18000, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (12, 2, 'A-02', 'Premium', 18000, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (13, 2, 'B-01', 'Standard', 10000, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (14, 2, 'B-02', 'Standard', 10000, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (15, 2, 'C-01', 'Economy', 7000, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (16, 3, 'A-01', 'Standard', 8000, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (17, 3, 'A-02', 'Standard', 8000, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (18, 3, 'A-03', 'Standard', 8000, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (19, 3, 'A-04', 'Standard', 8000, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (20, 3, 'A-05', 'Standard', 8000, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (21, 4, 'A-01', 'Economy', 3500, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (22, 4, 'A-02', 'Economy', 3500, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (23, 4, 'A-03', 'Economy', 3500, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (24, 4, 'A-04', 'Economy', 3500, 'available');
INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price, status) VALUES (25, 4, 'A-05', 'Economy', 3500, 'available');



-- 1. DYNAMIC PRICING FUNCTION

CREATE OR REPLACE FUNCTION calculate_dynamic_price(
    p_concert_id IN NUMBER,
    p_ticket_id IN NUMBER
) RETURN NUMBER 
IS
    v_base_price NUMBER;
    v_seat_type VARCHAR2(30);
    v_days_until NUMBER;
    v_concert_date DATE;
    v_sold_seats NUMBER;
    v_total_seats NUMBER;
    v_price NUMBER;
    v_occupancy_rate NUMBER;

BEGIN
    -- Get concert and ticket details
    SELECT c.base_price, t.seat_type, c.concert_date, c.total_seats
    INTO v_base_price, v_seat_type, v_concert_date, v_total_seats
    FROM concert c, ticket t
    WHERE c.concert_id = t.concert_id
    AND c.concert_id = p_concert_id
    AND t.ticket_id = p_ticket_id;
    
    -- Calculate days until concert
    v_days_until := v_concert_date - SYSDATE;
    
    -- Count sold seats for this concert
    SELECT COUNT(*) INTO v_sold_seats
    FROM ticket t
    JOIN booking b ON t.ticket_id = b.ticket_id
    WHERE t.concert_id = p_concert_id;
    
    -- Calculate occupancy rate
    v_occupancy_rate := (v_sold_seats / v_total_seats) * 100;
    
    -- Start with base price
    v_price := v_base_price;
    
    -- Apply seat type multiplier
    IF v_seat_type = 'VIP' THEN
        v_price := v_price * 2.5;
    ELSIF v_seat_type = 'Premium' THEN
        v_price := v_price * 1.8;
    ELSIF v_seat_type = 'Economy' THEN
        v_price := v_price * 0.7;
    END IF;
    
    -- Apply time-based pricing
    IF v_days_until <= 7 THEN
        v_price := v_price * 1.3; -- Last week: +30%
    ELSIF v_days_until <= 30 THEN
        v_price := v_price * 1.15; -- Last month: +15%
    END IF;
    
    -- Apply demand-based pricing
    IF v_occupancy_rate >= 80 THEN
        v_price := v_price * 1.25; -- High demand: +25%
    ELSIF v_occupancy_rate >= 50 THEN
        v_price := v_price * 1.1; -- Medium demand: +10%
    END IF;
    
    -- Round to nearest 100 RWF
    v_price := ROUND(v_price / 100) * 100;
    
    RETURN v_price;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN 15000; -- Default price
END;
/

-- 2. BOOKING ALLOWANCE FUNCTION

CREATE OR REPLACE FUNCTION check_booking_allowed RETURN VARCHAR2
IS
    v_day VARCHAR2(20);
    v_holiday_count NUMBER;
BEGIN
    -- Check day of week
    SELECT TO_CHAR(SYSDATE, 'DAY') INTO v_day FROM DUAL;
    v_day := TRIM(v_day);
    
    -- Check if today is a Rwanda holiday
    SELECT COUNT(*) INTO v_holiday_count
    FROM rwanda_holiday
    WHERE TRUNC(holiday_date) = TRUNC(SYSDATE);
    
    -- Business rule: No bookings on weekends or public holidays
    IF v_day IN ('SATURDAY', 'SUNDAY') THEN
        RETURN 'DENIED - Weekend bookings not allowed in Rwanda';
    ELSIF v_holiday_count > 0 THEN
        RETURN 'DENIED - Public holiday in Rwanda';
    ELSE
        RETURN 'ALLOWED';
    END IF;
END;
/

-- 3. LOYALTY DISCOUNT FUNCTION
CREATE OR REPLACE FUNCTION calculate_loyalty_discount(
    p_customer_id IN NUMBER,
    p_ticket_price IN NUMBER
) RETURN NUMBER
IS
    v_loyalty_points NUMBER;
    v_discount_percent NUMBER;
    v_discount_amount NUMBER;
BEGIN
    -- Get customer loyalty points
    SELECT loyalty_points INTO v_loyalty_points
    FROM customer
    WHERE customer_id = p_customer_id;
    
    -- Determine discount percentage
    IF v_loyalty_points >= 200 THEN
        v_discount_percent := 0.15; -- 15% discount
    ELSIF v_loyalty_points >= 100 THEN
        v_discount_percent := 0.10; -- 10% discount
    ELSIF v_loyalty_points >= 50 THEN
        v_discount_percent := 0.05; -- 5% discount
    ELSE
        v_discount_percent := 0; -- No discount
    END IF;
    
    v_discount_amount := p_ticket_price * v_discount_percent;
    
    -- Cap discount at 5000 RWF
    IF v_discount_amount > 5000 THEN
        v_discount_amount := 5000;
    END IF;
    
    RETURN v_discount_amount;
END;
/

-- 4. CONCERT POPULARITY FUNCTION
CREATE OR REPLACE FUNCTION get_concert_popularity(
    p_concert_id IN NUMBER
) RETURN VARCHAR2
IS
    v_tickets_sold NUMBER;
    v_total_seats NUMBER;
    v_occupancy_rate NUMBER;
BEGIN
    -- Count tickets sold for this concert
    SELECT COUNT(*) INTO v_tickets_sold
    FROM booking b
    JOIN ticket t ON b.ticket_id = t.ticket_id
    WHERE t.concert_id = p_concert_id;
    
    -- Get total seats
    SELECT total_seats INTO v_total_seats
    FROM concert
    WHERE concert_id = p_concert_id;
    
    -- Calculate occupancy rate
    IF v_total_seats > 0 THEN
        v_occupancy_rate := (v_tickets_sold / v_total_seats) * 100;
    ELSE
        v_occupancy_rate := 0;
    END IF;
    
    -- Return popularity level
    IF v_occupancy_rate >= 80 THEN
        RETURN 'VERY HIGH';
    ELSIF v_occupancy_rate >= 60 THEN
        RETURN 'HIGH';
    ELSIF v_occupancy_rate >= 40 THEN
        RETURN 'MEDIUM';
    ELSIF v_occupancy_rate >= 20 THEN
        RETURN 'LOW';
    ELSE
        RETURN 'VERY LOW';
    END IF;
END;
/

-- 5. REVENUE CALCULATOR FUNCTION

CREATE OR REPLACE FUNCTION calculate_concert_revenue(
    p_concert_id IN NUMBER
) RETURN NUMBER
IS
    v_total_revenue NUMBER;
BEGIN
    SELECT SUM(b.final_price) INTO v_total_revenue
    FROM booking b
    JOIN ticket t ON b.ticket_id = t.ticket_id
    WHERE t.concert_id = p_concert_id;
    
    RETURN NVL(v_total_revenue, 0);
END;
/


-- 1. MAIN BOOKING PROCEDURE
CREATE OR REPLACE PROCEDURE process_ticket_booking(
    p_ticket_id IN NUMBER,
    p_customer_id IN NUMBER,
    p_payment_method IN VARCHAR2 DEFAULT 'Momo'
)
IS
    v_booking_status VARCHAR2(100);
    v_ticket_price NUMBER;
    v_discount NUMBER;
    v_final_price NUMBER;
    v_customer_name VARCHAR2(200);
    v_current_status VARCHAR2(20);
    v_concert_id NUMBER;

BEGIN
    
    
    -- Check if booking is allowed
    v_booking_status := check_booking_allowed();
    IF v_booking_status != 'ALLOWED' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Booking failed: ' || v_booking_status);
    END IF;
    
    -- Check ticket availability
    SELECT status, current_price, concert_id 
    INTO v_current_status, v_ticket_price, v_concert_id
    FROM ticket 
    WHERE ticket_id = p_ticket_id;
    
    IF v_current_status != 'available' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Ticket ' || p_ticket_id || ' is not available. Current status: ' || v_current_status);
    END IF;
    
    -- Get customer name
    SELECT first_name || ' ' || last_name INTO v_customer_name
    FROM customer 
    WHERE customer_id = p_customer_id;
    
    -- Calculate dynamic price
    v_ticket_price := calculate_dynamic_price(v_concert_id, p_ticket_id);
    
    -- Calculate loyalty discount
    v_discount := calculate_loyalty_discount(p_customer_id, v_ticket_price);
    v_final_price := v_ticket_price - v_discount;
    
    -- Create booking record
    INSERT INTO booking (booking_id, ticket_id, customer_id, final_price, payment_method)
    VALUES (seq_booking_id.NEXTVAL, p_ticket_id, p_customer_id, v_final_price, p_payment_method);
    
    -- Update ticket status
    UPDATE ticket 
    SET status = 'booked',
        current_price = v_ticket_price,
        discount_applied = CASE WHEN v_discount > 0 THEN 'Yes' ELSE 'No' END,
        last_updated = SYSDATE
    WHERE ticket_id = p_ticket_id;
    
    -- Update customer loyalty points
    UPDATE customer 
    SET loyalty_points = loyalty_points + 10
    WHERE customer_id = p_customer_id;
    
    -- Log the transaction
    INSERT INTO audit_log (audit_id, user_action, table_name, record_id, details)
    VALUES (seq_audit_id.NEXTVAL, 'TICKET_BOOKING', 'BOOKING', 
            seq_booking_id.CURRVAL,
            'Customer: ' || v_customer_name || 
            ' | Ticket: ' || p_ticket_id || 
            ' | Price: ' || v_final_price || ' RWF' ||
            ' | Discount: ' || v_discount || ' RWF');
    
    COMMIT;
    
    -- Output success message
    DBMS_OUTPUT.PUT_LINE(' BOOKING SUCCESSFUL!');
    DBMS_OUTPUT.PUT_LINE('   Customer: ' || v_customer_name);
    DBMS_OUTPUT.PUT_LINE('   Ticket ID: ' || p_ticket_id);
    DBMS_OUTPUT.PUT_LINE('   Original Price: ' || v_ticket_price || ' RWF');
    DBMS_OUTPUT.PUT_LINE('   Loyalty Discount: ' || v_discount || ' RWF');
    DBMS_OUTPUT.PUT_LINE('   Final Price: ' || v_final_price || ' RWF');
    DBMS_OUTPUT.PUT_LINE('   Payment Method: ' || p_payment_method);
    DBMS_OUTPUT.PUT_LINE('   Booking ID: ' || seq_booking_id.CURRVAL);
    DBMS_OUTPUT.PUT_LINE('==================================');
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, 'Invalid ticket ID or customer ID');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004, 'Booking failed: ' || SQLERRM);
END;
/

-- ============================================
-- CONTINUED: CREATE REMAINING PROCEDURES
-- ============================================

-- 3. CANCEL BOOKING PROCEDURE
CREATE OR REPLACE PROCEDURE cancel_booking(
    p_booking_id IN NUMBER
)
IS
    v_ticket_id NUMBER;
    v_customer_id NUMBER;
    v_booking_exists NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('❌ PROCESSING BOOKING CANCELLATION: ' || p_booking_id);
    DBMS_OUTPUT.PUT_LINE('=============================================');
    
    -- Check if booking exists
    SELECT COUNT(*) INTO v_booking_exists
    FROM booking 
    WHERE booking_id = p_booking_id;
    
    IF v_booking_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Booking ID ' || p_booking_id || ' not found');
    END IF;
    
    -- Get booking details
    SELECT ticket_id, customer_id 
    INTO v_ticket_id, v_customer_id
    FROM booking 
    WHERE booking_id = p_booking_id;
    
    -- Update booking status
    UPDATE booking 
    SET booking_status = 'cancelled'
    WHERE booking_id = p_booking_id;
    
    -- Make ticket available again
    UPDATE ticket 
    SET status = 'available'
    WHERE ticket_id = v_ticket_id;
    
    -- Reduce loyalty points (penalty for cancellation)
    UPDATE customer 
    SET loyalty_points = GREATEST(loyalty_points - 5, 0)
    WHERE customer_id = v_customer_id;
    
    -- Log cancellation
    INSERT INTO audit_log (audit_id, user_action, table_name, record_id, details)
    VALUES (seq_audit_id.NEXTVAL, 'CANCEL_BOOKING', 'BOOKING', p_booking_id,
            'Booking ' || p_booking_id || ' cancelled. Ticket ' || v_ticket_id || ' is now available.');
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('✅ Booking ' || p_booking_id || ' cancelled successfully');
    DBMS_OUTPUT.PUT_LINE('   Ticket ' || v_ticket_id || ' is now available');
    DBMS_OUTPUT.PUT_LINE('   Customer loyalty points reduced by 5');
    DBMS_OUTPUT.PUT_LINE('=============================================');
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20006, 'Cancellation failed: ' || SQLERRM);
END;
/

-- 4. ADD NEW CONCERT PROCEDURE
CREATE OR REPLACE PROCEDURE add_new_concert(
    p_concert_name IN VARCHAR2,
    p_artist_name IN VARCHAR2,
    p_venue IN VARCHAR2,
    p_concert_date IN DATE,
    p_concert_time IN VARCHAR2,
    p_total_seats IN NUMBER,
    p_base_price IN NUMBER,
    p_genre IN VARCHAR2,
    p_city IN VARCHAR2
)
IS
    v_concert_id NUMBER;
    v_tickets_created NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('🎵 ADDING NEW CONCERT TO SYSTEM');
    DBMS_OUTPUT.PUT_LINE('================================');
    
    -- Validate Rwanda city
    IF p_city NOT IN ('Kigali', 'Huye', 'Musanze', 'Rubavu', 'Nyagatare') THEN
        RAISE_APPLICATION_ERROR(-20007, 'Invalid Rwanda city. Must be Kigali, Huye, Musanze, Rubavu, or Nyagatare');
    END IF;
    
    -- Validate future date
    IF p_concert_date < SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20008, 'Concert date cannot be in the past');
    END IF;
    
    -- Insert concert
    INSERT INTO concert (
        concert_id, concert_name, artist_name, venue, 
        concert_date, concert_time, total_seats, 
        base_price, genre, city
    ) VALUES (
        seq_concert_id.NEXTVAL,
        p_concert_name,
        p_artist_name,
        p_venue,
        p_concert_date,
        p_concert_time,
        p_total_seats,
        p_base_price,
        p_genre,
        p_city
    )
    RETURNING concert_id INTO v_concert_id;
    
    -- Auto-generate tickets for the new concert
    DECLARE
        v_vip_seats NUMBER := TRUNC(p_total_seats * 0.1); -- 10% VIP
        v_premium_seats NUMBER := TRUNC(p_total_seats * 0.2); -- 20% Premium
        v_standard_seats NUMBER := TRUNC(p_total_seats * 0.5); -- 50% Standard
        v_economy_seats NUMBER := p_total_seats - v_vip_seats - v_premium_seats - v_standard_seats;
    BEGIN
        -- Create VIP tickets
        FOR i IN 1..v_vip_seats LOOP
            INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price)
            VALUES (seq_ticket_id.NEXTVAL, v_concert_id, 'VIP-' || LPAD(i, 3, '0'), 'VIP', p_base_price * 2.5);
            v_tickets_created := v_tickets_created + 1;
        END LOOP;
        
        -- Create Premium tickets
        FOR i IN 1..v_premium_seats LOOP
            INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price)
            VALUES (seq_ticket_id.NEXTVAL, v_concert_id, 'PRE-' || LPAD(i, 3, '0'), 'Premium', p_base_price * 1.8);
            v_tickets_created := v_tickets_created + 1;
        END LOOP;
        
        -- Create Standard tickets
        FOR i IN 1..v_standard_seats LOOP
            INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price)
            VALUES (seq_ticket_id.NEXTVAL, v_concert_id, 'STD-' || LPAD(i, 3, '0'), 'Standard', p_base_price * 1.0);
            v_tickets_created := v_tickets_created + 1;
        END LOOP;
        
        -- Create Economy tickets
        FOR i IN 1..v_economy_seats LOOP
            INSERT INTO ticket (ticket_id, concert_id, seat_number, seat_type, current_price)
            VALUES (seq_ticket_id.NEXTVAL, v_concert_id, 'ECO-' || LPAD(i, 3, '0'), 'Economy', p_base_price * 0.7);
            v_tickets_created := v_tickets_created + 1;
        END LOOP;
    END;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE(' CONCERT ADDED SUCCESSFULLY!');
    DBMS_OUTPUT.PUT_LINE('   Concert ID: ' || v_concert_id);
    DBMS_OUTPUT.PUT_LINE('   Name: ' || p_concert_name);
    DBMS_OUTPUT.PUT_LINE('   Venue: ' || p_venue || ', ' || p_city);
    DBMS_OUTPUT.PUT_LINE('   Date: ' || TO_CHAR(p_concert_date, 'DD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE('   Total Seats: ' || p_total_seats);
    DBMS_OUTPUT.PUT_LINE('   Base Price: ' || p_base_price || ' RWF');
    DBMS_OUTPUT.PUT_LINE('   Tickets Created: ' || v_tickets_created);
    DBMS_OUTPUT.PUT_LINE('================================');
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20009, 'Failed to add concert: ' || SQLERRM);
END;
/

-- 5. DAILY PRICE UPDATE PROCEDURE
CREATE OR REPLACE PROCEDURE daily_price_update
IS
    v_updated_tickets NUMBER := 0;
    v_price_changes NUMBER := 0;
BEGIN

    DBMS_OUTPUT.PUT_LINE('Start Time: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
    
    FOR ticket_rec IN (
        SELECT t.ticket_id, t.concert_id, t.current_price, t.seat_type
        FROM ticket t
        WHERE t.status = 'available'
        ORDER BY t.concert_id, t.ticket_id
    ) LOOP
        BEGIN
            DECLARE
                v_new_price NUMBER;
                v_price_difference NUMBER;
            BEGIN
                -- Calculate new dynamic price
                v_new_price := calculate_dynamic_price(ticket_rec.concert_id, ticket_rec.ticket_id);
                v_price_difference := ABS(v_new_price - ticket_rec.current_price);
                
                -- Only update if price changed by at least 100 RWF
                IF v_price_difference >= 100 THEN
                    -- Log the price change
                    INSERT INTO pricing_log (log_id, ticket_id, old_price, new_price, change_reason)
                    VALUES (seq_log_id.NEXTVAL, ticket_rec.ticket_id, 
                           ticket_rec.current_price, v_new_price,
                           'Daily dynamic price update');
                    
                    -- Update ticket price
                    UPDATE ticket 
                    SET current_price = v_new_price,
                        last_updated = SYSDATE
                    WHERE ticket_id = ticket_rec.ticket_id;
                    
                    v_updated_tickets := v_updated_tickets + 1;
                    v_price_changes := v_price_changes + 1;
                    
                    -- Show progress every 10 updates
                    IF MOD(v_updated_tickets, 10) = 0 THEN
                        DBMS_OUTPUT.PUT_LINE('   Updated ' || v_updated_tickets || ' tickets...');
                    END IF;
                END IF;
                
            EXCEPTION
                WHEN OTHERS THEN
                    -- Log error but continue with other tickets
                    INSERT INTO audit_log (audit_id, user_action, table_name, details)
                    VALUES (seq_audit_id.NEXTVAL, 'PRICE_UPDATE_ERROR', 'TICKET',
                            'Ticket ' || ticket_rec.ticket_id || ': ' || SQLERRM);
            END;
        END;
    END LOOP;
    
    COMMIT;
    
   
    DBMS_OUTPUT.PUT_LINE('   Tickets checked: ' || v_updated_tickets);
    DBMS_OUTPUT.PUT_LINE('   Price changes: ' || v_price_changes);
    DBMS_OUTPUT.PUT_LINE('   End Time: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('  Daily update failed: ' || SQLERRM);
        INSERT INTO audit_log (audit_id, user_action, table_name, details)
        VALUES (seq_audit_id.NEXTVAL, 'DAILY_UPDATE_FAILED', 'SYSTEM', SQLERRM);
        COMMIT;
END;
/



-- 1. PRICE CHANGE AUDIT TRIGGER

CREATE OR REPLACE TRIGGER trg_audit_price_change
BEFORE UPDATE OF current_price ON ticket
FOR EACH ROW
BEGIN
    -- Only log if price actually changed
    IF :OLD.current_price != :NEW.current_price THEN
        INSERT INTO pricing_log (log_id, ticket_id, old_price, new_price, change_reason, changed_by)
        VALUES (
            seq_log_id.NEXTVAL,
            :OLD.ticket_id,
            :OLD.current_price,
            :NEW.current_price,
            CASE 
                WHEN :NEW.current_price > :OLD.current_price THEN 'Price increase - demand based'
                ELSE 'Price decrease - promotion or low demand'
            END,
            'System Trigger'
        );
        
        DBMS_OUTPUT.PUT_LINE('Price change logged for Ticket ' || :OLD.ticket_id || 
                            ': ' || :OLD.current_price || ' → ' || :NEW.current_price || ' RWF');
    END IF;
END;
/

-- 2. BOOKING RESTRICTION TRIGGER (No weekend/holiday bookings)

CREATE OR REPLACE TRIGGER trg_booking_restrictions
BEFORE INSERT ON booking
FOR EACH ROW
DECLARE
    v_day_of_week VARCHAR2(20);
    v_is_holiday NUMBER;
    v_holiday_name VARCHAR2(100);
BEGIN
    -- Get day of week

    SELECT TO_CHAR(SYSDATE, 'DAY') INTO v_day_of_week FROM DUAL;
    v_day_of_week := TRIM(v_day_of_week);
    
    -- Check if today is a Rwanda holiday
    BEGIN
        SELECT holiday_name INTO v_holiday_name
        FROM rwanda_holiday
        WHERE TRUNC(holiday_date) = TRUNC(SYSDATE)
        AND ROWNUM = 1;
        
        v_is_holiday := 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_is_holiday := 0;
            v_holiday_name := NULL;
    END;
    
    -- Enforce business rule: No bookings on weekends

    IF v_day_of_week IN ('SATURDAY', 'SUNDAY') THEN
        RAISE_APPLICATION_ERROR(-20101, 
            'Bookings are not allowed on weekends in Rwanda. ' ||
            'Please try again on a weekday (Monday-Friday).');
    END IF;
    
    -- Enforce business rule: No bookings on public holidays

    IF v_is_holiday = 1 THEN
        RAISE_APPLICATION_ERROR(-20102,
            'Today is ' || v_holiday_name || ', a public holiday in Rwanda. ' ||
            'Bookings are not allowed on public holidays.');
    END IF;
    
    -- Log booking attempt

    INSERT INTO audit_log (audit_id, user_action, table_name, record_id, details)
    VALUES (seq_audit_id.NEXTVAL, 'BOOKING_ATTEMPT', 'BOOKING', 
            :NEW.booking_id, 'Booking attempted on ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY'));
    
EXCEPTION
    WHEN OTHERS THEN
        -- Re-raise the error
        RAISE;
END;
/

-- 3. AUTO TIMESTAMP TRIGGER

CREATE OR REPLACE TRIGGER trg_update_timestamps
BEFORE UPDATE ON ticket
FOR EACH ROW
BEGIN
    :NEW.last_updated := SYSDATE;
END;
/

-- 4. CONCERT AUDIT TRIGGER

CREATE OR REPLACE TRIGGER trg_audit_concert_changes
AFTER INSERT OR UPDATE OR DELETE ON concert
FOR EACH ROW
DECLARE
    v_action VARCHAR2(20);
    v_details VARCHAR2(500);
BEGIN
    -- Determine action type
    IF INSERTING THEN
        v_action := 'INSERT';
        v_details := 'New concert: ' || :NEW.concert_name || 
                    ' at ' || :NEW.venue || ', ' || :NEW.city;
    ELSIF UPDATING THEN
        v_action := 'UPDATE';
        v_details := 'Updated concert: ' || :OLD.concert_name;
        
        -- Track what changed
        IF :OLD.concert_name != :NEW.concert_name THEN
            v_details := v_details || ' [Name: ' || :OLD.concert_name || ' → ' || :NEW.concert_name || ']';
        END IF;
        IF :OLD.base_price != :NEW.base_price THEN
            v_details := v_details || ' [Price: ' || :OLD.base_price || ' → ' || :NEW.base_price || ' RWF]';
        END IF;
    ELSE
        v_action := 'DELETE';
        v_details := 'Deleted concert: ' || :OLD.concert_name || 
                    ' (ID: ' || :OLD.concert_id || ')';
    END IF;
    
    -- Log to audit table
    INSERT INTO audit_log (audit_id, user_action, table_name, record_id, details)
    VALUES (seq_audit_id.NEXTVAL, v_action, 'CONCERT', 
            COALESCE(:NEW.concert_id, :OLD.concert_id), v_details);
END;
/

-- 5. COMPOUND TRIGGER FOR COMPREHENSIVE BOOKING VALIDATION

CREATE OR REPLACE TRIGGER trg_compound_booking_validation
FOR INSERT OR UPDATE ON booking
COMPOUND TRIGGER

    TYPE booking_record IS RECORD (
        booking_id NUMBER,
        ticket_id NUMBER,
        customer_id NUMBER,
        final_price NUMBER
    );
    
    TYPE booking_table IS TABLE OF booking_record INDEX BY PLS_INTEGER;
    v_bookings booking_table;
    
    -- Before each row

    BEFORE EACH ROW IS
    BEGIN
        -- Store booking data for validation
        v_bookings(v_bookings.COUNT + 1).booking_id := :NEW.booking_id;
        v_bookings(v_bookings.COUNT).ticket_id := :NEW.ticket_id;
        v_bookings(v_bookings.COUNT).customer_id := :NEW.customer_id;
        v_bookings(v_bookings.COUNT).final_price := :NEW.final_price;
    END BEFORE EACH ROW;
    
    -- After statement
    AFTER STATEMENT IS
        v_ticket_status VARCHAR2(20);
        v_ticket_price NUMBER;
        v_customer_exists NUMBER;
    BEGIN
        -- Validate each booking
        FOR i IN 1..v_bookings.COUNT LOOP
            -- Check if ticket exists and is available
            BEGIN
                SELECT status, current_price 
                INTO v_ticket_status, v_ticket_price
                FROM ticket 
                WHERE ticket_id = v_bookings(i).ticket_id;
                
                IF v_ticket_status != 'available' THEN
                    RAISE_APPLICATION_ERROR(-20103, 
                        'Ticket ' || v_bookings(i).ticket_id || 
                        ' is not available. Current status: ' || v_ticket_status);
                END IF;
                
                -- Validate price (allow 10% tolerance for dynamic pricing)

                IF ABS(v_bookings(i).final_price - v_ticket_price) > (v_ticket_price * 0.10) THEN
                    INSERT INTO audit_log (audit_id, user_action, table_name, details)
                    VALUES (seq_audit_id.NEXTVAL, 'PRICE_VALIDATION_WARNING', 'BOOKING',
                            'Booking ' || v_bookings(i).booking_id || 
                            ': Paid ' || v_bookings(i).final_price || 
                            ', Expected ~' || v_ticket_price);
                END IF;
                
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR(-20104, 
                        'Ticket ' || v_bookings(i).ticket_id || ' does not exist');
            END;
            
            -- Check if customer exists
            SELECT COUNT(*) INTO v_customer_exists
            FROM customer 
            WHERE customer_id = v_bookings(i).customer_id;
            
            IF v_customer_exists = 0 THEN
                RAISE_APPLICATION_ERROR(-20105, 
                    'Customer ' || v_bookings(i).customer_id || ' does not exist');
            END IF;
        END LOOP;
        
        -- Clear the collection
        v_bookings.DELETE;
        
    EXCEPTION
        WHEN OTHERS THEN
            v_bookings.DELETE;
            RAISE;
    END AFTER STATEMENT;
    
END trg_compound_booking_validation;
/


END;
/


-- 1. ESSENTIAL CONCERT BOOKING PACKAGE


CREATE OR REPLACE PACKAGE concert_system_pkg IS
    -- Main booking procedure
    PROCEDURE book_ticket(
        p_ticket_id IN NUMBER,
        p_customer_id IN NUMBER,
        p_payment_method IN VARCHAR2 DEFAULT 'Momo'
    );
    
    -- Price update procedure
    PROCEDURE update_all_prices;
    
    -- Sales report
    PROCEDURE generate_report(p_days NUMBER DEFAULT 30);
    
    -- Check if booking allowed
    FUNCTION can_book_today RETURN VARCHAR2;
    
END concert_system_pkg;
/

CREATE OR REPLACE PACKAGE BODY concert_system_pkg IS
    
    PROCEDURE book_ticket(
        p_ticket_id IN NUMBER,
        p_customer_id IN NUMBER,
        p_payment_method IN VARCHAR2 DEFAULT 'Momo'
    ) IS
        v_price NUMBER;
        v_final_price NUMBER;
        v_customer_name VARCHAR2(200);
    BEGIN
        -- Get ticket price
        SELECT current_price INTO v_price
        FROM ticket WHERE ticket_id = p_ticket_id AND status = 'available';
        
        -- Get customer name
        SELECT first_name || ' ' || last_name INTO v_customer_name
        FROM customer WHERE customer_id = p_customer_id;
        
        -- Create booking
        INSERT INTO booking (booking_id, ticket_id, customer_id, final_price, payment_method)
        VALUES (seq_booking_id.NEXTVAL, p_ticket_id, p_customer_id, v_price, p_payment_method);
        
        -- Update ticket
        UPDATE ticket SET status = 'booked' WHERE ticket_id = p_ticket_id;
        
        -- Add loyalty points
        UPDATE customer SET loyalty_points = loyalty_points + 10 
        WHERE customer_id = p_customer_id;
        
        COMMIT;
        
        DBMS_OUTPUT.PUT_LINE('Ticket ' || p_ticket_id || ' booked by ' || 
                           v_customer_name || ' for ' || v_price || ' RWF');
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Ticket not available or customer not found');
            RAISE;
    END book_ticket;
    
    PROCEDURE update_all_prices IS
        v_count NUMBER := 0;
    BEGIN
        FOR t IN (SELECT ticket_id, concert_id FROM ticket WHERE status = 'available') LOOP
            UPDATE ticket 
            SET current_price = calculate_dynamic_price(t.concert_id, t.ticket_id)
            WHERE ticket_id = t.ticket_id;
            v_count := v_count + 1;
        END LOOP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Updated ' || v_count || ' ticket prices');
    END update_all_prices;
    
    PROCEDURE generate_report(p_days NUMBER DEFAULT 30) IS
        v_revenue NUMBER;
        v_bookings NUMBER;
    BEGIN
        SELECT SUM(final_price), COUNT(*) INTO v_revenue, v_bookings
        FROM booking WHERE booking_date >= SYSDATE - p_days;
        
        DBMS_OUTPUT.PUT_LINE(' LAST ' || p_days || ' DAYS REPORT');
        DBMS_OUTPUT.PUT_LINE('   Revenue: ' || NVL(v_revenue, 0) || ' RWF');
        DBMS_OUTPUT.PUT_LINE('   Bookings: ' || NVL(v_bookings, 0));
    END generate_report;
    
    FUNCTION can_book_today RETURN VARCHAR2 IS
        v_day VARCHAR2(20);
    BEGIN
        SELECT TO_CHAR(SYSDATE, 'DAY') INTO v_day FROM DUAL;
        v_day := TRIM(v_day);
        
        IF v_day IN ('SATURDAY', 'SUNDAY') THEN
            RETURN 'No - Weekend';
        ELSE
            RETURN 'Yes';
        END IF;
    END can_book_today;
    
END concert_system_pkg;
/


-- 2. ESSENTIAL SECURITY RULES


-- Simple security trigger - No operations on weekends

CREATE OR REPLACE TRIGGER trg_weekend_restriction
BEFORE INSERT OR UPDATE OR DELETE ON booking
BEGIN
    IF TO_CHAR(SYSDATE, 'DY') IN ('SAT', 'SUN') THEN
        RAISE_APPLICATION_ERROR(-20001, 
            'No booking operations allowed on weekends in Rwanda');
    END IF;
END;
/

-- Simple audit trigger

CREATE OR REPLACE TRIGGER trg_audit_bookings
AFTER INSERT ON booking
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (audit_id, user_action, table_name, record_id, details)
    VALUES (seq_audit_id.NEXTVAL, 'BOOKING', 'BOOKING', :NEW.booking_id,
            'Ticket ' || :NEW.ticket_id || ' booked for ' || :NEW.final_price || ' RWF');
END;
/

-- Price change audit

CREATE OR REPLACE TRIGGER trg_audit_price_changes
AFTER UPDATE OF current_price ON ticket
FOR EACH ROW
BEGIN
    IF :OLD.current_price != :NEW.current_price THEN
        INSERT INTO pricing_log (log_id, ticket_id, old_price, new_price, change_reason)
        VALUES (seq_log_id.NEXTVAL, :OLD.ticket_id, :OLD.current_price, 
                :NEW.current_price, 'Price update');
    END IF;
END;
/

-- ============================================
-- 3. ESSENTIAL CURSOR FOR REPORTING
-- ============================================

CREATE OR REPLACE PROCEDURE generate_concert_summary
IS
    CURSOR concert_cursor IS
        SELECT 
            c.concert_id,
            c.concert_name,
            c.city,
            COUNT(t.ticket_id) as total_tickets,
            SUM(CASE WHEN t.status = 'booked' THEN 1 ELSE 0 END) as booked,
            SUM(CASE WHEN t.status = 'available' THEN 1 ELSE 0 END) as available
        FROM concert c
        LEFT JOIN ticket t ON c.concert_id = t.concert_id
        GROUP BY c.concert_id, c.concert_name, c.city
        ORDER BY c.concert_id;
    
    v_concert_rec concert_cursor%ROWTYPE;
BEGIN
   
    
    OPEN concert_cursor;
    
    LOOP
        FETCH concert_cursor INTO v_concert_rec;
        EXIT WHEN concert_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(v_concert_rec.concert_name || ' (' || v_concert_rec.city || ')');
        DBMS_OUTPUT.PUT_LINE('   Tickets: ' || v_concert_rec.booked || ' booked, ' || 
                           v_concert_rec.available || ' available');
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
    
    CLOSE concert_cursor;
    
    
    
EXCEPTION
    WHEN OTHERS THEN
        IF concert_cursor%ISOPEN THEN
            CLOSE concert_cursor;
        END IF;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
