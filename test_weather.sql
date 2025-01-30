--
-- PostgreSQL database dump
--

-- Dumped from database version 14.15 (Homebrew)
-- Dumped by pg_dump version 14.15 (Homebrew)

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
-- Name: birds; Type: TABLE; Schema: public; Owner: stephen
--

CREATE TABLE public.birds (
    name character varying(255),
    length numeric(10,1),
    wingspan numeric(10,1),
    family character varying(255),
    extinct boolean
);


ALTER TABLE public.birds OWNER TO stephen;

--
-- Name: menu_items; Type: TABLE; Schema: public; Owner: stephen
--

CREATE TABLE public.menu_items (
    item character varying(255),
    prep_time integer,
    ingredient_cost numeric(40,2),
    sales integer,
    menu_price numeric(40,2)
);


ALTER TABLE public.menu_items OWNER TO stephen;

--
-- Name: people; Type: TABLE; Schema: public; Owner: stephen
--

CREATE TABLE public.people (
    id integer NOT NULL,
    name character varying(30),
    age integer,
    occupation character varying(50)
);


ALTER TABLE public.people OWNER TO stephen;

--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: stephen
--

CREATE SEQUENCE public.people_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.people_id_seq OWNER TO stephen;

--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: stephen
--

ALTER SEQUENCE public.people_id_seq OWNED BY public.people.id;


--
-- Name: weather; Type: TABLE; Schema: public; Owner: stephen
--

CREATE TABLE public.weather (
    date date NOT NULL,
    low integer NOT NULL,
    high integer NOT NULL,
    rainfall numeric(4,3) DEFAULT 0 NOT NULL
);


ALTER TABLE public.weather OWNER TO stephen;

--
-- Name: people id; Type: DEFAULT; Schema: public; Owner: stephen
--

ALTER TABLE ONLY public.people ALTER COLUMN id SET DEFAULT nextval('public.people_id_seq'::regclass);


--
-- Data for Name: birds; Type: TABLE DATA; Schema: public; Owner: stephen
--

COPY public.birds (name, length, wingspan, family, extinct) FROM stdin;
Spotted Towhee	21.6	26.7	Emberizidae	f
American Robin	25.5	36.0	Turdidae	f
Greater Koa Finch	19.0	24.0	Fringillidae	t
Carolina Parakeet	33.0	55.8	Psittacidae	t
Common Kestrel	35.5	73.5	Falconidae	f
\.


--
-- Data for Name: menu_items; Type: TABLE DATA; Schema: public; Owner: stephen
--

COPY public.menu_items (item, prep_time, ingredient_cost, sales, menu_price) FROM stdin;
omelette	10	1.50	182	7.99
tacos	5	2.00	254	8.99
oatmeal	1	0.50	79	5.99
\.


--
-- Data for Name: people; Type: TABLE DATA; Schema: public; Owner: stephen
--

COPY public.people (id, name, age, occupation) FROM stdin;
1	Abby	34	biologist
2	Mu'nisa	26	\N
3	Mirabelle	40	contractor
\.


--
-- Data for Name: weather; Type: TABLE DATA; Schema: public; Owner: stephen
--

COPY public.weather (date, low, high, rainfall) FROM stdin;
2016-03-07	29	32	0.000
2016-03-08	23	31	0.000
2016-03-09	17	28	0.000
2016-03-01	34	43	0.117
2016-03-02	32	44	0.117
2016-03-03	31	47	0.156
2016-03-04	33	42	0.078
2016-03-05	39	46	0.273
2016-03-06	32	43	0.078
\.


--
-- Name: people_id_seq; Type: SEQUENCE SET; Schema: public; Owner: stephen
--

SELECT pg_catalog.setval('public.people_id_seq', 3, true);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: stephen
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

