{{ config(
    materialized='table'
) }}

with orders as (
  select
    customer_id,
    min(created_at) as first_order_at,
    count(distinct created_at) as number_of_orders
  from `analytics-engineers-club.coffee_shop.orders`
  group by 1
),
final as (
  select
    orders.customer_id,
    customers.name,
    customers.email,
    orders.first_order_at,
    orders.number_of_orders
  from `analytics-engineers-club.coffee_shop.customers` as customers
  inner join orders 
  on orders.customer_id = customers.id
)
select *
from final
order by first_order_at