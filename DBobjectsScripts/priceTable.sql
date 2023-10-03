
CREATE SEQUENCE public.price_entry_id_seq;

CREATE TABLE public.price (
                entry_id INTEGER NOT NULL DEFAULT nextval('public.price_entry_id_seq'),
                price REAL NOT NULL,
                start TIMESTAMP NOT NULL,
                end_1 TIMESTAMP NOT NULL,
                CONSTRAINT price_pk PRIMARY KEY (entry_id)
);
COMMENT ON TABLE public.price IS 'Stores hourly electricity prices and timestamps';
COMMENT ON COLUMN public.price.entry_id IS 'Automatically add a serial number for each row in the table';
COMMENT ON COLUMN public.price.price IS 'Hourly price in cents';
COMMENT ON COLUMN public.price.start IS 'Date and hour of when the time period starts';
COMMENT ON COLUMN public.price.end_1 IS 'Date and time for when the time period ends';


ALTER SEQUENCE public.price_entry_id_seq OWNED BY public.price.entry_id;
