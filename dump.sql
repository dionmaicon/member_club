--
-- PostgreSQL database cluster dump
--

\connect postgres

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET escape_string_warning = off;

--
-- Roles
--

CREATE ROLE adm1;
ALTER ROLE adm1 WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN PASSWORD 'md507e348ef2a6a3ffa662c22a011b7ccce';
CREATE ROLE admins;
ALTER ROLE admins WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN;
CREATE ROLE jao;
ALTER ROLE jao WITH SUPERUSER INHERIT NOCREATEROLE CREATEDB LOGIN PASSWORD 'md5ab7d2336903032ecd853b66f2c984a1d';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN PASSWORD 'md505ea766c2bc9e19f34b66114ace97598';
CREATE ROLE unitest;
ALTER ROLE unitest WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN;


--
-- Role memberships
--

GRANT unitest TO jao GRANTED BY postgres;




--
-- Database creation
--

CREATE DATABASE aps2 WITH TEMPLATE = template0 OWNER = jao;
CREATE DATABASE aps3 WITH TEMPLATE = template0 OWNER = jao;
CREATE DATABASE clientes WITH TEMPLATE = template0 OWNER = postgres;
CREATE DATABASE clube WITH TEMPLATE = template0 OWNER = jao;
CREATE DATABASE posto WITH TEMPLATE = template0 OWNER = jao;
CREATE DATABASE procedures WITH TEMPLATE = template0 OWNER = jao;
CREATE DATABASE sati WITH TEMPLATE = template0 OWNER = jao;
REVOKE ALL ON DATABASE template1 FROM PUBLIC;
REVOKE ALL ON DATABASE template1 FROM postgres;
GRANT ALL ON DATABASE template1 TO postgres;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;
CREATE DATABASE ukp WITH TEMPLATE = template0 OWNER = jao;
CREATE DATABASE unitest WITH TEMPLATE = template0 OWNER = postgres;
CREATE DATABASE uniteste WITH TEMPLATE = template0 OWNER = jao;


\connect aps2

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: jao
--

CREATE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO jao;

SET search_path = public, pg_catalog;

--
-- Name: proc_atualiza_auditoria_vagas(); Type: FUNCTION; Schema: public; Owner: jao
--

CREATE FUNCTION proc_atualiza_auditoria_vagas() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin 
	insert into auditoria(data,descricao)values(to_char(CURRENT_DATE, 'DD/MM/YYYY'),'Vaga '||old.codigo || ' excluida');
	return NULL;
end;
$$;


ALTER FUNCTION public.proc_atualiza_auditoria_vagas() OWNER TO jao;

--
-- Name: proc_atualiza_departamentos_delete(); Type: FUNCTION; Schema: public; Owner: jao
--

CREATE FUNCTION proc_atualiza_departamentos_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ 
declare
	reg RECORD;
	qtd integer := 0;
begin
		FOR reg in select  empregados.nome from empregados where empregados.depto = old.codigo
		loop			
			qtd = qtd + 1;
			RAISE NOTICE 'Nome empregado: % ', reg.nome;
		end loop;
		RAISE NOTICE 'Total de funcionarios sem departamento: % ', qtd;
		update empregados set depto = 0 where depto = old.codigo;
	  	return old;
	
	return NULL; 
end;
$$;


ALTER FUNCTION public.proc_atualiza_departamentos_delete() OWNER TO jao;

--
-- Name: proc_atualiza_ha_vagas(); Type: FUNCTION; Schema: public; Owner: jao
--

CREATE FUNCTION proc_atualiza_ha_vagas() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin

	if ( new.Dt_Rescisao is not NULL and old.dt_rescisao is NULL) then
		insert into ha_vagas(data,descricao,preenchida) values(CURRENT_DATE, 'precisa-se de '|| new.cargo ||' salario de '|| new.salario, 0);
	
	end if;
	return NULL;
end;
$$;


ALTER FUNCTION public.proc_atualiza_ha_vagas() OWNER TO jao;

--
-- Name: proc_atualiza_vagas_preenchida(); Type: FUNCTION; Schema: public; Owner: jao
--

CREATE FUNCTION proc_atualiza_vagas_preenchida() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ 

begin			
	insert into auditoria(data,descricao) values(to_char(CURRENT_DATE, 'DD/MM/YYYY'), 'Vaga '|| new.codigo ||' preenchida');
	update ha_vagas set preenchida = 1 where codigo = new.codigo; 
	return NULL; 
end;
$$;


ALTER FUNCTION public.proc_atualiza_vagas_preenchida() OWNER TO jao;

--
-- Name: proc_exclui_vagas_preenchidas(); Type: FUNCTION; Schema: public; Owner: jao
--

CREATE FUNCTION proc_exclui_vagas_preenchidas() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
		insert into auditoria values (to_char(CURRENT_DATE, 'DD/MM/YYYY'), 'Tentativa de exclusão em vagas_preenchidas....');
		return old;
	return NULL;
end;
$$;


ALTER FUNCTION public.proc_exclui_vagas_preenchidas() OWNER TO jao;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auditoria; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE auditoria (
    data character(10),
    descricao character varying(90)
);


ALTER TABLE public.auditoria OWNER TO jao;

--
-- Name: departamentos; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE departamentos (
    codigo integer NOT NULL,
    descricao character varying(30)
);


ALTER TABLE public.departamentos OWNER TO jao;

--
-- Name: departamentos_codigo_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE departamentos_codigo_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.departamentos_codigo_seq OWNER TO jao;

--
-- Name: departamentos_codigo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE departamentos_codigo_seq OWNED BY departamentos.codigo;


--
-- Name: departamentos_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('departamentos_codigo_seq', 6, true);


--
-- Name: empregados; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE empregados (
    codigo integer NOT NULL,
    nome character varying(50),
    sobrenome character varying(50),
    "dt_admissão" date,
    dt_rescisao date,
    salario numeric(9,2),
    cargo character varying(40),
    depto integer
);


ALTER TABLE public.empregados OWNER TO jao;

--
-- Name: empregados_codigo_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE empregados_codigo_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.empregados_codigo_seq OWNER TO jao;

--
-- Name: empregados_codigo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE empregados_codigo_seq OWNED BY empregados.codigo;


--
-- Name: empregados_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('empregados_codigo_seq', 8, true);


--
-- Name: ha_vagas; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE ha_vagas (
    codigo integer NOT NULL,
    data date,
    descricao character varying(90),
    preenchida character(1)
);


ALTER TABLE public.ha_vagas OWNER TO jao;

--
-- Name: ha_vagas_codigo_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE ha_vagas_codigo_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ha_vagas_codigo_seq OWNER TO jao;

--
-- Name: ha_vagas_codigo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE ha_vagas_codigo_seq OWNED BY ha_vagas.codigo;


--
-- Name: ha_vagas_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('ha_vagas_codigo_seq', 8, true);


--
-- Name: vagas_preenchidas; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE vagas_preenchidas (
    codigo integer NOT NULL,
    data date,
    descricao character varying(90),
    preenchida date
);


ALTER TABLE public.vagas_preenchidas OWNER TO jao;

--
-- Name: vagas_preenchidas_codigo_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE vagas_preenchidas_codigo_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.vagas_preenchidas_codigo_seq OWNER TO jao;

--
-- Name: vagas_preenchidas_codigo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE vagas_preenchidas_codigo_seq OWNED BY vagas_preenchidas.codigo;


--
-- Name: vagas_preenchidas_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('vagas_preenchidas_codigo_seq', 1, true);


--
-- Name: codigo; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY departamentos ALTER COLUMN codigo SET DEFAULT nextval('departamentos_codigo_seq'::regclass);


--
-- Name: codigo; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY empregados ALTER COLUMN codigo SET DEFAULT nextval('empregados_codigo_seq'::regclass);


--
-- Name: codigo; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY ha_vagas ALTER COLUMN codigo SET DEFAULT nextval('ha_vagas_codigo_seq'::regclass);


--
-- Name: codigo; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY vagas_preenchidas ALTER COLUMN codigo SET DEFAULT nextval('vagas_preenchidas_codigo_seq'::regclass);


--
-- Data for Name: auditoria; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY auditoria (data, descricao) FROM stdin;
18/10/2015	Teste insert com date
18/10/2015	Teste insert com date2
\N	Teste insert com date 3
19/10/2015	Vaga 6 excluida
19/10/2015	Vaga 8 preenchida
19/10/2015	Tentativa de exclusão em vagas_preenchidas....
\.


--
-- Data for Name: departamentos; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY departamentos (codigo, descricao) FROM stdin;
3	departamento dos borrachos
4	departamento de testes 2
0	os sem departamento
5	DepartamentoTeste
6	Departamento Teste 2
\.


--
-- Data for Name: empregados; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY empregados (codigo, nome, sobrenome, "dt_admissão", dt_rescisao, salario, cargo, depto) FROM stdin;
4	Diego	Araujo	2015-10-19	\N	1550.00	 n vai entrar	3
5	Jean	da Silva	2015-10-19	\N	6500.00	borracho de fim de semana	3
6	Ricardo	da Silva	2015-10-19	\N	3500.00	borracho da semana inteira	3
8	Dwajja	Santos	2015-10-19	2015-10-19	1500.00	Visitante	0
\.


--
-- Data for Name: ha_vagas; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY ha_vagas (codigo, data, descricao, preenchida) FROM stdin;
8	2015-10-19	precisa-se de Visitante salario de 1500.00	1
\.


--
-- Data for Name: vagas_preenchidas; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY vagas_preenchidas (codigo, data, descricao, preenchida) FROM stdin;
\.


--
-- Name: departamentos_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY departamentos
    ADD CONSTRAINT departamentos_pkey PRIMARY KEY (codigo);


--
-- Name: empregados_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY empregados
    ADD CONSTRAINT empregados_pkey PRIMARY KEY (codigo);


--
-- Name: ha_vagas_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY ha_vagas
    ADD CONSTRAINT ha_vagas_pkey PRIMARY KEY (codigo);


--
-- Name: atualiza_auditoria_vagas; Type: TRIGGER; Schema: public; Owner: jao
--

CREATE TRIGGER atualiza_auditoria_vagas
    AFTER DELETE ON ha_vagas
    FOR EACH ROW
    EXECUTE PROCEDURE proc_atualiza_auditoria_vagas();


--
-- Name: atualiza_departamentos_delete; Type: TRIGGER; Schema: public; Owner: jao
--

CREATE TRIGGER atualiza_departamentos_delete
    BEFORE DELETE ON departamentos
    FOR EACH ROW
    EXECUTE PROCEDURE proc_atualiza_departamentos_delete();


--
-- Name: atualiza_ha_vagas; Type: TRIGGER; Schema: public; Owner: jao
--

CREATE TRIGGER atualiza_ha_vagas
    AFTER UPDATE ON empregados
    FOR EACH ROW
    EXECUTE PROCEDURE proc_atualiza_ha_vagas();


--
-- Name: atualiza_vagas_preenchida; Type: TRIGGER; Schema: public; Owner: jao
--

CREATE TRIGGER atualiza_vagas_preenchida
    AFTER INSERT ON vagas_preenchidas
    FOR EACH ROW
    EXECUTE PROCEDURE proc_atualiza_vagas_preenchida();


--
-- Name: exclui_vagas_preenchidas; Type: TRIGGER; Schema: public; Owner: jao
--

CREATE TRIGGER exclui_vagas_preenchidas
    BEFORE DELETE ON vagas_preenchidas
    FOR EACH ROW
    EXECUTE PROCEDURE proc_exclui_vagas_preenchidas();


--
-- Name: empregados_depto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY empregados
    ADD CONSTRAINT empregados_depto_fkey FOREIGN KEY (depto) REFERENCES departamentos(codigo) ON DELETE CASCADE;


--
-- Name: vagas_preenchidas_codigo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY vagas_preenchidas
    ADD CONSTRAINT vagas_preenchidas_codigo_fkey FOREIGN KEY (codigo) REFERENCES ha_vagas(codigo) ON DELETE CASCADE;


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

\connect aps3

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: arbitro; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE arbitro (
    cpf character varying(15) NOT NULL
);


ALTER TABLE public.arbitro OWNER TO jao;

--
-- Name: atlequ; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE atlequ (
    idatlequ integer NOT NULL,
    aidcompetidor integer,
    eidcompetidor integer
);


ALTER TABLE public.atlequ OWNER TO jao;

--
-- Name: atlequ_idatlequ_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE atlequ_idatlequ_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.atlequ_idatlequ_seq OWNER TO jao;

--
-- Name: atlequ_idatlequ_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE atlequ_idatlequ_seq OWNED BY atlequ.idatlequ;


--
-- Name: atlequ_idatlequ_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('atlequ_idatlequ_seq', 17, true);


--
-- Name: atleta; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE atleta (
    idcompetidor integer NOT NULL,
    cpf character varying(15)
);


ALTER TABLE public.atleta OWNER TO jao;

--
-- Name: categoria; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE categoria (
    idcat integer NOT NULL,
    nomecat character varying(60),
    tipocat character varying(1),
    generocat character varying(1),
    idmod integer
);


ALTER TABLE public.categoria OWNER TO jao;

--
-- Name: categoria_idcat_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE categoria_idcat_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.categoria_idcat_seq OWNER TO jao;

--
-- Name: categoria_idcat_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE categoria_idcat_seq OWNED BY categoria.idcat;


--
-- Name: categoria_idcat_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('categoria_idcat_seq', 121, true);


--
-- Name: competicao; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE competicao (
    idcompeticao integer NOT NULL,
    fase character varying(1),
    datacompeticao date,
    horacompeticao character varying(5),
    idcat integer,
    idlocal integer
);


ALTER TABLE public.competicao OWNER TO jao;

--
-- Name: competicao_idcompeticao_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE competicao_idcompeticao_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.competicao_idcompeticao_seq OWNER TO jao;

--
-- Name: competicao_idcompeticao_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE competicao_idcompeticao_seq OWNED BY competicao.idcompeticao;


--
-- Name: competicao_idcompeticao_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('competicao_idcompeticao_seq', 12, true);


--
-- Name: competidor; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE competidor (
    idcompetidor integer NOT NULL
);


ALTER TABLE public.competidor OWNER TO jao;

--
-- Name: competidor_idcompetidor_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE competidor_idcompetidor_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.competidor_idcompetidor_seq OWNER TO jao;

--
-- Name: competidor_idcompetidor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE competidor_idcompetidor_seq OWNED BY competidor.idcompetidor;


--
-- Name: competidor_idcompetidor_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('competidor_idcompetidor_seq', 88, true);


--
-- Name: equipe; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE equipe (
    idcompetidor integer NOT NULL,
    nomeequi character varying(60)
);


ALTER TABLE public.equipe OWNER TO jao;

--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE funcionario (
    cpf character varying(15) NOT NULL
);


ALTER TABLE public.funcionario OWNER TO jao;

--
-- Name: inscricao; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE inscricao (
    idinscricao integer NOT NULL,
    idcat integer,
    idcompetidor integer
);


ALTER TABLE public.inscricao OWNER TO jao;

--
-- Name: inscricao_idinscricao_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE inscricao_idinscricao_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.inscricao_idinscricao_seq OWNER TO jao;

--
-- Name: inscricao_idinscricao_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE inscricao_idinscricao_seq OWNED BY inscricao.idinscricao;


--
-- Name: inscricao_idinscricao_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('inscricao_idinscricao_seq', 37, true);


--
-- Name: local; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE local (
    idlocal integer NOT NULL,
    enderecolocal character varying(40),
    capacidade character varying(10),
    cpf character varying(15)
);


ALTER TABLE public.local OWNER TO jao;

--
-- Name: local_idlocal_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE local_idlocal_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.local_idlocal_seq OWNER TO jao;

--
-- Name: local_idlocal_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE local_idlocal_seq OWNED BY local.idlocal;


--
-- Name: local_idlocal_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('local_idlocal_seq', 3, true);


--
-- Name: modalidade; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE modalidade (
    idmod integer NOT NULL,
    nomemod character varying(50)
);


ALTER TABLE public.modalidade OWNER TO jao;

--
-- Name: modalidade_idmod_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE modalidade_idmod_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.modalidade_idmod_seq OWNER TO jao;

--
-- Name: modalidade_idmod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE modalidade_idmod_seq OWNED BY modalidade.idmod;


--
-- Name: modalidade_idmod_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('modalidade_idmod_seq', 14, true);


--
-- Name: modarb; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE modarb (
    idmodarb integer NOT NULL,
    cpf character varying(15),
    idmod integer
);


ALTER TABLE public.modarb OWNER TO jao;

--
-- Name: modarb_idmodarb_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE modarb_idmodarb_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.modarb_idmodarb_seq OWNER TO jao;

--
-- Name: modarb_idmodarb_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE modarb_idmodarb_seq OWNED BY modarb.idmodarb;


--
-- Name: modarb_idmodarb_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('modarb_idmodarb_seq', 7, true);


--
-- Name: modloc; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE modloc (
    idmodloc integer NOT NULL,
    idlocal integer,
    idmod integer
);


ALTER TABLE public.modloc OWNER TO jao;

--
-- Name: modloc_idmodloc_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE modloc_idmodloc_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.modloc_idmodloc_seq OWNER TO jao;

--
-- Name: modloc_idmodloc_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE modloc_idmodloc_seq OWNED BY modloc.idmodloc;


--
-- Name: modloc_idmodloc_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('modloc_idmodloc_seq', 18, true);


--
-- Name: pessoa; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE pessoa (
    cpf character varying(15) NOT NULL,
    nomepessoa character varying(30),
    datanascimento date,
    sexo character varying(1)
);


ALTER TABLE public.pessoa OWNER TO jao;

--
-- Name: nadadores; Type: VIEW; Schema: public; Owner: jao
--

CREATE VIEW nadadores AS
    SELECT pessoa.nomepessoa, categoria.nomecat FROM pessoa, categoria, inscricao, modalidade, atleta WHERE ((((((pessoa.cpf)::text = (atleta.cpf)::text) AND (atleta.idcompetidor = inscricao.idcompetidor)) AND (inscricao.idcat = categoria.idcat)) AND (categoria.idmod = modalidade.idmod)) AND ((modalidade.nomemod)::text = 'Natacao'::text));


ALTER TABLE public.nadadores OWNER TO jao;

--
-- Name: participacao; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE participacao (
    idparticipacao integer NOT NULL,
    idcompeticao integer,
    idcompetidor integer,
    escore real,
    unidade character varying(15)
);


ALTER TABLE public.participacao OWNER TO jao;

--
-- Name: participacao_idparticipacao_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE participacao_idparticipacao_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.participacao_idparticipacao_seq OWNER TO jao;

--
-- Name: participacao_idparticipacao_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE participacao_idparticipacao_seq OWNED BY participacao.idparticipacao;


--
-- Name: participacao_idparticipacao_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('participacao_idparticipacao_seq', 30, true);


--
-- Name: patrocinador; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE patrocinador (
    cnpj character varying(20) NOT NULL,
    nomepat character varying(30),
    patevento character varying(1),
    patcompetidor character varying(1),
    enderecopat character varying(70),
    valor character varying(12)
);


ALTER TABLE public.patrocinador OWNER TO jao;

--
-- Name: patrocinio; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE patrocinio (
    idpatrocinio integer NOT NULL,
    idcompetidor integer,
    cnpj character varying(20)
);


ALTER TABLE public.patrocinio OWNER TO jao;

--
-- Name: patrocinio_idpatrocinio_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE patrocinio_idpatrocinio_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.patrocinio_idpatrocinio_seq OWNER TO jao;

--
-- Name: patrocinio_idpatrocinio_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE patrocinio_idpatrocinio_seq OWNED BY patrocinio.idpatrocinio;


--
-- Name: patrocinio_idpatrocinio_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('patrocinio_idpatrocinio_seq', 11, true);


--
-- Name: idatlequ; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY atlequ ALTER COLUMN idatlequ SET DEFAULT nextval('atlequ_idatlequ_seq'::regclass);


--
-- Name: idcat; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY categoria ALTER COLUMN idcat SET DEFAULT nextval('categoria_idcat_seq'::regclass);


--
-- Name: idcompeticao; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY competicao ALTER COLUMN idcompeticao SET DEFAULT nextval('competicao_idcompeticao_seq'::regclass);


--
-- Name: idcompetidor; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY competidor ALTER COLUMN idcompetidor SET DEFAULT nextval('competidor_idcompetidor_seq'::regclass);


--
-- Name: idinscricao; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY inscricao ALTER COLUMN idinscricao SET DEFAULT nextval('inscricao_idinscricao_seq'::regclass);


--
-- Name: idlocal; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY local ALTER COLUMN idlocal SET DEFAULT nextval('local_idlocal_seq'::regclass);


--
-- Name: idmod; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY modalidade ALTER COLUMN idmod SET DEFAULT nextval('modalidade_idmod_seq'::regclass);


--
-- Name: idmodarb; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY modarb ALTER COLUMN idmodarb SET DEFAULT nextval('modarb_idmodarb_seq'::regclass);


--
-- Name: idmodloc; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY modloc ALTER COLUMN idmodloc SET DEFAULT nextval('modloc_idmodloc_seq'::regclass);


--
-- Name: idparticipacao; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY participacao ALTER COLUMN idparticipacao SET DEFAULT nextval('participacao_idparticipacao_seq'::regclass);


--
-- Name: idpatrocinio; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY patrocinio ALTER COLUMN idpatrocinio SET DEFAULT nextval('patrocinio_idpatrocinio_seq'::regclass);


--
-- Data for Name: arbitro; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY arbitro (cpf) FROM stdin;
11122233345
11122233346
11122233347
11122233348
11122233349
\.


--
-- Data for Name: atlequ; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY atlequ (idatlequ, aidcompetidor, eidcompetidor) FROM stdin;
1	1	54
2	2	54
3	3	54
4	5	54
5	6	54
6	7	54
7	8	54
8	9	54
9	10	54
10	11	54
11	4	59
12	22	60
13	4	62
14	22	62
15	32	62
16	20	61
17	21	61
\.


--
-- Data for Name: atleta; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY atleta (idcompetidor, cpf) FROM stdin;
1	11122233301
2	11122233302
3	11122233303
4	11122233304
5	11122233305
6	11122233306
7	11122233307
8	11122233308
9	11122233309
10	11122233310
11	11122233311
12	11122233312
13	11122233313
14	11122233314
15	11122233315
16	11122233316
17	11122233317
18	11122233318
19	11122233319
20	11122233320
21	11122233321
22	11122233322
23	11122233323
24	11122233324
25	11122233325
26	11122233326
27	11122233327
28	11122233328
29	11122233329
30	11122233330
31	11122233331
32	11122233332
33	11122233333
34	11122233334
35	11122233335
36	11122233336
37	11122233337
38	11122233338
39	11122233339
40	11122233340
41	11122233341
42	11122233342
43	11122233343
44	11122233344
\.


--
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY categoria (idcat, nomecat, tipocat, generocat, idmod) FROM stdin;
1	100mt rasos	I	M	1
2	400mt barreiras	I	M	1
3	800mt rasos	I	M	1
4	800mt barreiras	I	M	1
5	Maratona	I	M	1
6	Salto distancia	I	M	1
7	Salto triplo	I	M	1
8	Salto altura	I	M	1
9	Salto com vara	I	M	1
10	Revezamento 4x100	C	M	1
11	Revezamento 4x400	C	M	1
12	Arremesso Disco	I	M	1
13	Arremesso Dardo	I	M	1
14	Arremesso Martelo	I	M	1
15	100mt rasos	I	F	1
16	400mt barreiras	I	F	1
17	800mt rasos	I	F	1
18	800mt barreiras	I	F	1
19	Maratona	I	F	1
20	Salto distancia	I	F	1
21	Salto triplo	I	F	1
22	Salto altura	I	F	1
23	Salto com vara	I	F	1
24	Revezamento 4x100	C	F	1
25	Revezamento 4x400	C	F	1
26	Arremesso Disco	I	F	1
27	Arremesso Dardo	I	F	1
28	Arremesso Martelo	I	F	1
29	Masculino       	C	M	2
30	Feminino        	C	F	2
31	Peso Galo	I	M	3
32	Peso Mosca	I	M	3
33	Peso Leve	I	M	3
34	Peso Pena	I	M	3
35	Peso Medio	I	M	3
36	Peso Pesado	I	M	3
37	Peso SuperPesado	I	M	3
38	Pista	I	M	4
39	Estrada	I	M	4
40	Pista	I	F	4
41	Estrada	I	F	4
42	Masculino	C	M	5
43	Feminino	C	F	5
44	Artistica	I	M	6
45	Ritmica	I	M	6
46	Trampolim AcrobÃ¡tico	I	M	6
47	Aerobica	I	M	6
48	Artistica	I	F	6
49	Ritmica	I	F	6
50	Trampolim Acrobatico	I	F	6
51	Aerobica	I	F	6
52	Masculino	I	M	7
53	Feminino	I	F	7
54	Peso Galo	I	M	8
55	Peso Mosca	I	M	8
56	Peso Leve	I	M	8
57	Peso Pena	I	M	8
58	Peso Medio	I	M	8
59	Peso Pesado	I	M	8
60	Peso SuperPesado	I	M	8
61	Saltos	I	M	9
62	Equitacao	I	M	9
63	Adestramento	I	M	9
64	Classe Laser	I	M	10
65	Classe Star	I	M	10
66	Classe finn	I	M	10
67	Classe 470	I	M	10
68	Classe Soling	I	M	10
69	Classe Tornado	I	M	10
70	Classe Europa	I	M	10
71	Classe Prancha-vela	I	M	10
72	Peso Galo	I	M	11
73	Peso Mosca	I	M	11
74	Peso Leve	I	M	11
75	Peso Pena	I	M	11
76	Peso Medio	I	M	11
77	Peso Pesado	I	M	11
78	Peso SuperPesado	I	M	11
79	50mt Livre	I	M	12
80	100mt Peito	I	M	12
81	100mt Costas	I	M	12
82	100mt Borboleta	I	M	12
83	100mt Livre	I	M	12
84	200mt Peito	I	M	12
85	200mt Costas	I	M	12
86	200mt Borboleta	I	M	12
87	200mt Livre	I	M	12
88	400mt Peito	I	M	12
89	400mt Costas	I	M	12
90	400mt Borboleta	I	M	12
91	400mt Livre	I	M	12
92	Revezamento 4x100 Livre	C	M	12
93	Revezamento 4x100 Costa	C	M	12
94	800mt Livre	I	M	12
95	1500mt Livre	I	M	12
96	50mt Livre	I	F	12
97	100mt Peito	I	F	12
98	100mt Costas	I	F	12
99	100mt Borboleta	I	F	12
100	100mt Livre	I	F	12
101	200mt Peito	I	F	12
102	200mt Costas	I	F	12
103	200mt Borboleta	I	F	12
104	200mt Livre	I	F	12
105	400mt Peito	I	F	12
106	400mt Costas	I	F	12
107	400mt Borboleta	I	F	12
108	400mt Livre	I	F	12
109	Revezamento 4x100 Livre	C	F	12
110	Revezamento 4x100 Costa	C	F	12
111	1500mt Livre	I	F	12
112	Mesa	I	M	13
113	Quadra	I	M	13
114	Mesa-Dupla	C	M	13
115	Quadra-Dupla	C	M	13
116	Mesa	I	F	13
117	Quadra	I	F	13
118	Mesa-Dupla	C	F	13
119	Quadra-Dupla	C	F	13
120	Masculino	C	M	14
121	Feminino	C	F	14
\.


--
-- Data for Name: competicao; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY competicao (idcompeticao, fase, datacompeticao, horacompeticao, idcat, idlocal) FROM stdin;
1	0	2006-07-10	12:00	1	3
2	1	2006-07-12	12:00	1	3
3	F	2006-07-13	12:00	1	3
4	0	2006-07-14	12:00	2	3
5	1	2006-07-15	12:00	2	3
6	F	2006-07-16	12:00	2	3
7	F	2006-07-17	12:00	121	1
8	0	2006-07-16	12:00	3	3
9	1	2006-07-17	12:00	3	3
10	0	2006-07-16	12:00	4	3
11	1	2006-07-17	12:00	4	3
12	3	2006-07-17	12:00	4	3
\.


--
-- Data for Name: competidor; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY competidor (idcompetidor) FROM stdin;
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
58
59
60
61
62
63
64
65
66
67
68
69
70
71
72
73
74
75
76
77
78
79
80
81
82
83
84
85
86
87
88
\.


--
-- Data for Name: equipe; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY equipe (idcompetidor, nomeequi) FROM stdin;
50	Fut Professores
51	Fut periodo 1
52	Fut periodo 2
53	Fut periodo 3
54	Fut periodo 4
55	Fut periodo 5
56	Fut periodo 6
57	Fut periodo 7
58	Fut periodo 8
59	Volei time 1
60	Volei time 2
61	Natação Comp. masculino
62	Natação Comp. feminino
\.


--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY funcionario (cpf) FROM stdin;
11122233345
11122233346
11122233347
11122233348
11122233349
\.


--
-- Data for Name: inscricao; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY inscricao (idinscricao, idcat, idcompetidor) FROM stdin;
1	1	1
2	1	2
3	1	3
4	15	4
5	1	5
6	1	6
7	1	7
8	1	8
9	1	9
10	1	10
11	2	11
12	2	12
13	2	13
14	2	14
15	2	15
16	2	16
17	2	17
18	2	18
19	2	19
20	2	20
21	42	50
22	42	51
23	42	52
24	42	53
25	42	54
26	42	55
27	42	56
28	42	57
29	42	58
30	121	59
31	121	60
32	79	1
33	80	2
34	81	3
35	82	5
36	96	4
37	97	22
\.


--
-- Data for Name: local; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY local (idlocal, enderecolocal, capacidade, cpf) FROM stdin;
1	Av. 2 nro 3, Udia-MG	5000	11122233348
2	Av. 3 nro 2, Udia-MG	60000	11122233347
3	Av. 1 nro 2, Rio-RJ	60000	11122233347
\.


--
-- Data for Name: modalidade; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY modalidade (idmod, nomemod) FROM stdin;
1	Atletismo
2	Basquete
3	Boxe
4	Ciclismo
5	Futebol
6	Ginástica
7	Handbol
8	Levantamento de Pesos
9	Hipismo
10	Iatimos
11	Judo
12	Natacao
13	Tenis
14	Volei
\.


--
-- Data for Name: modarb; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY modarb (idmodarb, cpf, idmod) FROM stdin;
1	11122233345	1
2	11122233345	5
3	11122233345	14
4	11122233346	1
5	11122233347	5
6	11122233348	1
7	11122233349	14
\.


--
-- Data for Name: modloc; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY modloc (idmodloc, idlocal, idmod) FROM stdin;
1	1	2
2	1	7
3	1	5
4	1	14
5	3	1
6	3	2
7	3	3
8	3	4
9	3	5
10	3	6
11	3	7
12	3	8
13	3	9
14	3	10
15	3	11
16	3	12
17	3	13
18	3	14
\.


--
-- Data for Name: participacao; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY participacao (idparticipacao, idcompeticao, idcompetidor, escore, unidade) FROM stdin;
1	1	1	12	segundos
2	1	2	13	segundos
3	1	3	14	segundos
4	1	9	15	segundos
5	1	5	16	segundos
6	1	6	17	segundos
7	1	7	17.200001	segundos
8	1	8	17.299999	segundos
9	2	1	12.5	segundos
10	2	2	12.6	segundos
11	2	3	12.7	segundos
12	2	9	12.8	segundos
13	3	1	12	segundos
14	3	2	11.6	segundos
15	4	11	55	segundos
16	4	12	56	segundos
17	4	13	57	segundos
18	4	14	58	segundos
19	4	15	59	segundos
20	4	16	60	segundos
21	4	17	60.099998	segundos
22	4	18	60.200001	segundos
23	5	11	54	segundos
24	5	12	55	segundos
25	5	13	56	segundos
26	5	14	57	segundos
27	6	11	52	segundos
28	6	12	51	segundos
29	7	59	3	sets
30	7	60	2	sets
\.


--
-- Data for Name: patrocinador; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY patrocinador (cnpj, nomepat, patevento, patcompetidor, enderecopat, valor) FROM stdin;
10222222000133	Fabrica esportiva 1	1	0	Av. Um   n 1, Udia-MG, Brasil	100000.00
20222222000133	Fabrica esportiva 2	1	0	Av. Dois n 2, Udia-MG, Brasil	50000.00
30222222000133	Fabrica esportiva 3	0	1	Av. Tres n 3, Udia-MG, Brasil	0
\.


--
-- Data for Name: patrocinio; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY patrocinio (idpatrocinio, idcompetidor, cnpj) FROM stdin;
1	1	20222222000133
2	2	20222222000133
3	3	20222222000133
4	4	20222222000133
5	4	30222222000133
6	5	30222222000133
7	6	30222222000133
8	7	30222222000133
9	8	30222222000133
10	9	30222222000133
11	10	30222222000133
\.


--
-- Data for Name: pessoa; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY pessoa (cpf, nomepessoa, datanascimento, sexo) FROM stdin;
11122233301	Adilson Pires	1990-01-01	M
11122233302	Artur A Moura	1990-01-01	M
11122233303	Cesar W Alvarenga	1990-01-01	M
11122233304	Claudia Araujo	1990-01-01	F
11122233305	Daniel N Guardieiro	1990-01-01	M
11122233306	Danilo Ribeiro	1990-01-01	M
11122233307	Diego C Bessa	1990-01-01	M
11122233308	Diego M Oliveira	1990-01-01	M
11122233309	Diogo Mendes	1990-01-01	M
11122233310	Edislei C Reis	1990-01-01	M
11122233311	Eduardo I Sa	1990-01-01	M
11122233312	Eli R Silva	1990-01-01	M
11122233313	Everson F Giacomelli Jr.	1990-01-01	M
11122233314	Fabiano S Terra	1990-01-01	M
11122233315	Fabricio S Araujo	1990-01-01	M
11122233316	Gabriel	1990-01-01	M
11122233317	Gil Victor	1990-01-01	M
11122233318	Guilherme H G Silva	1990-01-01	M
11122233319	Helder Linhare	1990-01-01	M
11122233320	Humberto E Cruz Jr.	1990-01-01	M
11122233321	Jackson G S Souza	1990-01-01	M
11122233322	Jaqueline A Papini	1990-01-01	F
11122233323	Johnathan Machado	1990-01-01	M
11122233324	Jose V Ramalho	1990-01-01	M
11122233325	Leonardo A Piedade	1990-01-01	M
11122233326	Leonardo M Malta	1990-01-01	M
11122233327	Lucas A Melo	1990-01-01	M
11122233328	Luiz F S GonÃ§alves	1990-01-01	M
11122233329	Luiz H F Mineo	1990-01-01	M
11122233330	Marcelo N Faria	1990-01-01	M
11122233331	Marco A L GonÃ§alves	1990-01-01	M
11122233332	Mariangela  S Simedo	1990-01-01	F
11122233333	Maxuel A Alves	1990-01-01	M
11122233334	Pablo D Rezende	1990-01-01	M
11122233335	Rafael Guersoni Resende	1990-01-01	M
11122233336	Raulcezar M F Alves	1990-01-01	M
11122233337	Ricardo S Brito	1990-01-01	M
11122233338	Rodrigo C CustÃ³dio	1990-01-01	M
11122233339	Rubens R Junior	1990-01-01	M
11122233340	Rubens S Melo	1990-01-01	M
11122233341	Samuel B Andrade	1990-01-01	M
11122233342	Thiago C Lopes	1990-01-01	M
11122233343	Thiago H Jesus	1990-01-01	M
11122233344	Thiago P Queiroz	1990-01-01	M
11122233345	Ilmerio R Silva	1990-01-01	M
11122233346	Autran Macedo	1990-01-01	M
11122233347	Anilton Joaquim	1990-01-01	M
11122233348	Claudio Camargo	1990-01-01	M
11122233349	Maria AmÃ©lia	1990-01-01	F
\.


--
-- Name: arbitro_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY arbitro
    ADD CONSTRAINT arbitro_pkey PRIMARY KEY (cpf);


--
-- Name: atlequ_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY atlequ
    ADD CONSTRAINT atlequ_pkey PRIMARY KEY (idatlequ);


--
-- Name: atleta_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY atleta
    ADD CONSTRAINT atleta_pkey PRIMARY KEY (idcompetidor);


--
-- Name: categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (idcat);


--
-- Name: competicao_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY competicao
    ADD CONSTRAINT competicao_pkey PRIMARY KEY (idcompeticao);


--
-- Name: competidor_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY competidor
    ADD CONSTRAINT competidor_pkey PRIMARY KEY (idcompetidor);


--
-- Name: equipe_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY equipe
    ADD CONSTRAINT equipe_pkey PRIMARY KEY (idcompetidor);


--
-- Name: funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (cpf);


--
-- Name: inscricao_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY inscricao
    ADD CONSTRAINT inscricao_pkey PRIMARY KEY (idinscricao);


--
-- Name: local_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY local
    ADD CONSTRAINT local_pkey PRIMARY KEY (idlocal);


--
-- Name: modalidade_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY modalidade
    ADD CONSTRAINT modalidade_pkey PRIMARY KEY (idmod);


--
-- Name: modarb_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY modarb
    ADD CONSTRAINT modarb_pkey PRIMARY KEY (idmodarb);


--
-- Name: modloc_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY modloc
    ADD CONSTRAINT modloc_pkey PRIMARY KEY (idmodloc);


--
-- Name: participacao_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY participacao
    ADD CONSTRAINT participacao_pkey PRIMARY KEY (idparticipacao);


--
-- Name: patrocinador_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY patrocinador
    ADD CONSTRAINT patrocinador_pkey PRIMARY KEY (cnpj);


--
-- Name: patrocinio_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY patrocinio
    ADD CONSTRAINT patrocinio_pkey PRIMARY KEY (idpatrocinio);


--
-- Name: pessoa_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY pessoa
    ADD CONSTRAINT pessoa_pkey PRIMARY KEY (cpf);


--
-- Name: atlequ_aidcompetidor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY atlequ
    ADD CONSTRAINT atlequ_aidcompetidor_fkey FOREIGN KEY (aidcompetidor) REFERENCES atleta(idcompetidor);


--
-- Name: atlequ_eidcompetidor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY atlequ
    ADD CONSTRAINT atlequ_eidcompetidor_fkey FOREIGN KEY (eidcompetidor) REFERENCES equipe(idcompetidor);


--
-- Name: atleta_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY atleta
    ADD CONSTRAINT atleta_cpf_fkey FOREIGN KEY (cpf) REFERENCES pessoa(cpf);


--
-- Name: atleta_idcompetidor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY atleta
    ADD CONSTRAINT atleta_idcompetidor_fkey FOREIGN KEY (idcompetidor) REFERENCES competidor(idcompetidor);


--
-- Name: categoria_idmod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY categoria
    ADD CONSTRAINT categoria_idmod_fkey FOREIGN KEY (idmod) REFERENCES modalidade(idmod);


--
-- Name: competicao_idcat_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY competicao
    ADD CONSTRAINT competicao_idcat_fkey FOREIGN KEY (idcat) REFERENCES categoria(idcat);


--
-- Name: competicao_idlocal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY competicao
    ADD CONSTRAINT competicao_idlocal_fkey FOREIGN KEY (idlocal) REFERENCES local(idlocal);


--
-- Name: equipe_idcompetidor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY equipe
    ADD CONSTRAINT equipe_idcompetidor_fkey FOREIGN KEY (idcompetidor) REFERENCES competidor(idcompetidor);


--
-- Name: inscricao_idcat_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY inscricao
    ADD CONSTRAINT inscricao_idcat_fkey FOREIGN KEY (idcat) REFERENCES categoria(idcat);


--
-- Name: inscricao_idcompetidor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY inscricao
    ADD CONSTRAINT inscricao_idcompetidor_fkey FOREIGN KEY (idcompetidor) REFERENCES competidor(idcompetidor);


--
-- Name: modarb_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY modarb
    ADD CONSTRAINT modarb_cpf_fkey FOREIGN KEY (cpf) REFERENCES arbitro(cpf);


--
-- Name: modarb_idmod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY modarb
    ADD CONSTRAINT modarb_idmod_fkey FOREIGN KEY (idmod) REFERENCES modalidade(idmod);


--
-- Name: modloc_idlocal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY modloc
    ADD CONSTRAINT modloc_idlocal_fkey FOREIGN KEY (idlocal) REFERENCES local(idlocal);


--
-- Name: modloc_idmod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY modloc
    ADD CONSTRAINT modloc_idmod_fkey FOREIGN KEY (idmod) REFERENCES modalidade(idmod);


--
-- Name: participacao_idcompeticao_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY participacao
    ADD CONSTRAINT participacao_idcompeticao_fkey FOREIGN KEY (idcompeticao) REFERENCES competicao(idcompeticao);


--
-- Name: participacao_idcompetidor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY participacao
    ADD CONSTRAINT participacao_idcompetidor_fkey FOREIGN KEY (idcompetidor) REFERENCES competidor(idcompetidor);


--
-- Name: patrocinio_cnpj_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY patrocinio
    ADD CONSTRAINT patrocinio_cnpj_fkey FOREIGN KEY (cnpj) REFERENCES patrocinador(cnpj);


--
-- Name: patrocinio_idcompetidor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY patrocinio
    ADD CONSTRAINT patrocinio_idcompetidor_fkey FOREIGN KEY (idcompetidor) REFERENCES competidor(idcompetidor);


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

\connect clientes

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: cliente; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE cliente (
    cliente_id integer NOT NULL,
    cliente_nome character varying(50),
    cliente_end character varying(50),
    cliente_end_cidade character(20),
    estado_codigo character varying(2),
    cliente_end_cep character varying(8),
    cliente_telefone character varying(10),
    cliente_perc_desconto numeric(2,0)
);


ALTER TABLE public.cliente OWNER TO postgres;

--
-- Name: estado; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE estado (
    estado_codigo character varying(2) NOT NULL,
    estado_nome character varying(25)
);


ALTER TABLE public.estado OWNER TO postgres;

--
-- Name: item; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE item (
    pedido_identificacao integer NOT NULL,
    produto_codigo smallint NOT NULL,
    item_quantidade smallint,
    item_valor_unitario numeric(5,2),
    item_valor_total numeric(5,2)
);


ALTER TABLE public.item OWNER TO postgres;

--
-- Name: pedido; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE pedido (
    pedido_identificacao integer NOT NULL,
    pedido_tipo integer,
    cliente_id integer,
    pedido_data_entrada date,
    pedido_valor_total numeric(7,2),
    pedido_desconto numeric(7,2),
    pedido_dt_embarque date
);


ALTER TABLE public.pedido OWNER TO postgres;

--
-- Name: produto; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE produto (
    produto_codigo smallint NOT NULL,
    produto_nome character varying(40),
    produto_preco numeric(5,2),
    ue_produto_cod character varying(3)
);


ALTER TABLE public.produto OWNER TO postgres;

--
-- Name: primeira_view; Type: VIEW; Schema: public; Owner: jao
--

CREATE VIEW primeira_view AS
    SELECT produto.produto_codigo AS codigo_produto, produto.produto_nome AS nome_produto FROM produto WHERE (produto.produto_preco > (2)::numeric);


ALTER TABLE public.primeira_view OWNER TO jao;

--
-- Name: produto_aux; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE produto_aux (
    produto_aux_nome character varying(40),
    produto_aux_preco numeric(5,2),
    produto_aux_codigo integer NOT NULL,
    ue_produto_aux_codigo character(3) NOT NULL
);


ALTER TABLE public.produto_aux OWNER TO postgres;

--
-- Name: produto_aux_produto_aux_codigo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE produto_aux_produto_aux_codigo_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.produto_aux_produto_aux_codigo_seq OWNER TO postgres;

--
-- Name: produto_aux_produto_aux_codigo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE produto_aux_produto_aux_codigo_seq OWNED BY produto_aux.produto_aux_codigo;


--
-- Name: produto_aux_produto_aux_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('produto_aux_produto_aux_codigo_seq', 1, false);


--
-- Name: ue_produto; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ue_produto (
    ue_produto_cod character(3) NOT NULL,
    ue_produto_descr character varying(50)
);


ALTER TABLE public.ue_produto OWNER TO postgres;

--
-- Name: ue_produto_aux; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ue_produto_aux (
    ue_produto_aux_descr character varying(50),
    ue_produto_aux_codigo character(3) NOT NULL
);


ALTER TABLE public.ue_produto_aux OWNER TO postgres;

--
-- Name: produto_aux_codigo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY produto_aux ALTER COLUMN produto_aux_codigo SET DEFAULT nextval('produto_aux_produto_aux_codigo_seq'::regclass);


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY cliente (cliente_id, cliente_nome, cliente_end, cliente_end_cidade, estado_codigo, cliente_end_cep, cliente_telefone, cliente_perc_desconto) FROM stdin;
1	João	Rua dos Bobos	Foz do Iguaçu       	PR	8585555	99999999	15
2	Maria	Rua das Violetas	Rio de Janeiro      	RJ	9985845	11111111	10
3	Marcos	Rua sem nome	São Joaquim         	MT	9874541	22222222	0
4	Fernanda	Rua qualquer	São Carlos          	SP	3994832	33333333	12
5	Jussara	Travessa aquela lá	Campo Grande        	MS	6904993	44444444	18
\.


--
-- Data for Name: estado; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY estado (estado_codigo, estado_nome) FROM stdin;
SP	São Paulo
RJ	Rio de Janeiro
PR	Paraná
SC	Santa Catarina
RS	Rio Grande do Sul
MT	Mato Grosso
MS	Mato Grosso do Sul
PI	Piauí
PA	Pará
\.


--
-- Data for Name: item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY item (pedido_identificacao, produto_codigo, item_quantidade, item_valor_unitario, item_valor_total) FROM stdin;
1	1	7	4.00	28.00
2	3	50	2.00	100.00
3	1	50	4.00	200.00
4	1	100	2.50	250.00
\.


--
-- Data for Name: pedido; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY pedido (pedido_identificacao, pedido_tipo, cliente_id, pedido_data_entrada, pedido_valor_total, pedido_desconto, pedido_dt_embarque) FROM stdin;
1	5	1	2005-11-11	28.00	0.00	2005-11-13
2	3	2	2005-11-11	300.00	5.00	2005-11-11
3	5	1	2005-12-18	450.00	20.00	2005-12-22
\.


--
-- Data for Name: produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY produto (produto_codigo, produto_nome, produto_preco, ue_produto_cod) FROM stdin;
1	ARROZ BRANCO	2.50	ARR
2	FEIJÃO CARIOCA	3.80	FEI
3	FEIJÃO PRETO	3.20	FEI
5	LEITE INTEGRAL	2.25	LET
4	MACARRÃO INSTANTÂNEO	2.70	MAC
\.


--
-- Data for Name: produto_aux; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY produto_aux (produto_aux_nome, produto_aux_preco, produto_aux_codigo, ue_produto_aux_codigo) FROM stdin;
ARROZ BRANCO	2.50	1	ARR
MACARRÃO INSTANTÂNEO	1.20	4	MAC
LEITE INTEGRAL	1.50	5	LET
\.


--
-- Data for Name: ue_produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ue_produto (ue_produto_cod, ue_produto_descr) FROM stdin;
ARR	ARROZ
FEI	FEIJÃO
MAC	MACARRÃO
LET	LEITE
\.


--
-- Data for Name: ue_produto_aux; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ue_produto_aux (ue_produto_aux_descr, ue_produto_aux_codigo) FROM stdin;
ARROZ	ARR
FEIJÃO	FEI
MACARRÃO	MAC
LEITE	LET
\.


--
-- Name: cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (cliente_id);


--
-- Name: estado_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY estado
    ADD CONSTRAINT estado_pkey PRIMARY KEY (estado_codigo);


--
-- Name: item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY item
    ADD CONSTRAINT item_pkey PRIMARY KEY (pedido_identificacao, produto_codigo);


--
-- Name: pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pedido
    ADD CONSTRAINT pedido_pkey PRIMARY KEY (pedido_identificacao);


--
-- Name: produto_aux_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY produto_aux
    ADD CONSTRAINT produto_aux_pkey PRIMARY KEY (produto_aux_codigo);


--
-- Name: produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY produto
    ADD CONSTRAINT produto_pkey PRIMARY KEY (produto_codigo);


--
-- Name: ue_produto_aux_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ue_produto_aux
    ADD CONSTRAINT ue_produto_aux_pkey PRIMARY KEY (ue_produto_aux_codigo);


--
-- Name: ue_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ue_produto
    ADD CONSTRAINT ue_produto_pkey PRIMARY KEY (ue_produto_cod);


--
-- Name: produto_aux_name_index; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX produto_aux_name_index ON produto_aux USING btree (produto_aux_nome);


--
-- Name: cliente_estado_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cliente
    ADD CONSTRAINT cliente_estado_fk FOREIGN KEY (estado_codigo) REFERENCES estado(estado_codigo);


--
-- Name: item_produto_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY item
    ADD CONSTRAINT item_produto_fk FOREIGN KEY (produto_codigo) REFERENCES produto(produto_codigo);


--
-- Name: pedido_cliente_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pedido
    ADD CONSTRAINT pedido_cliente_fk FOREIGN KEY (cliente_id) REFERENCES cliente(cliente_id);


--
-- Name: produto_ueproduto_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY produto
    ADD CONSTRAINT produto_ueproduto_fk FOREIGN KEY (ue_produto_cod) REFERENCES ue_produto(ue_produto_cod);


--
-- Name: ue_produto_aux_codigo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY produto_aux
    ADD CONSTRAINT ue_produto_aux_codigo FOREIGN KEY (ue_produto_aux_codigo) REFERENCES ue_produto_aux(ue_produto_aux_codigo) ON UPDATE CASCADE ON DELETE CASCADE;


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

\connect clube

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ambiente; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE ambiente (
    idambiente integer NOT NULL,
    nome character varying(100)
);


ALTER TABLE public.ambiente OWNER TO jao;

--
-- Name: ambiente_idambiente_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE ambiente_idambiente_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ambiente_idambiente_seq OWNER TO jao;

--
-- Name: ambiente_idambiente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE ambiente_idambiente_seq OWNED BY ambiente.idambiente;


--
-- Name: ambiente_idambiente_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('ambiente_idambiente_seq', 10, true);


--
-- Name: analise; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE analise (
    analise integer NOT NULL,
    cpf character varying(15),
    passou boolean
);


ALTER TABLE public.analise OWNER TO jao;

--
-- Name: analise_analise_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE analise_analise_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.analise_analise_seq OWNER TO jao;

--
-- Name: analise_analise_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE analise_analise_seq OWNED BY analise.analise;


--
-- Name: analise_analise_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('analise_analise_seq', 17, true);


--
-- Name: dependente; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE dependente (
    iddependente integer NOT NULL,
    idtitular integer,
    nome character varying(100),
    rg character varying(15),
    apto_piscina boolean DEFAULT false
);


ALTER TABLE public.dependente OWNER TO jao;

--
-- Name: dependente_iddependente_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE dependente_iddependente_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.dependente_iddependente_seq OWNER TO jao;

--
-- Name: dependente_iddependente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE dependente_iddependente_seq OWNED BY dependente.iddependente;


--
-- Name: dependente_iddependente_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('dependente_iddependente_seq', 21, true);


--
-- Name: endereco; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE endereco (
    idendereco integer NOT NULL,
    rua character varying(50),
    bairro character varying(20),
    cidade character varying(30),
    estado character varying(30),
    numero character varying(5)
);


ALTER TABLE public.endereco OWNER TO jao;

--
-- Name: endereco_idendereco_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE endereco_idendereco_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.endereco_idendereco_seq OWNER TO jao;

--
-- Name: endereco_idendereco_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE endereco_idendereco_seq OWNED BY endereco.idendereco;


--
-- Name: endereco_idendereco_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('endereco_idendereco_seq', 40, true);


--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE funcionario (
    idfuncionario integer NOT NULL,
    idsetor integer,
    nome character varying(100),
    senha character varying(8),
    eh_diretor boolean DEFAULT false,
    cpf character varying(15)
);


ALTER TABLE public.funcionario OWNER TO jao;

--
-- Name: funcionario_idfuncionario_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE funcionario_idfuncionario_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.funcionario_idfuncionario_seq OWNER TO jao;

--
-- Name: funcionario_idfuncionario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE funcionario_idfuncionario_seq OWNED BY funcionario.idfuncionario;


--
-- Name: funcionario_idfuncionario_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('funcionario_idfuncionario_seq', 11, true);


--
-- Name: inadimplentes; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE inadimplentes (
    idtitular integer,
    cpf character varying(15),
    nome character varying(30),
    telefone character varying(20),
    data_contato date,
    contatado boolean DEFAULT false,
    codigo integer NOT NULL
);


ALTER TABLE public.inadimplentes OWNER TO jao;

--
-- Name: inadimplentes_codigo_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE inadimplentes_codigo_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.inadimplentes_codigo_seq OWNER TO jao;

--
-- Name: inadimplentes_codigo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE inadimplentes_codigo_seq OWNED BY inadimplentes.codigo;


--
-- Name: inadimplentes_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('inadimplentes_codigo_seq', 68, true);


--
-- Name: joia; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE joia (
    idjoia integer NOT NULL,
    idtitular integer,
    pago boolean,
    valor real
);


ALTER TABLE public.joia OWNER TO jao;

--
-- Name: joia_idjoia_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE joia_idjoia_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.joia_idjoia_seq OWNER TO jao;

--
-- Name: joia_idjoia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE joia_idjoia_seq OWNED BY joia.idjoia;


--
-- Name: joia_idjoia_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('joia_idjoia_seq', 5, true);


--
-- Name: negados; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE negados (
    cpf character varying(15),
    motivo character varying(300),
    codigo integer NOT NULL
);


ALTER TABLE public.negados OWNER TO jao;

--
-- Name: negados_codigo_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE negados_codigo_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.negados_codigo_seq OWNER TO jao;

--
-- Name: negados_codigo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE negados_codigo_seq OWNED BY negados.codigo;


--
-- Name: negados_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('negados_codigo_seq', 5, true);


--
-- Name: pagamento; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE pagamento (
    idpagamento integer NOT NULL,
    idtitular integer,
    valor real,
    mes_de_referencia integer,
    ano_de_referencia integer,
    pago boolean DEFAULT false NOT NULL
);


ALTER TABLE public.pagamento OWNER TO jao;

--
-- Name: pagamento_idpagamento_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE pagamento_idpagamento_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.pagamento_idpagamento_seq OWNER TO jao;

--
-- Name: pagamento_idpagamento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE pagamento_idpagamento_seq OWNED BY pagamento.idpagamento;


--
-- Name: pagamento_idpagamento_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('pagamento_idpagamento_seq', 18, true);


--
-- Name: reserva; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE reserva (
    idreserva integer NOT NULL,
    idambiente integer,
    idtitular integer,
    data_de_solicitacao date,
    data_reserva date,
    hora_reserva integer,
    nome_dos_usuarios character varying(200)
);


ALTER TABLE public.reserva OWNER TO jao;

--
-- Name: reserva_idreserva_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE reserva_idreserva_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.reserva_idreserva_seq OWNER TO jao;

--
-- Name: reserva_idreserva_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE reserva_idreserva_seq OWNED BY reserva.idreserva;


--
-- Name: reserva_idreserva_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('reserva_idreserva_seq', 4, true);


--
-- Name: setor; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE setor (
    idsetor integer NOT NULL,
    nome character varying(100)
);


ALTER TABLE public.setor OWNER TO jao;

--
-- Name: setor_idsetor_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE setor_idsetor_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.setor_idsetor_seq OWNER TO jao;

--
-- Name: setor_idsetor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE setor_idsetor_seq OWNED BY setor.idsetor;


--
-- Name: setor_idsetor_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('setor_idsetor_seq', 6, true);


--
-- Name: socio; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE socio (
    idtitular integer NOT NULL,
    nome character varying(100),
    dt_nasc date,
    cpf character varying(15),
    rg character varying(20),
    celular character varying(15),
    mail character varying(50),
    formacao character varying(50),
    senha character varying(8),
    apto_piscina boolean,
    telefone character varying(20),
    profissao character varying(30),
    salario_mensal real,
    outras_rendas real,
    id_endereco integer NOT NULL,
    aceito boolean DEFAULT false NOT NULL,
    analise boolean DEFAULT false NOT NULL
);


ALTER TABLE public.socio OWNER TO jao;

--
-- Name: socio_idtitular_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE socio_idtitular_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.socio_idtitular_seq OWNER TO jao;

--
-- Name: socio_idtitular_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE socio_idtitular_seq OWNED BY socio.idtitular;


--
-- Name: socio_idtitular_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('socio_idtitular_seq', 22, true);


--
-- Name: idambiente; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY ambiente ALTER COLUMN idambiente SET DEFAULT nextval('ambiente_idambiente_seq'::regclass);


--
-- Name: analise; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY analise ALTER COLUMN analise SET DEFAULT nextval('analise_analise_seq'::regclass);


--
-- Name: iddependente; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY dependente ALTER COLUMN iddependente SET DEFAULT nextval('dependente_iddependente_seq'::regclass);


--
-- Name: idendereco; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY endereco ALTER COLUMN idendereco SET DEFAULT nextval('endereco_idendereco_seq'::regclass);


--
-- Name: idfuncionario; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY funcionario ALTER COLUMN idfuncionario SET DEFAULT nextval('funcionario_idfuncionario_seq'::regclass);


--
-- Name: codigo; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY inadimplentes ALTER COLUMN codigo SET DEFAULT nextval('inadimplentes_codigo_seq'::regclass);


--
-- Name: idjoia; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY joia ALTER COLUMN idjoia SET DEFAULT nextval('joia_idjoia_seq'::regclass);


--
-- Name: codigo; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY negados ALTER COLUMN codigo SET DEFAULT nextval('negados_codigo_seq'::regclass);


--
-- Name: idpagamento; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY pagamento ALTER COLUMN idpagamento SET DEFAULT nextval('pagamento_idpagamento_seq'::regclass);


--
-- Name: idreserva; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY reserva ALTER COLUMN idreserva SET DEFAULT nextval('reserva_idreserva_seq'::regclass);


--
-- Name: idsetor; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY setor ALTER COLUMN idsetor SET DEFAULT nextval('setor_idsetor_seq'::regclass);


--
-- Name: idtitular; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY socio ALTER COLUMN idtitular SET DEFAULT nextval('socio_idtitular_seq'::regclass);


--
-- Data for Name: ambiente; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY ambiente (idambiente, nome) FROM stdin;
3	Quadra de Tenis
4	Golf
5	Salao de festas
6	Playground
7	Futebol
8	Futebol Society
9	Futsal
10	Piscina Semi Olimpica
1	Piscina Aquecida
2	Piscina
\.


--
-- Data for Name: analise; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY analise (analise, cpf, passou) FROM stdin;
15	381.449.128-96	t
16	152.133.639-38	t
17	937.617.416-00	t
\.


--
-- Data for Name: dependente; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY dependente (iddependente, idtitular, nome, rg, apto_piscina) FROM stdin;
8	10	Jose Carlos	12345	f
10	10	Maria Carla Santanna	1234567	f
14	14	Maiara da Silva	841542648	f
15	14	Ricardo Coração de Leão	8748154	f
16	15	Isadora da Silva	887445155	f
17	18	Maria do Rosario	845215516	f
18	19	Maria Camargo	451545161	f
19	21	Diego Vieira	15411615	f
20	21	Marcela Vieira	15461616	f
21	21	Stephanie Vieira	15461564	f
\.


--
-- Data for Name: endereco; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY endereco (idendereco, rua, bairro, cidade, estado, numero) FROM stdin;
26	Manuel Thobias	Zona Norte	Porto Alegre	Rio Grande do Sul - RS	156
28	Campo Belo	Manguaça	Ponta Grossa	Paraná - PR	51
32	Av. Silva Jardim	Centro	Ponta Grossa	Paraná - PR	87
33	Av. Brasil	Centro	São Paulo	São Paulo - SP	600
34	Av. Brasil	Centro	São Paulo	São Paulo - SP	600
35	Av. Carlos Bonifacio	Centro	Curitiba	Paraná - PR	89
36	Rua os 18 do Forte	Centro	Caxias do Sul	Rio Grande do Sul - RS	10
37	Rua Benjamin Constante	Centro	Passo Fundo	Rio Grande do Sul - RS	14
38	Rua dos Pardais	Centro	Carazinho	Rio Grande do Sul - RS	900
39	Av. dos Profetas	Centro	Caxias do Sul	Rio Grande do Sul - RS	01
40	Rua 21	Centro	Ponta Grossa	Paraná - PR	17
24	Os 18 dos Forte	Centro	Caxias do Sul	Rio Grande do Sul - RS	152B
17	Julia Wanderley	Centro	Ponta Grossa	Acre - AC	1190
\.


--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY funcionario (idfuncionario, idsetor, nome, senha, eh_diretor, cpf) FROM stdin;
1	1	Joao Celio Barbosa	Entrada1	f	042.079.780-16
2	1	Osmar Loss	Entrada2	t	231.056.987-23
3	2	Marcelo Cirino	Reserva1	f	142.019.780-16
5	3	Ronaldo Nazario	Analise1	f	343.039.780-16
6	3	Dilma Roussef	Analise1	t	011.042.987-23
7	4	Gabriel Malinali	Cobranca	f	851.079.780-36
8	4	Renato Russo	Cobranca	t	042.060.780-46
9	5	Gian Giovane	Relacoes	t	011.042.987-23
10	5	Pedro Cabral Alves	Relacoes	f	851.079.780-36
11	6	Obana Baracka	Diretor1	t	111.123.456-78
4	2	Ricardo Rocha	Reserva1	t	042.024.780-06
\.


--
-- Data for Name: inadimplentes; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY inadimplentes (idtitular, cpf, nome, telefone, data_contato, contatado, codigo) FROM stdin;
21	937.617.416-00	Gustavo Vieira	(42)97815471	\N	f	67
10	505.386.646-57	Jose Miguel	123123133	2016-06-29	t	68
\.


--
-- Data for Name: joia; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY joia (idjoia, idtitular, pago, valor) FROM stdin;
1	10	t	150
2	8	t	200.3
5	21	t	207.006
\.


--
-- Data for Name: negados; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY negados (cpf, motivo, codigo) FROM stdin;
151.151.151-15	Renda Insuficiente	1
156.115.151-51	Renda Insuficiente	2
181.981.919-99	Nao Apresentou os documentos necessarios	3
788.916.111-31	Nao Apresentou os documentos necessarios	4
504.097.874-88	Nao Apresentou os documentos necessarios	5
\.


--
-- Data for Name: pagamento; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY pagamento (idpagamento, idtitular, valor, mes_de_referencia, ano_de_referencia, pago) FROM stdin;
13	10	50	6	2016	f
14	10	50	6	2016	f
15	10	50	6	2016	f
16	21	50	6	2016	f
17	21	50	6	2016	f
18	21	50	6	2016	f
\.


--
-- Data for Name: reserva; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY reserva (idreserva, idambiente, idtitular, data_de_solicitacao, data_reserva, hora_reserva, nome_dos_usuarios) FROM stdin;
1	3	8	\N	2016-07-08	7	Sonia Blade
3	3	8	\N	2016-07-14	8	Carlos Silva
4	3	8	2016-06-27	2016-07-14	7	Ricardo
\.


--
-- Data for Name: setor; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY setor (idsetor, nome) FROM stdin;
1	Entrada
2	Reserva
3	Analise
4	Cobranca
5	Relacoes
6	Diretoria
\.


--
-- Data for Name: socio; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY socio (idtitular, nome, dt_nasc, cpf, rg, celular, mail, formacao, senha, apto_piscina, telefone, profissao, salario_mensal, outras_rendas, id_endereco, aceito, analise) FROM stdin;
17	Carol Barcellos	1980-10-01	914.375.758-89	845245-51.0	(25)842245555	carol@bol.com	Historia	12345678	f	(25)842421578	Historiadora	1.5	1000	35	f	f
18	Mailson Souza	1991-10-01	117.491.485-87	18421-0	(54)848484841	ailson@uol.com	Sem formação	12345678	f	(54)848451545	Marceneiro	3000	0	36	f	f
20	Edmilson Calabria	1970-10-01	298.256.820-94	1515161541	(43)871514518	calabria@bol.com	Estudante	12345678	f	(43)871514518	Estudante	900	500	38	f	f
15	Will Smith	1960-06-01	845.585.112-05	8758489	(48)84528426	smith@hotmail.com	Ator	12345678	f	(48)84528426	Ator	25000	0	33	f	t
10	Jose Miguel	1975-03-11	505.386.646-57	789454515	132515641	jmigue@hotmail.com	sem formacao	12345678	f	123123133	Auxiliar de Escritorio	1500	0	28	t	t
19	Jean Camargo	1980-10-01	144.276.746-40	51541515	(54)98989884	jean@hotmail.com	Sem Formação	12345678	f	(54)98989884	Pedreiro	4000	500	37	f	t
22	João Barbosa	1920-01-01	004.945.178-24	887784889	(42)8984789	jb@hotmail.com	Sem Formação	12345678	f	(42)8984789	Autonomo	1000	1500	40	f	f
3	Dion Maicon Duarte	1991-08-11	287.238.822-20	2101226484	5491485156	dion@outlook.com	Ciencia da Computacao	78945612	f	5491451740	Desenvolvedor Java	7000	5000	17	f	f
16	Will Smith	1960-06-01	379.943.941-24	8758489	(48)84528426	smith@hotmail.com	Ator	12345678	f	(48)84528426	Ator	50000	80000	34	f	f
8	Carlos Santana	1964-02-02	935.332.477-75	1234567891	2121212133	santanac@rlos.com	Music	12345678	t	1212122121	Musico	1000	0	26	f	f
6	Adao Lopes	1950-01-01	381.449.128-96	1231231234	4218484841	jmaria@hotmail.com	Engenheiro Mecanico	\N	f	5484115188	Eng Mecanico	6000	2000	24	f	t
14	Marcelo Caipora	1990-06-11	152.133.639-38	451545-2	(42)99842141	marcelohhh@outlook.com	Ciências Da Computação	12345678	f	(42)99842141	Desenvolvedor	2000	1000	32	f	t
21	Gustavo Vieira	1987-10-01	937.617.416-00	151168	(42)97815471	gusv@hotmail.com	Engenharia de Software	12345678	f	(42)97815471	Engenheiro de Software	7000	5000	39	t	t
\.


--
-- Name: ambiente_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY ambiente
    ADD CONSTRAINT ambiente_pkey PRIMARY KEY (idambiente);


--
-- Name: analise_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY analise
    ADD CONSTRAINT analise_pkey PRIMARY KEY (analise);


--
-- Name: dependente_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY dependente
    ADD CONSTRAINT dependente_pkey PRIMARY KEY (iddependente);


--
-- Name: endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (idendereco);


--
-- Name: funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (idfuncionario);


--
-- Name: inadimplentes_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY inadimplentes
    ADD CONSTRAINT inadimplentes_pkey PRIMARY KEY (codigo);


--
-- Name: joia_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY joia
    ADD CONSTRAINT joia_pkey PRIMARY KEY (idjoia);


--
-- Name: negados_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY negados
    ADD CONSTRAINT negados_pkey PRIMARY KEY (codigo);


--
-- Name: pagamento_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY pagamento
    ADD CONSTRAINT pagamento_pkey PRIMARY KEY (idpagamento);


--
-- Name: reserva_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY reserva
    ADD CONSTRAINT reserva_pkey PRIMARY KEY (idreserva);


--
-- Name: setor_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY setor
    ADD CONSTRAINT setor_pkey PRIMARY KEY (idsetor);


--
-- Name: socio_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY socio
    ADD CONSTRAINT socio_pkey PRIMARY KEY (idtitular);


--
-- Name: dependente_idtitular_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY dependente
    ADD CONSTRAINT dependente_idtitular_fkey FOREIGN KEY (idtitular) REFERENCES socio(idtitular);


--
-- Name: funcionario_idsetor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY funcionario
    ADD CONSTRAINT funcionario_idsetor_fkey FOREIGN KEY (idsetor) REFERENCES setor(idsetor);


--
-- Name: joia_idtitular_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY joia
    ADD CONSTRAINT joia_idtitular_fkey FOREIGN KEY (idtitular) REFERENCES socio(idtitular);


--
-- Name: pagamento_idtitular_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY pagamento
    ADD CONSTRAINT pagamento_idtitular_fkey FOREIGN KEY (idtitular) REFERENCES socio(idtitular);


--
-- Name: reserva_idambiente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY reserva
    ADD CONSTRAINT reserva_idambiente_fkey FOREIGN KEY (idambiente) REFERENCES ambiente(idambiente);


--
-- Name: reserva_idtitular_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY reserva
    ADD CONSTRAINT reserva_idtitular_fkey FOREIGN KEY (idtitular) REFERENCES socio(idtitular);


--
-- Name: socio_id_endereco_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY socio
    ADD CONSTRAINT socio_id_endereco_fkey FOREIGN KEY (id_endereco) REFERENCES endereco(idendereco);


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

\connect postgres

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

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

\connect posto

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: jao
--

CREATE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO jao;

SET search_path = public, pg_catalog;

--
-- Name: atualiza_estoque_por_compras(); Type: FUNCTION; Schema: public; Owner: jao
--

CREATE FUNCTION atualiza_estoque_por_compras() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN 
	UPDATE PRODUTOS SET QUANT_EM_ESTOQUE = QUANT_EM_ESTOQUE + COMPRAS.QUANTIDADE FROM COMPRAS WHERE PRODUTOS.IDPRODUTO = COMPRAS.IDPRODUTO AND COMPRAS.UNID_MEDIDA = PRODUTOS.UNID_MEDIDA;
	RETURN NULL;
END;
$$;


ALTER FUNCTION public.atualiza_estoque_por_compras() OWNER TO jao;

--
-- Name: proc_atualiza_vendas(); Type: FUNCTION; Schema: public; Owner: jao
--

CREATE FUNCTION proc_atualiza_vendas() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN 
	IF (NEW.CONCRETIZADA IS TRUE AND OLD.CONCRETIZADA IS FALSE) THEN
		INSERT INTO VENDAS(IDPRODUTO,VALOR_VENDA_UNIDADE,VALOR_VENDA_TOTAL, QUANTIDADE, DATA, CODIGO_VENDA, TIPO_PAGAMENTO) VALUES(OLD.IDPRODUTO, 0, 0 ,OLD.QUANTIDADE,CURRENT_TIMESTAMP, OLD.CODIGO_VENDA, OLD.TIPO_PAGAMENTO);
		UPDATE PRODUTOS SET QUANT_EM_ESTOQUE = QUANT_EM_ESTOQUE - OLD.QUANTIDADE WHERE PRODUTOS.IDPRODUTO = OLD.IDPRODUTO AND QUANT_EM_ESTOQUE IS NOT NULL;
		UPDATE VENDAS SET VALOR_VENDA_TOTAL = PRODUTOS.PRECO_VENDA * OLD.QUANTIDADE , VALOR_VENDA_UNIDADE = PRODUTOS.PRECO_VENDA FROM PRODUTOS WHERE VENDAS.CODIGO_VENDA = OLD.CODIGO_VENDA AND PRODUTOS.IDPRODUTO = OLD.IDPRODUTO AND VALOR_VENDA_TOTAL = 0;  	
	END IF;
	RETURN NULL;
END;
$$;


ALTER FUNCTION public.proc_atualiza_vendas() OWNER TO jao;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: categorias; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE categorias (
    idcategoria integer NOT NULL,
    idsetor integer,
    descricao character varying(50)
);


ALTER TABLE public.categorias OWNER TO jao;

--
-- Name: categorias_idcategoria_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE categorias_idcategoria_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.categorias_idcategoria_seq OWNER TO jao;

--
-- Name: categorias_idcategoria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE categorias_idcategoria_seq OWNED BY categorias.idcategoria;


--
-- Name: categorias_idcategoria_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('categorias_idcategoria_seq', 12, true);


--
-- Name: compras; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE compras (
    idfornecedor integer,
    idproduto integer,
    unid_medida character varying(10) NOT NULL,
    quantidade real NOT NULL,
    preco_por_unidade real NOT NULL,
    data_entrada date
);


ALTER TABLE public.compras OWNER TO jao;

--
-- Name: produtos; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE produtos (
    idproduto integer NOT NULL,
    idcategoria integer NOT NULL,
    idfornecedor integer NOT NULL,
    nome character varying(50),
    descricao character varying(80),
    preco_venda real,
    quant_em_estoque real,
    unid_medida character varying(10),
    quant_minima_estoque real
);


ALTER TABLE public.produtos OWNER TO jao;

--
-- Name: estoque_minimo; Type: VIEW; Schema: public; Owner: jao
--

CREATE VIEW estoque_minimo AS
    SELECT produtos.idproduto AS codigo, produtos.idcategoria AS categoria, produtos.nome AS produto, produtos.quant_minima_estoque AS estoque_minimo, produtos.quant_em_estoque AS estoque_atual FROM produtos WHERE (produtos.quant_em_estoque < produtos.quant_minima_estoque);


ALTER TABLE public.estoque_minimo OWNER TO jao;

--
-- Name: setor; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE setor (
    idsetor integer NOT NULL,
    descricao character varying(50)
);


ALTER TABLE public.setor OWNER TO jao;

--
-- Name: estoque_setor_produto; Type: VIEW; Schema: public; Owner: jao
--

CREATE VIEW estoque_setor_produto AS
    SELECT setor.descricao AS setor, produtos.nome, produtos.quant_em_estoque AS quantidade FROM produtos, setor, categorias WHERE ((produtos.idcategoria = categorias.idcategoria) AND (categorias.idsetor = setor.idsetor)) GROUP BY produtos.nome, setor.descricao, produtos.quant_em_estoque ORDER BY setor.descricao DESC;


ALTER TABLE public.estoque_setor_produto OWNER TO jao;

--
-- Name: fornecedores; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE fornecedores (
    idfornecedor integer NOT NULL,
    razao_social character varying(50),
    cidade character varying(50),
    estado_uf character(2),
    rua character varying(50),
    numero character varying(6),
    cep character varying(10),
    cnpj character varying(20) NOT NULL
);


ALTER TABLE public.fornecedores OWNER TO jao;

--
-- Name: fornecedores_idfornecedor_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE fornecedores_idfornecedor_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.fornecedores_idfornecedor_seq OWNER TO jao;

--
-- Name: fornecedores_idfornecedor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE fornecedores_idfornecedor_seq OWNED BY fornecedores.idfornecedor;


--
-- Name: fornecedores_idfornecedor_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('fornecedores_idfornecedor_seq', 4, true);


--
-- Name: produtos_idproduto_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE produtos_idproduto_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.produtos_idproduto_seq OWNER TO jao;

--
-- Name: produtos_idproduto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE produtos_idproduto_seq OWNED BY produtos.idproduto;


--
-- Name: produtos_idproduto_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('produtos_idproduto_seq', 29, true);


--
-- Name: sessao; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE sessao (
    codigo integer NOT NULL,
    responsavel character varying(30) NOT NULL,
    data timestamp without time zone NOT NULL
);


ALTER TABLE public.sessao OWNER TO jao;

--
-- Name: sessao_codigo_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE sessao_codigo_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sessao_codigo_seq OWNER TO jao;

--
-- Name: sessao_codigo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE sessao_codigo_seq OWNED BY sessao.codigo;


--
-- Name: sessao_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('sessao_codigo_seq', 1, false);


--
-- Name: setor_idsetor_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE setor_idsetor_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.setor_idsetor_seq OWNER TO jao;

--
-- Name: setor_idsetor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE setor_idsetor_seq OWNED BY setor.idsetor;


--
-- Name: setor_idsetor_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('setor_idsetor_seq', 2, true);


--
-- Name: vendas; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE vendas (
    idproduto integer,
    valor_venda_unidade real,
    valor_venda_total real,
    quantidade real,
    data timestamp without time zone,
    codigo_venda integer,
    tipo_pagamento character varying(20)
);


ALTER TABLE public.vendas OWNER TO jao;

--
-- Name: vendas_aux; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE vendas_aux (
    idproduto integer,
    quantidade real,
    codigo_venda integer,
    tipo_pagamento character varying(20),
    concretizada boolean DEFAULT false
);


ALTER TABLE public.vendas_aux OWNER TO jao;

--
-- Name: vendas_produto_por_dia; Type: VIEW; Schema: public; Owner: jao
--

CREATE VIEW vendas_produto_por_dia AS
    SELECT sum(vendas.valor_venda_total) AS total, produtos.nome AS produto, (SELECT date_part('DAY'::text, vendas.data) AS date_part) AS dia FROM vendas, produtos WHERE (produtos.idproduto = vendas.idproduto) GROUP BY vendas.idproduto, produtos.nome, (SELECT date_part('DAY'::text, vendas.data) AS date_part) ORDER BY sum(vendas.valor_venda_total) DESC;


ALTER TABLE public.vendas_produto_por_dia OWNER TO jao;

--
-- Name: vendas_produto_por_mes; Type: VIEW; Schema: public; Owner: jao
--

CREATE VIEW vendas_produto_por_mes AS
    SELECT sum(vendas.valor_venda_total) AS total, produtos.nome AS produto, (SELECT date_part('MONTH'::text, vendas.data) AS date_part) AS mes FROM vendas, produtos WHERE (produtos.idproduto = vendas.idproduto) GROUP BY vendas.idproduto, produtos.nome, (SELECT date_part('MONTH'::text, vendas.data) AS date_part) ORDER BY sum(vendas.valor_venda_total) DESC;


ALTER TABLE public.vendas_produto_por_mes OWNER TO jao;

--
-- Name: vendas_setor_por_dia; Type: VIEW; Schema: public; Owner: jao
--

CREATE VIEW vendas_setor_por_dia AS
    SELECT sum(vendas.valor_venda_total) AS total, setor.descricao AS setor, (SELECT date_part('DAY'::text, vendas.data) AS date_part) AS dia FROM vendas, produtos, categorias, setor WHERE (((produtos.idproduto = vendas.idproduto) AND (produtos.idcategoria = categorias.idcategoria)) AND (categorias.idsetor = setor.idsetor)) GROUP BY setor.idsetor, setor.descricao, (SELECT date_part('DAY'::text, vendas.data) AS date_part) ORDER BY sum(vendas.valor_venda_total) DESC;


ALTER TABLE public.vendas_setor_por_dia OWNER TO jao;

--
-- Name: vendas_setor_por_mes; Type: VIEW; Schema: public; Owner: jao
--

CREATE VIEW vendas_setor_por_mes AS
    SELECT sum(vendas.valor_venda_total) AS total, setor.descricao AS setor, (SELECT date_part('MONTH'::text, vendas.data) AS date_part) AS mes FROM vendas, produtos, categorias, setor WHERE (((produtos.idproduto = vendas.idproduto) AND (produtos.idcategoria = categorias.idcategoria)) AND (categorias.idsetor = setor.idsetor)) GROUP BY setor.idsetor, setor.descricao, (SELECT date_part('MONTH'::text, vendas.data) AS date_part) ORDER BY sum(vendas.valor_venda_total) DESC;


ALTER TABLE public.vendas_setor_por_mes OWNER TO jao;

--
-- Name: idcategoria; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY categorias ALTER COLUMN idcategoria SET DEFAULT nextval('categorias_idcategoria_seq'::regclass);


--
-- Name: idfornecedor; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY fornecedores ALTER COLUMN idfornecedor SET DEFAULT nextval('fornecedores_idfornecedor_seq'::regclass);


--
-- Name: idproduto; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY produtos ALTER COLUMN idproduto SET DEFAULT nextval('produtos_idproduto_seq'::regclass);


--
-- Name: codigo; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY sessao ALTER COLUMN codigo SET DEFAULT nextval('sessao_codigo_seq'::regclass);


--
-- Name: idsetor; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY setor ALTER COLUMN idsetor SET DEFAULT nextval('setor_idsetor_seq'::regclass);


--
-- Data for Name: categorias; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY categorias (idcategoria, idsetor, descricao) FROM stdin;
1	1	COMBUSTIVEIS
2	1	LUBRIFICANTES
3	1	FILTROS DE OLEO
4	1	FILTROS DE COMBUSTIVEL
5	1	ADIT. PARA RADIADOR
6	1	ADIT. PARA LIMPADOR DE PARA-BRISAS
7	1	LAVAGENS
8	2	BEBIDAS
9	2	SALGADOS
10	2	BISCOITOS
11	2	ALIMENTOS EMBALADOS
12	2	GULOSEIMAS
\.


--
-- Data for Name: compras; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY compras (idfornecedor, idproduto, unid_medida, quantidade, preco_por_unidade, data_entrada) FROM stdin;
1	1	LITRO	5000	2.9000001	2015-11-13
1	1	LITRO	14970	2.9000001	2015-11-13
\.


--
-- Data for Name: fornecedores; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY fornecedores (idfornecedor, razao_social, cidade, estado_uf, rua, numero, cep, cnpj) FROM stdin;
1	PG COMBUSTIVEIS .LTDA	PONTA GROSSA	PR	AV: BRASIL	254B	84015-320	99.999.999/9999-01
2	PG ALIMENTOS .LTDA	PONTA GROSSA	PR	AV: MADRUGA	154	84015-325	99.999.999/9999-02
3	PG FILT. E ADIT .LTDA	PONTA GROSSA	PR	AV: BORGES DE MEDEIROS	2587	84015-330	99.999.999/9999-03
4	AUTO POSTO LAZARUS	PONTA GROSSA	PR	LOCAL	000	84015-330	99.999.999/9999-99
\.


--
-- Data for Name: produtos; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY produtos (idproduto, idcategoria, idfornecedor, nome, descricao, preco_venda, quant_em_estoque, unid_medida, quant_minima_estoque) FROM stdin;
6	2	3	OLEO MOTOR 1/2 LITRO	LOJA DO POSTO	5	15	UNIDADE	5
10	3	3	FILTRO DE OLEO 2	LOJA DO POSTO	13.5	20	UNIDADE	10
12	4	3	FILTRO DE COMBUSTIVEL 2	LOJA DO POSTO	16.5	20	UNIDADE	10
13	5	3	ADITIVO PARA RADIADORES 1	LOJA DO POSTO	11.99	9	UNIDADE	10
14	5	3	ADITIVO PARA RADIADORES 2	LOJA DO POSTO	10.5	18	UNIDADE	10
15	6	3	ADITIVO PARA PARA-BRISAS 1	LOJA DO POSTO	9.9899998	9	UNIDADE	8
16	6	3	ADITIVOS PARA PARA-BRISAS 2	LOJA DO POSTO	8.79	5	UNIDADE	6
17	7	4	LAVAGEM FORA	SERVICO DO POSTO	20	\N	UNIDADE	\N
18	7	4	LAVAGEM COMPLETA	SERVICO DO POSTO	30	\N	UNIDADE	\N
20	8	2	SUCO NATURAL 600ML	CONVENIENCIA	3	7	UNIDADE	5
21	8	2	SKOL 600ML	CONVENIENCIA	2.8900001	250	UNIDADE	80
23	8	2	BUDWEISER 600ML	CONVENIENCIA	2.99	400	UNIDADE	120
24	9	4	PRENSADO	CONVENIENCIA	4.8899999	5	UNIDADE	2
25	9	4	SANDUICHE	CONVENIENCIA	4.29	4	UNIDADE	3
26	9	4	PASTEL PROMOCAO	CONVENIENCIA	1.99	20	UNIDADE	5
28	11	2	MACARRAO 500GMS	CONVENIENCIA	3.8900001	8	UNIDADE	5
29	12	2	TRIDENT SABORES VARIADOS	CONVENIENCIA	1.5	300	UNIDADE	50
7	2	3	OLEO MOTOR 1 LITRO	LOJA DO POSTO	7.5	14	UNIDADE	5
9	3	3	FILTRO DE OLEO 1	LOJA DO POSTO	13	11	UNIDADE	10
1	1	1	GASOLINA COMUM	BOMBA 1 BICO 1	3.25	4858	LITRO	2000
8	2	3	OLEO MOTOR 3 LITROS	LOJA DO POSTO	12	10	UNIDADE	5
4	1	1	OLEO DIESEL	BOMBA 2 BICO 2	2.8	9999	LITRO	2000
11	4	3	FILTRO DE COMBUSTIVEL 1	LOJA DO POSTO	14	17	UNIDADE	10
2	1	1	GASOLINA ADITIVADA	BOMBA 1 BICO 2	3.5	9949	LITRO	2000
5	1	1	GAS NATURAL VEICULAR	TANQUE DE GAS	1.7	49899	LITRO	15000
3	1	1	ETANOL	BOMBA 2 BICO 1	2.75	9944.7998	LITRO	3000
22	8	2	HEINEKEN 600ML	CONVENIENCIA	3.29	238	UNIDADE	80
19	8	2	COCA-COLA 2L	CONVENIENCIA	5.5	97	UNIDADE	30
27	10	2	RUFLES	CONVENIENCIA	4.8899999	-27	UNIDADE	10
\.


--
-- Data for Name: sessao; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY sessao (codigo, responsavel, data) FROM stdin;
\.


--
-- Data for Name: setor; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY setor (idsetor, descricao) FROM stdin;
1	LOJA DO POSTO
2	LOJA DE CONVENIENCIA
\.


--
-- Data for Name: vendas; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY vendas (idproduto, valor_venda_unidade, valor_venda_total, quantidade, data, codigo_venda, tipo_pagamento) FROM stdin;
9	13	39	3	2015-11-14 00:00:00	3	DINHEIRO
8	12	24	2	2015-11-14 00:00:00	3	DINHEIRO
1	3.25	81.25	25	2015-11-14 00:00:00	3	CHEQUE
1	3.25	97.5	30	2015-11-14 12:35:19.111898	1	DINHEIRO
7	7.5	7.5	1	2015-11-14 12:35:19.111898	1	DINHEIRO
9	13	39	3	2015-11-14 12:35:19.111898	1	DINHEIRO
1	3.25	6.5	2	2015-11-14 12:35:19.111898	1	DINHEIRO
17	20	20	1	2015-11-14 13:05:40.540992	4	DINHEIRO
18	30	30	1	2015-11-14 13:05:40.540992	4	DINHEIRO
2	3.5	3.5	1	2015-11-24 20:07:41.465962	2	DINHEIRO
8	12	12	1	2015-11-24 20:07:41.465962	2	DINHEIRO
4	2.8	2.8	1	2015-11-24 20:08:47.884837	1	DINHEIRO
5	1.7	1.7	1	2015-11-24 20:08:47.884837	1	DINHEIRO
27	4.8899999	4.8899999	1	2015-11-24 20:08:47.884837	1	DINHEIRO
11	14	42	3	2015-11-24 20:09:55.098353	3	DINHEIRO
19	5.5	11	2	2015-11-24 20:09:55.098353	3	DINHEIRO
18	30	30	1	2015-11-24 20:14:07.130535	1	DEBITO
2	3.5	175	50	2015-11-24 20:14:07.130535	1	DEBITO
5	1.7	170	100	2015-11-24 20:14:07.130535	1	DEBITO
27	4.8899999	9.7799997	2	2015-11-24 20:23:38.233873	1	DINHEIRO
3	2.75	151.8	55.200001	2015-11-24 20:25:33.50776	3	CHEQUE
27	4.8899999	4.8899999	1	2015-11-24 20:49:37.712859	1	DINHEIRO
27	4.8899999	19.559999	4	2015-11-24 20:49:37.712859	1	DINHEIRO
27	4.8899999	34.23	7	2015-11-24 20:49:37.712859	1	DINHEIRO
22	3.29	39.48	12	2015-11-24 21:29:32.400422	1	DINHEIRO
27	4.8899999	4.8899999	1	2015-11-24 21:29:32.400422	1	DINHEIRO
27	4.8899999	244.5	50	2015-11-24 21:29:32.400422	1	DINHEIRO
19	5.5	5.5	1	2015-11-27 17:05:35.130729	3	DINHEIRO
27	4.8899999	4.8899999	1	2015-11-27 17:15:45.305735	1	DINHEIRO
\.


--
-- Data for Name: vendas_aux; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY vendas_aux (idproduto, quantidade, codigo_venda, tipo_pagamento, concretizada) FROM stdin;
19	1	1	DINHEIRO	f
27	1	1	DINHEIRO	f
2	1	2	DINHEIRO	t
8	1	2	DINHEIRO	t
27	1	2	DINHEIRO	f
4	1	2	DINHEIRO	f
3	55.200001	3	CHEQUE	t
11	3	3	DINHEIRO	t
19	2	3	DINHEIRO	t
19	1	3	DINHEIRO	t
22	12	1	DINHEIRO	t
27	1	1	DINHEIRO	t
27	50	1	DINHEIRO	t
18	1	1	DEBITO	t
2	50	1	DEBITO	t
5	100	1	DEBITO	t
1	30	1	DINHEIRO	t
7	1	1	DINHEIRO	t
9	3	1	DINHEIRO	t
1	2	1	DINHEIRO	t
4	1	1	DINHEIRO	t
5	1	1	DINHEIRO	t
27	1	1	DINHEIRO	t
27	2	1	DINHEIRO	t
27	1	1	DINHEIRO	t
27	4	1	DINHEIRO	t
27	7	1	DINHEIRO	t
27	1	1	DINHEIRO	t
\.


--
-- Name: categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (idcategoria);


--
-- Name: fornecedores_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY fornecedores
    ADD CONSTRAINT fornecedores_pkey PRIMARY KEY (idfornecedor);


--
-- Name: produtos_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY produtos
    ADD CONSTRAINT produtos_pkey PRIMARY KEY (idproduto);


--
-- Name: sessao_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY sessao
    ADD CONSTRAINT sessao_pkey PRIMARY KEY (codigo);


--
-- Name: setor_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY setor
    ADD CONSTRAINT setor_pkey PRIMARY KEY (idsetor);


--
-- Name: atualiza_estoque_compras; Type: TRIGGER; Schema: public; Owner: jao
--

CREATE TRIGGER atualiza_estoque_compras
    AFTER INSERT ON compras
    FOR EACH ROW
    EXECUTE PROCEDURE atualiza_estoque_por_compras();


--
-- Name: atualiza_vendas; Type: TRIGGER; Schema: public; Owner: jao
--

CREATE TRIGGER atualiza_vendas
    AFTER UPDATE ON vendas_aux
    FOR EACH ROW
    EXECUTE PROCEDURE proc_atualiza_vendas();


--
-- Name: categorias_idsetor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY categorias
    ADD CONSTRAINT categorias_idsetor_fkey FOREIGN KEY (idsetor) REFERENCES setor(idsetor) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: compras_idfornecedor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY compras
    ADD CONSTRAINT compras_idfornecedor_fkey FOREIGN KEY (idfornecedor) REFERENCES fornecedores(idfornecedor) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: compras_idproduto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY compras
    ADD CONSTRAINT compras_idproduto_fkey FOREIGN KEY (idproduto) REFERENCES produtos(idproduto) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: produtos_idcategoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY produtos
    ADD CONSTRAINT produtos_idcategoria_fkey FOREIGN KEY (idcategoria) REFERENCES categorias(idcategoria) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: produtos_idfornecedor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY produtos
    ADD CONSTRAINT produtos_idfornecedor_fkey FOREIGN KEY (idfornecedor) REFERENCES fornecedores(idfornecedor) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: vendas_aux_idproduto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY vendas_aux
    ADD CONSTRAINT vendas_aux_idproduto_fkey FOREIGN KEY (idproduto) REFERENCES produtos(idproduto) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: vendas_idproduto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY vendas
    ADD CONSTRAINT vendas_idproduto_fkey FOREIGN KEY (idproduto) REFERENCES produtos(idproduto) ON UPDATE RESTRICT ON DELETE RESTRICT;


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

\connect procedures

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: jao
--

CREATE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO jao;

SET search_path = public, pg_catalog;

--
-- Name: clientesdesconto(character varying); Type: FUNCTION; Schema: public; Owner: jao
--

CREATE FUNCTION clientesdesconto(character varying) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $_$
declare
reg record;
begin
for reg in select cliente.cliente_nome, cliente.cliente_perc_desconto from cliente, estado where cliente.estado_codigo = estado.estado_codigo and estado.estado_nome = $1 loop
return next reg;
end loop;
if not found then 
raise notice 'nada encontrado ';
end if;
end;
$_$;


ALTER FUNCTION public.clientesdesconto(character varying) OWNER TO jao;

--
-- Name: cria_tabela(integer); Type: FUNCTION; Schema: public; Owner: jao
--

CREATE FUNCTION cria_tabela(integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
begin
create table nova_cliente as select cliente_id, cliente_nome,cliente_telefone
from cliente
where cliente_perc_desconto <= $1;
raise notice 'tabela criada com sucesso!';
end;
$_$;


ALTER FUNCTION public.cria_tabela(integer) OWNER TO jao;

--
-- Name: getrecord(); Type: FUNCTION; Schema: public; Owner: jao
--

CREATE FUNCTION getrecord() RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare 
total integer;
begin
select count (*) into total from produto;
return total;
end;
$$;


ALTER FUNCTION public.getrecord() OWNER TO jao;

--
-- Name: sumandsub(integer, integer); Type: FUNCTION; Schema: public; Owner: jao
--

CREATE FUNCTION sumandsub(a integer, b integer, OUT soma integer, OUT sub integer) RETURNS record
    LANGUAGE plpgsql
    AS $$
begin
soma:=a+b;
sub:=a-b;
end;
$$;


ALTER FUNCTION public.sumandsub(a integer, b integer, OUT soma integer, OUT sub integer) OWNER TO jao;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: cliente; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE cliente (
    cliente_id integer NOT NULL,
    cliente_nome character varying(50),
    cliente_end character varying(50),
    cliente_end_cidade character(20),
    estado_codigo character varying(2),
    cliente_end_cep character varying(8),
    cliente_telefone character varying(10),
    cliente_perc_desconto numeric(2,0)
);


ALTER TABLE public.cliente OWNER TO jao;

--
-- Name: estado; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE estado (
    estado_codigo character varying(2) NOT NULL,
    estado_nome character varying(25)
);


ALTER TABLE public.estado OWNER TO jao;

--
-- Name: item; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE item (
    pedido_identificacao integer NOT NULL,
    produto_codigo smallint NOT NULL,
    item_quantidade smallint,
    item_valor_unitario numeric(5,2),
    item_valor_total numeric(5,2)
);


ALTER TABLE public.item OWNER TO jao;

--
-- Name: nova_cliente; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE nova_cliente (
    cliente_id integer,
    cliente_nome character varying(50),
    cliente_telefone character varying(10)
);


ALTER TABLE public.nova_cliente OWNER TO jao;

--
-- Name: pedido; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE pedido (
    pedido_identificacao integer NOT NULL,
    pedido_tipo integer,
    cliente_id integer,
    pedido_data_entrada date,
    pedido_valor_total numeric(7,2),
    pedido_desconto numeric(7,2),
    pedido_dt_embarque date
);


ALTER TABLE public.pedido OWNER TO jao;

--
-- Name: produto; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE produto (
    produto_codigo smallint NOT NULL,
    produto_nome character varying(40),
    produto_preco numeric(5,2),
    ue_produto_cod character varying(3)
);


ALTER TABLE public.produto OWNER TO jao;

--
-- Name: ue_produto; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE ue_produto (
    ue_produto_cod character(3) NOT NULL,
    ue_produto_descr character varying(50)
);


ALTER TABLE public.ue_produto OWNER TO jao;

--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY cliente (cliente_id, cliente_nome, cliente_end, cliente_end_cidade, estado_codigo, cliente_end_cep, cliente_telefone, cliente_perc_desconto) FROM stdin;
1	João	Rua dos Bobos	Foz do Iguaçu       	PR	8585555	99999999	15
2	Maria	Rua das Violetas	Rio de Janeiro      	RJ	9985845	11111111	10
3	Marcos	Rua sem nome	São Joaquim         	MT	9874541	22222222	0
4	Fernanda	Rua qualquer	São Carlos          	SP	3994832	33333333	12
5	Jussara	Travessa aquela lá	Campo Grande        	MS	6904993	44444444	18
6	Pedro	Travessa do padre	Natal               	RN	69098793	44444444	15
7	Valdir	Rua dos desesperados	Curitiba            	PR	6343993	448889444	20
8	Ana	Avenida Jucelino	Ponta Grossa        	PR	69989893	98944444	25
9	Bruna	Avenida Salgado Filho	Florianopolis       	SC	89898893	09094444	40
10	Filomena	Avenida Calvario	Porto Alegre        	RS	68798989	98744444	30
\.


--
-- Data for Name: estado; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY estado (estado_codigo, estado_nome) FROM stdin;
GO	Goias
MT	Mato Grosso
RJ	Rio de Janeiro
PR	Paraná
SC	Santa Catarina
RS	Rio Grande do Sul
MS	Mato Grosso do Sul
PI	Piauí
PA	Pará
RN	Rio Grande do Norte
BA	Bahia
PB	Paraiba
MG	Minas Gerais
AP	Amapá
RO	Rondonia
RR	Roraima
SE	Sergipe
AC	Acre
SP	São Paulo
\.


--
-- Data for Name: item; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY item (pedido_identificacao, produto_codigo, item_quantidade, item_valor_unitario, item_valor_total) FROM stdin;
1	1	7	4.00	28.00
2	3	50	2.00	100.00
3	1	50	4.00	200.00
4	1	100	4.00	400.00
5	2	7	4.00	28.00
6	3	50	2.00	100.00
7	4	50	4.00	200.00
8	5	100	2.50	250.00
\.


--
-- Data for Name: nova_cliente; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY nova_cliente (cliente_id, cliente_nome, cliente_telefone) FROM stdin;
2	Maria	11111111
3	Marcos	22222222
\.


--
-- Data for Name: pedido; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY pedido (pedido_identificacao, pedido_tipo, cliente_id, pedido_data_entrada, pedido_valor_total, pedido_desconto, pedido_dt_embarque) FROM stdin;
1	5	1	2005-11-11	28.00	0.00	2005-11-13
2	3	2	2005-11-11	300.00	5.00	2005-11-11
3	5	1	2014-12-18	450.00	20.00	2014-12-22
4	5	1	2013-08-20	1000.00	0.00	2013-09-25
5	3	9	2012-03-30	700.00	10.00	2012-04-13
6	3	10	2011-05-15	120.00	15.00	2011-11-13
\.


--
-- Data for Name: produto; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY produto (produto_codigo, produto_nome, produto_preco, ue_produto_cod) FROM stdin;
1	ARROZ BRANCO	2.50	ARR
2	FEIJÃO CARIOCA	3.80	FEI
3	FEIJÃO PRETO	3.20	FEI
4	MACARRÃO INSTANTÂNEO	1.20	MAC
5	LEITE INTEGRAL	1.50	LET
6	SABÃO EM PÓ	3.00	SAB
7	SUCO EM PÓ	0.80	SUC
8	DETERGENTE PIA	3.50	DET
9	MARGARINA COM SAL	4.00	MAR
10	SAL IODADO	2.50	SAL
11	TRIGO EM PÓ	5.00	TRI
12	AÇUCAR REFINADO	2.60	ACU
13	OLEO DE SOJA	3.40	OLE
\.


--
-- Data for Name: ue_produto; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY ue_produto (ue_produto_cod, ue_produto_descr) FROM stdin;
ARR	ARROZ
FEI	FEIJÃO
MAC	MACARRÃO
LET	LEITE
ACU	AÇUCAR
TRI	TRIGO
OLE	OLEO
MAR	MARGARINA
SAB	SABÃO
SUC	SUCO
SAL	SAL
DET	DETERGENT
\.


--
-- Name: cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (cliente_id);


--
-- Name: estado_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY estado
    ADD CONSTRAINT estado_pkey PRIMARY KEY (estado_codigo);


--
-- Name: item_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY item
    ADD CONSTRAINT item_pkey PRIMARY KEY (pedido_identificacao, produto_codigo);


--
-- Name: pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY pedido
    ADD CONSTRAINT pedido_pkey PRIMARY KEY (pedido_identificacao);


--
-- Name: produto_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY produto
    ADD CONSTRAINT produto_pkey PRIMARY KEY (produto_codigo);


--
-- Name: ue_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY ue_produto
    ADD CONSTRAINT ue_produto_pkey PRIMARY KEY (ue_produto_cod);


--
-- Name: cliente_estado_fk; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY cliente
    ADD CONSTRAINT cliente_estado_fk FOREIGN KEY (estado_codigo) REFERENCES estado(estado_codigo);


--
-- Name: item_produto_fk; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY item
    ADD CONSTRAINT item_produto_fk FOREIGN KEY (produto_codigo) REFERENCES produto(produto_codigo);


--
-- Name: pedido_cliente_fk; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY pedido
    ADD CONSTRAINT pedido_cliente_fk FOREIGN KEY (cliente_id) REFERENCES cliente(cliente_id);


--
-- Name: produto_ueproduto_fk; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY produto
    ADD CONSTRAINT produto_ueproduto_fk FOREIGN KEY (ue_produto_cod) REFERENCES ue_produto(ue_produto_cod);


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

\connect sati

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

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

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template database';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: aluno; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE aluno (
    ra integer NOT NULL,
    idendereco integer NOT NULL,
    mae character varying(50),
    pai character varying(50),
    periodo character(10),
    origem character varying(20),
    rg character varying(20),
    estadocivil character varying(10),
    nacionalidade character varying(20),
    sexo character(1),
    nome character varying(50),
    dtnasc date,
    cpf character varying(20),
    email character varying(70),
    telefone character varying(20),
    aceito boolean,
    idcurso integer NOT NULL
);


ALTER TABLE public.aluno OWNER TO jao;

--
-- Name: aluno_idcurso_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE aluno_idcurso_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.aluno_idcurso_seq OWNER TO jao;

--
-- Name: aluno_idcurso_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE aluno_idcurso_seq OWNED BY aluno.idcurso;


--
-- Name: aluno_idcurso_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('aluno_idcurso_seq', 1, false);


--
-- Name: aluno_idendereco_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE aluno_idendereco_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.aluno_idendereco_seq OWNER TO jao;

--
-- Name: aluno_idendereco_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE aluno_idendereco_seq OWNED BY aluno.idendereco;


--
-- Name: aluno_idendereco_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('aluno_idendereco_seq', 1, false);


--
-- Name: aluno_ra_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE aluno_ra_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.aluno_ra_seq OWNER TO jao;

--
-- Name: aluno_ra_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE aluno_ra_seq OWNED BY aluno.ra;


--
-- Name: aluno_ra_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('aluno_ra_seq', 1, false);


--
-- Name: curso; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE curso (
    idcurso integer NOT NULL,
    iddepart integer NOT NULL,
    nome character varying(50),
    turno character varying(10),
    tipo character varying(20),
    cargahor integer,
    credito smallint,
    duracao smallint
);


ALTER TABLE public.curso OWNER TO jao;

--
-- Name: curso_idcurso_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE curso_idcurso_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.curso_idcurso_seq OWNER TO jao;

--
-- Name: curso_idcurso_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE curso_idcurso_seq OWNED BY curso.idcurso;


--
-- Name: curso_idcurso_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('curso_idcurso_seq', 1, false);


--
-- Name: curso_iddepart_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE curso_iddepart_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.curso_iddepart_seq OWNER TO jao;

--
-- Name: curso_iddepart_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE curso_iddepart_seq OWNED BY curso.iddepart;


--
-- Name: curso_iddepart_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('curso_iddepart_seq', 1, false);


--
-- Name: departamento; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE departamento (
    iddepart integer NOT NULL,
    nome character varying(20)
);


ALTER TABLE public.departamento OWNER TO jao;

--
-- Name: departamento_iddepart_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE departamento_iddepart_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.departamento_iddepart_seq OWNER TO jao;

--
-- Name: departamento_iddepart_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE departamento_iddepart_seq OWNED BY departamento.iddepart;


--
-- Name: departamento_iddepart_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('departamento_iddepart_seq', 1, false);


--
-- Name: disciplina; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE disciplina (
    iddisc integer NOT NULL,
    idcurso integer NOT NULL,
    nome character varying(50),
    periodo character(10),
    credito character(10),
    tipo character varying(10),
    cargahor character(10),
    vagas character(10),
    codigo character varying(20),
    matricula integer NOT NULL,
    pre1 integer NOT NULL,
    pre2 integer NOT NULL,
    pre3 integer NOT NULL
);


ALTER TABLE public.disciplina OWNER TO jao;

--
-- Name: disciplina_idcurso_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE disciplina_idcurso_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.disciplina_idcurso_seq OWNER TO jao;

--
-- Name: disciplina_idcurso_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE disciplina_idcurso_seq OWNED BY disciplina.idcurso;


--
-- Name: disciplina_idcurso_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('disciplina_idcurso_seq', 1, false);


--
-- Name: disciplina_iddisc_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE disciplina_iddisc_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.disciplina_iddisc_seq OWNER TO jao;

--
-- Name: disciplina_iddisc_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE disciplina_iddisc_seq OWNED BY disciplina.iddisc;


--
-- Name: disciplina_iddisc_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('disciplina_iddisc_seq', 1, false);


--
-- Name: disciplina_matricula_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE disciplina_matricula_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.disciplina_matricula_seq OWNER TO jao;

--
-- Name: disciplina_matricula_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE disciplina_matricula_seq OWNED BY disciplina.matricula;


--
-- Name: disciplina_matricula_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('disciplina_matricula_seq', 1, false);


--
-- Name: disciplina_pre1_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE disciplina_pre1_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.disciplina_pre1_seq OWNER TO jao;

--
-- Name: disciplina_pre1_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE disciplina_pre1_seq OWNED BY disciplina.pre1;


--
-- Name: disciplina_pre1_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('disciplina_pre1_seq', 1, false);


--
-- Name: disciplina_pre2_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE disciplina_pre2_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.disciplina_pre2_seq OWNER TO jao;

--
-- Name: disciplina_pre2_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE disciplina_pre2_seq OWNED BY disciplina.pre2;


--
-- Name: disciplina_pre2_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('disciplina_pre2_seq', 1, false);


--
-- Name: disciplina_pre3_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE disciplina_pre3_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.disciplina_pre3_seq OWNER TO jao;

--
-- Name: disciplina_pre3_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE disciplina_pre3_seq OWNED BY disciplina.pre3;


--
-- Name: disciplina_pre3_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('disciplina_pre3_seq', 1, false);


--
-- Name: endereco; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE endereco (
    idendereco integer NOT NULL,
    rua character varying(50),
    numero integer,
    bairro character varying(50),
    cidade character varying(20),
    estado character(10),
    cep character varying(20),
    complemento character varying(20)
);


ALTER TABLE public.endereco OWNER TO jao;

--
-- Name: endereco_idendereco_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE endereco_idendereco_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.endereco_idendereco_seq OWNER TO jao;

--
-- Name: endereco_idendereco_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE endereco_idendereco_seq OWNED BY endereco.idendereco;


--
-- Name: endereco_idendereco_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('endereco_idendereco_seq', 1, false);


--
-- Name: matriculanota; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE matriculanota (
    idmatricula integer NOT NULL,
    idturma integer NOT NULL,
    ra integer NOT NULL,
    ano character(10),
    semestre character(1),
    frequencia numeric(2,2),
    um numeric(2,2),
    dois numeric(2,2),
    iddisc integer NOT NULL
);


ALTER TABLE public.matriculanota OWNER TO jao;

--
-- Name: matriculanota_iddisc_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE matriculanota_iddisc_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.matriculanota_iddisc_seq OWNER TO jao;

--
-- Name: matriculanota_iddisc_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE matriculanota_iddisc_seq OWNED BY matriculanota.iddisc;


--
-- Name: matriculanota_iddisc_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('matriculanota_iddisc_seq', 1, false);


--
-- Name: matriculanota_idmatricula_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE matriculanota_idmatricula_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.matriculanota_idmatricula_seq OWNER TO jao;

--
-- Name: matriculanota_idmatricula_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE matriculanota_idmatricula_seq OWNED BY matriculanota.idmatricula;


--
-- Name: matriculanota_idmatricula_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('matriculanota_idmatricula_seq', 1, false);


--
-- Name: matriculanota_idturma_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE matriculanota_idturma_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.matriculanota_idturma_seq OWNER TO jao;

--
-- Name: matriculanota_idturma_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE matriculanota_idturma_seq OWNED BY matriculanota.idturma;


--
-- Name: matriculanota_idturma_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('matriculanota_idturma_seq', 1, false);


--
-- Name: matriculanota_ra_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE matriculanota_ra_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.matriculanota_ra_seq OWNER TO jao;

--
-- Name: matriculanota_ra_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE matriculanota_ra_seq OWNED BY matriculanota.ra;


--
-- Name: matriculanota_ra_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('matriculanota_ra_seq', 1, false);


--
-- Name: professor; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE professor (
    matricula integer NOT NULL,
    idendereco integer NOT NULL,
    iddepart integer NOT NULL,
    formacao character varying(20),
    cfe character varying(20),
    ischefe boolean,
    rg character varying(20),
    estadocivil character varying(10),
    nacionalidade character varying(20),
    sexo character(1),
    nome character varying(50),
    dtnasc date,
    cpf character varying(20),
    telefone character varying(20),
    email character varying(70)
);


ALTER TABLE public.professor OWNER TO jao;

--
-- Name: professor_iddepart_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE professor_iddepart_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.professor_iddepart_seq OWNER TO jao;

--
-- Name: professor_iddepart_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE professor_iddepart_seq OWNED BY professor.iddepart;


--
-- Name: professor_iddepart_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('professor_iddepart_seq', 1, false);


--
-- Name: professor_idendereco_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE professor_idendereco_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.professor_idendereco_seq OWNER TO jao;

--
-- Name: professor_idendereco_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE professor_idendereco_seq OWNED BY professor.idendereco;


--
-- Name: professor_idendereco_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('professor_idendereco_seq', 1, false);


--
-- Name: professor_matricula_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE professor_matricula_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.professor_matricula_seq OWNER TO jao;

--
-- Name: professor_matricula_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE professor_matricula_seq OWNED BY professor.matricula;


--
-- Name: professor_matricula_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('professor_matricula_seq', 1, false);


--
-- Name: turma; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE turma (
    idturma integer NOT NULL,
    iddisc integer NOT NULL,
    turma character varying(10),
    hoarario character varying(20)
);


ALTER TABLE public.turma OWNER TO jao;

--
-- Name: turma_iddisc_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE turma_iddisc_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.turma_iddisc_seq OWNER TO jao;

--
-- Name: turma_iddisc_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE turma_iddisc_seq OWNED BY turma.iddisc;


--
-- Name: turma_iddisc_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('turma_iddisc_seq', 1, false);


--
-- Name: turma_idturma_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE turma_idturma_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.turma_idturma_seq OWNER TO jao;

--
-- Name: turma_idturma_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE turma_idturma_seq OWNED BY turma.idturma;


--
-- Name: turma_idturma_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('turma_idturma_seq', 1, false);


--
-- Name: ra; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY aluno ALTER COLUMN ra SET DEFAULT nextval('aluno_ra_seq'::regclass);


--
-- Name: idendereco; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY aluno ALTER COLUMN idendereco SET DEFAULT nextval('aluno_idendereco_seq'::regclass);


--
-- Name: idcurso; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY aluno ALTER COLUMN idcurso SET DEFAULT nextval('aluno_idcurso_seq'::regclass);


--
-- Name: idcurso; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY curso ALTER COLUMN idcurso SET DEFAULT nextval('curso_idcurso_seq'::regclass);


--
-- Name: iddepart; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY curso ALTER COLUMN iddepart SET DEFAULT nextval('curso_iddepart_seq'::regclass);


--
-- Name: iddepart; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY departamento ALTER COLUMN iddepart SET DEFAULT nextval('departamento_iddepart_seq'::regclass);


--
-- Name: iddisc; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina ALTER COLUMN iddisc SET DEFAULT nextval('disciplina_iddisc_seq'::regclass);


--
-- Name: idcurso; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina ALTER COLUMN idcurso SET DEFAULT nextval('disciplina_idcurso_seq'::regclass);


--
-- Name: matricula; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina ALTER COLUMN matricula SET DEFAULT nextval('disciplina_matricula_seq'::regclass);


--
-- Name: pre1; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina ALTER COLUMN pre1 SET DEFAULT nextval('disciplina_pre1_seq'::regclass);


--
-- Name: pre2; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina ALTER COLUMN pre2 SET DEFAULT nextval('disciplina_pre2_seq'::regclass);


--
-- Name: pre3; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina ALTER COLUMN pre3 SET DEFAULT nextval('disciplina_pre3_seq'::regclass);


--
-- Name: idendereco; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY endereco ALTER COLUMN idendereco SET DEFAULT nextval('endereco_idendereco_seq'::regclass);


--
-- Name: idmatricula; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY matriculanota ALTER COLUMN idmatricula SET DEFAULT nextval('matriculanota_idmatricula_seq'::regclass);


--
-- Name: idturma; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY matriculanota ALTER COLUMN idturma SET DEFAULT nextval('matriculanota_idturma_seq'::regclass);


--
-- Name: ra; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY matriculanota ALTER COLUMN ra SET DEFAULT nextval('matriculanota_ra_seq'::regclass);


--
-- Name: iddisc; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY matriculanota ALTER COLUMN iddisc SET DEFAULT nextval('matriculanota_iddisc_seq'::regclass);


--
-- Name: matricula; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY professor ALTER COLUMN matricula SET DEFAULT nextval('professor_matricula_seq'::regclass);


--
-- Name: idendereco; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY professor ALTER COLUMN idendereco SET DEFAULT nextval('professor_idendereco_seq'::regclass);


--
-- Name: iddepart; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY professor ALTER COLUMN iddepart SET DEFAULT nextval('professor_iddepart_seq'::regclass);


--
-- Name: idturma; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY turma ALTER COLUMN idturma SET DEFAULT nextval('turma_idturma_seq'::regclass);


--
-- Name: iddisc; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY turma ALTER COLUMN iddisc SET DEFAULT nextval('turma_iddisc_seq'::regclass);


--
-- Data for Name: aluno; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY aluno (ra, idendereco, mae, pai, periodo, origem, rg, estadocivil, nacionalidade, sexo, nome, dtnasc, cpf, email, telefone, aceito, idcurso) FROM stdin;
\.


--
-- Data for Name: curso; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY curso (idcurso, iddepart, nome, turno, tipo, cargahor, credito, duracao) FROM stdin;
\.


--
-- Data for Name: departamento; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY departamento (iddepart, nome) FROM stdin;
\.


--
-- Data for Name: disciplina; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY disciplina (iddisc, idcurso, nome, periodo, credito, tipo, cargahor, vagas, codigo, matricula, pre1, pre2, pre3) FROM stdin;
\.


--
-- Data for Name: endereco; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY endereco (idendereco, rua, numero, bairro, cidade, estado, cep, complemento) FROM stdin;
\.


--
-- Data for Name: matriculanota; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY matriculanota (idmatricula, idturma, ra, ano, semestre, frequencia, um, dois, iddisc) FROM stdin;
\.


--
-- Data for Name: professor; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY professor (matricula, idendereco, iddepart, formacao, cfe, ischefe, rg, estadocivil, nacionalidade, sexo, nome, dtnasc, cpf, telefone, email) FROM stdin;
\.


--
-- Data for Name: turma; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY turma (idturma, iddisc, turma, hoarario) FROM stdin;
\.


--
-- Name: aluno_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY aluno
    ADD CONSTRAINT aluno_pkey PRIMARY KEY (ra);


--
-- Name: curso_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY curso
    ADD CONSTRAINT curso_pkey PRIMARY KEY (idcurso);


--
-- Name: departamento_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY departamento
    ADD CONSTRAINT departamento_pkey PRIMARY KEY (iddepart);


--
-- Name: disciplina_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY disciplina
    ADD CONSTRAINT disciplina_pkey PRIMARY KEY (iddisc);


--
-- Name: endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (idendereco);


--
-- Name: matriculanota_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY matriculanota
    ADD CONSTRAINT matriculanota_pkey PRIMARY KEY (idmatricula, idturma, ra, iddisc);


--
-- Name: professor_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY professor
    ADD CONSTRAINT professor_pkey PRIMARY KEY (matricula);


--
-- Name: turma_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY turma
    ADD CONSTRAINT turma_pkey PRIMARY KEY (idturma);


--
-- Name: aluno_idcurso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY aluno
    ADD CONSTRAINT aluno_idcurso_fkey FOREIGN KEY (idcurso) REFERENCES curso(idcurso);


--
-- Name: aluno_idendereco_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY aluno
    ADD CONSTRAINT aluno_idendereco_fkey FOREIGN KEY (idendereco) REFERENCES endereco(idendereco) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: curso_iddepart_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY curso
    ADD CONSTRAINT curso_iddepart_fkey FOREIGN KEY (iddepart) REFERENCES departamento(iddepart) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: disciplina_idcurso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina
    ADD CONSTRAINT disciplina_idcurso_fkey FOREIGN KEY (idcurso) REFERENCES curso(idcurso) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: disciplina_matricula_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina
    ADD CONSTRAINT disciplina_matricula_fkey FOREIGN KEY (matricula) REFERENCES professor(matricula);


--
-- Name: disciplina_pre1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina
    ADD CONSTRAINT disciplina_pre1_fkey FOREIGN KEY (pre1) REFERENCES disciplina(iddisc);


--
-- Name: disciplina_pre2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina
    ADD CONSTRAINT disciplina_pre2_fkey FOREIGN KEY (pre2) REFERENCES disciplina(iddisc);


--
-- Name: disciplina_pre3_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina
    ADD CONSTRAINT disciplina_pre3_fkey FOREIGN KEY (pre3) REFERENCES disciplina(iddisc);


--
-- Name: matriculanota_iddisc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY matriculanota
    ADD CONSTRAINT matriculanota_iddisc_fkey FOREIGN KEY (iddisc) REFERENCES disciplina(iddisc) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: matriculanota_idturma_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY matriculanota
    ADD CONSTRAINT matriculanota_idturma_fkey FOREIGN KEY (idturma) REFERENCES turma(idturma) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: matriculanota_ra_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY matriculanota
    ADD CONSTRAINT matriculanota_ra_fkey FOREIGN KEY (ra) REFERENCES aluno(ra) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: professor_iddepart_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY professor
    ADD CONSTRAINT professor_iddepart_fkey FOREIGN KEY (iddepart) REFERENCES departamento(iddepart) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: professor_idendereco_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY professor
    ADD CONSTRAINT professor_idendereco_fkey FOREIGN KEY (idendereco) REFERENCES endereco(idendereco) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: turma_iddisc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY turma
    ADD CONSTRAINT turma_iddisc_fkey FOREIGN KEY (iddisc) REFERENCES disciplina(iddisc) ON UPDATE CASCADE ON DELETE RESTRICT;


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

\connect ukp

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: aluno; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE aluno (
    ra integer NOT NULL,
    idendereco integer NOT NULL,
    mae character varying(50),
    pai character varying(50),
    periodo character(2),
    origem character(2),
    rg character varying(20),
    estadocivil character varying(10),
    nacionalidade character varying(20),
    sexo character(1),
    nome character varying(50),
    dtnasc date,
    cpf character varying(20),
    email character varying(70),
    telefone character varying(20),
    aceito boolean
);


ALTER TABLE public.aluno OWNER TO jao;

--
-- Name: aluno_idendereco_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE aluno_idendereco_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.aluno_idendereco_seq OWNER TO jao;

--
-- Name: aluno_idendereco_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE aluno_idendereco_seq OWNED BY aluno.idendereco;


--
-- Name: aluno_idendereco_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('aluno_idendereco_seq', 1, false);


--
-- Name: aluno_ra_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE aluno_ra_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.aluno_ra_seq OWNER TO jao;

--
-- Name: aluno_ra_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE aluno_ra_seq OWNED BY aluno.ra;


--
-- Name: aluno_ra_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('aluno_ra_seq', 1, true);


--
-- Name: curso; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE curso (
    idcurso integer NOT NULL,
    iddepart integer NOT NULL,
    nome character varying(50),
    turno character varying(10),
    tipo character varying(20),
    cargahor integer,
    credito smallint,
    duracao smallint
);


ALTER TABLE public.curso OWNER TO jao;

--
-- Name: curso_idcurso_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE curso_idcurso_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.curso_idcurso_seq OWNER TO jao;

--
-- Name: curso_idcurso_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE curso_idcurso_seq OWNED BY curso.idcurso;


--
-- Name: curso_idcurso_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('curso_idcurso_seq', 1, false);


--
-- Name: curso_iddepart_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE curso_iddepart_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.curso_iddepart_seq OWNER TO jao;

--
-- Name: curso_iddepart_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE curso_iddepart_seq OWNED BY curso.iddepart;


--
-- Name: curso_iddepart_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('curso_iddepart_seq', 1, false);


--
-- Name: departamento; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE departamento (
    iddepart integer NOT NULL,
    nome character varying(20)
);


ALTER TABLE public.departamento OWNER TO jao;

--
-- Name: departamento_iddepart_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE departamento_iddepart_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.departamento_iddepart_seq OWNER TO jao;

--
-- Name: departamento_iddepart_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE departamento_iddepart_seq OWNED BY departamento.iddepart;


--
-- Name: departamento_iddepart_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('departamento_iddepart_seq', 1, true);


--
-- Name: desempenho; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE desempenho (
    idmatricula integer NOT NULL,
    iddisc integer NOT NULL,
    ra integer NOT NULL,
    ano character(4),
    semestre character(1),
    frequencia numeric(2,2),
    um numeric(2,2),
    dois numeric(2,2)
);


ALTER TABLE public.desempenho OWNER TO jao;

--
-- Name: desempenho_iddisc_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE desempenho_iddisc_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.desempenho_iddisc_seq OWNER TO jao;

--
-- Name: desempenho_iddisc_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE desempenho_iddisc_seq OWNED BY desempenho.iddisc;


--
-- Name: desempenho_iddisc_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('desempenho_iddisc_seq', 1, false);


--
-- Name: desempenho_idmatricula_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE desempenho_idmatricula_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.desempenho_idmatricula_seq OWNER TO jao;

--
-- Name: desempenho_idmatricula_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE desempenho_idmatricula_seq OWNED BY desempenho.idmatricula;


--
-- Name: desempenho_idmatricula_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('desempenho_idmatricula_seq', 1, false);


--
-- Name: desempenho_ra_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE desempenho_ra_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.desempenho_ra_seq OWNER TO jao;

--
-- Name: desempenho_ra_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE desempenho_ra_seq OWNED BY desempenho.ra;


--
-- Name: desempenho_ra_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('desempenho_ra_seq', 1, false);


--
-- Name: disciplina; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE disciplina (
    iddisc integer NOT NULL,
    idcurso integer NOT NULL,
    nome character varying(50),
    periodo character(2),
    credito character(2),
    tipo character varying(10),
    cargahor character(3),
    vagas character(2)
);


ALTER TABLE public.disciplina OWNER TO jao;

--
-- Name: disciplina_idcurso_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE disciplina_idcurso_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.disciplina_idcurso_seq OWNER TO jao;

--
-- Name: disciplina_idcurso_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE disciplina_idcurso_seq OWNED BY disciplina.idcurso;


--
-- Name: disciplina_idcurso_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('disciplina_idcurso_seq', 1, false);


--
-- Name: disciplina_iddisc_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE disciplina_iddisc_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.disciplina_iddisc_seq OWNER TO jao;

--
-- Name: disciplina_iddisc_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE disciplina_iddisc_seq OWNED BY disciplina.iddisc;


--
-- Name: disciplina_iddisc_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('disciplina_iddisc_seq', 1, false);


--
-- Name: endereco; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE endereco (
    idendereco integer NOT NULL,
    rua character varying(50),
    numero integer,
    bairro character varying(50),
    cidade character varying(20),
    estado character(2),
    cep character varying(20),
    complemento character varying(20)
);


ALTER TABLE public.endereco OWNER TO jao;

--
-- Name: endereco_idendereco_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE endereco_idendereco_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.endereco_idendereco_seq OWNER TO jao;

--
-- Name: endereco_idendereco_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE endereco_idendereco_seq OWNED BY endereco.idendereco;


--
-- Name: endereco_idendereco_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('endereco_idendereco_seq', 2, true);


--
-- Name: prereq; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE prereq (
    idprereq integer NOT NULL,
    iddisc integer NOT NULL
);


ALTER TABLE public.prereq OWNER TO jao;

--
-- Name: prereq_iddisc_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE prereq_iddisc_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.prereq_iddisc_seq OWNER TO jao;

--
-- Name: prereq_iddisc_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE prereq_iddisc_seq OWNED BY prereq.iddisc;


--
-- Name: prereq_iddisc_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('prereq_iddisc_seq', 1, false);


--
-- Name: prereq_idprereq_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE prereq_idprereq_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.prereq_idprereq_seq OWNER TO jao;

--
-- Name: prereq_idprereq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE prereq_idprereq_seq OWNED BY prereq.idprereq;


--
-- Name: prereq_idprereq_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('prereq_idprereq_seq', 1, false);


--
-- Name: professor; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE professor (
    matricula integer NOT NULL,
    idendereco integer NOT NULL,
    iddepart integer NOT NULL,
    formacao character varying(20),
    cfe character varying(20),
    ischefe boolean,
    rg character varying(20),
    estadocivil character varying(10),
    nacionalidade character varying(20),
    sexo character(1),
    nome character varying(50),
    dtnasc date,
    cpf character varying(20),
    telefone character varying(20),
    email character varying(70)
);


ALTER TABLE public.professor OWNER TO jao;

--
-- Name: professor_iddepart_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE professor_iddepart_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.professor_iddepart_seq OWNER TO jao;

--
-- Name: professor_iddepart_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE professor_iddepart_seq OWNED BY professor.iddepart;


--
-- Name: professor_iddepart_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('professor_iddepart_seq', 1, false);


--
-- Name: professor_idendereco_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE professor_idendereco_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.professor_idendereco_seq OWNER TO jao;

--
-- Name: professor_idendereco_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE professor_idendereco_seq OWNED BY professor.idendereco;


--
-- Name: professor_idendereco_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('professor_idendereco_seq', 1, false);


--
-- Name: professor_matricula_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE professor_matricula_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.professor_matricula_seq OWNER TO jao;

--
-- Name: professor_matricula_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE professor_matricula_seq OWNED BY professor.matricula;


--
-- Name: professor_matricula_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('professor_matricula_seq', 1, true);


--
-- Name: turma; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE turma (
    idturma integer NOT NULL,
    iddisc integer NOT NULL,
    turma character varying(10)
);


ALTER TABLE public.turma OWNER TO jao;

--
-- Name: turma_iddisc_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE turma_iddisc_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.turma_iddisc_seq OWNER TO jao;

--
-- Name: turma_iddisc_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE turma_iddisc_seq OWNED BY turma.iddisc;


--
-- Name: turma_iddisc_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('turma_iddisc_seq', 1, false);


--
-- Name: turma_idturma_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE turma_idturma_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.turma_idturma_seq OWNER TO jao;

--
-- Name: turma_idturma_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE turma_idturma_seq OWNED BY turma.idturma;


--
-- Name: turma_idturma_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('turma_idturma_seq', 1, false);


--
-- Name: ra; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY aluno ALTER COLUMN ra SET DEFAULT nextval('aluno_ra_seq'::regclass);


--
-- Name: idendereco; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY aluno ALTER COLUMN idendereco SET DEFAULT nextval('aluno_idendereco_seq'::regclass);


--
-- Name: idcurso; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY curso ALTER COLUMN idcurso SET DEFAULT nextval('curso_idcurso_seq'::regclass);


--
-- Name: iddepart; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY curso ALTER COLUMN iddepart SET DEFAULT nextval('curso_iddepart_seq'::regclass);


--
-- Name: iddepart; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY departamento ALTER COLUMN iddepart SET DEFAULT nextval('departamento_iddepart_seq'::regclass);


--
-- Name: idmatricula; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY desempenho ALTER COLUMN idmatricula SET DEFAULT nextval('desempenho_idmatricula_seq'::regclass);


--
-- Name: iddisc; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY desempenho ALTER COLUMN iddisc SET DEFAULT nextval('desempenho_iddisc_seq'::regclass);


--
-- Name: ra; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY desempenho ALTER COLUMN ra SET DEFAULT nextval('desempenho_ra_seq'::regclass);


--
-- Name: iddisc; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina ALTER COLUMN iddisc SET DEFAULT nextval('disciplina_iddisc_seq'::regclass);


--
-- Name: idcurso; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina ALTER COLUMN idcurso SET DEFAULT nextval('disciplina_idcurso_seq'::regclass);


--
-- Name: idendereco; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY endereco ALTER COLUMN idendereco SET DEFAULT nextval('endereco_idendereco_seq'::regclass);


--
-- Name: idprereq; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY prereq ALTER COLUMN idprereq SET DEFAULT nextval('prereq_idprereq_seq'::regclass);


--
-- Name: iddisc; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY prereq ALTER COLUMN iddisc SET DEFAULT nextval('prereq_iddisc_seq'::regclass);


--
-- Name: matricula; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY professor ALTER COLUMN matricula SET DEFAULT nextval('professor_matricula_seq'::regclass);


--
-- Name: idendereco; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY professor ALTER COLUMN idendereco SET DEFAULT nextval('professor_idendereco_seq'::regclass);


--
-- Name: iddepart; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY professor ALTER COLUMN iddepart SET DEFAULT nextval('professor_iddepart_seq'::regclass);


--
-- Name: idturma; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY turma ALTER COLUMN idturma SET DEFAULT nextval('turma_idturma_seq'::regclass);


--
-- Name: iddisc; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY turma ALTER COLUMN iddisc SET DEFAULT nextval('turma_iddisc_seq'::regclass);


--
-- Data for Name: aluno; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY aluno (ra, idendereco, mae, pai, periodo, origem, rg, estadocivil, nacionalidade, sexo, nome, dtnasc, cpf, email, telefone, aceito) FROM stdin;
1	2	Maria Pinta	Joao Pinto	01	SP	2578467846	SoBronha	Brasileiro	M	Joao Zidane	2015-11-02	487.874.874-67	zzedic@margoluc.ano.br	42-91554451	f
\.


--
-- Data for Name: curso; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY curso (idcurso, iddepart, nome, turno, tipo, cargahor, credito, duracao) FROM stdin;
\.


--
-- Data for Name: departamento; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY departamento (iddepart, nome) FROM stdin;
1	Departamento Teste
\.


--
-- Data for Name: desempenho; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY desempenho (idmatricula, iddisc, ra, ano, semestre, frequencia, um, dois) FROM stdin;
\.


--
-- Data for Name: disciplina; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY disciplina (iddisc, idcurso, nome, periodo, credito, tipo, cargahor, vagas) FROM stdin;
\.


--
-- Data for Name: endereco; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY endereco (idendereco, rua, numero, bairro, cidade, estado, cep, complemento) FROM stdin;
1	Picada Cafe	10	Bairro de Teste	Cidade de Teste	SP	9587-157	Embaixo da Ponte
2	Embaixada dos testes	1	Centro	Cidade de Teste	SP	9587-157	Na Ponte
\.


--
-- Data for Name: prereq; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY prereq (idprereq, iddisc) FROM stdin;
\.


--
-- Data for Name: professor; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY professor (matricula, idendereco, iddepart, formacao, cfe, ischefe, rg, estadocivil, nacionalidade, sexo, nome, dtnasc, cpf, telefone, email) FROM stdin;
1	1	1	Chefe de Teste	cfe814871	t	9587157157	SoComendo	Brasileiro	M	Chah de cafe	2015-11-02	028.884.994-41	41-98578487	varzsorofa@chanhchang.com.azuis
\.


--
-- Data for Name: turma; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY turma (idturma, iddisc, turma) FROM stdin;
\.


--
-- Name: aluno_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY aluno
    ADD CONSTRAINT aluno_pkey PRIMARY KEY (ra);


--
-- Name: curso_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY curso
    ADD CONSTRAINT curso_pkey PRIMARY KEY (idcurso);


--
-- Name: departamento_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY departamento
    ADD CONSTRAINT departamento_pkey PRIMARY KEY (iddepart);


--
-- Name: desempenho_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY desempenho
    ADD CONSTRAINT desempenho_pkey PRIMARY KEY (idmatricula, iddisc, ra);


--
-- Name: disciplina_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY disciplina
    ADD CONSTRAINT disciplina_pkey PRIMARY KEY (iddisc);


--
-- Name: endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (idendereco);


--
-- Name: prereq_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY prereq
    ADD CONSTRAINT prereq_pkey PRIMARY KEY (idprereq, iddisc);


--
-- Name: professor_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY professor
    ADD CONSTRAINT professor_pkey PRIMARY KEY (matricula);


--
-- Name: turma_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY turma
    ADD CONSTRAINT turma_pkey PRIMARY KEY (idturma, iddisc);


--
-- Name: aluno_idendereco_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY aluno
    ADD CONSTRAINT aluno_idendereco_fkey FOREIGN KEY (idendereco) REFERENCES endereco(idendereco) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: curso_iddepart_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY curso
    ADD CONSTRAINT curso_iddepart_fkey FOREIGN KEY (iddepart) REFERENCES departamento(iddepart) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: curso_iddepart_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY curso
    ADD CONSTRAINT curso_iddepart_fkey1 FOREIGN KEY (iddepart) REFERENCES departamento(iddepart) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: disciplina_idcurso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina
    ADD CONSTRAINT disciplina_idcurso_fkey FOREIGN KEY (idcurso) REFERENCES curso(idcurso) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: prereq_iddisc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY prereq
    ADD CONSTRAINT prereq_iddisc_fkey FOREIGN KEY (iddisc) REFERENCES disciplina(iddisc) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: prereq_iddisc_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY prereq
    ADD CONSTRAINT prereq_iddisc_fkey1 FOREIGN KEY (iddisc) REFERENCES disciplina(iddisc) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: prereq_idprereq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY prereq
    ADD CONSTRAINT prereq_idprereq_fkey FOREIGN KEY (idprereq) REFERENCES disciplina(iddisc) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: prereq_idprereq_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY prereq
    ADD CONSTRAINT prereq_idprereq_fkey1 FOREIGN KEY (idprereq) REFERENCES disciplina(iddisc) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: professor_iddepart_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY professor
    ADD CONSTRAINT professor_iddepart_fkey FOREIGN KEY (iddepart) REFERENCES departamento(iddepart) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: professor_iddepart_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY professor
    ADD CONSTRAINT professor_iddepart_fkey1 FOREIGN KEY (iddepart) REFERENCES departamento(iddepart) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: professor_idendereco_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY professor
    ADD CONSTRAINT professor_idendereco_fkey FOREIGN KEY (idendereco) REFERENCES endereco(idendereco) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: professor_idendereco_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY professor
    ADD CONSTRAINT professor_idendereco_fkey1 FOREIGN KEY (idendereco) REFERENCES endereco(idendereco) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: turma_iddisc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY turma
    ADD CONSTRAINT turma_iddisc_fkey FOREIGN KEY (iddisc) REFERENCES disciplina(iddisc) ON UPDATE CASCADE ON DELETE RESTRICT;


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

\connect unitest

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: aluno; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE aluno (
    ra integer NOT NULL,
    idendereco integer NOT NULL,
    mae character varying(50),
    pai character varying(50),
    periodo character(2),
    origem character(2),
    rg character varying(20),
    estadocivil character varying(10),
    nacionalidade character varying(20),
    sexo character(1),
    nome character varying(50),
    dtnasc date,
    cpf character varying(20),
    email character varying(70),
    telefone character varying(20),
    aceito boolean
);


ALTER TABLE public.aluno OWNER TO jao;

--
-- Name: aluno_idendereco_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE aluno_idendereco_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.aluno_idendereco_seq OWNER TO jao;

--
-- Name: aluno_idendereco_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE aluno_idendereco_seq OWNED BY aluno.idendereco;


--
-- Name: aluno_idendereco_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('aluno_idendereco_seq', 1, false);


--
-- Name: aluno_ra_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE aluno_ra_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.aluno_ra_seq OWNER TO jao;

--
-- Name: aluno_ra_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE aluno_ra_seq OWNED BY aluno.ra;


--
-- Name: aluno_ra_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('aluno_ra_seq', 1, true);


--
-- Name: curso; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE curso (
    idcurso integer NOT NULL,
    iddepart integer NOT NULL,
    nome character varying(50),
    turno character varying(10),
    tipo character varying(20),
    cargahor integer,
    credito smallint,
    duracao smallint
);


ALTER TABLE public.curso OWNER TO jao;

--
-- Name: curso_idcurso_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE curso_idcurso_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.curso_idcurso_seq OWNER TO jao;

--
-- Name: curso_idcurso_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE curso_idcurso_seq OWNED BY curso.idcurso;


--
-- Name: curso_idcurso_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('curso_idcurso_seq', 1, true);


--
-- Name: curso_iddepart_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE curso_iddepart_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.curso_iddepart_seq OWNER TO jao;

--
-- Name: curso_iddepart_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE curso_iddepart_seq OWNED BY curso.iddepart;


--
-- Name: curso_iddepart_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('curso_iddepart_seq', 1, false);


--
-- Name: departamento; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE departamento (
    iddepart integer NOT NULL,
    nome character varying(20)
);


ALTER TABLE public.departamento OWNER TO jao;

--
-- Name: departamento_iddepart_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE departamento_iddepart_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.departamento_iddepart_seq OWNER TO jao;

--
-- Name: departamento_iddepart_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE departamento_iddepart_seq OWNED BY departamento.iddepart;


--
-- Name: departamento_iddepart_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('departamento_iddepart_seq', 1, true);


--
-- Name: desempenho; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE desempenho (
    idmatricula integer NOT NULL,
    iddisc integer NOT NULL,
    ra integer NOT NULL,
    ano character(4),
    semestre character(1),
    frequencia numeric(2,2),
    um numeric(2,2),
    dois numeric(2,2)
);


ALTER TABLE public.desempenho OWNER TO jao;

--
-- Name: desempenho_iddisc_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE desempenho_iddisc_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.desempenho_iddisc_seq OWNER TO jao;

--
-- Name: desempenho_iddisc_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE desempenho_iddisc_seq OWNED BY desempenho.iddisc;


--
-- Name: desempenho_iddisc_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('desempenho_iddisc_seq', 1, false);


--
-- Name: desempenho_idmatricula_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE desempenho_idmatricula_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.desempenho_idmatricula_seq OWNER TO jao;

--
-- Name: desempenho_idmatricula_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE desempenho_idmatricula_seq OWNED BY desempenho.idmatricula;


--
-- Name: desempenho_idmatricula_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('desempenho_idmatricula_seq', 1, false);


--
-- Name: desempenho_ra_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE desempenho_ra_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.desempenho_ra_seq OWNER TO jao;

--
-- Name: desempenho_ra_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE desempenho_ra_seq OWNED BY desempenho.ra;


--
-- Name: desempenho_ra_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('desempenho_ra_seq', 1, false);


--
-- Name: disciplina; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE disciplina (
    iddisc integer NOT NULL,
    idcurso integer NOT NULL,
    nome character varying(50),
    periodo character(2),
    credito character(2),
    tipo character varying(10),
    cargahor character(3),
    vagas character(2)
);


ALTER TABLE public.disciplina OWNER TO jao;

--
-- Name: disciplina_idcurso_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE disciplina_idcurso_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.disciplina_idcurso_seq OWNER TO jao;

--
-- Name: disciplina_idcurso_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE disciplina_idcurso_seq OWNED BY disciplina.idcurso;


--
-- Name: disciplina_idcurso_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('disciplina_idcurso_seq', 1, false);


--
-- Name: disciplina_iddisc_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE disciplina_iddisc_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.disciplina_iddisc_seq OWNER TO jao;

--
-- Name: disciplina_iddisc_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE disciplina_iddisc_seq OWNED BY disciplina.iddisc;


--
-- Name: disciplina_iddisc_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('disciplina_iddisc_seq', 1, false);


--
-- Name: endereco; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE endereco (
    idendereco integer NOT NULL,
    rua character varying(50),
    numero integer,
    bairro character varying(50),
    cidade character varying(20),
    estado character(2),
    cep character varying(20),
    complemento character varying(20)
);


ALTER TABLE public.endereco OWNER TO jao;

--
-- Name: endereco_idendereco_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE endereco_idendereco_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.endereco_idendereco_seq OWNER TO jao;

--
-- Name: endereco_idendereco_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE endereco_idendereco_seq OWNED BY endereco.idendereco;


--
-- Name: endereco_idendereco_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('endereco_idendereco_seq', 2, true);


--
-- Name: prereq; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE prereq (
    idprereq integer NOT NULL,
    iddisc integer NOT NULL
);


ALTER TABLE public.prereq OWNER TO jao;

--
-- Name: prereq_iddisc_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE prereq_iddisc_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.prereq_iddisc_seq OWNER TO jao;

--
-- Name: prereq_iddisc_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE prereq_iddisc_seq OWNED BY prereq.iddisc;


--
-- Name: prereq_iddisc_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('prereq_iddisc_seq', 1, false);


--
-- Name: prereq_idprereq_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE prereq_idprereq_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.prereq_idprereq_seq OWNER TO jao;

--
-- Name: prereq_idprereq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE prereq_idprereq_seq OWNED BY prereq.idprereq;


--
-- Name: prereq_idprereq_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('prereq_idprereq_seq', 1, false);


--
-- Name: professor; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE professor (
    matricula integer NOT NULL,
    idendereco integer NOT NULL,
    iddepart integer NOT NULL,
    formacao character varying(20),
    cfe character varying(20),
    ischefe boolean,
    rg character varying(20),
    estadocivil character varying(10),
    nacionalidade character varying(20),
    sexo character(1),
    nome character varying(50),
    dtnasc date,
    cpf character varying(20),
    telefone character varying(20),
    email character varying(70)
);


ALTER TABLE public.professor OWNER TO jao;

--
-- Name: professor_iddepart_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE professor_iddepart_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.professor_iddepart_seq OWNER TO jao;

--
-- Name: professor_iddepart_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE professor_iddepart_seq OWNED BY professor.iddepart;


--
-- Name: professor_iddepart_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('professor_iddepart_seq', 1, false);


--
-- Name: professor_idendereco_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE professor_idendereco_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.professor_idendereco_seq OWNER TO jao;

--
-- Name: professor_idendereco_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE professor_idendereco_seq OWNED BY professor.idendereco;


--
-- Name: professor_idendereco_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('professor_idendereco_seq', 1, false);


--
-- Name: professor_matricula_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE professor_matricula_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.professor_matricula_seq OWNER TO jao;

--
-- Name: professor_matricula_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE professor_matricula_seq OWNED BY professor.matricula;


--
-- Name: professor_matricula_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('professor_matricula_seq', 1, true);


--
-- Name: turma; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE turma (
    idturma integer NOT NULL,
    iddisc integer NOT NULL,
    turma character varying(10)
);


ALTER TABLE public.turma OWNER TO jao;

--
-- Name: turma_iddisc_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE turma_iddisc_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.turma_iddisc_seq OWNER TO jao;

--
-- Name: turma_iddisc_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE turma_iddisc_seq OWNED BY turma.iddisc;


--
-- Name: turma_iddisc_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('turma_iddisc_seq', 1, false);


--
-- Name: turma_idturma_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE turma_idturma_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.turma_idturma_seq OWNER TO jao;

--
-- Name: turma_idturma_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE turma_idturma_seq OWNED BY turma.idturma;


--
-- Name: turma_idturma_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('turma_idturma_seq', 1, false);


--
-- Name: ra; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY aluno ALTER COLUMN ra SET DEFAULT nextval('aluno_ra_seq'::regclass);


--
-- Name: idendereco; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY aluno ALTER COLUMN idendereco SET DEFAULT nextval('aluno_idendereco_seq'::regclass);


--
-- Name: idcurso; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY curso ALTER COLUMN idcurso SET DEFAULT nextval('curso_idcurso_seq'::regclass);


--
-- Name: iddepart; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY curso ALTER COLUMN iddepart SET DEFAULT nextval('curso_iddepart_seq'::regclass);


--
-- Name: iddepart; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY departamento ALTER COLUMN iddepart SET DEFAULT nextval('departamento_iddepart_seq'::regclass);


--
-- Name: idmatricula; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY desempenho ALTER COLUMN idmatricula SET DEFAULT nextval('desempenho_idmatricula_seq'::regclass);


--
-- Name: iddisc; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY desempenho ALTER COLUMN iddisc SET DEFAULT nextval('desempenho_iddisc_seq'::regclass);


--
-- Name: ra; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY desempenho ALTER COLUMN ra SET DEFAULT nextval('desempenho_ra_seq'::regclass);


--
-- Name: iddisc; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina ALTER COLUMN iddisc SET DEFAULT nextval('disciplina_iddisc_seq'::regclass);


--
-- Name: idcurso; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina ALTER COLUMN idcurso SET DEFAULT nextval('disciplina_idcurso_seq'::regclass);


--
-- Name: idendereco; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY endereco ALTER COLUMN idendereco SET DEFAULT nextval('endereco_idendereco_seq'::regclass);


--
-- Name: idprereq; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY prereq ALTER COLUMN idprereq SET DEFAULT nextval('prereq_idprereq_seq'::regclass);


--
-- Name: iddisc; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY prereq ALTER COLUMN iddisc SET DEFAULT nextval('prereq_iddisc_seq'::regclass);


--
-- Name: matricula; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY professor ALTER COLUMN matricula SET DEFAULT nextval('professor_matricula_seq'::regclass);


--
-- Name: idendereco; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY professor ALTER COLUMN idendereco SET DEFAULT nextval('professor_idendereco_seq'::regclass);


--
-- Name: iddepart; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY professor ALTER COLUMN iddepart SET DEFAULT nextval('professor_iddepart_seq'::regclass);


--
-- Name: idturma; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY turma ALTER COLUMN idturma SET DEFAULT nextval('turma_idturma_seq'::regclass);


--
-- Name: iddisc; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY turma ALTER COLUMN iddisc SET DEFAULT nextval('turma_iddisc_seq'::regclass);


--
-- Data for Name: aluno; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY aluno (ra, idendereco, mae, pai, periodo, origem, rg, estadocivil, nacionalidade, sexo, nome, dtnasc, cpf, email, telefone, aceito) FROM stdin;
1	2	Maria Pinta	Joao Pinto	01	SP	2578467846	SoBronha	Brasileiro	M	Joao Zidane	2015-11-02	487.874.874-67	zzedic@margoluc.ano.br	42-91554451	f
\.


--
-- Data for Name: curso; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY curso (idcurso, iddepart, nome, turno, tipo, cargahor, credito, duracao) FROM stdin;
1	1	ciencia	integral	seila	3525	64	4
\.


--
-- Data for Name: departamento; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY departamento (iddepart, nome) FROM stdin;
1	Departamento Teste
\.


--
-- Data for Name: desempenho; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY desempenho (idmatricula, iddisc, ra, ano, semestre, frequencia, um, dois) FROM stdin;
\.


--
-- Data for Name: disciplina; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY disciplina (iddisc, idcurso, nome, periodo, credito, tipo, cargahor, vagas) FROM stdin;
\.


--
-- Data for Name: endereco; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY endereco (idendereco, rua, numero, bairro, cidade, estado, cep, complemento) FROM stdin;
1	Picada Cafe	10	Bairro de Teste	Cidade de Teste	SP	9587-157	Embaixo da Ponte
2	Embaixada dos testes	1	Centro	Cidade de Teste	SP	9587-157	Na Ponte
\.


--
-- Data for Name: prereq; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY prereq (idprereq, iddisc) FROM stdin;
\.


--
-- Data for Name: professor; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY professor (matricula, idendereco, iddepart, formacao, cfe, ischefe, rg, estadocivil, nacionalidade, sexo, nome, dtnasc, cpf, telefone, email) FROM stdin;
1	1	1	Chefe de Teste	cfe814871	t	9587157157	SoComendo	Brasileiro	M	Chah de cafe	2015-11-02	028.884.994-41	41-98578487	varzsorofa@chanhchang.com.azuis
\.


--
-- Data for Name: turma; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY turma (idturma, iddisc, turma) FROM stdin;
\.


--
-- Name: aluno_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY aluno
    ADD CONSTRAINT aluno_pkey PRIMARY KEY (ra);


--
-- Name: curso_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY curso
    ADD CONSTRAINT curso_pkey PRIMARY KEY (idcurso);


--
-- Name: departamento_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY departamento
    ADD CONSTRAINT departamento_pkey PRIMARY KEY (iddepart);


--
-- Name: desempenho_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY desempenho
    ADD CONSTRAINT desempenho_pkey PRIMARY KEY (idmatricula, iddisc, ra);


--
-- Name: disciplina_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY disciplina
    ADD CONSTRAINT disciplina_pkey PRIMARY KEY (iddisc);


--
-- Name: endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (idendereco);


--
-- Name: prereq_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY prereq
    ADD CONSTRAINT prereq_pkey PRIMARY KEY (idprereq, iddisc);


--
-- Name: professor_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY professor
    ADD CONSTRAINT professor_pkey PRIMARY KEY (matricula);


--
-- Name: turma_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY turma
    ADD CONSTRAINT turma_pkey PRIMARY KEY (idturma, iddisc);


--
-- Name: aluno_idendereco_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY aluno
    ADD CONSTRAINT aluno_idendereco_fkey FOREIGN KEY (idendereco) REFERENCES endereco(idendereco) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: curso_iddepart_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY curso
    ADD CONSTRAINT curso_iddepart_fkey FOREIGN KEY (iddepart) REFERENCES departamento(iddepart) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: curso_iddepart_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY curso
    ADD CONSTRAINT curso_iddepart_fkey1 FOREIGN KEY (iddepart) REFERENCES departamento(iddepart) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: disciplina_idcurso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina
    ADD CONSTRAINT disciplina_idcurso_fkey FOREIGN KEY (idcurso) REFERENCES curso(idcurso) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: prereq_iddisc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY prereq
    ADD CONSTRAINT prereq_iddisc_fkey FOREIGN KEY (iddisc) REFERENCES disciplina(iddisc) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: prereq_iddisc_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY prereq
    ADD CONSTRAINT prereq_iddisc_fkey1 FOREIGN KEY (iddisc) REFERENCES disciplina(iddisc) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: prereq_idprereq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY prereq
    ADD CONSTRAINT prereq_idprereq_fkey FOREIGN KEY (idprereq) REFERENCES disciplina(iddisc) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: prereq_idprereq_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY prereq
    ADD CONSTRAINT prereq_idprereq_fkey1 FOREIGN KEY (idprereq) REFERENCES disciplina(iddisc) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: professor_iddepart_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY professor
    ADD CONSTRAINT professor_iddepart_fkey FOREIGN KEY (iddepart) REFERENCES departamento(iddepart) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: professor_iddepart_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY professor
    ADD CONSTRAINT professor_iddepart_fkey1 FOREIGN KEY (iddepart) REFERENCES departamento(iddepart) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: professor_idendereco_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY professor
    ADD CONSTRAINT professor_idendereco_fkey FOREIGN KEY (idendereco) REFERENCES endereco(idendereco) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: professor_idendereco_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY professor
    ADD CONSTRAINT professor_idendereco_fkey1 FOREIGN KEY (idendereco) REFERENCES endereco(idendereco) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: turma_iddisc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY turma
    ADD CONSTRAINT turma_iddisc_fkey FOREIGN KEY (iddisc) REFERENCES disciplina(iddisc) ON UPDATE CASCADE ON DELETE RESTRICT;


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

\connect uniteste

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: jao
--

CREATE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO jao;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: aluno; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE aluno (
    ra integer NOT NULL,
    idendereco integer,
    mae character varying(50),
    pai character varying(50),
    origem character varying(20),
    rg character varying(20),
    estadocivil character varying(20),
    nacionalidade character varying(20),
    sexo character(1),
    nome character varying(50),
    dtnasc date,
    cpf character varying(20),
    email character varying(70),
    telefone character varying(20),
    aceito boolean,
    idcurso integer,
    periodo integer DEFAULT 1
);


ALTER TABLE public.aluno OWNER TO jao;

--
-- Name: aluno_ra_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE aluno_ra_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1
    CYCLE;


ALTER TABLE public.aluno_ra_seq OWNER TO jao;

--
-- Name: aluno_ra_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE aluno_ra_seq OWNED BY aluno.ra;


--
-- Name: aluno_ra_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('aluno_ra_seq', 46003, true);


--
-- Name: curso; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE curso (
    idcurso integer NOT NULL,
    iddepart integer,
    nome character varying(50),
    turno character varying(10),
    tipo character varying(20),
    cargahor integer,
    credito smallint,
    duracao smallint
);


ALTER TABLE public.curso OWNER TO jao;

--
-- Name: curso_idcurso_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE curso_idcurso_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.curso_idcurso_seq OWNER TO jao;

--
-- Name: curso_idcurso_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE curso_idcurso_seq OWNED BY curso.idcurso;


--
-- Name: curso_idcurso_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('curso_idcurso_seq', 12, true);


--
-- Name: departamento; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE departamento (
    iddepart integer NOT NULL,
    nome character varying(20)
);


ALTER TABLE public.departamento OWNER TO jao;

--
-- Name: departamento_iddepart_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE departamento_iddepart_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.departamento_iddepart_seq OWNER TO jao;

--
-- Name: departamento_iddepart_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE departamento_iddepart_seq OWNED BY departamento.iddepart;


--
-- Name: departamento_iddepart_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('departamento_iddepart_seq', 2, true);


--
-- Name: disciplina; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE disciplina (
    iddisc integer NOT NULL,
    idcurso integer,
    nome character varying(50),
    tipo character varying(30),
    codigo character varying(20),
    matricula integer,
    pre1 integer,
    pre2 integer,
    pre3 integer,
    periodo integer DEFAULT 1,
    credito integer,
    cargahor integer,
    vagas integer DEFAULT 50
);


ALTER TABLE public.disciplina OWNER TO jao;

--
-- Name: disciplina_cargahor_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE disciplina_cargahor_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.disciplina_cargahor_seq OWNER TO jao;

--
-- Name: disciplina_cargahor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE disciplina_cargahor_seq OWNED BY disciplina.cargahor;


--
-- Name: disciplina_cargahor_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('disciplina_cargahor_seq', 1, false);


--
-- Name: disciplina_iddisc_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE disciplina_iddisc_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.disciplina_iddisc_seq OWNER TO jao;

--
-- Name: disciplina_iddisc_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE disciplina_iddisc_seq OWNED BY disciplina.iddisc;


--
-- Name: disciplina_iddisc_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('disciplina_iddisc_seq', 5, true);


--
-- Name: endereco; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE endereco (
    idendereco integer NOT NULL,
    rua character varying(50),
    numero integer,
    bairro character varying(50),
    cidade character varying(20),
    estado character(10),
    cep character varying(20),
    complemento character varying(20)
);


ALTER TABLE public.endereco OWNER TO jao;

--
-- Name: endereco_idendereco_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE endereco_idendereco_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.endereco_idendereco_seq OWNER TO jao;

--
-- Name: endereco_idendereco_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE endereco_idendereco_seq OWNED BY endereco.idendereco;


--
-- Name: endereco_idendereco_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('endereco_idendereco_seq', 25, true);


--
-- Name: matriculanota; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE matriculanota (
    idmatricula integer NOT NULL,
    idturma integer,
    ra integer,
    semestre character(1),
    frequencia real DEFAULT 75,
    notaum real DEFAULT 0,
    notadois real DEFAULT 0,
    "DataInicioSemestre" date DEFAULT '2015-02-15'::date,
    "DataFimSemestre" date DEFAULT '2015-07-15'::date,
    aprovado boolean DEFAULT false
);


ALTER TABLE public.matriculanota OWNER TO jao;

--
-- Name: matriculanota_idmatricula_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE matriculanota_idmatricula_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.matriculanota_idmatricula_seq OWNER TO jao;

--
-- Name: matriculanota_idmatricula_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE matriculanota_idmatricula_seq OWNED BY matriculanota.idmatricula;


--
-- Name: matriculanota_idmatricula_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('matriculanota_idmatricula_seq', 1, true);


--
-- Name: professor; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE professor (
    matricula integer NOT NULL,
    idendereco integer,
    iddepart integer,
    formacao character varying(20),
    cfe character varying(20),
    ischefe boolean,
    rg character varying(20),
    estadocivil character varying(10),
    nacionalidade character varying(20),
    sexo character(1),
    nome character varying(50),
    dtnasc date,
    cpf character varying(20),
    telefone character varying(20),
    email character varying(70)
);


ALTER TABLE public.professor OWNER TO jao;

--
-- Name: professor_matricula_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE professor_matricula_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.professor_matricula_seq OWNER TO jao;

--
-- Name: professor_matricula_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE professor_matricula_seq OWNED BY professor.matricula;


--
-- Name: professor_matricula_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('professor_matricula_seq', 15002, true);


--
-- Name: turma; Type: TABLE; Schema: public; Owner: jao; Tablespace: 
--

CREATE TABLE turma (
    idturma integer NOT NULL,
    iddisc integer,
    turma character varying(10),
    horario character varying(20),
    aberta boolean DEFAULT true,
    vagas integer DEFAULT 50
);


ALTER TABLE public.turma OWNER TO jao;

--
-- Name: turma_idturma_seq; Type: SEQUENCE; Schema: public; Owner: jao
--

CREATE SEQUENCE turma_idturma_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.turma_idturma_seq OWNER TO jao;

--
-- Name: turma_idturma_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jao
--

ALTER SEQUENCE turma_idturma_seq OWNED BY turma.idturma;


--
-- Name: turma_idturma_seq; Type: SEQUENCE SET; Schema: public; Owner: jao
--

SELECT pg_catalog.setval('turma_idturma_seq', 5, true);


--
-- Name: ra; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY aluno ALTER COLUMN ra SET DEFAULT nextval('aluno_ra_seq'::regclass);


--
-- Name: idcurso; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY curso ALTER COLUMN idcurso SET DEFAULT nextval('curso_idcurso_seq'::regclass);


--
-- Name: iddepart; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY departamento ALTER COLUMN iddepart SET DEFAULT nextval('departamento_iddepart_seq'::regclass);


--
-- Name: iddisc; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina ALTER COLUMN iddisc SET DEFAULT nextval('disciplina_iddisc_seq'::regclass);


--
-- Name: idendereco; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY endereco ALTER COLUMN idendereco SET DEFAULT nextval('endereco_idendereco_seq'::regclass);


--
-- Name: idmatricula; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY matriculanota ALTER COLUMN idmatricula SET DEFAULT nextval('matriculanota_idmatricula_seq'::regclass);


--
-- Name: matricula; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY professor ALTER COLUMN matricula SET DEFAULT nextval('professor_matricula_seq'::regclass);


--
-- Name: idturma; Type: DEFAULT; Schema: public; Owner: jao
--

ALTER TABLE ONLY turma ALTER COLUMN idturma SET DEFAULT nextval('turma_idturma_seq'::regclass);


--
-- Data for Name: aluno; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY aluno (ra, idendereco, mae, pai, origem, rg, estadocivil, nacionalidade, sexo, nome, dtnasc, cpf, email, telefone, aceito, idcurso, periodo) FROM stdin;
46003	25	mamae	papai	Vestibular	4949	Solteiro(a)	caribenho	M	joao 1	2015-12-01	498489	asda@jsiaj	1984198	f	11	1
\.


--
-- Data for Name: curso; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY curso (idcurso, iddepart, nome, turno, tipo, cargahor, credito, duracao) FROM stdin;
12	1	ENGENHARIA DE SOFTWARE	MATUTINO	GRADUAçãO	10	10	10
11	1	CIENCIA DA COMPUTACAO	MATUTINO	GRADUAçãO	1	1	8
\.


--
-- Data for Name: departamento; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY departamento (iddepart, nome) FROM stdin;
1	COMPUTACAO
\.


--
-- Data for Name: disciplina; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY disciplina (iddisc, idcurso, nome, tipo, codigo, matricula, pre1, pre2, pre3, periodo, credito, cargahor, vagas) FROM stdin;
5	11	DISCIPLINA 1	OPTATIVA	DSC001	15002	\N	\N	\N	1	4	68	32
\.


--
-- Data for Name: endereco; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY endereco (idendereco, rua, numero, bairro, cidade, estado, cep, complemento) FROM stdin;
1	Baixada das pulgas	15	centro	ponta grossa	PR        	84010-170	casa
2	Baixada dos profesores	564	centro	ponta grossa	parana    	8401-157	apt
3	BAIZADAS	51	JAJAISJDIA	DASD	AP        	9891486	HAPPY
4	BAIZADAS	51	JAJAISJDIA	DASD	AP        	9891486	HAPPY
5	AV BRASIL	894	CENTRO	PONTA GROSSA	AC        	9819419	APT DO PORTUGA
6	BAIXADA DOS PROFESORES	564	CENTRO	PONTA GROSSA	PARANA    	8401-157	
7	BAIXADA DOS PROFESORES	564	CENTRO	PONTA GROSSA	PARANA    	8401-157	
8	BAIXADA DOS PROFESORES	564	CENTRO	PONTA GROSSA	PARANA    	8401-157	
9	BAIXADA DOS PROFESORES	564	CENTRO	PONTA GROSSA	PARANA    	8401-157	
10	BAIXADA DOS PROFESORES	564	CENTRO	PONTA GROSSA	PARANA    	8401-157	
11	BAIXADA DOS PROFESORES	564	CENTRO	PONTA GROSSA	PARANA    	8401-157	
12	BAIXADA DOS PROFESORES	564	CENTRO	PONTA GROSSA	PARANA    	8401-157	
13	BAIXADA DOS PROFESORES	564	CENTRO	PONTA GROSSA	PARANA    	8401-157	
14	DA FRENTE DA RUA DE TRAZ	1561	DO CENTRO	PONTA GROSSA	AC        	89849	APT
15	BAIXADA DOS PROFESORES	564	CENTRO	PONTA GROSSA	PARANA    	8401-157	
16	BAIXADA DOS PROFESORES	564	CENTRO	PONTA GROSSA	PARANA    	8401-157	
17	BAIXADA DOS PROFESORES	564	CENTRO	PONTA GROSSA	PARANA    	8401-157	
18	BAIXADA DOS PROFESORES	564	CENTRO	PONTA GROSSA	PARANA    	8401-157	
19	HAHAHAH	49498	HAHAH	AHUSHU	AC        	49494	46549
20	DAS BIBOCAS	84949	CENTRO	PONTA GROSSA	PARANA    	94894	
21	DAS BIBOCAS	84949	CENTRO	PONTA GROSSA	PARANA    	94894	
22	DAS BIBOCAS	84949	CENTRO	PONTA GROSSA	PARANA    	94894	
23	DA FRENTE	468	CENTRO	PONTA GROSSA	PARANA    	15616	
24	DO LADO	468	CENTRO	PONTA GROSSA	PARANA    	15616	
25	EUTROPIES	4564	CENTRO	PONTA	AM        	15161	DE CASA
\.


--
-- Data for Name: matriculanota; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY matriculanota (idmatricula, idturma, ra, semestre, frequencia, notaum, notadois, "DataInicioSemestre", "DataFimSemestre", aprovado) FROM stdin;
\.


--
-- Data for Name: professor; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY professor (matricula, idendereco, iddepart, formacao, cfe, ischefe, rg, estadocivil, nacionalidade, sexo, nome, dtnasc, cpf, telefone, email) FROM stdin;
15001	23	1	ASTRONAULTA	15616	f	51616	BAHI	BRASIL	M	JOAJAO	2015-12-01	16489	156156	DAHDUSA@HAUS.COM
15002	23	1	ASTRONAULTA	15616	t	51616468	MG	BRASIL	F	MARIA JOSE	2015-12-01	156484698	1561561661	DAHDUSA@HAUS.COM
\.


--
-- Data for Name: turma; Type: TABLE DATA; Schema: public; Owner: jao
--

COPY turma (idturma, iddisc, turma, horario, aberta, vagas) FROM stdin;
\.


--
-- Name: aluno_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY aluno
    ADD CONSTRAINT aluno_pkey PRIMARY KEY (ra);


--
-- Name: curso_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY curso
    ADD CONSTRAINT curso_pkey PRIMARY KEY (idcurso);


--
-- Name: departamento_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY departamento
    ADD CONSTRAINT departamento_pkey PRIMARY KEY (iddepart);


--
-- Name: disciplina_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY disciplina
    ADD CONSTRAINT disciplina_pkey PRIMARY KEY (iddisc);


--
-- Name: endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (idendereco);


--
-- Name: matriculanota_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY matriculanota
    ADD CONSTRAINT matriculanota_pkey PRIMARY KEY (idmatricula);


--
-- Name: professor_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY professor
    ADD CONSTRAINT professor_pkey PRIMARY KEY (matricula);


--
-- Name: turma_pkey; Type: CONSTRAINT; Schema: public; Owner: jao; Tablespace: 
--

ALTER TABLE ONLY turma
    ADD CONSTRAINT turma_pkey PRIMARY KEY (idturma);


--
-- Name: aluno_idcurso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY aluno
    ADD CONSTRAINT aluno_idcurso_fkey FOREIGN KEY (idcurso) REFERENCES curso(idcurso);


--
-- Name: aluno_idendereco_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY aluno
    ADD CONSTRAINT aluno_idendereco_fkey FOREIGN KEY (idendereco) REFERENCES endereco(idendereco) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: curso_iddepart_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY curso
    ADD CONSTRAINT curso_iddepart_fkey FOREIGN KEY (iddepart) REFERENCES departamento(iddepart) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: disciplina_idcurso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina
    ADD CONSTRAINT disciplina_idcurso_fkey FOREIGN KEY (idcurso) REFERENCES curso(idcurso) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: disciplina_matricula_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina
    ADD CONSTRAINT disciplina_matricula_fkey FOREIGN KEY (matricula) REFERENCES professor(matricula);


--
-- Name: disciplina_pre1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina
    ADD CONSTRAINT disciplina_pre1_fkey FOREIGN KEY (pre1) REFERENCES disciplina(iddisc);


--
-- Name: disciplina_pre2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina
    ADD CONSTRAINT disciplina_pre2_fkey FOREIGN KEY (pre2) REFERENCES disciplina(iddisc);


--
-- Name: disciplina_pre3_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY disciplina
    ADD CONSTRAINT disciplina_pre3_fkey FOREIGN KEY (pre3) REFERENCES disciplina(iddisc);


--
-- Name: matriculanota_idturma_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY matriculanota
    ADD CONSTRAINT matriculanota_idturma_fkey FOREIGN KEY (idturma) REFERENCES turma(idturma) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: matriculanota_ra_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY matriculanota
    ADD CONSTRAINT matriculanota_ra_fkey FOREIGN KEY (ra) REFERENCES aluno(ra) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: professor_iddepart_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY professor
    ADD CONSTRAINT professor_iddepart_fkey FOREIGN KEY (iddepart) REFERENCES departamento(iddepart) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: professor_idendereco_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY professor
    ADD CONSTRAINT professor_idendereco_fkey FOREIGN KEY (idendereco) REFERENCES endereco(idendereco) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: turma_iddisc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jao
--

ALTER TABLE ONLY turma
    ADD CONSTRAINT turma_iddisc_fkey FOREIGN KEY (iddisc) REFERENCES disciplina(iddisc) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--
