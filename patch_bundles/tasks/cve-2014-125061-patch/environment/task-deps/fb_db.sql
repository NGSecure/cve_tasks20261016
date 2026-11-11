SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;
SET search_path = public, pg_catalog;
SET default_tablespace = '';
SET default_with_oids = false;


CREATE TABLE fb_account (
    account_id bigint NOT NULL,
    protocol_id integer,
    address text NOT NULL,
    port integer NOT NULL,
    login text NOT NULL
);

CREATE SEQUENCE fb_account_account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE fb_account_account_id_seq OWNED BY fb_account.account_id;


CREATE TABLE fb_client (
    client_id integer NOT NULL,
    login text NOT NULL,
    password text NOT NULL
);


CREATE TABLE fb_client_acl (
    client_id integer,
    ace_id integer NOT NULL
);


CREATE TABLE fb_client_acl_dict (
    ace_id integer NOT NULL,
    ace_desc text NOT NULL
);



CREATE SEQUENCE fb_client_acl_dict_ace_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fb_client_acl_dict_ace_id_seq OWNED BY fb_client_acl_dict.ace_id;



CREATE SEQUENCE fb_client_client_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE fb_client_client_id_seq OWNED BY fb_client.client_id;


CREATE TABLE fb_configuration (
    key text NOT NULL,
    value text NOT NULL
);


CREATE TABLE fb_file_status (
    transfer_id integer,
    filename text NOT NULL,
    status_time timestamp with time zone NOT NULL,
    status_id integer
);


CREATE TABLE fb_file_status_dict (
    status_id integer NOT NULL,
    status_desc text NOT NULL,
    status_type text NOT NULL
);


CREATE SEQUENCE fb_file_status_dict_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE fb_file_status_dict_status_id_seq OWNED BY fb_file_status_dict.status_id;



CREATE TABLE fb_protocol_dict (
    protocol_id integer NOT NULL,
    protocol_desc text NOT NULL
);



CREATE SEQUENCE fb_protocol_dict_protocol_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE fb_protocol_dict_protocol_id_seq OWNED BY fb_protocol_dict.protocol_id;



CREATE TABLE fb_transfer (
    transfer_id bigint NOT NULL,
    transfer_hash text NOT NULL,
    source_id integer,
    target_id integer,
    source_path text NOT NULL,
    target_path text NOT NULL
);


CREATE TABLE fb_transfer_status (
    transfer_id integer,
    status_id integer,
    status_time timestamp with time zone NOT NULL
);



CREATE TABLE fb_transfer_status_dict (
    status_id integer NOT NULL,
    status_desc text NOT NULL
);



CREATE SEQUENCE fb_transfer_status_dict_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fb_transfer_status_dict_status_id_seq OWNED BY fb_transfer_status_dict.status_id;



CREATE SEQUENCE fb_transfer_transfer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE fb_transfer_transfer_id_seq OWNED BY fb_transfer.transfer_id;
ALTER TABLE ONLY fb_account ALTER COLUMN account_id SET DEFAULT nextval('fb_account_account_id_seq'::regclass);
ALTER TABLE ONLY fb_client ALTER COLUMN client_id SET DEFAULT nextval('fb_client_client_id_seq'::regclass);
ALTER TABLE ONLY fb_client_acl_dict ALTER COLUMN ace_id SET DEFAULT nextval('fb_client_acl_dict_ace_id_seq'::regclass);
ALTER TABLE ONLY fb_file_status_dict ALTER COLUMN status_id SET DEFAULT nextval('fb_file_status_dict_status_id_seq'::regclass);
ALTER TABLE ONLY fb_protocol_dict ALTER COLUMN protocol_id SET DEFAULT nextval('fb_protocol_dict_protocol_id_seq'::regclass);
ALTER TABLE ONLY fb_transfer ALTER COLUMN transfer_id SET DEFAULT nextval('fb_transfer_transfer_id_seq'::regclass);
ALTER TABLE ONLY fb_transfer_status_dict ALTER COLUMN status_id SET DEFAULT nextval('fb_transfer_status_dict_status_id_seq'::regclass);


COPY fb_protocol_dict (protocol_id, protocol_desc) FROM stdin;
1	cifs
2	ftp
3	sftp
\.


COPY fb_file_status_dict (status_id, status_desc, status_type) FROM stdin;
1	failed to archive file	error
2	failed to compress file	error
3	failed to decompress file	error
4	failed to decrypt file	error
6	failed to download file	error
7	failed to encrypt file	error
8	failed to remove file	warning
9	failed to remove md5 file	warning
10	failed to upload file	error
11	failed to upload md5 file	error
12	failed to verify md5	error
13	file archived	notification
14	file compressed	notification
15	file decompressed	notification
16	file decrypted	notification
17	file downloaded	notification
18	file encrypted	notification
19	file removed	notification
20	file scanned	notification
21	file uploaded	notification
32	failed to calculate md5	error
31	failed to encode file	error
30	file encoded	notification
29	transfer scheduled	notification
28	transfer completed	notification
27	md5 verified	notification
26	md5 file uploaded	notification
25	md5 file removed	notification
24	md5 file downloaded	notification
23	malicious code detected	error
22	internal system error	error
5	failed to download md5 file	error
\.


COPY fb_transfer_status_dict (status_id, status_desc) FROM stdin;
34	transfer completed successfully
35	transfer completed with errors
33	transfer running
\.


COPY fb_client (client_id, login, password) FROM stdin;
1	admin	2f2f61cd432a23242ddbef59a8f0cde3
\.


COPY fb_client_acl_dict (ace_id, ace_desc) FROM stdin;
1	transfer
2	status
3	list
\.


COPY fb_client_acl (client_id, ace_id) FROM stdin;
1	1
1	2
1	3
\.


COPY fb_configuration (key, value) FROM stdin;
auth	none
ssl	false
port	1080
syslog	true
debug	false
\.


ALTER TABLE ONLY fb_account
    ADD CONSTRAINT fb_account_pkey PRIMARY KEY (account_id);


ALTER TABLE ONLY fb_account
    ADD CONSTRAINT fb_account_protocol_id_key UNIQUE (protocol_id, address, port, login);


ALTER TABLE ONLY fb_client_acl_dict
    ADD CONSTRAINT fb_client_acl_dict_pkey PRIMARY KEY (ace_id);


ALTER TABLE ONLY fb_client
    ADD CONSTRAINT fb_client_login_key UNIQUE (login);


ALTER TABLE ONLY fb_client
    ADD CONSTRAINT fb_client_pkey PRIMARY KEY (client_id);


ALTER TABLE ONLY fb_configuration
    ADD CONSTRAINT fb_configuration_pkey PRIMARY KEY (key);


ALTER TABLE ONLY fb_file_status_dict
    ADD CONSTRAINT fb_file_status_dict_pkey PRIMARY KEY (status_id);


ALTER TABLE ONLY fb_protocol_dict
    ADD CONSTRAINT fb_protocol_dict_pkey PRIMARY KEY (protocol_id);


ALTER TABLE ONLY fb_transfer
    ADD CONSTRAINT fb_transfer_pkey PRIMARY KEY (transfer_id);


ALTER TABLE ONLY fb_transfer_status_dict
    ADD CONSTRAINT fb_transfer_status_dict_pkey PRIMARY KEY (status_id);


ALTER TABLE ONLY fb_account
    ADD CONSTRAINT fb_account_protocol_id_fkey FOREIGN KEY (protocol_id) REFERENCES fb_protocol_dict(protocol_id) ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE ONLY fb_client_acl
    ADD CONSTRAINT fb_client_acl_client_id_fkey FOREIGN KEY (client_id) REFERENCES fb_client(client_id) ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE ONLY fb_file_status
    ADD CONSTRAINT fb_file_status_status_id_fkey FOREIGN KEY (status_id) REFERENCES fb_file_status_dict(status_id) ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE ONLY fb_file_status
    ADD CONSTRAINT fb_file_status_transfer_id_fkey FOREIGN KEY (transfer_id) REFERENCES fb_transfer(transfer_id) ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE ONLY fb_transfer
    ADD CONSTRAINT fb_transfer_source_id_fkey FOREIGN KEY (source_id) REFERENCES fb_account(account_id) ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE ONLY fb_transfer_status
    ADD CONSTRAINT fb_transfer_status_status_id_fkey FOREIGN KEY (status_id) REFERENCES fb_transfer_status_dict(status_id) ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE ONLY fb_transfer_status
    ADD CONSTRAINT fb_transfer_status_transfer_id_fkey FOREIGN KEY (transfer_id) REFERENCES fb_transfer(transfer_id) ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE ONLY fb_transfer
    ADD CONSTRAINT fb_transfer_target_id_fkey FOREIGN KEY (target_id) REFERENCES fb_account(account_id) ON UPDATE CASCADE ON DELETE CASCADE;

