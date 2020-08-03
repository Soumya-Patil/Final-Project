-- Table: public.bikes

-- DROP TABLE public.bikes;

CREATE TABLE public.bikes
(
    station_id integer NOT NULL,
    bikes_available integer,
    bikes_disabled integer,
    docks_available integer,
    docks_disabled integer,
    time_reported timestamp without time zone,
    CONSTRAINT bikes_pkey PRIMARY KEY (station_id)
)

TABLESPACE pg_default;

ALTER TABLE public.bikes
    OWNER to postgres;