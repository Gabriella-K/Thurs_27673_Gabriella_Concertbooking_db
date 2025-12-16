# CONCERT BOOKING SYSTEM- ORACLE PL/SQL CAPSTONE PROJECT

## Student Information
- **Name:** Gabriella UCYEYE
- **Student ID:** 27673
- **Course:** PL/SQL Database management

## Project Overview
A smart ticketing system that automates concert bookings across Rwanda with dynamic pricing, loyalty rewards, and comprehensive analytics.

## Key objectives
- Automatically adjust ticket prices based on demand, time until concert, seat type, and day of week
- Prevent bookings on weekends and public holidays per Rwandan business customs.
- Generate real-time analytics on sales, revenue by city, and concert popularity.
- Comprehensive auditing, foreign key constraints, and transaction management

## Prerequisites tools
- **Database:** Oracle database 21 c
- **Development:** SQL Developer
- **Modeling:** BPMN & SQL MODELER
- **Monitoring:** Oracle Database Manager

## ER Diagram
Shows the database schema, emphasizing on the relationship between entities.
![ER diagram](https://github.com/Gabriella-K/Thurs_27673_Gabriella_Concertbooking_db/blob/6a7b567e0c43d20c1f0ab3b36da5729a21bf0399/Screenshot/ER.png)
## OEM 
Oracle Enterprise helps to monitor all the process on the port of 1521

## Setup Guide
First we created the pluggable database with enough tablespace and granted all privileges to the admin
![pdb](https://github.com/Gabriella-K/Thurs_27673_Gabriella_Concertbooking_db/blob/6a7b567e0c43d20c1f0ab3b36da5729a21bf0399/Screenshot/PDB.png)
![pdb1](https://github.com/Gabriella-K/Thurs_27673_Gabriella_Concertbooking_db/blob/6a7b567e0c43d20c1f0ab3b36da5729a21bf0399/Screenshot/PDB(1).png)

## Database Tables and insert
We created tables. The following is one of the tables created and values added
```sql
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

```
![Table](https://github.com/Gabriella-K/Thurs_27673_Gabriella_Concertbooking_db/blob/6a7b567e0c43d20c1f0ab3b36da5729a21bf0399/Screenshot/Table.png)


## Functions
Here we have functions with their return types, which will help us to calculate the dynamic price of the tickets
``` sql
create or replace FUNCTION calculate_dynamic_price(
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
```
![Function](https://github.com/Gabriella-K/Thurs_27673_Gabriella_Concertbooking_db/blob/6a7b567e0c43d20c1f0ab3b36da5729a21bf0399/Screenshot/function.png)

## Procedure
The procedure here can help the administrator of the system website to add more concerts
 and also shows some of the windows functions.
 
 ``` sql
 create or replace PROCEDURE add_new_concert(
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

    DBMS_OUTPUT.PUT_LINE('✅ CONCERT ADDED SUCCESSFULLY!');
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
```
![Procedure](https://github.com/Gabriella-K/Thurs_27673_Gabriella_Concertbooking_db/blob/6a7b567e0c43d20c1f0ab3b36da5729a21bf0399/Screenshot/procedure.png)
![procedure windows](https://github.com/Gabriella-K/Thurs_27673_Gabriella_Concertbooking_db/blob/6a7b567e0c43d20c1f0ab3b36da5729a21bf0399/Screenshot/procedureW.png)
## Audit log
``` sql
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
```
![Audit](https://github.com/Gabriella-K/Thurs_27673_Gabriella_Concertbooking_db/blob/6a7b567e0c43d20c1f0ab3b36da5729a21bf0399/Screenshot/audit.png)

## PL/SQL Package: concert_system_pkg
## Specification
``` sql
create or replace PACKAGE concert_system_pkg IS
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
```
![package](https://github.com/Gabriella-K/Thurs_27673_Gabriella_Concertbooking_db/blob/6a7b567e0c43d20c1f0ab3b36da5729a21bf0399/Screenshot/package.png)

## Trigger: Security rules
This trigger will not allow registration or booking of tickets in the weekends or on the public holidays

``` sql
create or replace TRIGGER trg_booking_restrictions
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
```
![Triggerf](https://github.com/Gabriella-K/Thurs_27673_Gabriella_Concertbooking_db/blob/6a7b567e0c43d20c1f0ab3b36da5729a21bf0399/Screenshot/triggerf.png)
![Trigger](https://github.com/Gabriella-K/Thurs_27673_Gabriella_Concertbooking_db/blob/6a7b567e0c43d20c1f0ab3b36da5729a21bf0399/Screenshot/Trigger.png)



 
