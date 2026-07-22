-- Loading training data in your warehouse

-- create this one directly in the schema
create or replace table sandbox.tim_wilson.js_customers
(
    id integer,
    first_name varchar,
    last_name varchar
);

copy into sandbox.tim_wilson.js_customers (id, first_name, last_name)
    from 's3://dbt-tutorial-public/jaffle_shop_customers.csv'
        file_format = (
            type = 'CSV'
            field_delimiter = ','
            skip_header = 1
        )
;

create or replace table sandbox.tim_wilson.js_orders
(
  id integer,
  user_id integer,
  order_date date,
  status varchar,
  _etl_loaded_at timestamp default current_timestamp
);

copy into sandbox.tim_wilson.js_orders (id, user_id, order_date, status)
    from 's3://dbt-tutorial-public/jaffle_shop_orders.csv'
        file_format = (
            type = 'CSV'
            field_delimiter = ','
            skip_header = 1
        )
;

create or replace table sandbox.tim_wilson.js_stripe_payment (
  id integer,
  orderid integer,
  paymentmethod varchar,
  status varchar,
  amount integer,
  created date,
  _batched_at timestamp default current_timestamp
);

copy into sandbox.tim_wilson.js_stripe_payment (id, orderid, paymentmethod, status, amount, created)
from 's3://dbt-tutorial-public/stripe_payments.csv'
    file_format = (
        type = 'CSV'
        field_delimiter = ','
        skip_header = 1
    )
;



