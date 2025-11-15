with Country as (
    select iso_code, name, array_agg(ifnull(dafif_code, 'Unknown')) as dafif_codes, _data_source, _load_time
    from {{ ref('countries') }} 
    group by iso_code, name, _data_source, _load_time
)

select *
from Country
where iso_code is not null 
union all
select t.mapped_iso_code, c.name, c.dafif_codes, c._data_source, c._load_time 
from Country c join {{ ref('tmp_country_iso_codes') }} t 
on c.name = t.name
where t.mapped_iso_code is not null
and c.iso_code is null  
