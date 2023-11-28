--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4
-- Dumped by pg_dump version 15.4

-- Started on 2023-11-21 11:42:22

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 214 (class 1259 OID 19482)
-- Name: hourly_price; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hourly_price (
    timeslot timestamp with time zone NOT NULL,
    price real NOT NULL
);


ALTER TABLE public.hourly_price OWNER TO postgres;

--
-- TOC entry 3420 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE hourly_price; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.hourly_price IS 'This table is for hourly electricity prices and weather data';


--
-- TOC entry 225 (class 1259 OID 19539)
-- Name: average_by_month_num; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.average_by_month_num AS
 SELECT EXTRACT(isodow FROM hourly_price.timeslot) AS kknumero,
    avg(hourly_price.price) AS avg
   FROM public.hourly_price
  GROUP BY (EXTRACT(isodow FROM hourly_price.timeslot))
  ORDER BY (EXTRACT(isodow FROM hourly_price.timeslot));


ALTER TABLE public.average_by_month_num OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 19518)
-- Name: average_by_weekday_num; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.average_by_weekday_num AS
 SELECT EXTRACT(isodow FROM hourly_price.timeslot) AS vpnumero,
    avg(hourly_price.price) AS avg
   FROM public.hourly_price
  GROUP BY (EXTRACT(isodow FROM hourly_price.timeslot))
  ORDER BY (EXTRACT(isodow FROM hourly_price.timeslot));


ALTER TABLE public.average_by_weekday_num OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 19495)
-- Name: average_by_year; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.average_by_year AS
 SELECT EXTRACT(year FROM hourly_price.timeslot) AS vuosi,
    avg(hourly_price.price) AS keskihinta
   FROM public.hourly_price
  GROUP BY (EXTRACT(year FROM hourly_price.timeslot));


ALTER TABLE public.average_by_year OWNER TO postgres;

--
-- TOC entry 3421 (class 0 OID 0)
-- Dependencies: 217
-- Name: VIEW average_by_year; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.average_by_year IS 'Average electricity prices on yearly basis';


--
-- TOC entry 218 (class 1259 OID 19499)
-- Name: average_by_year_and_month; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.average_by_year_and_month AS
 SELECT EXTRACT(year FROM hourly_price.timeslot) AS vuosi,
    EXTRACT(month FROM hourly_price.timeslot) AS kuukausi,
    avg(hourly_price.price) AS keskihinta,
    stddev_pop(hourly_price.price) AS hajonta,
    (avg(hourly_price.price) + stddev_pop(hourly_price.price)) AS "yläraja",
    (avg(hourly_price.price) - stddev_pop(hourly_price.price)) AS alaraja
   FROM public.hourly_price
  GROUP BY (EXTRACT(year FROM hourly_price.timeslot)), (EXTRACT(month FROM hourly_price.timeslot));


ALTER TABLE public.average_by_year_and_month OWNER TO postgres;

--
-- TOC entry 3422 (class 0 OID 0)
-- Dependencies: 218
-- Name: VIEW average_by_year_and_month; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.average_by_year_and_month IS 'Calculates average electricity prices for year-month basis';


--
-- TOC entry 219 (class 1259 OID 19503)
-- Name: average_by_year_month_day; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.average_by_year_month_day AS
 SELECT EXTRACT(year FROM hourly_price.timeslot) AS vuosi,
    EXTRACT(month FROM hourly_price.timeslot) AS kuukausi,
    EXTRACT(day FROM hourly_price.timeslot) AS "päivä",
    avg(hourly_price.price) AS keskihinta
   FROM public.hourly_price
  GROUP BY (EXTRACT(year FROM hourly_price.timeslot)), (EXTRACT(month FROM hourly_price.timeslot)), (EXTRACT(day FROM hourly_price.timeslot));


ALTER TABLE public.average_by_year_month_day OWNER TO postgres;

--
-- TOC entry 3423 (class 0 OID 0)
-- Dependencies: 219
-- Name: VIEW average_by_year_month_day; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.average_by_year_month_day IS 'Average electricity prices on a year-month-day basis';


--
-- TOC entry 220 (class 1259 OID 19515)
-- Name: weekday_lookup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.weekday_lookup (
    weekday_number integer NOT NULL,
    fin_name character varying(20) NOT NULL,
    swe_name character varying(20) NOT NULL,
    eng_name character varying(20) NOT NULL,
    ger_name character varying(20) NOT NULL,
    tur_name character varying(20) NOT NULL
);


ALTER TABLE public.weekday_lookup OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 19522)
-- Name: avg_price_by_weekday_name; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.avg_price_by_weekday_name AS
 SELECT weekday_lookup.fin_name AS "viikonpäivä",
    weekday_lookup.swe_name AS veckodag,
    weekday_lookup.eng_name AS weekday,
    weekday_lookup.ger_name AS wochentag,
    weekday_lookup.tur_name AS haftaici,
    round((average_by_weekday_num.avg)::numeric, 3) AS keskihinta
   FROM public.weekday_lookup,
    public.average_by_weekday_num
  WHERE ((weekday_lookup.weekday_number)::numeric = average_by_weekday_num.vpnumero)
  ORDER BY average_by_weekday_num.vpnumero;


ALTER TABLE public.avg_price_by_weekday_name OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 19487)
-- Name: current_prices; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.current_prices AS
 SELECT hourly_price.timeslot AS kello,
    hourly_price.price AS hinta
   FROM public.hourly_price
  WHERE (hourly_price.timeslot >= now())
  ORDER BY hourly_price.timeslot;


ALTER TABLE public.current_prices OWNER TO postgres;

--
-- TOC entry 3424 (class 0 OID 0)
-- Dependencies: 215
-- Name: VIEW current_prices; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.current_prices IS 'Shows electricity prices from now on';


--
-- TOC entry 230 (class 1259 OID 19613)
-- Name: observation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.observation (
    "timestamp" timestamp without time zone NOT NULL,
    place character varying(50) NOT NULL,
    wind_direction real,
    wind_speed real,
    temperature real
);


ALTER TABLE public.observation OWNER TO postgres;

--
-- TOC entry 3425 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE observation; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.observation IS 'Stores FMI weather observations in 10 minute intervals';


--
-- TOC entry 231 (class 1259 OID 19618)
-- Name: current_weather; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.current_weather AS
 SELECT observation.temperature AS "lämpötila",
    observation.wind_speed AS tuuli,
    observation.wind_direction AS suunta
   FROM public.observation
  ORDER BY observation."timestamp" DESC
 LIMIT 1;


ALTER TABLE public.current_weather OWNER TO postgres;

--
-- TOC entry 3426 (class 0 OID 0)
-- Dependencies: 231
-- Name: VIEW current_weather; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.current_weather IS 'Current weather observations';


--
-- TOC entry 229 (class 1259 OID 19604)
-- Name: forecast; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.forecast (
    "timestamp" timestamp without time zone NOT NULL,
    place character varying(50) NOT NULL,
    wind_direction real,
    wind_speed real,
    temperature real
);


ALTER TABLE public.forecast OWNER TO postgres;

--
-- TOC entry 3427 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE forecast; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.forecast IS 'FMI weather forecast for 36 hours';


--
-- TOC entry 228 (class 1259 OID 19600)
-- Name: hourly_page; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.hourly_page AS
 SELECT EXTRACT(day FROM hourly_price.timeslot) AS day,
    EXTRACT(hour FROM hourly_price.timeslot) AS hour,
    hourly_price.price
   FROM public.hourly_price
  WHERE (hourly_price.timeslot >= now())
  ORDER BY (EXTRACT(day FROM hourly_price.timeslot)), (EXTRACT(hour FROM hourly_price.timeslot));


ALTER TABLE public.hourly_page OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 19622)
-- Name: latest_forecasts; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.latest_forecasts AS
 SELECT forecast."timestamp",
    forecast.place,
    forecast.wind_direction,
    forecast.wind_speed,
    forecast.temperature
   FROM public.forecast
  WHERE (forecast."timestamp" >= now());


ALTER TABLE public.latest_forecasts OWNER TO postgres;

--
-- TOC entry 3428 (class 0 OID 0)
-- Dependencies: 232
-- Name: VIEW latest_forecasts; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.latest_forecasts IS 'Forecasts from now onwards';


--
-- TOC entry 223 (class 1259 OID 19532)
-- Name: month_name_lookup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.month_name_lookup (
    month_number integer NOT NULL,
    fin_name character varying(20) NOT NULL,
    swe_name character varying(20),
    eng_name character varying(20),
    ger_name character varying(20),
    tur_name character varying(20)
);


ALTER TABLE public.month_name_lookup OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 19535)
-- Name: monthly_averages_by_year_fin; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.monthly_averages_by_year_fin AS
 SELECT average_by_year_and_month.vuosi,
    month_name_lookup.fin_name,
    average_by_year_and_month.keskihinta
   FROM public.average_by_year_and_month,
    public.month_name_lookup
  WHERE (average_by_year_and_month.kuukausi = (month_name_lookup.month_number)::numeric)
  ORDER BY average_by_year_and_month.vuosi, average_by_year_and_month.kuukausi;


ALTER TABLE public.monthly_averages_by_year_fin OWNER TO postgres;

--
-- TOC entry 3429 (class 0 OID 0)
-- Dependencies: 224
-- Name: VIEW monthly_averages_by_year_fin; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.monthly_averages_by_year_fin IS 'Monthly averages with Finnish month names';


--
-- TOC entry 226 (class 1259 OID 19592)
-- Name: previous_month_average; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.previous_month_average AS
 SELECT average_by_year_and_month.keskihinta,
    average_by_year_and_month."yläraja",
    average_by_year_and_month.alaraja
   FROM public.average_by_year_and_month
  WHERE ((average_by_year_and_month.vuosi = EXTRACT(year FROM now())) AND (average_by_year_and_month.kuukausi = (EXTRACT(month FROM now()) - (1)::numeric)));


ALTER TABLE public.previous_month_average OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 19491)
-- Name: running_average; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.running_average AS
 SELECT round((avg(hourly_price.price))::numeric, 3) AS keskihinta
   FROM public.hourly_price;


ALTER TABLE public.running_average OWNER TO postgres;

--
-- TOC entry 3430 (class 0 OID 0)
-- Dependencies: 216
-- Name: VIEW running_average; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.running_average IS 'Calculates average electricity price from all rows';


--
-- TOC entry 227 (class 1259 OID 19596)
-- Name: running_avg_and_stddev; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.running_avg_and_stddev AS
 SELECT avg(hourly_price.price) AS hinta,
    stddev(hourly_price.price) AS keskihajonta
   FROM public.hourly_price;


ALTER TABLE public.running_avg_and_stddev OWNER TO postgres;

--
-- TOC entry 3431 (class 0 OID 0)
-- Dependencies: 227
-- Name: VIEW running_avg_and_stddev; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.running_avg_and_stddev IS 'Calcultates average electricity price and standard deviation from whole price data';


--
-- TOC entry 3413 (class 0 OID 19604)
-- Dependencies: 229
-- Data for Name: forecast; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3410 (class 0 OID 19482)
-- Dependencies: 214
-- Data for Name: hourly_price; Type: TABLE DATA; Schema: public; Owner: postgres
--


--
-- TOC entry 3412 (class 0 OID 19532)
-- Dependencies: 223
-- Data for Name: month_name_lookup; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.month_name_lookup VALUES (1, 'tammikuu', 'januari', 'January', 'Januar', 'Ocak');
INSERT INTO public.month_name_lookup VALUES (2, 'helmikuu', 'februari', 'February', 'Februar', 'Şubat');
INSERT INTO public.month_name_lookup VALUES (3, 'maaliskuu', 'mars', 'March', 'März', 'Mart');
INSERT INTO public.month_name_lookup VALUES (4, 'huhtikuu', 'april', 'April', 'April', 'Nisan');
INSERT INTO public.month_name_lookup VALUES (5, 'toukokuu', 'maj', 'May', 'Mai', 'Mayis');
INSERT INTO public.month_name_lookup VALUES (6, 'kesäkuu', 'juni', 'June', 'Juni', 'Haziran');
INSERT INTO public.month_name_lookup VALUES (7, 'heinäkuu', 'juli', 'July', 'Juli', 'Temmuz');
INSERT INTO public.month_name_lookup VALUES (8, 'elokuu', 'augusti', 'August', 'August', 'Ağustos');
INSERT INTO public.month_name_lookup VALUES (9, 'syyskuu', 'september', 'September', 'September', 'Eylül');
INSERT INTO public.month_name_lookup VALUES (10, 'lokakuu', 'oktober', 'October', 'Oktober', 'Ekim');
INSERT INTO public.month_name_lookup VALUES (11, 'marraskuu', 'november', 'November', 'November', 'Kasım');
INSERT INTO public.month_name_lookup VALUES (12, 'joulukuu', 'december', 'December', 'Dezember', 'Aralık');


--
-- TOC entry 3414 (class 0 OID 19613)
-- Dependencies: 230
-- Data for Name: observation; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3411 (class 0 OID 19515)
-- Dependencies: 220
-- Data for Name: weekday_lookup; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.weekday_lookup VALUES (1, 'maanantai', 'måndag', 'monday', 'Montag', 'Pazartesi');
INSERT INTO public.weekday_lookup VALUES (2, 'tiistai', 'tisdag', 'tuesday', 'Dienstag', 'Sali');
INSERT INTO public.weekday_lookup VALUES (3, 'keskiviikko', 'onsdag', 'wednesday', 'Mittwoch', 'Carsamba');
INSERT INTO public.weekday_lookup VALUES (4, 'torstai', 'torsdag', 'thursday', 'Donnerstag', 'Persemble');
INSERT INTO public.weekday_lookup VALUES (5, 'perjantai', 'fredag', 'friday', 'Freitag', 'Cuma');
INSERT INTO public.weekday_lookup VALUES (6, 'lauantai', 'lördag', 'saturday', 'Samstag', 'Cumartesi');
INSERT INTO public.weekday_lookup VALUES (7, 'sunnuntai', 'söndag', 'sunday', 'Sonntag', 'Pazar');


--
-- TOC entry 3251 (class 2606 OID 19608)
-- Name: forecast forecast_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forecast
    ADD CONSTRAINT forecast_pk PRIMARY KEY ("timestamp", place);


--
-- TOC entry 3245 (class 2606 OID 19486)
-- Name: hourly_price hourly_price_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hourly_price
    ADD CONSTRAINT hourly_price_pkey PRIMARY KEY (timeslot);


--
-- TOC entry 3249 (class 2606 OID 19612)
-- Name: month_name_lookup month_name_lookup_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.month_name_lookup
    ADD CONSTRAINT month_name_lookup_pkey PRIMARY KEY (month_number);


--
-- TOC entry 3253 (class 2606 OID 19617)
-- Name: observation observation_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observation
    ADD CONSTRAINT observation_pk PRIMARY KEY ("timestamp", place);


--
-- TOC entry 3247 (class 2606 OID 19610)
-- Name: weekday_lookup weekday_lookup_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weekday_lookup
    ADD CONSTRAINT weekday_lookup_pk PRIMARY KEY (weekday_number);


-- Completed on 2023-11-21 11:42:23

--
-- PostgreSQL database dump complete
--

