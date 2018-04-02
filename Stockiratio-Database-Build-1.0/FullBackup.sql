-- As of 03/07/2017 15:45:00
--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

	CREATE ROLE android;
	 ALTER ROLE android WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md5355f8f338c97298a9afd5fae0df6d706';
COMMENT ON ROLE android IS 'This account will be used by the android team to interact with the test environment.';
	CREATE ROLE client;
	 ALTER ROLE client WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md5d134162e5dc600b30c58e16532f3ada0';
COMMENT ON ROLE client IS 'This account will be used by the fictional clients of this application to interact with the database.';
	CREATE ROLE postgres;
	 ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;
	CREATE ROLE scho7838;
	 ALTER ROLE scho7838 WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION NOBYPASSRLS CONNECTION LIMIT 1 PASSWORD 'md5fcad782f8ad6927c9c65ff8b50abf10b';
COMMENT ON ROLE scho7838 IS 'User Account for Mary Scholten';
	CREATE ROLE schu0520;
	 ALTER ROLE schu0520 WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION NOBYPASSRLS CONNECTION LIMIT 1 PASSWORD 'md5ffea17107a6144d15f5eba13c4185064';
COMMENT ON ROLE schu0520 IS 'User Account for Will Schultz';
	CREATE ROLE scraper;
	 ALTER ROLE scraper WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md57b8ca975d3ef1fe7cef952bba05b5cf2';
COMMENT ON ROLE scraper IS 'This account will be used by the scraper team to interact with the test environment.';
	CREATE ROLE shos3198;
	 ALTER ROLE shos3198 WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION NOBYPASSRLS CONNECTION LIMIT 1 PASSWORD 'md5f4b438ddb26088ff17096cd8121894ae';
COMMENT ON ROLE shos3198 IS 'User Account for Ayo Shosanya';
	CREATE ROLE webdev;
	 ALTER ROLE webdev WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md5715af38848d1a59ea805a23a9182b363';
COMMENT ON ROLE webdev IS 'This account will be used by the web development team in interacting with this database.';
	CREATE ROLE zhou0119;
	 ALTER ROLE zhou0119 WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION NOBYPASSRLS CONNECTION LIMIT 1 PASSWORD 'md5add836be1cb2296b03bcce65b8cd71c9';
COMMENT ON ROLE zhou0119 IS 'User Account For Chao Zhou';






--
-- Database creation
--

				    CREATE DATABASE "Production" WITH TEMPLATE = template0 OWNER = postgres;
			 REVOKE ALL ON DATABASE "Production" FROM PUBLIC;
			 REVOKE ALL ON DATABASE "Production" FROM postgres;
			  GRANT ALL ON DATABASE "Production" TO postgres;
GRANT CONNECT,TEMPORARY ON DATABASE "Production" TO PUBLIC;
			  GRANT ALL ON DATABASE "Production" TO scho7838 WITH GRANT OPTION;
			  GRANT ALL ON DATABASE "Production" TO schu0520 WITH GRANT OPTION;
			  GRANT ALL ON DATABASE "Production" TO shos3198 WITH GRANT OPTION;
			  GRANT ALL ON DATABASE "Production" TO zhou0119 WITH GRANT OPTION;
		  GRANT CONNECT ON DATABASE "Production" TO android;
		  GRANT CONNECT ON DATABASE "Production" TO scraper;
		  GRANT CONNECT ON DATABASE "Production" TO webdev;
					CREATE DATABASE "Sandbox" WITH TEMPLATE = template0 OWNER = schu0520;
			  GRANT ALL ON DATABASE "Sandbox" TO scho7838 WITH GRANT OPTION;
			  GRANT ALL ON DATABASE "Sandbox" TO schu0520 WITH GRANT OPTION;
			  GRANT ALL ON DATABASE "Sandbox" TO shos3198 WITH GRANT OPTION;
			  GRANT ALL ON DATABASE "Sandbox" TO zhou0119 WITH GRANT OPTION;
		  GRANT CONNECT ON DATABASE "Sandbox" TO android;
		  GRANT CONNECT ON DATABASE "Sandbox" TO scraper;
		  GRANT CONNECT ON DATABASE "Sandbox" TO webdev;
			 REVOKE ALL ON DATABASE template1 FROM PUBLIC;
			 REVOKE ALL ON DATABASE template1 FROM postgres;
			  GRANT ALL ON DATABASE template1 TO postgres;
		  GRANT CONNECT ON DATABASE template1 TO PUBLIC;


\connect "Production"

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.6
-- Dumped by pg_dump version 9.5.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: Production; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE "Production" IS 'This database is used for the production use of the Stockiratio application.';


--
-- Name: stockiratio; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA stockiratio;
 ALTER SCHEMA stockiratio OWNER TO postgres;

--
-- Name: SCHEMA stockiratio; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA stockiratio IS 'This schema will house all tables and functions for the stockiratio application.';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
	   SET search_path = stockiratio, pg_catalog;

--
-- Name: android_logout(character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION android_logout(
	usern character varying) 
	RETURNS boolean
    LANGUAGE plpgsql
    AS 
	$$

	BEGIN
		UPDATE stockiratio.usersession
		   SET session_key = NULL
		 WHERE username = LOWER(usern);
		RETURN TRUE;
	END

	$$;


ALTER FUNCTION stockiratio.android_logout(usern character varying) OWNER TO schu0520;

--
-- Name: android_stock_search(character varying, character varying, character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION android_stock_search(
	info character varying, 
	usern character varying, 
	sessionkey character varying) 
	RETURNS TABLE(
		company_name character varying, 
		stock_symbol character varying, 
		stock_price numeric)
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN
		IF(sessionkey IN (SELECT session_key
							FROM stockiratio.usersession
						   WHERE username = LOWER(usern)))
			THEN
				RETURN QUERY
				SELECT company.name, stock.symbol, stock.price
                  FROM stockiratio.stock
            INNER JOIN stockiratio.company
                 USING(symbol)
                WHERE (UPPER(company.name) LIKE UPPER('%' || info || '%')) 
                   OR (UPPER(stock.symbol) LIKE UPPER('%' || info || '%'));
		END IF;
	END

	$$;


ALTER FUNCTION stockiratio.android_stock_search(info character varying, usern character varying, sessionkey character varying) OWNER TO schu0520;

--
-- Name: android_update_pw(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION android_update_pw(
	usern character varying, 
	oldpw character varying, 
	pw character varying, 
	sessionkey character varying) 
	RETURNS boolean
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN
		IF(sessionkey IN (SELECT session_key
						  FROM stockiratio.usersession
						  WHERE username = LOWER(usern)))
			THEN
				UPDATE stockiratio.account
				   SET user_password = crypt(pw, gen_salt('bf'))
				 WHERE username = LOWER(usern) 
				   AND user_password = crypt(oldpw, user_password);
				RETURN TRUE;
		ELSE
			RETURN FALSE;
		END IF;
	END
	
	$$;


ALTER FUNCTION stockiratio.android_update_pw(usern character varying, oldpw character varying, pw character varying, sessionkey character varying) OWNER TO schu0520;

--
-- Name: android_update_user(character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION android_update_user(
	usern character varying, 
	firstn character varying, 
	lastn character varying, 
	pref character varying, 
	sessionkey character varying) 
	RETURNS boolean
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN
		IF(sessionkey IN (SELECT session_key
							FROM stockiratio.usersession
						   WHERE username = LOWER(usern)))
			THEN
				UPDATE stockiratio.users
				   SET first_name = firstn,
					   last_name = lastn,
					   prefix = pre
				 WHERE username = LOWER(usern);
				RETURN TRUE;
		ELSE
			RETURN FALSE;
		END IF;
	END

	$$;


ALTER FUNCTION stockiratio.android_update_user(usern character varying, firstn character varying, lastn character varying, pref character varying, sessionkey character varying) OWNER TO schu0520;

--
-- Name: android_verify_login(character varying, character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION android_verify_login(
	usern character varying, 
	pw character varying) 
	RETURNS boolean
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN
		IF(LOWER(usern) IN (SELECT usernname
							  FROM stockiratio.account
							 WHERE user_password = crypt(pw, user_password)))
			THEN
			   UPDATE stockiratio.usersession
				  SET session_key = md5(random()::text)
				WHERE username = LOWER(usern);
			   RETURN TRUE;
		ELSE
		   RETURN FALSE;
		END IF;
	END
	
	$$;


ALTER FUNCTION stockiratio.android_verify_login(usern character varying, pw character varying) OWNER TO schu0520;

--
-- Name: android_view_client_info(character varying, character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION android_view_client_info(
	usern character varying, 
	sessionkey character varying) 
	RETURNS TABLE(
		pre character varying, 
		firstn character varying, 
		lastn character varying, 
		usersname character varying)
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN
		IF(sessionkey IN (SELECT session_key
						    FROM stockiratio.usersession
						   WHERE username = LOWER(usern)))
			THEN
				RETURN QUERY
				SELECT prefix, first_name, last_name, username
				  FROM stockiratio.users
				 WHERE username = LOWER(usern);
		END IF;
	END

	$$;


ALTER FUNCTION stockiratio.android_view_client_info(usern character varying, sessionkey character varying) OWNER TO schu0520;

--
-- Name: create_company(character varying, character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION create_company(
	comp character varying, 
	sym character varying) 
	RETURNS boolean
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN
		INSERT INTO stockiratio.company
			VALUES (comp, UPPER(sym));
			 RETURN TRUE;
		EXCEPTION
			WHEN unique_violation 
				THEN RETURN FALSE;
		 
	END

	$$;


ALTER FUNCTION stockiratio.create_company(comp character varying, sym character varying) OWNER TO schu0520;

--
-- Name: create_stock(character varying, character varying, timestamp without time zone, numeric, numeric, numeric, numeric, numeric, numeric, numeric, integer, numeric, numeric, numeric, character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION create_stock(
	comp character varying, 
	sym character varying, 
	dat timestamp without time zone, 
	stockcost numeric, 
	change numeric, 
	changepct numeric, 
	dayhigh numeric, 
	daylow numeric, 
	yearhigh numeric, 
	yearlow numeric, 
	vol integer, 
	div numeric, 
	pe numeric, 
	earnps numeric, 
	ind character varying) 
	RETURNS boolean
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN
	
		IF (UPPER(sym) IN (SELECT symbol
							 FROM stockiratio.company
							WHERE symbol = UPPER(sym) 
						AND UPPER("name") = UPPER(comp))) 
			THEN
				INSERT INTO stockiratio.stock
					 VALUES(UPPER(sym), dat, stockcost, change, changepct, dayhigh, daylow, yearhigh, yearlow, vol, div, pe, earnps, ind);
					 RETURN TRUE;
		ELSE
			INSERT INTO stockiratio.company
				VALUES (comp, UPPER(sym));
			INSERT INTO stockiratio.stock
				 VALUES(UPPER(sym), dat, stockcost, change, changepct, dayhigh, daylow, yearhigh, yearlow, vol, div, pe, earnps, ind);
				 RETURN TRUE;
		END IF;
		EXCEPTION 
			WHEN others 
				THEN RETURN FALSE;
        
	END

	$$;


ALTER FUNCTION stockiratio.create_stock(comp character varying, sym character varying, dat timestamp without time zone, stockcost numeric, change numeric, changepct numeric, dayhigh numeric, daylow numeric, yearhigh numeric, yearlow numeric, vol integer, div numeric, pe numeric, earnps numeric, ind character varying) OWNER TO schu0520;

--
-- Name: create_user(character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION create_user(
	usern character varying, 
	pw character varying, 
	firstn character varying, 
	lastn character varying, 
	pre character varying) 
	RETURNS boolean
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN      
		INSERT INTO stockiratio.users (username, first_name, last_name, prefix)
            VALUES (LOWER(usern), firstn, lastn, pre);
		INSERT INTO stockiratio.account (username, user_password)
            VALUES (LOWER(usern), crypt(pw, gen_salt('bf')));
			 RETURN TRUE;
		EXCEPTION 
			WHEN others 
				THEN RETURN FALSE;
	END

	$$;


ALTER FUNCTION stockiratio.create_user(usern character varying, pw character varying, firstn character varying, lastn character varying, pre character varying) OWNER TO schu0520;

--
-- Name: stock_search(character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION stock_search(
	info character varying) 
	RETURNS TABLE(
		comp_name character varying, 
		stock_symbol character varying, 
		stock_price numeric)
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN
		RETURN QUERY
		SELECT company.name, stock.symbol, stock.price
          FROM stockiratio.stock
	INNER JOIN stockiratio.company
		 USING(symbol)
		WHERE (UPPER(company.name) LIKE UPPER('%' || info || '%')) 
           OR (UPPER(stock.symbol) LIKE UPPER('%' || info || '%'));
	END

	$$;


ALTER FUNCTION stockiratio.stock_search(info character varying) OWNER TO schu0520;

--
-- Name: update_pw(character varying, character varying, character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION update_pw(
	usern character varying, 
	oldpw character varying, 
	pw character varying) 
	RETURNS boolean
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN
		IF(LOWER(usern) IN (SELECT username
							  FROM stockiratio.account
							 WHERE user_password = crypt(oldpw, user_password)))
			THEN
				UPDATE stockiratio.account
				   SET user_password = crypt(pw, gen_salt('bf'))
				 WHERE username = LOWER(usern);
				RETURN TRUE;
		ELSE
			RETURN FALSE;
    END IF;
	END

	$$;


ALTER FUNCTION stockiratio.update_pw(usern character varying, oldpw character varying, pw character varying) OWNER TO schu0520;

--
-- Name: update_user(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION update_user(
	usern character varying, 
	firstn character varying, 
	lastn character varying, 
	pre character varying) 
	RETURNS boolean
    LANGUAGE plpgsql
    AS 
	$$

	BEGIN
		UPDATE stockiratio.users
		   SET first_name = firstn,
			   last_name = lastn,
			   prefix = pre
		 WHERE username = LOWER(usern);
		RETURN TRUE;
	END

	$$;


ALTER FUNCTION stockiratio.update_user(usern character varying, firstn character varying, lastn character varying, pre character varying) OWNER TO schu0520;

--
-- Name: verify_web_login(character varying, character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION verify_web_login(
	usern character varying, 
	pw character varying) 
	RETURNS boolean
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN
		IF(LOWER(usern) IN (SELECT username
							  FROM stockiratio.account
							 WHERE user_password = crypt(pw, user_password)))
			THEN
				RETURN TRUE;
		ELSE
			RETURN FALSE;
		END IF;
	END

	$$;


ALTER FUNCTION stockiratio.verify_web_login(usern character varying, pw character varying) OWNER TO schu0520;

--
-- Name: view_client_info(character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION view_client_info(
	usern character varying) 
	RETURNS TABLE(
		pre character varying, 
		firstn character varying, 
		lastn character varying, 
		usersname character varying)
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN
		RETURN QUERY
		SELECT prefix, first_name, last_name, username
		  FROM stockiratio.users
		 WHERE username = LOWER(usern);
	END

	$$;


ALTER FUNCTION stockiratio.view_client_info(usern character varying) OWNER TO schu0520;
		   SET default_tablespace = '';
		   SET default_with_oids = false;

--
-- Name: account; Type: TABLE; Schema: stockiratio; Owner: schu0520
--

CREATE TABLE account (
	username character varying NOT NULL,
    user_pass character varying NOT NULL,
    session_key character varying
);


ALTER TABLE account OWNER TO schu0520;

--
-- Name: TABLE account; Type: COMMENT; Schema: stockiratio; Owner: schu0520
--

COMMENT ON TABLE account IS 'This table stores account information on a user.';


--
-- Name: company; Type: TABLE; Schema: stockiratio; Owner: schu0520
--

CREATE TABLE company (
    name character varying NOT NULL,
    symbol character varying NOT NULL
);


ALTER TABLE company OWNER TO schu0520;

--
-- Name: TABLE company; Type: COMMENT; Schema: stockiratio; Owner: schu0520
--

COMMENT ON TABLE company IS 'This table will store information on the company.';


--
-- Name: stock; Type: TABLE; Schema: stockiratio; Owner: schu0520
--

CREATE TABLE stock (
    symbol character varying NOT NULL,
    date timestamp without time zone NOT NULL,
    price numeric NOT NULL,
    change numeric,
    change_pct numeric,
    day_high numeric,
    day_low numeric,
    year_high numeric,
    year_low numeric,
    volume integer,
    dividend numeric,
    pe_ratio numeric,
    earn_per_share numeric,
    industry character varying
);


ALTER TABLE stock OWNER TO schu0520;

--
-- Name: TABLE stock; Type: COMMENT; Schema: stockiratio; Owner: schu0520
--

COMMENT ON TABLE stock IS 'This table will store information on company stocks.  This data has the ability to change throughout the day.';


--
-- Name: users; Type: TABLE; Schema: stockiratio; Owner: schu0520
--

CREATE TABLE users (
    username character varying NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    prefix character varying NOT NULL
);


ALTER TABLE users OWNER TO schu0520;

--
-- Name: TABLE users; Type: COMMENT; Schema: stockiratio; Owner: schu0520
--

COMMENT ON TABLE users IS 'This table stores personal information on the user.';


--
-- Name: usersession; Type: VIEW; Schema: stockiratio; Owner: schu0520
--

CREATE VIEW usersession AS
	 SELECT account.username,
			account.session_key
	   FROM account;


ALTER TABLE usersession OWNER TO schu0520;

--
-- Name: VIEW usersession; Type: COMMENT; Schema: stockiratio; Owner: schu0520
--

COMMENT ON VIEW usersession IS 'This view is used to update the session key on login from the proper functions.';


--
-- Data for Name: account; Type: TABLE DATA; Schema: stockiratio; Owner: schu0520
--

COPY account (username, user_pass, session_key) FROM stdin;


--
-- Data for Name: company; Type: TABLE DATA; Schema: stockiratio; Owner: schu0520
--

COPY company (name, symbol) FROM stdin;


--
-- Data for Name: stock; Type: TABLE DATA; Schema: stockiratio; Owner: schu0520
--

COPY stock (symbol, date, price, change, change_pct, day_high, day_low, year_high, year_low, volume, dividend, pe_ratio, earn_per_share, industry) FROM stdin;


--
-- Data for Name: users; Type: TABLE DATA; Schema: stockiratio; Owner: schu0520
--

COPY users (username, first_name, last_name, prefix) FROM stdin;


--
-- Name: company_pkey; Type: CONSTRAINT; Schema: stockiratio; Owner: schu0520
--

ALTER TABLE ONLY company
  ADD CONSTRAINT company_pkey PRIMARY KEY (symbol);


--
-- Name: stock_pkey; Type: CONSTRAINT; Schema: stockiratio; Owner: schu0520
--

ALTER TABLE ONLY stock
  ADD CONSTRAINT stock_pkey PRIMARY KEY (symbol, date);


--
-- Name: unique_stock; Type: CONSTRAINT; Schema: stockiratio; Owner: schu0520
--

ALTER TABLE ONLY stock
  ADD CONSTRAINT unique_stock UNIQUE (symbol, date);


--
-- Name: unique_username; Type: CONSTRAINT; Schema: stockiratio; Owner: schu0520
--

ALTER TABLE ONLY users
  ADD CONSTRAINT unique_username UNIQUE (username);


--
-- Name: uniquesymbol; Type: CONSTRAINT; Schema: stockiratio; Owner: schu0520
--

ALTER TABLE ONLY company
  ADD CONSTRAINT uniquesymbol UNIQUE (symbol);


--
-- Name: uniqueusername; Type: CONSTRAINT; Schema: stockiratio; Owner: schu0520
--

ALTER TABLE ONLY account
  ADD CONSTRAINT uniqueusername UNIQUE (username);


--
-- Name: username; Type: CONSTRAINT; Schema: stockiratio; Owner: schu0520
--

ALTER TABLE ONLY users
  ADD CONSTRAINT username PRIMARY KEY (username);


--
-- Name: CONSTRAINT username ON users; Type: COMMENT; Schema: stockiratio; Owner: schu0520
--

COMMENT ON CONSTRAINT username ON users IS 'Usernames cannot be be the same as another person''s username.';


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
 GRANT ALL ON SCHEMA public TO postgres;
 GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: stockiratio; Type: ACL; Schema: -; Owner: postgres
--

 REVOKE ALL ON SCHEMA stockiratio FROM PUBLIC;
 REVOKE ALL ON SCHEMA stockiratio FROM postgres;
  GRANT ALL ON SCHEMA stockiratio TO postgres;
  GRANT ALL ON SCHEMA stockiratio TO scho7838 WITH GRANT OPTION;
  GRANT ALL ON SCHEMA stockiratio TO schu0520 WITH GRANT OPTION;
  GRANT ALL ON SCHEMA stockiratio TO shos3198 WITH GRANT OPTION;
  GRANT ALL ON SCHEMA stockiratio TO zhou0119 WITH GRANT OPTION;
GRANT USAGE ON SCHEMA stockiratio TO webdev;
GRANT USAGE ON SCHEMA stockiratio TO android;
GRANT USAGE ON SCHEMA stockiratio TO scraper;


--
-- Name: android_logout(character varying); Type: ACL; Schema: stockiratio; Owner: schu0520
--

REVOKE ALL ON FUNCTION android_logout(usern character varying) FROM PUBLIC;
 GRANT ALL ON FUNCTION android_logout(usern character varying) TO android;
 GRANT ALL ON FUNCTION android_logout(usern character varying) TO scraper;
 GRANT ALL ON FUNCTION android_logout(usern character varying) TO scho7838 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION android_logout(usern character varying) TO shos3198 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION android_logout(usern character varying) TO zhou0119 WITH GRANT OPTION;


--
-- Name: android_stock_search(character varying, character varying, character varying); Type: ACL; Schema: stockiratio; Owner: schu0520
--

REVOKE ALL ON FUNCTION android_stock_search(info character varying, usern character varying, sessionkey character varying) FROM PUBLIC;
 GRANT ALL ON FUNCTION android_stock_search(info character varying, usern character varying, sessionkey character varying) TO PUBLIC;
 GRANT ALL ON FUNCTION android_stock_search(info character varying, usern character varying, sessionkey character varying) TO zhou0119 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION android_stock_search(info character varying, usern character varying, sessionkey character varying) TO scho7838 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION android_stock_search(info character varying, usern character varying, sessionkey character varying) TO android;
 GRANT ALL ON FUNCTION android_stock_search(info character varying, usern character varying, sessionkey character varying) TO scraper;
 GRANT ALL ON FUNCTION android_stock_search(info character varying, usern character varying, sessionkey character varying) TO shos3198 WITH GRANT OPTION;


--
-- Name: android_update_pw(character varying, character varying, character varying, character varying); Type: ACL; Schema: stockiratio; Owner: schu0520
--

REVOKE ALL ON FUNCTION android_update_pw(usern character varying, oldpw character varying, pw character varying, sessionkey character varying) FROM PUBLIC;
 GRANT ALL ON FUNCTION android_update_pw(usern character varying, oldpw character varying, pw character varying, sessionkey character varying) TO android;
 GRANT ALL ON FUNCTION android_update_pw(usern character varying, oldpw character varying, pw character varying, sessionkey character varying) TO scraper;
 GRANT ALL ON FUNCTION android_update_pw(usern character varying, oldpw character varying, pw character varying, sessionkey character varying) TO scho7838 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION android_update_pw(usern character varying, oldpw character varying, pw character varying, sessionkey character varying) TO shos3198 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION android_update_pw(usern character varying, oldpw character varying, pw character varying, sessionkey character varying) TO zhou0119 WITH GRANT OPTION;


--
-- Name: android_verify_login(character varying, character varying); Type: ACL; Schema: stockiratio; Owner: schu0520
--

REVOKE ALL ON FUNCTION android_verify_login(usern character varying, pw character varying) FROM PUBLIC;
 GRANT ALL ON FUNCTION android_verify_login(usern character varying, pw character varying) TO android;
 GRANT ALL ON FUNCTION android_verify_login(usern character varying, pw character varying) TO scho7838 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION android_verify_login(usern character varying, pw character varying) TO scraper;
 GRANT ALL ON FUNCTION android_verify_login(usern character varying, pw character varying) TO shos3198 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION android_verify_login(usern character varying, pw character varying) TO zhou0119 WITH GRANT OPTION;


--
-- Name: android_view_client_info(character varying, character varying); Type: ACL; Schema: stockiratio; Owner: schu0520
--

REVOKE ALL ON FUNCTION android_view_client_info(usern character varying, sessionkey character varying) FROM PUBLIC;
 GRANT ALL ON FUNCTION android_view_client_info(usern character varying, sessionkey character varying) TO PUBLIC;
 GRANT ALL ON FUNCTION android_view_client_info(usern character varying, sessionkey character varying) TO zhou0119 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION android_view_client_info(usern character varying, sessionkey character varying) TO scho7838 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION android_view_client_info(usern character varying, sessionkey character varying) TO android;
 GRANT ALL ON FUNCTION android_view_client_info(usern character varying, sessionkey character varying) TO scraper;
 GRANT ALL ON FUNCTION android_view_client_info(usern character varying, sessionkey character varying) TO shos3198 WITH GRANT OPTION;


--
-- Name: create_company(character varying, character varying); Type: ACL; Schema: stockiratio; Owner: schu0520
--

REVOKE ALL ON FUNCTION create_company(comp character varying, sym character varying) FROM PUBLIC;
 GRANT ALL ON FUNCTION create_company(comp character varying, sym character varying) TO scho7838 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION create_company(comp character varying, sym character varying) TO shos3198 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION create_company(comp character varying, sym character varying) TO zhou0119 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION create_company(comp character varying, sym character varying) TO scraper;


--
-- Name: create_stock(character varying, character varying, timestamp without time zone, numeric, numeric, numeric, numeric, numeric, numeric, numeric, integer, numeric, numeric, numeric, character varying); Type: ACL; Schema: stockiratio; Owner: schu0520
--

REVOKE ALL ON FUNCTION create_stock(comp character varying, sym character varying, dat timestamp without time zone, stockcost numeric, change numeric, changepct numeric, dayhigh numeric, daylow numeric, yearhigh numeric, yearlow numeric, vol integer, div numeric, pe numeric, earnps numeric, ind character varying) FROM PUBLIC;
 GRANT ALL ON FUNCTION create_stock(comp character varying, sym character varying, dat timestamp without time zone, stockcost numeric, change numeric, changepct numeric, dayhigh numeric, daylow numeric, yearhigh numeric, yearlow numeric, vol integer, div numeric, pe numeric, earnps numeric, ind character varying) TO scho7838 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION create_stock(comp character varying, sym character varying, dat timestamp without time zone, stockcost numeric, change numeric, changepct numeric, dayhigh numeric, daylow numeric, yearhigh numeric, yearlow numeric, vol integer, div numeric, pe numeric, earnps numeric, ind character varying) TO shos3198 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION create_stock(comp character varying, sym character varying, dat timestamp without time zone, stockcost numeric, change numeric, changepct numeric, dayhigh numeric, daylow numeric, yearhigh numeric, yearlow numeric, vol integer, div numeric, pe numeric, earnps numeric, ind character varying) TO scraper;
 GRANT ALL ON FUNCTION create_stock(comp character varying, sym character varying, dat timestamp without time zone, stockcost numeric, change numeric, changepct numeric, dayhigh numeric, daylow numeric, yearhigh numeric, yearlow numeric, vol integer, div numeric, pe numeric, earnps numeric, ind character varying) TO zhou0119 WITH GRANT OPTION;


--
-- Name: stock_search(character varying); Type: ACL; Schema: stockiratio; Owner: schu0520
--

REVOKE ALL ON FUNCTION stock_search(info character varying) FROM PUBLIC;
 GRANT ALL ON FUNCTION stock_search(info character varying) TO webdev;
 GRANT ALL ON FUNCTION stock_search(info character varying) TO scho7838 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION stock_search(info character varying) TO shos3198 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION stock_search(info character varying) TO zhou0119 WITH GRANT OPTION;


--
-- Name: update_pw(character varying, character varying, character varying); Type: ACL; Schema: stockiratio; Owner: schu0520
--

REVOKE ALL ON FUNCTION update_pw(usern character varying, oldpw character varying, pw character varying) FROM PUBLIC;
 GRANT ALL ON FUNCTION update_pw(usern character varying, oldpw character varying, pw character varying) TO scho7838 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION update_pw(usern character varying, oldpw character varying, pw character varying) TO shos3198 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION update_pw(usern character varying, oldpw character varying, pw character varying) TO zhou0119 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION update_pw(usern character varying, oldpw character varying, pw character varying) TO webdev;


--
-- Name: verify_web_login(character varying, character varying); Type: ACL; Schema: stockiratio; Owner: schu0520
--

REVOKE ALL ON FUNCTION verify_web_login(usern character varying, pw character varying) FROM PUBLIC;
 GRANT ALL ON FUNCTION verify_web_login(usern character varying, pw character varying) TO scho7838 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION verify_web_login(usern character varying, pw character varying) TO shos3198 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION verify_web_login(usern character varying, pw character varying) TO zhou0119 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION verify_web_login(usern character varying, pw character varying) TO webdev;


--
-- Name: view_client_info(character varying); Type: ACL; Schema: stockiratio; Owner: schu0520
--

REVOKE ALL ON FUNCTION view_client_info(usern character varying) FROM PUBLIC;
 GRANT ALL ON FUNCTION view_client_info(usern character varying) TO PUBLIC;
 GRANT ALL ON FUNCTION view_client_info(usern character varying) TO zhou0119 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION view_client_info(usern character varying) TO webdev;
 GRANT ALL ON FUNCTION view_client_info(usern character varying) TO scho7838 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION view_client_info(usern character varying) TO shos3198 WITH GRANT OPTION;


--
-- Name: account; Type: ACL; Schema: stockiratio; Owner: schu0520
--

				REVOKE ALL ON TABLE account FROM PUBLIC;
GRANT SELECT,INSERT,UPDATE ON TABLE account TO android;
GRANT SELECT,INSERT,UPDATE ON TABLE account TO webdev;
				 GRANT ALL ON TABLE account TO scho7838 WITH GRANT OPTION;
				 GRANT ALL ON TABLE account TO shos3198 WITH GRANT OPTION;
				 GRANT ALL ON TABLE account TO zhou0119 WITH GRANT OPTION;
GRANT SELECT,INSERT,UPDATE ON TABLE account TO scraper;


--
-- Name: company; Type: ACL; Schema: stockiratio; Owner: schu0520
--

		 REVOKE ALL ON TABLE company FROM PUBLIC;
	   GRANT SELECT ON TABLE company TO client;
		  GRANT ALL ON TABLE company TO scho7838 WITH GRANT OPTION;
		  GRANT ALL ON TABLE company TO shos3198 WITH GRANT OPTION;
		  GRANT ALL ON TABLE company TO zhou0119 WITH GRANT OPTION;
GRANT SELECT,INSERT ON TABLE company TO scraper;


--
-- Name: stock; Type: ACL; Schema: stockiratio; Owner: schu0520
--

		 REVOKE ALL ON TABLE stock FROM PUBLIC;
GRANT SELECT,INSERT ON TABLE stock TO scraper;
	   GRANT SELECT ON TABLE stock TO client;
		  GRANT ALL ON TABLE stock TO scho7838 WITH GRANT OPTION;
		  GRANT ALL ON TABLE stock TO shos3198 WITH GRANT OPTION;
		  GRANT ALL ON TABLE stock TO zhou0119 WITH GRANT OPTION;


--
-- Name: users; Type: ACL; Schema: stockiratio; Owner: schu0520
--

				REVOKE ALL ON TABLE users FROM PUBLIC;
				 GRANT ALL ON TABLE users TO scho7838 WITH GRANT OPTION;
				 GRANT ALL ON TABLE users TO shos3198 WITH GRANT OPTION;
				 GRANT ALL ON TABLE users TO zhou0119 WITH GRANT OPTION;
GRANT SELECT,INSERT,UPDATE ON TABLE users TO android;
GRANT SELECT,INSERT,UPDATE ON TABLE users TO webdev;
			  GRANT SELECT ON TABLE users TO client;
GRANT SELECT,INSERT,UPDATE ON TABLE users TO scraper;


--
-- Name: usersession; Type: ACL; Schema: stockiratio; Owner: schu0520
--

		 REVOKE ALL ON TABLE usersession FROM PUBLIC;
		  GRANT ALL ON TABLE usersession TO scho7838 WITH GRANT OPTION;
		  GRANT ALL ON TABLE usersession TO shos3198 WITH GRANT OPTION;
		  GRANT ALL ON TABLE usersession TO zhou0119 WITH GRANT OPTION;
GRANT SELECT,UPDATE ON TABLE usersession TO android;
GRANT SELECT,UPDATE ON TABLE usersession TO scraper;


--
-- PostgreSQL database dump complete
--

\connect "Sandbox"

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.6
-- Dumped by pg_dump version 9.5.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: Sandbox; Type: COMMENT; Schema: -; Owner: schu0520
--

COMMENT ON DATABASE "Sandbox" IS 'This database is a replica of the Production database.';


--
-- Name: stockiratio; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA stockiratio;
 ALTER SCHEMA stockiratio OWNER TO postgres;

--
-- Name: SCHEMA stockiratio; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA stockiratio IS 'This schema will house all tables and functions for the stockiratio application.';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
	   SET search_path = public, pg_catalog;

--
-- Name: android_logout(character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION android_logout(
	usern character varying) 
	RETURNS boolean
    LANGUAGE plpgsql
    AS 
	$$

	BEGIN
		UPDATE stockiratio.usersession
		   SET session_key = NULL
		 WHERE username = LOWER(usern);
		RETURN TRUE;
	END

	$$;


ALTER FUNCTION stockiratio.android_logout(usern character varying) OWNER TO schu0520;

--
-- Name: android_stock_search(character varying, character varying, character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION android_stock_search(
	info character varying, 
	usern character varying, 
	sessionkey character varying) 
	RETURNS TABLE(
		company_name character varying, 
		stock_symbol character varying, 
		stock_price numeric)
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN
		IF(sessionkey IN (SELECT session_key
							FROM stockiratio.usersession
						   WHERE username = LOWER(usern)))
			THEN
				RETURN QUERY
				SELECT company.name, stock.symbol, stock.price
                  FROM stockiratio.stock
            INNER JOIN stockiratio.company
                 USING(symbol)
                WHERE (UPPER(company.name) LIKE UPPER('%' || info || '%')) 
                   OR (UPPER(stock.symbol) LIKE UPPER('%' || info || '%'));
		END IF;
	END

	$$;


ALTER FUNCTION stockiratio.android_stock_search(info character varying, usern character varying, sessionkey character varying) OWNER TO schu0520;

--
-- Name: android_update_pw(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION android_update_pw(
	usern character varying, 
	oldpw character varying, 
	pw character varying, 
	sessionkey character varying) 
	RETURNS boolean
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN
		IF(sessionkey IN (SELECT session_key
						  FROM stockiratio.usersession
						  WHERE username = LOWER(usern)))
			THEN
				UPDATE stockiratio.account
				   SET user_password = crypt(pw, gen_salt('bf'))
				 WHERE username = LOWER(usern) 
				   AND user_password = crypt(oldpw, user_password);
				RETURN TRUE;
		ELSE
			RETURN FALSE;
		END IF;
	END
	
	$$;


ALTER FUNCTION stockiratio.android_update_pw(usern character varying, oldpw character varying, pw character varying, sessionkey character varying) OWNER TO schu0520;

--
-- Name: android_update_user(character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION android_update_user(
	usern character varying, 
	firstn character varying, 
	lastn character varying, 
	pref character varying, 
	sessionkey character varying) 
	RETURNS boolean
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN
		IF(sessionkey IN (SELECT session_key
							FROM stockiratio.usersession
						   WHERE username = LOWER(usern)))
			THEN
				UPDATE stockiratio.users
				   SET first_name = firstn,
					   last_name = lastn,
					   prefix = pre
				 WHERE username = LOWER(usern);
				RETURN TRUE;
		ELSE
			RETURN FALSE;
		END IF;
	END

	$$;


ALTER FUNCTION stockiratio.android_update_user(usern character varying, firstn character varying, lastn character varying, pref character varying, sessionkey character varying) OWNER TO schu0520;

--
-- Name: android_verify_login(character varying, character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION android_verify_login(
	usern character varying, 
	pw character varying) 
	RETURNS boolean
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN
		IF(LOWER(usern) IN (SELECT usernname
							  FROM stockiratio.account
							 WHERE user_password = crypt(pw, user_password)))
			THEN
			   UPDATE stockiratio.usersession
				  SET session_key = md5(random()::text)
				WHERE username = LOWER(usern);
			   RETURN TRUE;
		ELSE
		   RETURN FALSE;
		END IF;
	END
	
	$$;


ALTER FUNCTION stockiratio.android_verify_login(usern character varying, pw character varying) OWNER TO schu0520;

--
-- Name: android_view_client_info(character varying, character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION android_view_client_info(
	usern character varying, 
	sessionkey character varying) 
	RETURNS TABLE(
		pre character varying, 
		firstn character varying, 
		lastn character varying, 
		usersname character varying)
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN
		IF(sessionkey IN (SELECT session_key
						    FROM stockiratio.usersession
						   WHERE username = LOWER(usern)))
			THEN
				RETURN QUERY
				SELECT prefix, first_name, last_name, username
				  FROM stockiratio.users
				 WHERE username = LOWER(usern);
		END IF;
	END

	$$;


ALTER FUNCTION stockiratio.android_view_client_info(usern character varying, sessionkey character varying) OWNER TO schu0520;

--
-- Name: create_company(character varying, character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION create_company(
	comp character varying, 
	sym character varying) 
	RETURNS boolean
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN
		INSERT INTO stockiratio.company
			VALUES (comp, UPPER(sym));
			 RETURN TRUE;
		EXCEPTION
			WHEN unique_violation 
				THEN RETURN FALSE;
		 
	END

	$$;


ALTER FUNCTION stockiratio.create_company(comp character varying, sym character varying) OWNER TO schu0520;

--
-- Name: create_stock(character varying, character varying, timestamp without time zone, numeric, numeric, numeric, numeric, numeric, numeric, numeric, integer, numeric, numeric, numeric, character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION create_stock(
	comp character varying, 
	sym character varying, 
	dat timestamp without time zone, 
	stockcost numeric, 
	change numeric, 
	changepct numeric, 
	dayhigh numeric, 
	daylow numeric, 
	yearhigh numeric, 
	yearlow numeric, 
	vol integer, 
	div numeric, 
	pe numeric, 
	earnps numeric, 
	ind character varying) 
	RETURNS boolean
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN
	
		IF (UPPER(sym) IN (SELECT symbol
							 FROM stockiratio.company
							WHERE symbol = UPPER(sym) 
						AND UPPER("name") = UPPER(comp))) 
			THEN
				INSERT INTO stockiratio.stock
					 VALUES(UPPER(sym), dat, stockcost, change, changepct, dayhigh, daylow, yearhigh, yearlow, vol, div, pe, earnps, ind);
					 RETURN TRUE;
		ELSE
			INSERT INTO stockiratio.company
				VALUES (comp, UPPER(sym));
			INSERT INTO stockiratio.stock
				 VALUES(UPPER(sym), dat, stockcost, change, changepct, dayhigh, daylow, yearhigh, yearlow, vol, div, pe, earnps, ind);
				 RETURN TRUE;
		END IF;
		EXCEPTION 
			WHEN others 
				THEN RETURN FALSE;
        
	END

	$$;


ALTER FUNCTION stockiratio.create_stock(comp character varying, sym character varying, dat timestamp without time zone, stockcost numeric, change numeric, changepct numeric, dayhigh numeric, daylow numeric, yearhigh numeric, yearlow numeric, vol integer, div numeric, pe numeric, earnps numeric, ind character varying) OWNER TO schu0520;

--
-- Name: create_user(character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION create_user(
	usern character varying, 
	pw character varying, 
	firstn character varying, 
	lastn character varying, 
	pre character varying) 
	RETURNS boolean
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN      
		INSERT INTO stockiratio.users (username, first_name, last_name, prefix)
            VALUES (LOWER(usern), firstn, lastn, pre);
		INSERT INTO stockiratio.account (username, user_password)
            VALUES (LOWER(usern), crypt(pw, gen_salt('bf')));
			 RETURN TRUE;
		EXCEPTION 
			WHEN others 
				THEN RETURN FALSE;
	END

	$$;


ALTER FUNCTION stockiratio.create_user(usern character varying, pw character varying, firstn character varying, lastn character varying, pre character varying) OWNER TO schu0520;

--
-- Name: stock_search(character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION stock_search(
	info character varying) 
	RETURNS TABLE(
		comp_name character varying, 
		stock_symbol character varying, 
		stock_price numeric)
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN
		RETURN QUERY
		SELECT company.name, stock.symbol, stock.price
          FROM stockiratio.stock
	INNER JOIN stockiratio.company
		 USING(symbol)
		WHERE (UPPER(company.name) LIKE UPPER('%' || info || '%')) 
           OR (UPPER(stock.symbol) LIKE UPPER('%' || info || '%'));
	END

	$$;


ALTER FUNCTION stockiratio.stock_search(info character varying) OWNER TO schu0520;

--
-- Name: update_pw(character varying, character varying, character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION update_pw(
	usern character varying, 
	oldpw character varying, 
	pw character varying) 
	RETURNS boolean
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN
		IF(LOWER(usern) IN (SELECT username
							  FROM stockiratio.account
							 WHERE user_password = crypt(oldpw, user_password)))
			THEN
				UPDATE stockiratio.account
				   SET user_password = crypt(pw, gen_salt('bf'))
				 WHERE username = LOWER(usern);
				RETURN TRUE;
		ELSE
			RETURN FALSE;
    END IF;
	END

	$$;


ALTER FUNCTION stockiratio.update_pw(usern character varying, oldpw character varying, pw character varying) OWNER TO schu0520;

--
-- Name: update_user(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION update_user(
	usern character varying, 
	firstn character varying, 
	lastn character varying, 
	pre character varying) 
	RETURNS boolean
    LANGUAGE plpgsql
    AS 
	$$

	BEGIN
		UPDATE stockiratio.users
		   SET first_name = firstn,
			   last_name = lastn,
			   prefix = pre
		 WHERE username = LOWER(usern);
		RETURN TRUE;
	END

	$$;


ALTER FUNCTION stockiratio.update_user(usern character varying, firstn character varying, lastn character varying, pre character varying) OWNER TO schu0520;

--
-- Name: verify_web_login(character varying, character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION verify_web_login(
	usern character varying, 
	pw character varying) 
	RETURNS boolean
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN
		IF(LOWER(usern) IN (SELECT username
							  FROM stockiratio.account
							 WHERE user_password = crypt(pw, user_password)))
			THEN
				RETURN TRUE;
		ELSE
			RETURN FALSE;
		END IF;
	END

	$$;


ALTER FUNCTION stockiratio.verify_web_login(usern character varying, pw character varying) OWNER TO schu0520;

--
-- Name: view_client_info(character varying); Type: FUNCTION; Schema: stockiratio; Owner: schu0520
--

CREATE FUNCTION view_client_info(
	usern character varying) 
	RETURNS TABLE(
		pre character varying, 
		firstn character varying, 
		lastn character varying, 
		usersname character varying)
    LANGUAGE plpgsql
    AS 
	$$
	
	BEGIN
		RETURN QUERY
		SELECT prefix, first_name, last_name, username
		  FROM stockiratio.users
		 WHERE username = LOWER(usern);
	END

	$$;


ALTER FUNCTION stockiratio.view_client_info(usern character varying) OWNER TO schu0520;
		   SET default_tablespace = '';
		   SET default_with_oids = false;

--
-- Name: account; Type: TABLE; Schema: stockiratio; Owner: schu0520
--

CREATE TABLE account (
    username character varying NOT NULL,
    user_password character varying NOT NULL,
    session_key character varying
);


ALTER TABLE account OWNER TO schu0520;

--
-- Name: TABLE account; Type: COMMENT; Schema: stockiratio; Owner: schu0520
--

COMMENT ON TABLE account IS 'This table stores account information on a user.';


--
-- Name: company; Type: TABLE; Schema: stockiratio; Owner: schu0520
--

CREATE TABLE company (
    name character varying NOT NULL,
    symbol character varying NOT NULL
);


ALTER TABLE company OWNER TO schu0520;

--
-- Name: TABLE company; Type: COMMENT; Schema: stockiratio; Owner: schu0520
--

COMMENT ON TABLE company IS 'This table will store information on the company.';


--
-- Name: stock; Type: TABLE; Schema: stockiratio; Owner: schu0520
--

CREATE TABLE stock (
    symbol character varying NOT NULL,
    date timestamp without time zone NOT NULL,
    price numeric NOT NULL,
    change numeric,
    change_pct numeric,
    day_high numeric,
    day_low numeric,
    year_high numeric,
    year_low numeric,
    volume integer,
    dividend numeric,
    pe_ratio numeric,
    earn_per_share numeric,
    industry character varying
);


ALTER TABLE stock OWNER TO schu0520;

--
-- Name: TABLE stock; Type: COMMENT; Schema: stockiratio; Owner: schu0520
--

COMMENT ON TABLE stock IS 'This table will store information on company stocks.  This data has the ability to change throughout the day.';


--
-- Name: users; Type: TABLE; Schema: stockiratio; Owner: schu0520
--

CREATE TABLE users (
    username character varying NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    prefix character varying NOT NULL
);


ALTER TABLE users OWNER TO schu0520;

--
-- Name: TABLE users; Type: COMMENT; Schema: stockiratio; Owner: schu0520
--

COMMENT ON TABLE users IS 'This table stores personal information on the user.';


--
-- Name: usersession; Type: VIEW; Schema: stockiratio; Owner: schu0520
--

CREATE VIEW usersession AS
	 SELECT account.username,
			account.session_key
	   FROM account;


ALTER TABLE usersession OWNER TO schu0520;

--
-- Name: VIEW usersession; Type: COMMENT; Schema: stockiratio; Owner: schu0520
--

COMMENT ON VIEW usersession IS 'This view is used to update the session key on login from the proper functions.';
			SET search_path = public, pg_catalog;

--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: schu0520
--

COPY account (username, password, session_key) FROM stdin;


--
-- Data for Name: company; Type: TABLE DATA; Schema: public; Owner: schu0520
--

COPY company (name, symbol) FROM stdin;


--
-- Data for Name: stock; Type: TABLE DATA; Schema: public; Owner: schu0520
--

COPY stock (symbol, date, price, change, change_pct, day_high, day_low, year_high, year_low, volume, dividend, pe_ratio, earn_per_share, industry) FROM stdin;


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: schu0520
--

COPY users (username, first_name, last_name, prefix) FROM stdin;
 SET search_path = stockiratio, pg_catalog;

--
-- Data for Name: account; Type: TABLE DATA; Schema: stockiratio; Owner: schu0520
--

COPY account (username, user_password, session_key) FROM stdin;
test1	$2a$06$M7fmiSeoaujNMMwMn.MVUe0P7GM3U0vX3oIzdxhTO6afwflvmGdI2	\N
test2	$2a$06$ks6hUZgfr4eLzcH1F4.r/eBYmkEL1CRtlNPC1fYxeTYlUK1RMdrBW	\N
testing1	$2a$06$A1QI1qN/PITRUQOrZZ4ZY.U6nhjj4RLl33UMyQcmWFwkZrVbGFfam	\N
testing2	$2a$06$IsmCJZSyF4pSuh00b5QzIuK74H7qVNyBVv6zfleNUMogVRW7u2bYu	\N
testing3	$2a$06$JSrGS5IZnYxk7I2weKQD8e3p8yiFRwuG5Wcq07mP7beXoS42zvM9O	\N
testing4	$2a$06$x1RAYrYgpQ8LyQREaXtkpuPsKtmaERm1EY/OvWHZTRlvrjK32PEkq	\N
testing5	$2a$06$V2QBFBPDdOfdXaX4KSjuN.RqR2kkJYRMz.oATtmPKjt3pCHKFBJWO	\N
\.


--
-- Data for Name: company; Type: TABLE DATA; Schema: stockiratio; Owner: schu0520
--

COPY company (name, symbol) FROM stdin;
Apple	AAPL
TEST	BOB
TEST1	BOB1
\.


--
-- Data for Name: stock; Type: TABLE DATA; Schema: stockiratio; Owner: schu0520
--

COPY stock (symbol, date, price, change, change_pct, day_high, day_low, year_high, year_low, volume, dividend, pe_ratio, earn_per_share, industry) FROM stdin;
AAPL	2099-08-03 04:00:00	76.98	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	not sure
BOB	2099-08-03 04:04:00	76.88	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	not sure
BOB	2099-08-04 04:04:00	76.88	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	not sure
BOB	2099-08-05 04:04:00	76.88	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	not sure
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: stockiratio; Owner: schu0520
--

COPY users (username, first_name, last_name, prefix) FROM stdin;
test1	Will	Schultz	Mr.
test2	Will	Schultz	Mr.
testing1	Will	Schultz	Mr.
testing2	Will	Schultz	Mr.
testing3	Will	Schultz	Mr.
testing4	Will	Schultz	Mr.
testing5	Will	Schultz	Mr.
\.


SET search_path = public, pg_catalog;

--
-- Name: company_pkey; Type: CONSTRAINT; Schema: public; Owner: schu0520
--

ALTER TABLE ONLY company
  ADD CONSTRAINT company_pkey PRIMARY KEY (symbol);


--
-- Name: stock_pkey; Type: CONSTRAINT; Schema: public; Owner: schu0520
--

ALTER TABLE ONLY stock
  ADD CONSTRAINT stock_pkey PRIMARY KEY (symbol, date);


--
-- Name: unique_symbol; Type: CONSTRAINT; Schema: public; Owner: schu0520
--

ALTER TABLE ONLY stock
  ADD CONSTRAINT unique_symbol UNIQUE (symbol);


--
-- Name: unique_username; Type: CONSTRAINT; Schema: public; Owner: schu0520
--

ALTER TABLE ONLY users
  ADD CONSTRAINT unique_username UNIQUE (username);


--
-- Name: uniquesymbol; Type: CONSTRAINT; Schema: public; Owner: schu0520
--

ALTER TABLE ONLY company
  ADD CONSTRAINT uniquesymbol UNIQUE (symbol);


--
-- Name: uniqueusername; Type: CONSTRAINT; Schema: public; Owner: schu0520
--

ALTER TABLE ONLY account
  ADD CONSTRAINT uniqueusername UNIQUE (username);


--
-- Name: username; Type: CONSTRAINT; Schema: public; Owner: schu0520
--

ALTER TABLE ONLY users
  ADD CONSTRAINT username PRIMARY KEY (username);


--
-- Name: CONSTRAINT username ON users; Type: COMMENT; Schema: public; Owner: schu0520
--

COMMENT ON CONSTRAINT username ON users IS 'Usernames cannot be be the same as another person''s username.';
				  SET search_path = stockiratio, pg_catalog;

--
-- Name: company_pkey; Type: CONSTRAINT; Schema: stockiratio; Owner: schu0520
--

ALTER TABLE ONLY company
  ADD CONSTRAINT company_pkey PRIMARY KEY (symbol);


--
-- Name: stock_pkey; Type: CONSTRAINT; Schema: stockiratio; Owner: schu0520
--

ALTER TABLE ONLY stock
  ADD CONSTRAINT stock_pkey PRIMARY KEY (symbol, date);


--
-- Name: unique_stock; Type: CONSTRAINT; Schema: stockiratio; Owner: schu0520
--

ALTER TABLE ONLY stock
  ADD CONSTRAINT unique_stock UNIQUE (symbol, date);


--
-- Name: uniqueusername; Type: CONSTRAINT; Schema: stockiratio; Owner: schu0520
--

ALTER TABLE ONLY account
  ADD CONSTRAINT uniqueusername UNIQUE (username);


--
-- Name: username; Type: CONSTRAINT; Schema: stockiratio; Owner: schu0520
--

ALTER TABLE ONLY users
  ADD CONSTRAINT username PRIMARY KEY (username);


--
-- Name: CONSTRAINT username ON users; Type: COMMENT; Schema: stockiratio; Owner: schu0520
--

COMMENT ON CONSTRAINT username ON users IS 'Usernames cannot be be the same as another person''s username.';


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
 GRANT ALL ON SCHEMA public TO postgres;
 GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: stockiratio; Type: ACL; Schema: -; Owner: postgres
--

 REVOKE ALL ON SCHEMA stockiratio FROM PUBLIC;
 REVOKE ALL ON SCHEMA stockiratio FROM postgres;
  GRANT ALL ON SCHEMA stockiratio TO postgres;
  GRANT ALL ON SCHEMA stockiratio TO scho7838 WITH GRANT OPTION;
  GRANT ALL ON SCHEMA stockiratio TO schu0520 WITH GRANT OPTION;
  GRANT ALL ON SCHEMA stockiratio TO shos3198 WITH GRANT OPTION;
  GRANT ALL ON SCHEMA stockiratio TO zhou0119 WITH GRANT OPTION;
GRANT USAGE ON SCHEMA stockiratio TO webdev;
GRANT USAGE ON SCHEMA stockiratio TO android;
GRANT USAGE ON SCHEMA stockiratio TO scraper;


--
-- Name: android_logout(character varying); Type: ACL; Schema: stockiratio; Owner: schu0520
--

REVOKE ALL ON FUNCTION android_logout(usern character varying) FROM PUBLIC;
REVOKE ALL ON FUNCTION android_logout(usern character varying) FROM schu0520;
 GRANT ALL ON FUNCTION android_logout(usern character varying) TO schu0520;
 GRANT ALL ON FUNCTION android_logout(usern character varying) TO android;
 GRANT ALL ON FUNCTION android_logout(usern character varying) TO scraper;
 GRANT ALL ON FUNCTION android_logout(usern character varying) TO scho7838 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION android_logout(usern character varying) TO shos3198 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION android_logout(usern character varying) TO zhou0119 WITH GRANT OPTION;


--
-- Name: android_stock_search(character varying, character varying, character varying); Type: ACL; Schema: stockiratio; Owner: schu0520
--

REVOKE ALL ON FUNCTION android_stock_search(info character varying, usern character varying, sessionkey character varying) FROM PUBLIC;
REVOKE ALL ON FUNCTION android_stock_search(info character varying, usern character varying, sessionkey character varying) FROM schu0520;
 GRANT ALL ON FUNCTION android_stock_search(info character varying, usern character varying, sessionkey character varying) TO schu0520;
 GRANT ALL ON FUNCTION android_stock_search(info character varying, usern character varying, sessionkey character varying) TO PUBLIC;
 GRANT ALL ON FUNCTION android_stock_search(info character varying, usern character varying, sessionkey character varying) TO zhou0119 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION android_stock_search(info character varying, usern character varying, sessionkey character varying) TO scho7838 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION android_stock_search(info character varying, usern character varying, sessionkey character varying) TO android;
 GRANT ALL ON FUNCTION android_stock_search(info character varying, usern character varying, sessionkey character varying) TO scraper;
 GRANT ALL ON FUNCTION android_stock_search(info character varying, usern character varying, sessionkey character varying) TO shos3198 WITH GRANT OPTION;


--
-- Name: android_update_pw(character varying, character varying, character varying, character varying); Type: ACL; Schema: stockiratio; Owner: schu0520
--

REVOKE ALL ON FUNCTION android_update_pw(usern character varying, oldpw character varying, pw character varying, sessionkey character varying) FROM PUBLIC;
REVOKE ALL ON FUNCTION android_update_pw(usern character varying, oldpw character varying, pw character varying, sessionkey character varying) FROM schu0520;
 GRANT ALL ON FUNCTION android_update_pw(usern character varying, oldpw character varying, pw character varying, sessionkey character varying) TO schu0520;
 GRANT ALL ON FUNCTION android_update_pw(usern character varying, oldpw character varying, pw character varying, sessionkey character varying) TO android;
 GRANT ALL ON FUNCTION android_update_pw(usern character varying, oldpw character varying, pw character varying, sessionkey character varying) TO scraper;
 GRANT ALL ON FUNCTION android_update_pw(usern character varying, oldpw character varying, pw character varying, sessionkey character varying) TO scho7838 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION android_update_pw(usern character varying, oldpw character varying, pw character varying, sessionkey character varying) TO shos3198 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION android_update_pw(usern character varying, oldpw character varying, pw character varying, sessionkey character varying) TO zhou0119 WITH GRANT OPTION;


--
-- Name: android_verify_login(character varying, character varying); Type: ACL; Schema: stockiratio; Owner: schu0520
--

REVOKE ALL ON FUNCTION android_verify_login(usern character varying, pw character varying) FROM PUBLIC;
REVOKE ALL ON FUNCTION android_verify_login(usern character varying, pw character varying) FROM schu0520;
 GRANT ALL ON FUNCTION android_verify_login(usern character varying, pw character varying) TO schu0520;
 GRANT ALL ON FUNCTION android_verify_login(usern character varying, pw character varying) TO android;
 GRANT ALL ON FUNCTION android_verify_login(usern character varying, pw character varying) TO scho7838 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION android_verify_login(usern character varying, pw character varying) TO scraper;
 GRANT ALL ON FUNCTION android_verify_login(usern character varying, pw character varying) TO shos3198 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION android_verify_login(usern character varying, pw character varying) TO zhou0119 WITH GRANT OPTION;


--
-- Name: android_view_client_info(character varying, character varying); Type: ACL; Schema: stockiratio; Owner: schu0520
--

REVOKE ALL ON FUNCTION android_view_client_info(usern character varying, sessionkey character varying) FROM PUBLIC;
REVOKE ALL ON FUNCTION android_view_client_info(usern character varying, sessionkey character varying) FROM schu0520;
 GRANT ALL ON FUNCTION android_view_client_info(usern character varying, sessionkey character varying) TO schu0520;
 GRANT ALL ON FUNCTION android_view_client_info(usern character varying, sessionkey character varying) TO PUBLIC;
 GRANT ALL ON FUNCTION android_view_client_info(usern character varying, sessionkey character varying) TO zhou0119 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION android_view_client_info(usern character varying, sessionkey character varying) TO scho7838 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION android_view_client_info(usern character varying, sessionkey character varying) TO android;
 GRANT ALL ON FUNCTION android_view_client_info(usern character varying, sessionkey character varying) TO scraper;
 GRANT ALL ON FUNCTION android_view_client_info(usern character varying, sessionkey character varying) TO shos3198 WITH GRANT OPTION;


--
-- Name: create_company(character varying, character varying); Type: ACL; Schema: stockiratio; Owner: schu0520
--

REVOKE ALL ON FUNCTION create_company(comp character varying, sym character varying) FROM PUBLIC;
REVOKE ALL ON FUNCTION create_company(comp character varying, sym character varying) FROM schu0520;
 GRANT ALL ON FUNCTION create_company(comp character varying, sym character varying) TO schu0520;
 GRANT ALL ON FUNCTION create_company(comp character varying, sym character varying) TO scho7838 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION create_company(comp character varying, sym character varying) TO shos3198 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION create_company(comp character varying, sym character varying) TO zhou0119 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION create_company(comp character varying, sym character varying) TO scraper;


--
-- Name: create_stock(character varying, character varying, timestamp without time zone, numeric, numeric, numeric, numeric, numeric, numeric, numeric, integer, numeric, numeric, numeric, character varying); Type: ACL; Schema: stockiratio; Owner: schu0520
--

REVOKE ALL ON FUNCTION create_stock(comp character varying, sym character varying, dat timestamp without time zone, stockcost numeric, change numeric, changepct numeric, dayhigh numeric, daylow numeric, yearhigh numeric, yearlow numeric, vol integer, div numeric, pe numeric, earnps numeric, ind character varying) FROM PUBLIC;
REVOKE ALL ON FUNCTION create_stock(comp character varying, sym character varying, dat timestamp without time zone, stockcost numeric, change numeric, changepct numeric, dayhigh numeric, daylow numeric, yearhigh numeric, yearlow numeric, vol integer, div numeric, pe numeric, earnps numeric, ind character varying) FROM schu0520;
 GRANT ALL ON FUNCTION create_stock(comp character varying, sym character varying, dat timestamp without time zone, stockcost numeric, change numeric, changepct numeric, dayhigh numeric, daylow numeric, yearhigh numeric, yearlow numeric, vol integer, div numeric, pe numeric, earnps numeric, ind character varying) TO schu0520;
 GRANT ALL ON FUNCTION create_stock(comp character varying, sym character varying, dat timestamp without time zone, stockcost numeric, change numeric, changepct numeric, dayhigh numeric, daylow numeric, yearhigh numeric, yearlow numeric, vol integer, div numeric, pe numeric, earnps numeric, ind character varying) TO scho7838 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION create_stock(comp character varying, sym character varying, dat timestamp without time zone, stockcost numeric, change numeric, changepct numeric, dayhigh numeric, daylow numeric, yearhigh numeric, yearlow numeric, vol integer, div numeric, pe numeric, earnps numeric, ind character varying) TO shos3198 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION create_stock(comp character varying, sym character varying, dat timestamp without time zone, stockcost numeric, change numeric, changepct numeric, dayhigh numeric, daylow numeric, yearhigh numeric, yearlow numeric, vol integer, div numeric, pe numeric, earnps numeric, ind character varying) TO scraper;
 GRANT ALL ON FUNCTION create_stock(comp character varying, sym character varying, dat timestamp without time zone, stockcost numeric, change numeric, changepct numeric, dayhigh numeric, daylow numeric, yearhigh numeric, yearlow numeric, vol integer, div numeric, pe numeric, earnps numeric, ind character varying) TO zhou0119 WITH GRANT OPTION;


--
-- Name: stock_search(character varying); Type: ACL; Schema: stockiratio; Owner: schu0520
--

REVOKE ALL ON FUNCTION stock_search(info character varying) FROM PUBLIC;
REVOKE ALL ON FUNCTION stock_search(info character varying) FROM schu0520;
 GRANT ALL ON FUNCTION stock_search(info character varying) TO schu0520;
 GRANT ALL ON FUNCTION stock_search(info character varying) TO webdev;
 GRANT ALL ON FUNCTION stock_search(info character varying) TO scho7838 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION stock_search(info character varying) TO shos3198 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION stock_search(info character varying) TO zhou0119 WITH GRANT OPTION;


--
-- Name: update_pw(character varying, character varying, character varying); Type: ACL; Schema: stockiratio; Owner: schu0520
--

REVOKE ALL ON FUNCTION update_pw(usern character varying, oldpw character varying, pw character varying) FROM PUBLIC;
REVOKE ALL ON FUNCTION update_pw(usern character varying, oldpw character varying, pw character varying) FROM schu0520;
 GRANT ALL ON FUNCTION update_pw(usern character varying, oldpw character varying, pw character varying) TO schu0520;
 GRANT ALL ON FUNCTION update_pw(usern character varying, oldpw character varying, pw character varying) TO scho7838 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION update_pw(usern character varying, oldpw character varying, pw character varying) TO shos3198 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION update_pw(usern character varying, oldpw character varying, pw character varying) TO zhou0119 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION update_pw(usern character varying, oldpw character varying, pw character varying) TO webdev;


--
-- Name: verify_web_login(character varying, character varying); Type: ACL; Schema: stockiratio; Owner: schu0520
--

REVOKE ALL ON FUNCTION verify_web_login(usern character varying, pw character varying) FROM PUBLIC;
REVOKE ALL ON FUNCTION verify_web_login(usern character varying, pw character varying) FROM schu0520;
 GRANT ALL ON FUNCTION verify_web_login(usern character varying, pw character varying) TO schu0520;
 GRANT ALL ON FUNCTION verify_web_login(usern character varying, pw character varying) TO scho7838 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION verify_web_login(usern character varying, pw character varying) TO shos3198 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION verify_web_login(usern character varying, pw character varying) TO zhou0119 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION verify_web_login(usern character varying, pw character varying) TO webdev WITH GRANT OPTION;


--
-- Name: view_client_info(character varying); Type: ACL; Schema: stockiratio; Owner: schu0520
--

REVOKE ALL ON FUNCTION view_client_info(usern character varying) FROM PUBLIC;
REVOKE ALL ON FUNCTION view_client_info(usern character varying) FROM schu0520;
 GRANT ALL ON FUNCTION view_client_info(usern character varying) TO schu0520;
 GRANT ALL ON FUNCTION view_client_info(usern character varying) TO PUBLIC;
 GRANT ALL ON FUNCTION view_client_info(usern character varying) TO zhou0119 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION view_client_info(usern character varying) TO webdev;
 GRANT ALL ON FUNCTION view_client_info(usern character varying) TO scho7838 WITH GRANT OPTION;
 GRANT ALL ON FUNCTION view_client_info(usern character varying) TO shos3198 WITH GRANT OPTION;


SET search_path = public, pg_catalog;

--
-- Name: account; Type: ACL; Schema: public; Owner: schu0520
--

				REVOKE ALL ON TABLE account FROM PUBLIC;
				REVOKE ALL ON TABLE account FROM schu0520;
				 GRANT ALL ON TABLE account TO schu0520;
GRANT SELECT,INSERT,UPDATE ON TABLE account TO android;
GRANT SELECT,INSERT,UPDATE ON TABLE account TO webdev;
				 GRANT ALL ON TABLE account TO scho7838 WITH GRANT OPTION;
				 GRANT ALL ON TABLE account TO shos3198 WITH GRANT OPTION;
				 GRANT ALL ON TABLE account TO zhou0119 WITH GRANT OPTION;
GRANT SELECT,INSERT,UPDATE ON TABLE account TO scraper;


--
-- Name: company; Type: ACL; Schema: public; Owner: schu0520
--

	     REVOKE ALL ON TABLE company FROM PUBLIC;
	     REVOKE ALL ON TABLE company FROM schu0520;
	      GRANT ALL ON TABLE company TO schu0520;
	   GRANT SELECT ON TABLE company TO client;
	      GRANT ALL ON TABLE company TO scho7838 WITH GRANT OPTION;
	      GRANT ALL ON TABLE company TO shos3198 WITH GRANT OPTION;
	      GRANT ALL ON TABLE company TO zhou0119 WITH GRANT OPTION;
GRANT SELECT,INSERT ON TABLE company TO scraper;


--
-- Name: stock; Type: ACL; Schema: public; Owner: schu0520
--

		 REVOKE ALL ON TABLE stock FROM PUBLIC;
		 REVOKE ALL ON TABLE stock FROM schu0520;
		  GRANT ALL ON TABLE stock TO schu0520;
GRANT SELECT,INSERT ON TABLE stock TO scraper;
	   GRANT SELECT ON TABLE stock TO client;
		  GRANT ALL ON TABLE stock TO scho7838 WITH GRANT OPTION;
		  GRANT ALL ON TABLE stock TO shos3198 WITH GRANT OPTION;
		  GRANT ALL ON TABLE stock TO zhou0119 WITH GRANT OPTION;


--
-- Name: users; Type: ACL; Schema: public; Owner: schu0520
--

				REVOKE ALL ON TABLE users FROM PUBLIC;
				REVOKE ALL ON TABLE users FROM schu0520;
				 GRANT ALL ON TABLE users TO schu0520;
				 GRANT ALL ON TABLE users TO scho7838 WITH GRANT OPTION;
				 GRANT ALL ON TABLE users TO shos3198 WITH GRANT OPTION;
				 GRANT ALL ON TABLE users TO zhou0119 WITH GRANT OPTION;
GRANT SELECT,INSERT,UPDATE ON TABLE users TO android;
GRANT SELECT,INSERT,UPDATE ON TABLE users TO webdev;
			  GRANT SELECT ON TABLE users TO client;
GRANT SELECT,INSERT,UPDATE ON TABLE users TO scraper;


--
-- Name: usersession; Type: ACL; Schema: public; Owner: schu0520
--

		 REVOKE ALL ON TABLE usersession FROM PUBLIC;
		 REVOKE ALL ON TABLE usersession FROM schu0520;
		  GRANT ALL ON TABLE usersession TO schu0520;
		  GRANT ALL ON TABLE usersession TO scho7838 WITH GRANT OPTION;
		  GRANT ALL ON TABLE usersession TO shos3198 WITH GRANT OPTION;
		  GRANT ALL ON TABLE usersession TO zhou0119 WITH GRANT OPTION;
GRANT SELECT,UPDATE ON TABLE usersession TO android;
GRANT SELECT,UPDATE ON TABLE usersession TO scraper;


SET search_path = stockiratio, pg_catalog;

--
-- Name: account; Type: ACL; Schema: stockiratio; Owner: schu0520
--

				REVOKE ALL ON TABLE account FROM PUBLIC;
				 GRANT ALL ON TABLE account TO zhou0119 WITH GRANT OPTION;
GRANT SELECT,INSERT,UPDATE ON TABLE account TO scraper;
GRANT SELECT,INSERT,UPDATE ON TABLE account TO webdev;
				 GRANT ALL ON TABLE account TO scho7838 WITH GRANT OPTION;
GRANT SELECT,INSERT,UPDATE ON TABLE account TO android;
				 GRANT ALL ON TABLE account TO shos3198 WITH GRANT OPTION;


--
-- Name: company; Type: ACL; Schema: stockiratio; Owner: schu0520
--

		 REVOKE ALL ON TABLE company FROM PUBLIC;
	   GRANT SELECT ON TABLE company TO client;
		  GRANT ALL ON TABLE company TO zhou0119 WITH GRANT OPTION;
		  GRANT ALL ON TABLE company TO shos3198 WITH GRANT OPTION;
GRANT SELECT,INSERT ON TABLE company TO scraper;
		  GRANT ALL ON TABLE company TO scho7838 WITH GRANT OPTION;


--
-- Name: stock; Type: ACL; Schema: stockiratio; Owner: schu0520
--

		 REVOKE ALL ON TABLE stock FROM PUBLIC;
	   GRANT SELECT ON TABLE stock TO client;
		  GRANT ALL ON TABLE stock TO zhou0119 WITH GRANT OPTION;
GRANT SELECT,INSERT ON TABLE stock TO scraper;
		  GRANT ALL ON TABLE stock TO shos3198 WITH GRANT OPTION;
		  GRANT ALL ON TABLE stock TO scho7838 WITH GRANT OPTION;


--
-- Name: users; Type: ACL; Schema: stockiratio; Owner: schu0520
--

				REVOKE ALL ON TABLE users FROM PUBLIC;
			  GRANT SELECT ON TABLE users TO client;
				 GRANT ALL ON TABLE users TO zhou0119 WITH GRANT OPTION;
GRANT SELECT,INSERT,UPDATE ON TABLE users TO scraper;
GRANT SELECT,INSERT,UPDATE ON TABLE users TO webdev;
				 GRANT ALL ON TABLE users TO scho7838 WITH GRANT OPTION;
				 GRANT ALL ON TABLE users TO shos3198 WITH GRANT OPTION;
GRANT SELECT,INSERT,UPDATE ON TABLE users TO android;


--
-- Name: usersession; Type: ACL; Schema: stockiratio; Owner: schu0520
--

		 REVOKE ALL ON TABLE usersession FROM PUBLIC;
	  	  GRANT ALL ON TABLE usersession TO zhou0119 WITH GRANT OPTION;
		  GRANT ALL ON TABLE usersession TO shos3198 WITH GRANT OPTION;
GRANT SELECT,UPDATE ON TABLE usersession TO android;
GRANT SELECT,UPDATE ON TABLE usersession TO scraper;
		  GRANT ALL ON TABLE usersession TO scho7838 WITH GRANT OPTION;


--
-- PostgreSQL database dump complete
--

\connect postgres

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.6
-- Dumped by pg_dump version 9.5.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
 GRANT ALL ON SCHEMA public TO postgres;
 GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

\connect template1

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.6
-- Dumped by pg_dump version 9.5.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
 GRANT ALL ON SCHEMA public TO postgres;
 GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

