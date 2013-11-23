--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: test_child_tables; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE test_child_tables (
    id integer NOT NULL,
    test_table_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: test_child_tables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE test_child_tables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: test_child_tables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE test_child_tables_id_seq OWNED BY test_child_tables.id;


--
-- Name: test_tables; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE test_tables (
    id integer NOT NULL,
    cbinary bytea,
    cboolean boolean DEFAULT false,
    cdate date,
    cdatetime timestamp without time zone,
    cdecimal numeric,
    cfloat double precision,
    cinteger integer,
    cstring character varying(255) DEFAULT 'default_value'::character varying,
    ctext text,
    ctime time without time zone,
    ctimestamp timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: test_tables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE test_tables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: test_tables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE test_tables_id_seq OWNED BY test_tables.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_child_tables ALTER COLUMN id SET DEFAULT nextval('test_child_tables_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_tables ALTER COLUMN id SET DEFAULT nextval('test_tables_id_seq'::regclass);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY schema_migrations (version) FROM stdin;
20131121062057
20131121062105
\.


--
-- Data for Name: test_child_tables; Type: TABLE DATA; Schema: public; Owner: -
--

COPY test_child_tables (id, test_table_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: test_child_tables_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('test_child_tables_id_seq', 1, false);


--
-- Data for Name: test_tables; Type: TABLE DATA; Schema: public; Owner: -
--

COPY test_tables (id, cbinary, cboolean, cdate, cdatetime, cdecimal, cfloat, cinteger, cstring, ctext, ctime, ctimestamp, created_at, updated_at) FROM stdin;
\.


--
-- Name: test_tables_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('test_tables_id_seq', 1, false);


--
-- Name: test_child_tables_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY test_child_tables
    ADD CONSTRAINT test_child_tables_pkey PRIMARY KEY (id);


--
-- Name: test_tables_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY test_tables
    ADD CONSTRAINT test_tables_pkey PRIMARY KEY (id);


--
-- Name: index_test_child_tables_on_test_table_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_test_child_tables_on_test_table_id ON test_child_tables USING btree (test_table_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

