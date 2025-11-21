
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
        select
            row_count
        from (
            select
                count(*) AS row_count
            from `cs378-fa2025`.`dbt_air_travel_stg`.`tsa_traffic`
        )
        where row_count <> ( select count(*) from `cs378-fa2025`.`air_travel_raw`.`tsa_traffic` )

  
  
      
    ) dbt_internal_test