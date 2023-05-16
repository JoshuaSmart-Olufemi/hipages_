with base_cte as (
    SELECT
    id,
    gender,
    {{ age_in_years('birth_date') }} AS age,
    sum(amount) as total_expense,
    transaction_date,
    category             
    FROM {{ ref('contacts_joined_with_transactions') }}
    GROUP BY
    1,2,3,5,6

)

, window_functions as (
    SELECT distinct *
    , first_value(transaction_date) over (partition by id order by transaction_date ) as first_purchase_date
    , last_value(transaction_date) over (partition by id order by transaction_date desc)  as last_purchase_date
    , sum(total_expense) over (partition by category) as total_amount_of_purchase_per_category
    FROM base_cte
)

SELECT * FROM window_functions