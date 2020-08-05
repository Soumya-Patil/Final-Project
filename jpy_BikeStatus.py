# Dependencies
import json
import requests 
from pprint import pprint
import pandas as pd
from pandas import json_normalize
import urllib
import psycopg2
import sqlalchemy
from sqlalchemy import create_engine
from datetime import datetime, date
import schedule 
import time


r = requests.get('https://gbfs.citibikenyc.com/gbfs/en/station_status.json')
df = json_normalize(r.json()['data']['stations'])


df2 = df.rename(columns={"num_bikes_available":"bikes_available","num_bikes_disabled":"bikes_disabled","num_docks_available":"docks_available","num_docks_disabled":"docks_disabled","last_reported":"time_reported"})


bike_df = df2[["station_id","bikes_available","bikes_disabled","docks_available","docks_disabled","time_reported"]]


def epoch_to_readable(xepoch):
    
    return datetime.fromtimestamp(xepoch)

bike_df['time_reported'] = bike_df.apply(lambda x: epoch_to_readable(x['time_reported']), axis = 1 )


db_connection_string = "postgres:jaigurudev@localhost:5432/FinalProject"
engine = create_engine(f'postgresql://{db_connection_string}')


bike_df.to_sql(name = 'bikes',con = engine , if_exists = 'append',index = False)







