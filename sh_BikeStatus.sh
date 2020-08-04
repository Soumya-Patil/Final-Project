# BikeStatus Script

def rw_to_db():

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

    schedule.every(10).minutes.do(rw_to_db)
    schedule.every().hour.do(job)
    schedule.every().day.at("13:00").do(rw_to_db)

while 1:
    schedule.run_pending()
    time.sleep(1)