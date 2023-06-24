--
-- PostgreSQL database dump
--

-- Dumped from database version 14.8
-- Dumped by pg_dump version 14.8

-- Started on 2023-06-24 10:49:44

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

--
-- TOC entry 3 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3412 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 229 (class 1255 OID 16395)
-- Name: adjust_stocks_from_sales(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.adjust_stocks_from_sales() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   
        INSERT INTO stock_transactions (product_id, quantity, transaction_type,new_stocks)
        VALUES (NEW.product_id, NEW.quantity, 'SALES',(select 
    (p.initial_stocks + (select coalesce(sum(po.output_quantity),0) as in from production_outputs po where po.product_id = p.product_id) -
    (select coalesce(sum(si.quantity), 0) as out from sales_items si where si.product_id = p.product_id) - 
     (select coalesce(sum(rp.quantity), 0) as repros from repro_products rp where rp.product_id = p.product_id)) as current_stocks
    from products p where p.product_id = new.product_id limit 1));

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.adjust_stocks_from_sales() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 209 (class 1259 OID 16396)
-- Name: delivered_packagings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.delivered_packagings (
    id bigint NOT NULL,
    packaging_id integer NOT NULL,
    delivered_quantity integer NOT NULL,
    date_delivered character varying NOT NULL
);


ALTER TABLE public.delivered_packagings OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16401)
-- Name: delivered_packagings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.delivered_packagings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.delivered_packagings_id_seq OWNER TO postgres;

--
-- TOC entry 3413 (class 0 OID 0)
-- Dependencies: 210
-- Name: delivered_packagings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.delivered_packagings_id_seq OWNED BY public.delivered_packagings.id;


--
-- TOC entry 211 (class 1259 OID 16402)
-- Name: packagings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.packagings (
    packaging_id bigint NOT NULL,
    packaging_name character varying,
    initial_stocks bigint
);


ALTER TABLE public.packagings OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 16407)
-- Name: packagings_packaging_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.packagings_packaging_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.packagings_packaging_id_seq OWNER TO postgres;

--
-- TOC entry 3414 (class 0 OID 0)
-- Dependencies: 212
-- Name: packagings_packaging_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.packagings_packaging_id_seq OWNED BY public.packagings.packaging_id;


--
-- TOC entry 213 (class 1259 OID 16408)
-- Name: product_sales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_sales (
    customer_name character varying NOT NULL,
    "createdAt" character varying,
    sales_id bigint NOT NULL,
    "updatedAt" character varying,
    stocks_movement_key character varying
);


ALTER TABLE public.product_sales OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16413)
-- Name: product_sales_sales_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_sales_sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_sales_sales_id_seq OWNER TO postgres;

--
-- TOC entry 3415 (class 0 OID 0)
-- Dependencies: 214
-- Name: product_sales_sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_sales_sales_id_seq OWNED BY public.product_sales.sales_id;


--
-- TOC entry 215 (class 1259 OID 16414)
-- Name: production_outputs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.production_outputs (
    production_id bigint NOT NULL,
    product_id integer NOT NULL,
    output_quantity integer NOT NULL,
    damaged_packaging integer,
    production_date character varying NOT NULL
);


ALTER TABLE public.production_outputs OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16419)
-- Name: production_outputs_production_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.production_outputs_production_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.production_outputs_production_id_seq OWNER TO postgres;

--
-- TOC entry 3416 (class 0 OID 0)
-- Dependencies: 216
-- Name: production_outputs_production_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.production_outputs_production_id_seq OWNED BY public.production_outputs.production_id;


--
-- TOC entry 217 (class 1259 OID 16420)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    product_id integer NOT NULL,
    product_name character varying,
    initial_stocks integer NOT NULL,
    packaging_size numeric
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16425)
-- Name: products_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_product_id_seq OWNER TO postgres;

--
-- TOC entry 3417 (class 0 OID 0)
-- Dependencies: 218
-- Name: products_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;


--
-- TOC entry 219 (class 1259 OID 16426)
-- Name: released_packagings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.released_packagings (
    id bigint NOT NULL,
    packaging_id bigint NOT NULL,
    quantity_released bigint NOT NULL,
    date_released character varying,
    released_for character varying
);


ALTER TABLE public.released_packagings OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16431)
-- Name: released_packagings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.released_packagings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.released_packagings_id_seq OWNER TO postgres;

--
-- TOC entry 3418 (class 0 OID 0)
-- Dependencies: 220
-- Name: released_packagings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.released_packagings_id_seq OWNED BY public.released_packagings.id;


--
-- TOC entry 221 (class 1259 OID 16432)
-- Name: repro_products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.repro_products (
    id bigint NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    reason character varying
);


ALTER TABLE public.repro_products OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16437)
-- Name: repro_products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.repro_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.repro_products_id_seq OWNER TO postgres;

--
-- TOC entry 3419 (class 0 OID 0)
-- Dependencies: 222
-- Name: repro_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.repro_products_id_seq OWNED BY public.repro_products.id;


--
-- TOC entry 223 (class 1259 OID 16438)
-- Name: returned_packagings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.returned_packagings (
    id bigint NOT NULL,
    packaging_id integer NOT NULL,
    quantity_returned integer NOT NULL,
    returned_date character varying NOT NULL
);


ALTER TABLE public.returned_packagings OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16443)
-- Name: returned_packagings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.returned_packagings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.returned_packagings_id_seq OWNER TO postgres;

--
-- TOC entry 3420 (class 0 OID 0)
-- Dependencies: 224
-- Name: returned_packagings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.returned_packagings_id_seq OWNED BY public.returned_packagings.id;


--
-- TOC entry 225 (class 1259 OID 16444)
-- Name: sales_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_items (
    sales_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    sales_item_id bigint NOT NULL
);


ALTER TABLE public.sales_items OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16447)
-- Name: sales_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sales_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_items_id_seq OWNER TO postgres;

--
-- TOC entry 3421 (class 0 OID 0)
-- Dependencies: 226
-- Name: sales_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sales_items_id_seq OWNED BY public.sales_items.sales_item_id;


--
-- TOC entry 227 (class 1259 OID 16448)
-- Name: stocks_flow; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stocks_flow (
    id integer NOT NULL,
    product_id integer,
    update_type character varying NOT NULL,
    quantity integer NOT NULL,
    new_quantity integer,
    update_key character varying
);


ALTER TABLE public.stocks_flow OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16453)
-- Name: stocks_flow_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stocks_flow_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stocks_flow_id_seq OWNER TO postgres;

--
-- TOC entry 3422 (class 0 OID 0)
-- Dependencies: 228
-- Name: stocks_flow_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stocks_flow_id_seq OWNED BY public.stocks_flow.id;


--
-- TOC entry 3210 (class 2604 OID 16454)
-- Name: delivered_packagings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivered_packagings ALTER COLUMN id SET DEFAULT nextval('public.delivered_packagings_id_seq'::regclass);


--
-- TOC entry 3211 (class 2604 OID 16455)
-- Name: packagings packaging_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.packagings ALTER COLUMN packaging_id SET DEFAULT nextval('public.packagings_packaging_id_seq'::regclass);


--
-- TOC entry 3212 (class 2604 OID 16456)
-- Name: product_sales sales_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sales ALTER COLUMN sales_id SET DEFAULT nextval('public.product_sales_sales_id_seq'::regclass);


--
-- TOC entry 3213 (class 2604 OID 16457)
-- Name: production_outputs production_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.production_outputs ALTER COLUMN production_id SET DEFAULT nextval('public.production_outputs_production_id_seq'::regclass);


--
-- TOC entry 3214 (class 2604 OID 16458)
-- Name: products product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);


--
-- TOC entry 3215 (class 2604 OID 16459)
-- Name: released_packagings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.released_packagings ALTER COLUMN id SET DEFAULT nextval('public.released_packagings_id_seq'::regclass);


--
-- TOC entry 3216 (class 2604 OID 16460)
-- Name: repro_products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repro_products ALTER COLUMN id SET DEFAULT nextval('public.repro_products_id_seq'::regclass);


--
-- TOC entry 3217 (class 2604 OID 16461)
-- Name: returned_packagings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.returned_packagings ALTER COLUMN id SET DEFAULT nextval('public.returned_packagings_id_seq'::regclass);


--
-- TOC entry 3218 (class 2604 OID 16462)
-- Name: sales_items sales_item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_items ALTER COLUMN sales_item_id SET DEFAULT nextval('public.sales_items_id_seq'::regclass);


--
-- TOC entry 3219 (class 2604 OID 16463)
-- Name: stocks_flow id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stocks_flow ALTER COLUMN id SET DEFAULT nextval('public.stocks_flow_id_seq'::regclass);


--
-- TOC entry 3387 (class 0 OID 16396)
-- Dependencies: 209
-- Data for Name: delivered_packagings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.delivered_packagings VALUES (2, 4, 19850, '05/03/2023');
INSERT INTO public.delivered_packagings VALUES (6, 1, 6614, '05/04/2023');


--
-- TOC entry 3389 (class 0 OID 16402)
-- Dependencies: 211
-- Data for Name: packagings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.packagings VALUES (1, 'DOGGY WOGGY ADULT LAMINATED SACKS', 3730);
INSERT INTO public.packagings VALUES (2, 'PLASTIC 24x36 (FLEXI)', 7374);
INSERT INTO public.packagings VALUES (3, 'PLASTIC 24x36 (LABO)', 1976);
INSERT INTO public.packagings VALUES (5, 'PLASTIC 18.5x28', 17765);
INSERT INTO public.packagings VALUES (4, 'PLASTIC 22x33', 1531);
INSERT INTO public.packagings VALUES (7, 'KRAFT BAG WHITE 18x5x35', 694);
INSERT INTO public.packagings VALUES (8, 'PIGLET BOOSTER', 6065);
INSERT INTO public.packagings VALUES (6, 'DOGGY WOGGY PUPPY LAMINATED SACKS', 1000);


--
-- TOC entry 3391 (class 0 OID 16408)
-- Dependencies: 213
-- Data for Name: product_sales; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '05/18/2023', 28, NULL, NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-19 10:09:33.982 +08:00', 32, '2023-05-19 10:09:33.982 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-19 12:49:18.874 +08:00', 37, '2023-05-19 12:49:18.874 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-19 14:25:11.550 +08:00', 40, '2023-05-19 14:25:11.550 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-05-19 16:44:32.545 +08:00', 41, '2023-05-19 16:44:32.545 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-05-20 08:25:49.222 +08:00', 42, '2023-05-20 08:25:49.222 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-20 11:02:18.696 +08:00', 43, '2023-05-20 11:02:18.696 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-05-20 11:04:38.323 +08:00', 44, '2023-05-20 11:04:38.323 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-20 11:16:26.796 +08:00', 45, '2023-05-20 11:16:26.796 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('PRODUCTION DEPARTMENT', '2023-05-22 11:25:54.336 +08:00', 46, '2023-05-22 11:25:54.336 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-22 17:26:45.835 +08:00', 47, '2023-05-22 17:26:45.835 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-05-22 17:28:19.788 +08:00', 48, '2023-05-22 17:28:19.788 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-05-22 17:28:40.762 +08:00', 49, '2023-05-22 17:28:40.762 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('SANI', '2023-05-22 18:04:03.127 +08:00', 50, '2023-05-22 18:04:03.127 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-23 10:25:40.648 +08:00', 51, '2023-05-23 10:25:40.648 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('KKM', '2023-05-23 16:37:04.839 +08:00', 52, '2023-05-23 16:37:04.839 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('PUAL CAGUING', '2023-05-23 16:42:02.043 +08:00', 53, '2023-05-23 16:42:02.043 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('EMMANUEL MANALANG', '2023-05-24 11:07:52.053 +08:00', 54, '2023-05-24 11:07:52.053 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-24 11:53:13.242 +08:00', 55, '2023-05-24 11:53:13.242 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NUGOLD', '2023-05-24 11:55:16.969 +08:00', 56, '2023-05-24 11:55:16.969 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('TONY HERNANDEZ', '2023-05-24 16:33:12.925 +08:00', 57, '2023-05-24 16:33:12.925 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-05-24 16:33:48.484 +08:00', 58, '2023-05-24 16:33:48.484 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('AVENIDA', '2023-05-25 08:23:38.028 +08:00', 59, '2023-05-25 08:23:38.028 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NIÑO ARAÑO', '2023-05-25 08:33:20.205 +08:00', 60, '2023-05-25 08:33:20.205 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-25 09:51:29.732 +08:00', 61, '2023-05-25 09:51:29.732 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RAPHAEL DELA CRUZ', '2023-05-25 10:50:46.082 +08:00', 62, '2023-05-25 10:50:46.082 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-26 10:34:55.930 +08:00', 63, '2023-05-26 10:34:55.930 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('MARVIN CARANDANG', '2023-05-26 10:35:14.101 +08:00', 64, '2023-05-26 10:35:14.101 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('JULIUS JASA', '2023-05-27 08:54:14.816 +08:00', 65, '2023-05-27 08:54:14.816 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-05-27 11:26:22.921 +08:00', 67, '2023-05-27 11:26:22.921 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-05-27 09:45:11.568 +08:00', 66, '2023-05-27 09:45:11.568 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-29 09:04:57.243 +08:00', 68, '2023-05-29 09:04:57.243 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-29 10:49:14.166 +08:00', 69, '2023-05-29 10:49:14.166 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-05-29 13:36:57.509 +08:00', 70, '2023-05-29 13:36:57.509 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-05-29 14:44:17.374 +08:00', 71, '2023-05-29 14:44:17.374 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-30 09:30:41.398 +08:00', 72, '2023-05-30 09:30:41.398 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('SANI', '2023-05-30 14:44:56.895 +08:00', 73, '2023-05-30 14:44:56.895 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-05-30 16:02:27.898 +08:00', 74, '2023-05-30 16:02:27.898 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-05-31 09:32:36.865 +08:00', 75, '2023-05-31 09:32:36.865 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-31 10:00:06.554 +08:00', 76, '2023-05-31 10:00:06.554 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-31 14:03:27.535 +08:00', 77, '2023-05-31 14:03:27.535 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-05-31 14:04:24.885 +08:00', 78, '2023-05-31 14:04:24.885 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('KKM', '2023-05-31 14:53:26.880 +08:00', 80, '2023-05-31 14:53:26.880 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('CASH SALES', '2023-06-01 09:52:26.815 +08:00', 81, '2023-06-01 09:52:26.815 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-01 09:53:48.149 +08:00', 82, '2023-06-01 09:53:48.149 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-01 14:46:52.939 +08:00', 83, '2023-06-01 14:46:52.939 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-06-01 16:37:33.753 +08:00', 84, '2023-06-01 16:37:33.753 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-02 09:52:13.760 +08:00', 85, '2023-06-02 09:52:13.760 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('TONY HERNANDEZ', '2023-06-02 16:33:38.712 +08:00', 86, '2023-06-02 16:33:38.712 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('CASH SALES', '2023-06-03 11:25:14.045 +08:00', 87, '2023-06-03 11:25:14.045 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NIÑO ARAÑO', '2023-06-05 08:35:23.089 +08:00', 88, '2023-06-05 08:35:23.089 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-05 14:36:57.525 +08:00', 89, '2023-06-05 14:36:57.525 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('PAU CAGUING', '2023-06-06 08:12:43.285 +08:00', 90, '2023-06-06 08:12:43.285 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-06-06 08:14:23.492 +08:00', 91, '2023-06-06 08:14:23.492 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-06-06 08:14:54.309 +08:00', 92, '2023-06-06 08:14:54.309 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-06 09:23:27.893 +08:00', 93, '2023-06-06 09:23:27.893 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-06 14:30:29.219 +08:00', 94, '2023-06-06 14:30:29.219 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-06-06 16:17:20.320 +08:00', 95, '2023-06-06 16:17:20.320 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-07 09:51:03.788 +08:00', 96, '2023-06-07 09:51:03.788 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-07 14:16:11.308 +08:00', 97, '2023-06-07 14:16:11.308 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-07 14:16:41.270 +08:00', 98, '2023-06-07 14:16:41.270 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-06-07 16:29:51.629 +08:00', 99, '2023-06-07 16:29:51.629 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-08 10:28:13.110 +08:00', 100, '2023-06-08 10:28:13.110 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-08 11:33:55.006 +08:00', 101, '2023-06-08 11:33:55.006 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-08 13:10:02.037 +08:00', 102, '2023-06-08 13:10:02.037 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-13 08:22:11.925 +08:00', 103, '2023-06-13 08:22:11.925 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-13 08:22:25.163 +08:00', 104, '2023-06-13 08:22:25.163 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-06-13 08:22:54.795 +08:00', 105, '2023-06-13 08:22:54.795 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-13 14:37:56.580 +08:00', 106, '2023-06-13 14:37:56.580 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-13 14:38:01.812 +08:00', 107, '2023-06-13 14:38:01.812 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('CASH SALES', '2023-06-13 14:38:14.904 +08:00', 108, '2023-06-13 14:38:14.904 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-06-13 14:38:34.419 +08:00', 109, '2023-06-13 14:38:34.419 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-06-13 14:38:57.375 +08:00', 110, '2023-06-13 14:38:57.375 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-06-14 08:13:09.569 +08:00', 111, '2023-06-14 08:13:09.569 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('TONY HERNANDEZ', '2023-06-14 08:13:36.588 +08:00', 112, '2023-06-14 08:13:36.588 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('LAKAL', '2023-06-14 08:21:01.110 +08:00', 114, '2023-06-14 08:21:01.110 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('CLDS CORPORATION', '2023-06-14 13:38:25.485 +08:00', 117, '2023-06-14 13:38:25.485 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-14 13:39:06.422 +08:00', 118, '2023-06-14 13:39:06.422 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('SIR RAPHY', '2023-06-15 09:30:56.750 +08:00', 119, '2023-06-15 09:30:56.750 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NUGOLD', '2023-06-15 11:20:38.918 +08:00', 120, '2023-06-15 11:20:38.918 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('DOC MANNY', '2023-06-15 11:32:19.882 +08:00', 121, '2023-06-15 11:32:19.882 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-15 11:32:29.814 +08:00', 122, '2023-06-15 11:32:29.814 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-06-15 11:34:05.463 +08:00', 123, '2023-06-15 11:34:05.463 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('CASH SALES', '2023-06-15 15:56:46.817 +08:00', 124, '2023-06-15 15:56:46.817 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-16 10:36:31.366 +08:00', 125, '2023-06-16 10:36:31.366 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('MARVIN CARANDANG', '2023-06-16 13:29:54.323 +08:00', 126, '2023-06-16 13:29:54.323 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-16 14:27:33.159 +08:00', 127, '2023-06-16 14:27:33.159 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-06-16 16:30:24.288 +08:00', 128, '2023-06-16 16:30:24.288 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NUGOLD ', '2023-06-16 17:01:18.270 +08:00', 129, '2023-06-16 17:01:18.270 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-06-17 08:51:49.412 +08:00', 130, '2023-06-17 08:51:49.412 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-06-17 11:23:15.871 +08:00', 131, '2023-06-17 11:23:15.871 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('TONY HERNANDEZ', '2023-06-17 11:55:02.694 +08:00', 132, '2023-06-17 11:55:02.694 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-19 09:14:01.964 +08:00', 165, '2023-06-19 09:14:01.964 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-19 13:10:55.875 +08:00', 166, '2023-06-19 13:10:55.875 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('CLDS', '2023-06-20 08:04:41.160 +08:00', 167, '2023-06-20 08:04:41.160 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-06-20 08:35:54.840 +08:00', 168, '2023-06-20 08:35:54.840 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-20 09:07:14.032 +08:00', 169, '2023-06-20 09:07:14.032 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('KKM', '2023-06-20 15:15:28.403 +08:00', 170, '2023-06-20 15:15:28.403 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-20 15:58:18.527 +08:00', 171, '2023-06-20 15:58:18.527 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-21 10:01:26.382 +08:00', 172, '2023-06-21 10:01:26.382 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-21 10:25:20.706 +08:00', 173, '2023-06-21 10:25:20.706 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-06-21 12:42:07.855 +08:00', 174, '2023-06-21 12:42:07.855 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-22 13:44:05.428 +08:00', 175, '2023-06-22 13:44:05.428 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-23 08:18:14.508 +08:00', 176, '2023-06-23 08:18:14.508 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-23 10:07:17.473 +08:00', 177, '2023-06-23 10:07:17.473 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-06-23 13:16:48.214 +08:00', 183, '2023-06-23 13:16:48.214 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-06-23 15:06:23.248 +08:00', 202, '2023-06-23 15:06:23.248 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-24 09:06:45.773 +08:00', 205, '2023-06-24 09:06:45.773 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-06-24 09:07:08.384 +08:00', 206, '2023-06-24 09:07:08.384 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-06-24 10:45:22.431 +08:00', 207, '2023-06-24 10:45:22.431 +08:00', NULL);


--
-- TOC entry 3393 (class 0 OID 16414)
-- Dependencies: 215
-- Data for Name: production_outputs; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.production_outputs VALUES (2, 1, 800, 0, '05/18/2023');
INSERT INTO public.production_outputs VALUES (3, 1, 1800, 2, '05/19/2023');
INSERT INTO public.production_outputs VALUES (4, 1, 112, 0, '05/20/2023');
INSERT INTO public.production_outputs VALUES (5, 7, 177, 0, '50/20/2023');
INSERT INTO public.production_outputs VALUES (6, 6, 18, 0, '05/22/2023');
INSERT INTO public.production_outputs VALUES (7, 15, 700, 0, '05/23/2023');
INSERT INTO public.production_outputs VALUES (8, 15, 288, 10, '05/23/2023');
INSERT INTO public.production_outputs VALUES (9, 6, 100, 0, '05/24/2023');
INSERT INTO public.production_outputs VALUES (10, 3, 200, 0, '05/24/2023');
INSERT INTO public.production_outputs VALUES (11, 4, 50, 0, '05/24/2023');
INSERT INTO public.production_outputs VALUES (12, 17, 288, 0, '05/25/2023');
INSERT INTO public.production_outputs VALUES (13, 18, 320, 0, '05/25/2023');
INSERT INTO public.production_outputs VALUES (14, 4, 50, 0, '05/25/2023');
INSERT INTO public.production_outputs VALUES (15, 4, 300, 0, '05/26/2027');
INSERT INTO public.production_outputs VALUES (16, 19, 236, 0, '05/26/2023');
INSERT INTO public.production_outputs VALUES (17, 4, 56, 5, '05/27/2023');
INSERT INTO public.production_outputs VALUES (18, 21, 100, 0, '05/29/2023');
INSERT INTO public.production_outputs VALUES (19, 21, 898, 1, '05/30/2023');
INSERT INTO public.production_outputs VALUES (20, 20, 200, 0, '05/30/2023');
INSERT INTO public.production_outputs VALUES (21, 20, 752, 0, '06/01/2023');
INSERT INTO public.production_outputs VALUES (22, 16, 300, 0, '06/02/2023');
INSERT INTO public.production_outputs VALUES (23, 16, 900, 0, '06/03/2023');
INSERT INTO public.production_outputs VALUES (24, 16, 326, 0, '06/05/2023');
INSERT INTO public.production_outputs VALUES (25, 2, 436, 0, '06/05/2023');
INSERT INTO public.production_outputs VALUES (26, 1, 902, 0, '06/07/2023');
INSERT INTO public.production_outputs VALUES (27, 7, 232, 0, '06/14/2023');
INSERT INTO public.production_outputs VALUES (28, 18, 320, 0, '06/14/2023');
INSERT INTO public.production_outputs VALUES (29, 22, 363, 0, '06/14/2023');
INSERT INTO public.production_outputs VALUES (30, 19, 241, 0, '06/14/2023');
INSERT INTO public.production_outputs VALUES (31, 23, 118, 0, '06/14/2023');
INSERT INTO public.production_outputs VALUES (32, 15, 650, 0, '06/19/2023');
INSERT INTO public.production_outputs VALUES (33, 15, 302, 2, '06/20/2023');
INSERT INTO public.production_outputs VALUES (34, 1, 200, 0, '06/21/2023');
INSERT INTO public.production_outputs VALUES (35, 2, 404, 0, '06/21/2023');
INSERT INTO public.production_outputs VALUES (36, 24, 220, 0, '06/22/2023');
INSERT INTO public.production_outputs VALUES (37, 1, 1000, 0, '06/22/2023');
INSERT INTO public.production_outputs VALUES (39, 24, 220, 0, '06/24/2023');
INSERT INTO public.production_outputs VALUES (40, 18, 320, 1, '06/24/2023');
INSERT INTO public.production_outputs VALUES (38, 1, 100, 0, '06/24/2023');
INSERT INTO public.production_outputs VALUES (41, 1, 500, 0, '06/24/2023');


--
-- TOC entry 3395 (class 0 OID 16420)
-- Dependencies: 217
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.products VALUES (4, 'KITTY WITTY', 202, 20);
INSERT INTO public.products VALUES (6, 'SOLENN CAT FOOD', 18, 20);
INSERT INTO public.products VALUES (7, 'RAM', 71, 20);
INSERT INTO public.products VALUES (8, 'FOOD FOR THE DOG PUPPY', 280, 9.09);
INSERT INTO public.products VALUES (3, 'FELIZ CAT FOOD', 80, 20);
INSERT INTO public.products VALUES (1, 'DOGGY WOGGY ADULT', 1289, 20);
INSERT INTO public.products VALUES (2, 'DOGGY WOGGY PUPPY', 186, 10);
INSERT INTO public.products VALUES (14, 'CHM - PUPPY', 38, 10);
INSERT INTO public.products VALUES (15, 'PERFECTO', 0, 20);
INSERT INTO public.products VALUES (16, 'NUGOLD - A', 112, 15);
INSERT INTO public.products VALUES (17, 'ANG MAESTRO BABY STAG BOOSTER', 0, 25);
INSERT INTO public.products VALUES (18, 'ANG MAESTRO STAG DEVELOPER', 0, 25);
INSERT INTO public.products VALUES (19, 'ANG MAESTRO BULL STAG', 0, 25);
INSERT INTO public.products VALUES (20, 'CHM - ADULT (PLASTIC)', 0, 20);
INSERT INTO public.products VALUES (21, 'CHM - ADULT (SACKS)', 0, 20);
INSERT INTO public.products VALUES (22, 'ANG MAESTRO JUNIOR STAG', 0, 25);
INSERT INTO public.products VALUES (23, 'PIGLET BOOSTER', 0, 20);
INSERT INTO public.products VALUES (24, 'FOOD FOR THE DOG ADULT', 0, 18.18);


--
-- TOC entry 3397 (class 0 OID 16426)
-- Dependencies: 219
-- Data for Name: released_packagings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.released_packagings VALUES (1, 5, 1013, '05-03-2023', NULL);
INSERT INTO public.released_packagings VALUES (2, 1, 1730, '05-11-2023', NULL);
INSERT INTO public.released_packagings VALUES (3, 1, 1500, '05-11-2023', NULL);
INSERT INTO public.released_packagings VALUES (4, 1, 1000, '05/11/13', NULL);
INSERT INTO public.released_packagings VALUES (5, 6, 30, '05/16/2023', NULL);
INSERT INTO public.released_packagings VALUES (6, 4, 1, '05/18/2023', NULL);
INSERT INTO public.released_packagings VALUES (8, 1, 1114, '05/16/2023', NULL);
INSERT INTO public.released_packagings VALUES (9, 1, 500, '05/19/2023', NULL);
INSERT INTO public.released_packagings VALUES (10, 4, 200, '05/20/2023', NULL);
INSERT INTO public.released_packagings VALUES (11, 4, 973, '05/22/2023', NULL);
INSERT INTO public.released_packagings VALUES (12, 4, 350, '05/23/2023', NULL);
INSERT INTO public.released_packagings VALUES (14, 1, 1, '05/23/2023', NULL);
INSERT INTO public.released_packagings VALUES (13, 4, 0, '05/23/2023', NULL);
INSERT INTO public.released_packagings VALUES (15, 7, 18, '05/22/2023', NULL);
INSERT INTO public.released_packagings VALUES (16, 7, 300, '05/24/2023', NULL);
INSERT INTO public.released_packagings VALUES (18, 3, 300, '05/24/2023', NULL);
INSERT INTO public.released_packagings VALUES (17, 4, 325, '05/24/2023', 'KITTY WITTY');
INSERT INTO public.released_packagings VALUES (19, 4, 280, '05/26/2023', 'KITTY WITTY');
INSERT INTO public.released_packagings VALUES (21, 2, 800, '05/29/2023', 'CHM - A LINER');
INSERT INTO public.released_packagings VALUES (23, 4, 145, '05/30/2023', 'CHM - A');
INSERT INTO public.released_packagings VALUES (24, 4, 700, '05/30/2023', 'CHM - A');
INSERT INTO public.released_packagings VALUES (25, 4, 350, '05/31/2023', 'CHM - A');
INSERT INTO public.released_packagings VALUES (22, 2, 224, '05/30/2023', 'CHM - A LINER');
INSERT INTO public.released_packagings VALUES (27, 8, 1000, '06/02/2023', 'PICKED UP BY AVENIDA');
INSERT INTO public.released_packagings VALUES (28, 1, 1, '06/03/2023', 'rebag dwa');
INSERT INTO public.released_packagings VALUES (29, 6, 436, '06/05/2023', 'DWP');
INSERT INTO public.released_packagings VALUES (30, 1, 867, '06/06/2023', 'DWA');
INSERT INTO public.released_packagings VALUES (31, 1, 200, '06/07/2023', 'DWA');
INSERT INTO public.released_packagings VALUES (32, 1, 1, '06/13/2023', 'rebag dwa');
INSERT INTO public.released_packagings VALUES (33, 2, 30, '06/13/2023', 'CAPT CAT LINER');
INSERT INTO public.released_packagings VALUES (34, 3, 76, '06/13/2023', 'CAPT CAT');
INSERT INTO public.released_packagings VALUES (37, 4, 232, '06/14/2023', 'released for RAM');
INSERT INTO public.released_packagings VALUES (38, 4, 11, '06/14/2023', 'released for RAM - delivery');
INSERT INTO public.released_packagings VALUES (39, 4, 100, '06/14/2023', 'released for piglet booster');
INSERT INTO public.released_packagings VALUES (40, 4, 2, '06/17/2023', 'rebag RAM');
INSERT INTO public.released_packagings VALUES (41, 4, 50, '06/14/2023', 'piglet booster');
INSERT INTO public.released_packagings VALUES (42, 4, 1979, '06/19/2023', 'for perfecto');
INSERT INTO public.released_packagings VALUES (43, 3, 1, '06/21/2023', 'rebag solenn');
INSERT INTO public.released_packagings VALUES (44, 2, 320, '06/23/2023', 'liner for stag dev');


--
-- TOC entry 3399 (class 0 OID 16432)
-- Dependencies: 221
-- Data for Name: repro_products; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.repro_products VALUES (1, 4, 1, 'wrecked packaging');
INSERT INTO public.repro_products VALUES (2, 1, 1, 'returned by Sir Elmer Antallan');
INSERT INTO public.repro_products VALUES (3, 1, 1, 'wrecked packaging');
INSERT INTO public.repro_products VALUES (4, 1, 1, 'wrecked packaging');
INSERT INTO public.repro_products VALUES (5, 4, 1, 'wrecked packaging');
INSERT INTO public.repro_products VALUES (6, 7, 71, 'Failed quality');


--
-- TOC entry 3401 (class 0 OID 16438)
-- Dependencies: 223
-- Data for Name: returned_packagings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.returned_packagings VALUES (2, 5, 55, '05/19/2023');
INSERT INTO public.returned_packagings VALUES (3, 1, 869, '05/20/2023');
INSERT INTO public.returned_packagings VALUES (5, 4, 23, '05/20/2023');
INSERT INTO public.returned_packagings VALUES (6, 4, 325, '05/24/2023');
INSERT INTO public.returned_packagings VALUES (7, 4, 145, '05/29/2023');
INSERT INTO public.returned_packagings VALUES (8, 4, 242, '05/31/2023');
INSERT INTO public.returned_packagings VALUES (9, 3, 11, '06/14/2023');
INSERT INTO public.returned_packagings VALUES (10, 4, 30, '06/15/2023');
INSERT INTO public.returned_packagings VALUES (11, 4, 1027, '06/23/2023');


--
-- TOC entry 3403 (class 0 OID 16444)
-- Dependencies: 225
-- Data for Name: sales_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sales_items VALUES (67, 1, 100, 115);
INSERT INTO public.sales_items VALUES (68, 1, 40, 116);
INSERT INTO public.sales_items VALUES (69, 1, 30, 117);
INSERT INTO public.sales_items VALUES (69, 2, 1, 118);
INSERT INTO public.sales_items VALUES (70, 1, 75, 119);
INSERT INTO public.sales_items VALUES (70, 2, 20, 120);
INSERT INTO public.sales_items VALUES (71, 17, 80, 121);
INSERT INTO public.sales_items VALUES (71, 19, 20, 122);
INSERT INTO public.sales_items VALUES (72, 1, 40, 123);
INSERT INTO public.sales_items VALUES (40, 1, 35, 67);
INSERT INTO public.sales_items VALUES (40, 2, 6, 68);
INSERT INTO public.sales_items VALUES (40, 6, 1, 69);
INSERT INTO public.sales_items VALUES (41, 1, 14, 70);
INSERT INTO public.sales_items VALUES (41, 2, 7, 71);
INSERT INTO public.sales_items VALUES (42, 1, 13, 72);
INSERT INTO public.sales_items VALUES (42, 2, 6, 73);
INSERT INTO public.sales_items VALUES (42, 3, 2, 74);
INSERT INTO public.sales_items VALUES (43, 1, 30, 75);
INSERT INTO public.sales_items VALUES (43, 2, 15, 76);
INSERT INTO public.sales_items VALUES (44, 1, 85, 77);
INSERT INTO public.sales_items VALUES (45, 1, 25, 78);
INSERT INTO public.sales_items VALUES (46, 4, 18, 79);
INSERT INTO public.sales_items VALUES (47, 1, 40, 80);
INSERT INTO public.sales_items VALUES (47, 2, 4, 81);
INSERT INTO public.sales_items VALUES (48, 4, 2, 82);
INSERT INTO public.sales_items VALUES (49, 1, 18, 83);
INSERT INTO public.sales_items VALUES (50, 1, 946, 84);
INSERT INTO public.sales_items VALUES (50, 3, 20, 85);
INSERT INTO public.sales_items VALUES (28, 1, 40, 31);
INSERT INTO public.sales_items VALUES (28, 2, 10, 32);
INSERT INTO public.sales_items VALUES (51, 1, 30, 86);
INSERT INTO public.sales_items VALUES (52, 15, 938, 87);
INSERT INTO public.sales_items VALUES (52, 4, 150, 88);
INSERT INTO public.sales_items VALUES (52, 14, 38, 89);
INSERT INTO public.sales_items VALUES (32, 1, 20, 37);
INSERT INTO public.sales_items VALUES (32, 6, 10, 38);
INSERT INTO public.sales_items VALUES (53, 1, 40, 90);
INSERT INTO public.sales_items VALUES (53, 2, 10, 91);
INSERT INTO public.sales_items VALUES (53, 3, 5, 92);
INSERT INTO public.sales_items VALUES (54, 1, 20, 93);
INSERT INTO public.sales_items VALUES (55, 1, 32, 94);
INSERT INTO public.sales_items VALUES (55, 2, 6, 95);
INSERT INTO public.sales_items VALUES (56, 16, 112, 96);
INSERT INTO public.sales_items VALUES (57, 1, 20, 97);
INSERT INTO public.sales_items VALUES (57, 3, 2, 98);
INSERT INTO public.sales_items VALUES (58, 1, 17, 99);
INSERT INTO public.sales_items VALUES (58, 3, 1, 100);
INSERT INTO public.sales_items VALUES (58, 2, 1, 101);
INSERT INTO public.sales_items VALUES (59, 8, 280, 102);
INSERT INTO public.sales_items VALUES (60, 1, 20, 103);
INSERT INTO public.sales_items VALUES (61, 1, 40, 104);
INSERT INTO public.sales_items VALUES (62, 4, 50, 105);
INSERT INTO public.sales_items VALUES (63, 1, 30, 106);
INSERT INTO public.sales_items VALUES (63, 2, 5, 107);
INSERT INTO public.sales_items VALUES (37, 1, 20, 51);
INSERT INTO public.sales_items VALUES (37, 6, 1, 52);
INSERT INTO public.sales_items VALUES (64, 1, 22, 108);
INSERT INTO public.sales_items VALUES (65, 1, 50, 109);
INSERT INTO public.sales_items VALUES (65, 2, 20, 110);
INSERT INTO public.sales_items VALUES (65, 6, 12, 111);
INSERT INTO public.sales_items VALUES (66, 17, 208, 112);
INSERT INTO public.sales_items VALUES (66, 18, 320, 113);
INSERT INTO public.sales_items VALUES (66, 19, 160, 114);
INSERT INTO public.sales_items VALUES (72, 6, 1, 124);
INSERT INTO public.sales_items VALUES (73, 1, 791, 125);
INSERT INTO public.sales_items VALUES (73, 2, 50, 126);
INSERT INTO public.sales_items VALUES (74, 1, 18, 128);
INSERT INTO public.sales_items VALUES (73, 3, 100, 127);
INSERT INTO public.sales_items VALUES (75, 1, 50, 129);
INSERT INTO public.sales_items VALUES (76, 1, 30, 130);
INSERT INTO public.sales_items VALUES (76, 2, 10, 131);
INSERT INTO public.sales_items VALUES (76, 6, 5, 132);
INSERT INTO public.sales_items VALUES (77, 1, 25, 133);
INSERT INTO public.sales_items VALUES (77, 2, 3, 134);
INSERT INTO public.sales_items VALUES (77, 6, 1, 135);
INSERT INTO public.sales_items VALUES (78, 19, 56, 136);
INSERT INTO public.sales_items VALUES (80, 4, 150, 138);
INSERT INTO public.sales_items VALUES (80, 15, 50, 139);
INSERT INTO public.sales_items VALUES (80, 21, 868, 140);
INSERT INTO public.sales_items VALUES (81, 1, 1, 141);
INSERT INTO public.sales_items VALUES (82, 1, 5, 142);
INSERT INTO public.sales_items VALUES (82, 6, 20, 143);
INSERT INTO public.sales_items VALUES (82, 2, 12, 144);
INSERT INTO public.sales_items VALUES (83, 1, 30, 145);
INSERT INTO public.sales_items VALUES (84, 1, 18, 146);
INSERT INTO public.sales_items VALUES (85, 1, 30, 147);
INSERT INTO public.sales_items VALUES (85, 6, 2, 148);
INSERT INTO public.sales_items VALUES (86, 1, 15, 149);
INSERT INTO public.sales_items VALUES (86, 3, 5, 150);
INSERT INTO public.sales_items VALUES (87, 1, 1, 151);
INSERT INTO public.sales_items VALUES (88, 1, 25, 152);
INSERT INTO public.sales_items VALUES (89, 1, 30, 153);
INSERT INTO public.sales_items VALUES (90, 1, 5, 154);
INSERT INTO public.sales_items VALUES (91, 1, 18, 155);
INSERT INTO public.sales_items VALUES (91, 3, 1, 156);
INSERT INTO public.sales_items VALUES (92, 1, 75, 157);
INSERT INTO public.sales_items VALUES (92, 2, 20, 158);
INSERT INTO public.sales_items VALUES (93, 1, 25, 159);
INSERT INTO public.sales_items VALUES (94, 1, 35, 160);
INSERT INTO public.sales_items VALUES (95, 1, 14, 161);
INSERT INTO public.sales_items VALUES (95, 2, 4, 162);
INSERT INTO public.sales_items VALUES (95, 3, 2, 163);
INSERT INTO public.sales_items VALUES (96, 1, 35, 164);
INSERT INTO public.sales_items VALUES (96, 2, 10, 165);
INSERT INTO public.sales_items VALUES (97, 1, 30, 166);
INSERT INTO public.sales_items VALUES (97, 2, 5, 167);
INSERT INTO public.sales_items VALUES (98, 1, 30, 168);
INSERT INTO public.sales_items VALUES (98, 2, 1, 169);
INSERT INTO public.sales_items VALUES (98, 6, 1, 170);
INSERT INTO public.sales_items VALUES (99, 1, 50, 171);
INSERT INTO public.sales_items VALUES (100, 1, 30, 172);
INSERT INTO public.sales_items VALUES (100, 2, 5, 173);
INSERT INTO public.sales_items VALUES (101, 1, 40, 174);
INSERT INTO public.sales_items VALUES (102, 1, 30, 175);
INSERT INTO public.sales_items VALUES (103, 1, 25, 176);
INSERT INTO public.sales_items VALUES (103, 2, 21, 177);
INSERT INTO public.sales_items VALUES (104, 1, 20, 178);
INSERT INTO public.sales_items VALUES (105, 1, 18, 179);
INSERT INTO public.sales_items VALUES (106, 1, 40, 180);
INSERT INTO public.sales_items VALUES (106, 2, 5, 181);
INSERT INTO public.sales_items VALUES (107, 1, 30, 182);
INSERT INTO public.sales_items VALUES (107, 2, 5, 183);
INSERT INTO public.sales_items VALUES (108, 1, 1, 184);
INSERT INTO public.sales_items VALUES (109, 1, 40, 185);
INSERT INTO public.sales_items VALUES (109, 2, 10, 186);
INSERT INTO public.sales_items VALUES (110, 1, 60, 187);
INSERT INTO public.sales_items VALUES (110, 2, 20, 188);
INSERT INTO public.sales_items VALUES (110, 6, 10, 189);
INSERT INTO public.sales_items VALUES (111, 1, 15, 190);
INSERT INTO public.sales_items VALUES (111, 2, 2, 191);
INSERT INTO public.sales_items VALUES (112, 1, 23, 193);
INSERT INTO public.sales_items VALUES (111, 3, 2, 192);
INSERT INTO public.sales_items VALUES (112, 3, 2, 194);
INSERT INTO public.sales_items VALUES (114, 4, 50, 195);
INSERT INTO public.sales_items VALUES (114, 7, 4, 196);
INSERT INTO public.sales_items VALUES (117, 1, 200, 198);
INSERT INTO public.sales_items VALUES (117, 2, 100, 199);
INSERT INTO public.sales_items VALUES (118, 1, 40, 200);
INSERT INTO public.sales_items VALUES (119, 7, 200, 201);
INSERT INTO public.sales_items VALUES (119, 4, 20, 202);
INSERT INTO public.sales_items VALUES (120, 16, 667, 203);
INSERT INTO public.sales_items VALUES (121, 1, 11, 204);
INSERT INTO public.sales_items VALUES (122, 1, 33, 205);
INSERT INTO public.sales_items VALUES (123, 18, 320, 206);
INSERT INTO public.sales_items VALUES (123, 23, 118, 207);
INSERT INTO public.sales_items VALUES (123, 22, 363, 208);
INSERT INTO public.sales_items VALUES (123, 19, 241, 209);
INSERT INTO public.sales_items VALUES (124, 1, 1, 210);
INSERT INTO public.sales_items VALUES (124, 2, 1, 211);
INSERT INTO public.sales_items VALUES (125, 1, 20, 212);
INSERT INTO public.sales_items VALUES (125, 6, 1, 213);
INSERT INTO public.sales_items VALUES (126, 1, 31, 214);
INSERT INTO public.sales_items VALUES (127, 1, 30, 215);
INSERT INTO public.sales_items VALUES (127, 2, 5, 216);
INSERT INTO public.sales_items VALUES (128, 1, 18, 217);
INSERT INTO public.sales_items VALUES (129, 16, 667, 218);
INSERT INTO public.sales_items VALUES (130, 2, 10, 220);
INSERT INTO public.sales_items VALUES (130, 1, 40, 219);
INSERT INTO public.sales_items VALUES (131, 1, 80, 221);
INSERT INTO public.sales_items VALUES (131, 2, 10, 222);
INSERT INTO public.sales_items VALUES (132, 1, 20, 223);
INSERT INTO public.sales_items VALUES (165, 1, 30, 256);
INSERT INTO public.sales_items VALUES (165, 2, 5, 257);
INSERT INTO public.sales_items VALUES (165, 6, 2, 258);
INSERT INTO public.sales_items VALUES (166, 1, 30, 259);
INSERT INTO public.sales_items VALUES (166, 6, 2, 260);
INSERT INTO public.sales_items VALUES (167, 1, 300, 261);
INSERT INTO public.sales_items VALUES (167, 2, 197, 262);
INSERT INTO public.sales_items VALUES (168, 1, 18, 263);
INSERT INTO public.sales_items VALUES (169, 1, 40, 264);
INSERT INTO public.sales_items VALUES (170, 20, 952, 265);
INSERT INTO public.sales_items VALUES (170, 21, 130, 266);
INSERT INTO public.sales_items VALUES (170, 15, 52, 267);
INSERT INTO public.sales_items VALUES (171, 1, 36, 268);
INSERT INTO public.sales_items VALUES (172, 1, 40, 269);
INSERT INTO public.sales_items VALUES (173, 1, 30, 270);
INSERT INTO public.sales_items VALUES (174, 1, 100, 271);
INSERT INTO public.sales_items VALUES (175, 1, 20, 272);
INSERT INTO public.sales_items VALUES (175, 2, 15, 273);
INSERT INTO public.sales_items VALUES (175, 6, 5, 274);
INSERT INTO public.sales_items VALUES (176, 1, 35, 275);
INSERT INTO public.sales_items VALUES (177, 1, 20, 276);
INSERT INTO public.sales_items VALUES (183, 1, 60, 285);
INSERT INTO public.sales_items VALUES (183, 2, 10, 286);
INSERT INTO public.sales_items VALUES (183, 6, 10, 287);
INSERT INTO public.sales_items VALUES (202, 1, 18, 306);
INSERT INTO public.sales_items VALUES (205, 1, 40, 310);
INSERT INTO public.sales_items VALUES (205, 2, 7, 311);
INSERT INTO public.sales_items VALUES (206, 1, 18, 312);
INSERT INTO public.sales_items VALUES (206, 2, 1, 313);
INSERT INTO public.sales_items VALUES (207, 18, 320, 314);


--
-- TOC entry 3405 (class 0 OID 16448)
-- Dependencies: 227
-- Data for Name: stocks_flow; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3423 (class 0 OID 0)
-- Dependencies: 210
-- Name: delivered_packagings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.delivered_packagings_id_seq', 6, true);


--
-- TOC entry 3424 (class 0 OID 0)
-- Dependencies: 212
-- Name: packagings_packaging_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.packagings_packaging_id_seq', 8, false);


--
-- TOC entry 3425 (class 0 OID 0)
-- Dependencies: 214
-- Name: product_sales_sales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_sales_sales_id_seq', 207, true);


--
-- TOC entry 3426 (class 0 OID 0)
-- Dependencies: 216
-- Name: production_outputs_production_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.production_outputs_production_id_seq', 41, true);


--
-- TOC entry 3427 (class 0 OID 0)
-- Dependencies: 218
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_product_id_seq', 24, true);


--
-- TOC entry 3428 (class 0 OID 0)
-- Dependencies: 220
-- Name: released_packagings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.released_packagings_id_seq', 44, true);


--
-- TOC entry 3429 (class 0 OID 0)
-- Dependencies: 222
-- Name: repro_products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.repro_products_id_seq', 6, true);


--
-- TOC entry 3430 (class 0 OID 0)
-- Dependencies: 224
-- Name: returned_packagings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.returned_packagings_id_seq', 11, true);


--
-- TOC entry 3431 (class 0 OID 0)
-- Dependencies: 226
-- Name: sales_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sales_items_id_seq', 314, true);


--
-- TOC entry 3432 (class 0 OID 0)
-- Dependencies: 228
-- Name: stocks_flow_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stocks_flow_id_seq', 1, false);


--
-- TOC entry 3221 (class 2606 OID 16465)
-- Name: delivered_packagings delivered_packagings_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivered_packagings
    ADD CONSTRAINT delivered_packagings_pk PRIMARY KEY (id);


--
-- TOC entry 3224 (class 2606 OID 16467)
-- Name: packagings packagings_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.packagings
    ADD CONSTRAINT packagings_pk PRIMARY KEY (packaging_id);


--
-- TOC entry 3226 (class 2606 OID 16469)
-- Name: product_sales product_sales_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sales
    ADD CONSTRAINT product_sales_pk PRIMARY KEY (sales_id);


--
-- TOC entry 3228 (class 2606 OID 16471)
-- Name: production_outputs production_outputs_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.production_outputs
    ADD CONSTRAINT production_outputs_pk PRIMARY KEY (production_id);


--
-- TOC entry 3230 (class 2606 OID 16473)
-- Name: products products_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pk PRIMARY KEY (product_id);


--
-- TOC entry 3232 (class 2606 OID 16475)
-- Name: released_packagings released_packagings_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.released_packagings
    ADD CONSTRAINT released_packagings_pk PRIMARY KEY (id);


--
-- TOC entry 3234 (class 2606 OID 16477)
-- Name: repro_products repro_products_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repro_products
    ADD CONSTRAINT repro_products_pk PRIMARY KEY (id);


--
-- TOC entry 3236 (class 2606 OID 16479)
-- Name: returned_packagings returned_packagings_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.returned_packagings
    ADD CONSTRAINT returned_packagings_pk PRIMARY KEY (id);


--
-- TOC entry 3238 (class 2606 OID 16481)
-- Name: sales_items sales_items_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_items
    ADD CONSTRAINT sales_items_pk PRIMARY KEY (sales_item_id);


--
-- TOC entry 3222 (class 1259 OID 16482)
-- Name: packagings_packaging_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX packagings_packaging_id_idx ON public.packagings USING btree (packaging_id);


--
-- TOC entry 3239 (class 1259 OID 16483)
-- Name: stocks_flow_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stocks_flow_id_idx ON public.stocks_flow USING btree (id);


--
-- TOC entry 3240 (class 2606 OID 16484)
-- Name: delivered_packagings delivered_packagings_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivered_packagings
    ADD CONSTRAINT delivered_packagings_fk FOREIGN KEY (packaging_id) REFERENCES public.packagings(packaging_id);


--
-- TOC entry 3241 (class 2606 OID 16489)
-- Name: production_outputs production_outputs_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.production_outputs
    ADD CONSTRAINT production_outputs_fk FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 3242 (class 2606 OID 16494)
-- Name: released_packagings released_packagings_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.released_packagings
    ADD CONSTRAINT released_packagings_fk FOREIGN KEY (packaging_id) REFERENCES public.packagings(packaging_id) ON DELETE CASCADE;


--
-- TOC entry 3243 (class 2606 OID 16499)
-- Name: repro_products repro_products_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repro_products
    ADD CONSTRAINT repro_products_fk FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 3244 (class 2606 OID 16504)
-- Name: returned_packagings returned_packagings_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.returned_packagings
    ADD CONSTRAINT returned_packagings_fk FOREIGN KEY (packaging_id) REFERENCES public.packagings(packaging_id);


--
-- TOC entry 3245 (class 2606 OID 16509)
-- Name: sales_items sales_items_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_items
    ADD CONSTRAINT sales_items_fk FOREIGN KEY (sales_id) REFERENCES public.product_sales(sales_id) ON DELETE CASCADE;


--
-- TOC entry 3246 (class 2606 OID 16514)
-- Name: sales_items sales_items_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_items
    ADD CONSTRAINT sales_items_fk_1 FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 3247 (class 2606 OID 16519)
-- Name: stocks_flow stocks_flow_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stocks_flow
    ADD CONSTRAINT stocks_flow_fk FOREIGN KEY (product_id) REFERENCES public.products(product_id);


-- Completed on 2023-06-24 10:49:45

--
-- PostgreSQL database dump complete
--

