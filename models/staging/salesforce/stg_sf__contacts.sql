
with source as (
    select * from {{ source('salesforce','contacts') }}
),

renamed as (
    select
        id,
        username as user_name,
        name,
        gender,
        address, 
        mail as email_address,
        birthdate as birth_date,
        _loaded_at_utc
    from source 
         
)

, deduplicate as (
    {{ dbt_utils.deduplicate(
    relation='renamed',
    partition_by='id',
    order_by='birth_date',
   )
}}
)



select {{ dbt_utils.generate_surrogate_key(['id','user_name','address','birth_date']) }} as surrogate_key,
* 
from deduplicate
where id is not null
--select --{{ dbt_utils.generate_surrogate_key(['id','user_name','address','birth_date']) }} as surrogate_key,
 --*
--from renamed 
--where id = '3458a748-e9bb-47bc-a3f2-c9bf9c6316b9' 



