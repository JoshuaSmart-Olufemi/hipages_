
with source as (
    select * from {{ source('web','transactions') }}
),

renamed as (
    select
        id,
        coalesce(contact_id, '0') as contact_id,
        {{ as_timestamp_utc('transaction_date') }} as transaction_date,
        amount,
        item_count,
        category, 
        _loaded_at_utc
    from source     
)

, deduplicate as (
    {{ dbt_utils.deduplicate(
    relation='renamed',
    partition_by='id',
    order_by='_loaded_at_utc',
   )
}}
)



select * from deduplicate
where contact_id is not null
/*count(*), contact_id from deduplicate
group by 2
having count(*) > 1*/


