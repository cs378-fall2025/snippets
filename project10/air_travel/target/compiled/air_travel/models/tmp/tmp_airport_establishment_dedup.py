def model(dbt, session):
    
    dbt.config(submission_method="bigframes", materialized="table")
    
    source_df = dbt.ref("Airport_Establishment")
    result_df = source_df.drop_duplicates(subset=['business'], keep='first')

    return result_df


# This part is user provided model code
# you will need to copy the next section to run the code
# COMMAND ----------
# this part is dbt logic for get ref work, do not modify

def ref(*args, **kwargs):
    refs = {"Airport_Establishment": "cs378-fa2025.dbt_air_travel_int.Airport_Establishment"}
    key = '.'.join(args)
    version = kwargs.get("v") or kwargs.get("version")
    if version:
        key += f".v{version}"
    dbt_load_df_function = kwargs.get("dbt_load_df_function")
    return dbt_load_df_function(refs[key])


def source(*args, dbt_load_df_function):
    sources = {}
    key = '.'.join(args)
    return dbt_load_df_function(sources[key])


config_dict = {}


class config:
    def __init__(self, *args, **kwargs):
        pass

    @staticmethod
    def get(key, default=None):
        return config_dict.get(key, default)

class this:
    """dbt.this() or dbt.this.identifier"""
    database = "cs378-fa2025"
    schema = "dbt_air_travel_tmp"
    identifier = "tmp_airport_establishment_dedup"
    
    def __repr__(self):
        return 'cs378-fa2025.dbt_air_travel_tmp.tmp_airport_establishment_dedup'


class dbtObj:
    def __init__(self, load_df_function) -> None:
        self.source = lambda *args: source(*args, dbt_load_df_function=load_df_function)
        self.ref = lambda *args, **kwargs: ref(*args, **kwargs, dbt_load_df_function=load_df_function)
        self.config = config
        self.this = this()
        self.is_incremental = False

# COMMAND ----------


