begin;
CREATE TABLE nauczyciele (
	id                   serial  NOT NULL,
	imie                 varchar(20)  NOT NULL,
	nazwisko             varchar(20)  ,
	id_uzytkownika	     varchar(20) DEFAULT NULL,
	CONSTRAINT pk_nauczyciele PRIMARY KEY ( id ),
	CONSTRAINT idx_id_uzytkownika UNIQUE ( id_uzytkownika )
 );

CREATE TABLE rodzaje_aktywnosci (
	id                   serial  NOT NULL,
	nazwa                varchar(20)  NOT NULL,
	waga                 numeric(1,0)  NOT NULL,
	CONSTRAINT pk_rodzajeaktywnosci PRIMARY KEY ( id ),
	CONSTRAINT idx_nazwa_0 UNIQUE ( nazwa )
 );

CREATE TABLE klasy (
	id                   serial  NOT NULL,
	oddzial              char(1)  NOT NULL,
	rok_rozpoczecia	     numeric(4,0) NOT NULL,
	id_wychowawcy        serial  NOT NULL,
	CONSTRAINT pk_klasy PRIMARY KEY ( id ),
	CONSTRAINT idx_klasy UNIQUE ( id_wychowawcy )
 );


CREATE TABLE przedmioty (
	id                   serial  NOT NULL,
	nazwa                varchar(15)  NOT NULL,
	id_prowadzacego      serial  NOT NULL,
	id_klasy             serial  NOT NULL,
	aktywny		     bool DEFAULT TRUE NOT NULL,
	CONSTRAINT pk_przedmioty PRIMARY KEY ( id )
 );

CREATE INDEX idx_przedmioty ON przedmioty ( id_klasy );

CREATE INDEX idx_przedmioty_0 ON przedmioty ( id_prowadzacego );

CREATE TABLE uczniowie (
	imie                 varchar(20)  NOT NULL,
	nazwisko             varchar(20)  NOT NULL,
	telefon_do_rodzica   numeric(9,0) ,
	pesel                char(11) NOT NULL,
	id_klasy             serial  NOT NULL,
	id_uzytkownika	     varchar(20) DEFAULT NULL,
	aktywny		     bool DEFAULT TRUE NOT NULL,
	CONSTRAINT pk_uczniowie PRIMARY KEY ( pesel ),
	CONSTRAINT idx_id_uuzytkownika UNIQUE ( id_uzytkownika )
 );

ALTER TABLE uczniowie ADD CONSTRAINT ck_pesel check(char_length(pesel)=11 and (floor(to_number(pesel,'99999999999')/10000000000)%10 + floor(to_number(pesel,'99999999999')/1000000000)%10*3 + floor(to_number(pesel,'99999999999')/100000000)%10*7 + floor(to_number(pesel,'99999999999')/10000000)%10*9 + floor(to_number(pesel,'99999999999')/1000000)%10 + floor(to_number(pesel,'99999999999')/100000)%10*3 + floor(to_number(pesel,'99999999999')/10000)%10*7 + floor(to_number(pesel,'99999999999')/1000)%10*9 + floor(to_number(pesel,'99999999999')/100)%10 + floor(to_number(pesel,'99999999999')/10)%10*3 + to_number(pesel,'99999999999')%10)%10 = 0);

ALTER TABLE uczniowie ADD CONSTRAINT ck_telefon check(telefon_do_rodzica between 100000000 and 999999999);

CREATE INDEX idx_uczniowie ON uczniowie ( id_klasy );

CREATE TABLE uwagi (
	id                   serial  NOT NULL,
	id_ucznia            char(11)  NOT NULL,
	id_nauczyciela       serial  NOT NULL,
	opis                 varchar(300)  NOT NULL,
	czy_pozytywna        bool DEFAULT true NOT NULL,
	data_wystawienia     date DEFAULT current_date NOT NULL,
	CONSTRAINT pk_uwagi PRIMARY KEY ( id )
 );

ALTER TABLE uwagi ADD CONSTRAINT ck_0 CHECK ( data_wystawienia <= now() );

CREATE TABLE oceny_uczniow (
	id                   serial  NOT NULL,
	wartosc              numeric(1,0)  NOT NULL,
	id_ucznia            char(11)  NOT NULL,
	id_przedmiotu        serial  NOT NULL,
	id_aktywnosci        serial  NOT NULL,
	tematyka	     varchar(20) NOT NULL,
	CONSTRAINT pk_oceny_uczniow PRIMARY KEY ( id )
 );

CREATE TABLE plan_lekcji (
	id                   serial  NOT NULL,
	id_przedmiotu        serial  NOT NULL,
	nr_lekcji            numeric(1,0)  NOT NULL,
	dzien_tygodnia       numeric(1,0)  NOT NULL,
	CONSTRAINT pk_plan_lekcji PRIMARY KEY ( id )
 );

CREATE INDEX idx_plan_lekcji ON plan_lekcji ( id_przedmiotu );

CREATE TABLE przeprowadzone_lekcje (
	id                   serial  NOT NULL,
	"data"               date DEFAULT current_date NOT NULL,
	temat_zajec          varchar(100)  ,
	id_prowadzacego      serial  NOT NULL,
	id_lekcji            serial  NOT NULL,
	CONSTRAINT pk_lekcje PRIMARY KEY ( id )
 );

ALTER TABLE przeprowadzone_lekcje ADD CONSTRAINT ck_1 CHECK ( data <= now() );

CREATE INDEX idx_Lekcje ON przeprowadzone_lekcje ( id_prowadzacego );

CREATE INDEX idx_lekcje_0 ON przeprowadzone_lekcje ( id_lekcji );

CREATE TABLE nieobecnosci (
	id_ucznia            char(11)  NOT NULL,
	id_lekcji            serial  NOT NULL,
	CONSTRAINT idx_nieobecnosci_1 PRIMARY KEY ( id_ucznia, id_lekcji )
 );

CREATE TABLE uzytkownicy (
	login 		     varchar(20) NOT NULL,
	haslo		     varchar(20) NOT NULL,
	CONSTRAINT pk_uzytkownicy PRIMARY KEY ( login )
 );

CREATE OR REPLACE FUNCTION check_weekday(i numeric(1,0)) RETURNS numeric(1,0)
	AS $$ select dzien_tygodnia from plan_lekcji where i=id $$
	LANGUAGE SQL;

CREATE OR REPLACE FUNCTION check_ocena_przedmiot(id_przedm integer, id_u char) RETURNS bool
	AS $$ select (select id_klasy from przedmioty where id_przedm=id) = (select id_klasy from uczniowie where id_u=pesel) $$
	LANGUAGE SQL;

CREATE OR REPLACE FUNCTION check_nieobecnosc_przedmiot(id_lek integer, id_u char) RETURNS bool
	AS $$ select (select id_klasy from uczniowie where id_u=pesel) = (select id_klasy from przeprowadzone_lekcje prl join plan_lekcji pl on id_lekcji=pl.id join przedmioty p on id_przedmiotu=p.id where prl.id=id_lek) $$
	LANGUAGE SQL;

ALTER TABLE przeprowadzone_lekcje ADD CONSTRAINT ck_weekday CHECK( to_number(to_char("data", 'D'),'9')=check_weekday(id_lekcji));

ALTER TABLE oceny_uczniow ADD CONSTRAINT ck_oceny_przedmioty CHECK ( check_ocena_przedmiot(id_przedmiotu,id_ucznia) );

ALTER TABLE nieobecnosci ADD CONSTRAINT ck_niebecnosci_przedmioty CHECK ( check_nieobecnosc_przedmiot(id_lekcji,id_ucznia) );

ALTER TABLE klasy ADD CONSTRAINT fk_klasy_nauczyciele FOREIGN KEY ( id_wychowawcy ) REFERENCES nauczyciele( id );

ALTER TABLE nieobecnosci ADD CONSTRAINT fk_nieobecnosci_uczniowie FOREIGN KEY ( id_ucznia ) REFERENCES uczniowie( pesel ) on delete cascade;

ALTER TABLE nieobecnosci ADD CONSTRAINT fk_nieobecnosci_lekcje FOREIGN KEY ( id_lekcji ) REFERENCES przeprowadzone_lekcje( id ) on delete cascade;

ALTER TABLE oceny_uczniow ADD CONSTRAINT fk_oceny_uczniow_uczniowie FOREIGN KEY ( id_ucznia ) REFERENCES uczniowie( pesel ) on delete cascade;

ALTER TABLE oceny_uczniow ADD CONSTRAINT fk_oceny_uczniow_przedmioty FOREIGN KEY ( id_przedmiotu ) REFERENCES przedmioty( id );

ALTER TABLE oceny_uczniow ADD CONSTRAINT fk_oceny_uczniow_rodzaje_aktywnosci FOREIGN KEY ( id_aktywnosci ) REFERENCES rodzaje_aktywnosci( id );

ALTER TABLE plan_lekcji ADD CONSTRAINT fk_plan_lekcji_przedmioty FOREIGN KEY ( id_przedmiotu ) REFERENCES przedmioty( id ) on delete cascade;

ALTER TABLE przedmioty ADD CONSTRAINT fk_przedmioty_klasy FOREIGN KEY ( id_klasy ) REFERENCES klasy( id ) on delete cascade;

ALTER TABLE przedmioty ADD CONSTRAINT fk_przedmioty_nauczyciele FOREIGN KEY ( id_prowadzacego ) REFERENCES nauczyciele( id );

ALTER TABLE przeprowadzone_lekcje ADD CONSTRAINT fk_lekcje_nauczyciele FOREIGN KEY ( id_prowadzacego ) REFERENCES nauczyciele( id );

ALTER TABLE przeprowadzone_lekcje ADD CONSTRAINT fk_lekcje_plan_lekcji FOREIGN KEY ( id_lekcji ) REFERENCES plan_lekcji( id ) on delete cascade;

ALTER TABLE uczniowie ADD CONSTRAINT fk_uczniowie_klasy FOREIGN KEY ( id_klasy ) REFERENCES klasy( id ) on delete cascade;

ALTER TABLE uwagi ADD CONSTRAINT fk_uwagi_nauczyciele FOREIGN KEY ( id_nauczyciela ) REFERENCES nauczyciele( id );

ALTER TABLE uwagi ADD CONSTRAINT fk_uwagi_uczniowie FOREIGN KEY ( id_ucznia ) REFERENCES uczniowie( pesel ) on delete cascade;

ALTER TABLE uczniowie ADD CONSTRAINT fk_uczniowie_uzytkownicy FOREIGN KEY ( id_uzytkownika ) REFERENCES uzytkownicy( login ) on delete cascade;

ALTER TABLE nauczyciele ADD CONSTRAINT fk_nauczyciele_uzytkownicy FOREIGN KEY ( id_uzytkownika ) REFERENCES uzytkownicy( login ) on delete cascade;

CREATE OR REPLACE FUNCTION user_id_check() returns trigger AS $user_id_check$
BEGIN
	IF ( new.id_uzytkownika in (select id_uzytkownika from uczniowie) or new.id_uzytkownika in (select id_uzytkownika from nauczyciele)) 
	THEN RAISE EXCEPTION 'niepoprawne id_uzytkownika';
	END IF;
	RETURN NEW;
END;
$user_id_check$ LANGUAGE plpgsql;

CREATE TRIGGER user_id_check BEFORE INSERT OR UPDATE ON uczniowie
FOR EACH ROW EXECUTE PROCEDURE user_id_check();

CREATE TRIGGER user_id_check BEFORE INSERT OR UPDATE ON nauczyciele
FOR EACH ROW EXECUTE PROCEDURE user_id_check();

create or replace function getsubjectteacher(lid integer) returns integer 
	as $$ select id_prowadzacego from przedmioty where id=lid $$
	language SQL;

create or replace function teacherlesson() returns trigger as $teacherlesson$
begin
	if(getsubjectteacher(new.id_przedmiotu) in (select id_prowadzacego from plan_lekcji pl join przedmioty p on pl.id_przedmiotu=p.id where pl.dzien_tygodnia = new.dzien_tygodnia and pl.nr_lekcji=new.nr_lekcji and p.aktywny))
	THEN RAISE EXCEPTION 'nauczyciel juz prowadzi inna lekcje w tym czasie';
	END IF;
	RETURN NEW;
END;
$teacherlesson$ LANGUAGE plpgsql;

CREATE TRIGGER teacherlesson BEFORE INSERT OR UPDATE ON plan_lekcji
FOR EACH ROW EXECUTE PROCEDURE teacherlesson();

create or replace function getsubjectclass(lid integer) returns integer 
	as $$ select id_klasy from przedmioty where id=lid $$
	language SQL;

create or replace function classlesson() returns trigger as $classlesson$
begin
	if(getsubjectclass(new.id_przedmiotu) in (select id_klasy from plan_lekcji pl join przedmioty p on pl.id_przedmiotu=p.id where pl.dzien_tygodnia = new.dzien_tygodnia and pl.nr_lekcji=new.nr_lekcji and p.aktywny))
	THEN RAISE EXCEPTION 'nauczyciel juz prowadzi inna lekcje w tym czasie';
	END IF;
	RETURN NEW;
END;
$classlesson$ LANGUAGE plpgsql;

CREATE TRIGGER classlesson BEFORE INSERT OR UPDATE ON plan_lekcji
FOR EACH ROW EXECUTE PROCEDURE classlesson();

--przykladowe dane:

INSERT INTO rodzaje_aktywnosci (nazwa, waga) VALUES
 ('sprawdzian', 5),
 ('kartkowka', 2),
 ('odpowiedz ustna', 3),
 ('aktywnosc lekcyjna', 1),
 ('zadanie domowe', 2),
 ('wypracowanie', 4);

INSERT INTO uzytkownicy(login,haslo) VALUES
 ('kamil','kamil'),
 ('qwerty','ytrewq'),
 ('6FWV6AXO4'	,'99GDQ5OMQA618'),
('FSC20G68OWARXF8AG6'	,'N5LDRDS0S3R'),
('Y7E4GCE3FFXU0WP'	,'Y1OOG7VL23U'),
('PI718UEW'	,'2AAV1W'),
('SQM6GYSOYR93U'	,'4BF9NIYRQKQ'),
('P9NIGEL2WJ'	,'3WMIJG5N74YM'),
('4S2TAT91TKHIQ','3T71RJE10Y'),
('LHKFHUQYSO9N'	,'7H5BNAN'),
('WGLBKS2AG'	,'KK72AOPRE76SU'),
('A3AG09KU5AU'	,'JDROULX'),
('A98J87UW1D88ONSG2Q','PX38CHSGGQFKUP9'),
('XRIUJQSAK'	,'3O8YHW5CH'),
('NTY1T3UKKBM4P8SHI','J2DQ6UV1QRUL2EJYA'),
('BR6Y17YC5JGKHUGK5'	,'H0EJP8Y5PX0HDIQ'),
('CQRDVJSV2VQ'	,'QDDEFSTQEH'),
('3IGQRA'	,'8W8BJ'),
('WOMAYODX9CDXN','YAMMBK6EF'),
('YBFKSLACD4P'	,'Q6ECB1WGJ271W94J'),
('VVGMCMGLDV'	,'H55KO1'),
('2TG4J00OB9JKWPCQ'	,'437R2CWEQJE8RPY0M'),
('UNMY7J'	,'HH6TOIPAUMD9MWR'),
('P8OF5'	,'B8FRJC2NGIL3'),
('KK4GH7SWDXC'	,'GNF952O'),
('J2GF1QM5BRMF4TJ','YF40O4'),
('PXCNCOTO8LO0P15K2','TC2350AVUK60GTF'),
('L7XKBEDFLWN'	,'AFRWNKBFY0NL'),
('5SBVRWM'	,'I9R61BTK5'),
('3MSD2M6RK2J1MQ','6W6DARCMJHJQC3Y'),
('U9EICGLOYW'	,'YOMDV48FH9T'),
('ER3XYX1L'	,'OO767'),
('UXUE3VYQVUN5J'	,'EG9XV2PXXV05'),
('VNNE6STBFT806XWEND'	,'CIH1NJPS6R'),
('BOCPOSTFXX6X0MY5MH'	,'FGL7NC6WTDYKWD'),
('8GNNQ26DTNDGEMY9'	,'G60LG'),
('ERTSXA0D'	,'V9MXY'),
('Y83YM8W'	,'YI33U3SEURUQTUVOI1'),
('AS0EXENCPPFUG','24ECGPQ'),
('OJAWWC7UNKMV'	,'WGHS9ECC'),
('UBHI612NM'	,'4YWFJSCISUBVXQ4'),
('7V3KIQLFVE3K4A','QW7LUF7SJDEMBQA'),
('DHSCCRQ0'	,'0DEV8UAEE7VXIR'),
('MQE7X'	,'VY2XI1SE8KRM22S'),
('4RBK3QQFW4QKG4','WU2S2'),
('S2SJ9EJ48'	,'8G6U9MK723'),
('YK125LX5NB'	,'9UVFT40YD87D9'),
('YV03F'	,'9RXMXJ'),
('IK3L0Q'	,'URLS6OS6ROTVLTCT'),
('HTSG6L7R19'	,'5HC3DTI20CCPVUA8G'),
('CYGL8CS'	,'3PNI267KG4KUEUS8N'),
('4U96N3N1R0WDWO','8VCP02DYPU0BTM');



INSERT INTO nauczyciele (imie,id_uzytkownika, nazwisko) VALUES
 ('Llrbbmqb'	,'qwerty'	,	 'Mdarzow')	,
 ('Liddq'	,'FSC20G68OWARXF8AG6'	,	 'Mdxrjmow')	,
 ('Gjybld'	,'Y7E4GCE3FFXU0WP'	,	 'Jfsarcbynec')	,
 ('Vxxpklo'	,'PI718UEW'	,	 'Vllnmpapqfw')	,
 ('Mkmcoqh'	,'SQM6GYSOYR93U'	,	 'Enkuewhsqmg')	,
 ('Jcljjiv'	,'P9NIGEL2WJ'	,	 'Cmdkqt')	,
 ('Tmvtr'	,'4S2TAT91TKHIQ'	,	 'Vljptnsnf')	,
 ('Ijmafad'	,'LHKFHUQYSO9N'	,	 'Twsofsbcn')	,
 ('Bffbsaq'	,'WGLBKS2AG'	,	 'Apqcace')	,
 ('Qvfrkmln'	,'A3AG09KU5AU'	,	 'Ajkpqpxrjx')	,
 ('Lyxacbhh'	,'A98J87UW1D88ONSG2Q'	,	 'Gcqcoend')	,
 ('Sgdwd'	,'XRIUJQSAK'	,	 'Acgpxiqvku')	,
 ('Fcgdewht'	,'NTY1T3UKKBM4P8SHI'	,	 'Siohordtqk')	,
 ('Tgspq'	,'BR6Y17YC5JGKHUGK5'	,	 'Hmsboaguwn')	,
 ('Vnzlg'	,'CQRDVJSV2VQ'	,	 'Twpbtrw')	,
 ('Sadeug'	,'3IGQRA'	,	 'Pmoqcd')	,
 ('Stokyxho'	,'WOMAYODX9CDXN'	,	 'Rhwdvmxx')	,
 ('Exlmnd'	,'YBFKSLACD4P'	,	 'Cukwag')	,
 ('Guukw'	,'VVGMCMGLDV'	,	 'Abxubume')	,
 ('Yatdrmy'	,'2TG4J00OB9JKWPCQ'	,	 'Tajxlog');	


INSERT INTO klasy (oddzial,rok_rozpoczecia, id_wychowawcy) VALUES
 ('A', 2006, 1),
 ('B', 2006, 2),
 ('A', 2005, 4),
 ('B', 2005, 5),
 ('A', 2004, 11),
 ('C', 2006, 7),
 ('D', 2006, 8),
 ('C', 2005, 9),
 ('D', 2005, 10),
 ('E', 2005, 12),
 ('C', 2004, 3),
 ('B', 2004, 6);

INSERT INTO przedmioty (nazwa, id_prowadzacego, id_klasy,aktywny) VALUES
 ('Matematyka1', 1, 1,TRUE),
 ('Matematyka1', 1, 2, TRUE),
 ('Matematyka3', 1, 3, TRUE),
 ('Matematyka2', 1, 4, TRUE),
 ('Matematyka2', 1, 5, TRUE),
 ('Matematyka3', 1, 6, TRUE),
 ('Jezyk polski1', 2, 1, TRUE),
 ('Jezyk polski1', 2, 2, TRUE),
 ('Jezyk polski3', 2, 3, TRUE),
 ('Jezyk polski2', 2, 4, TRUE),
 ('Jezyk polski2', 2, 5, TRUE),
 ('Jezyk polski3', 2, 6, TRUE),
 ('WF1', 3, 1, TRUE),
 ('WF1', 3, 2, TRUE),
 ('WF3', 3, 3, TRUE),
 ('WF2', 3, 4, TRUE),
 ('Chemia1', 5, 1, TRUE),
 ('Chemia3', 5, 3, TRUE),
 ('Chemia2', 4, 5, TRUE),
 ('Biologia1', 5, 1, TRUE),
 ('Biologia3', 5, 3, TRUE),
 ('Biologia2', 4, 5, TRUE),
 ('Informatyka1', 6, 2, TRUE),
 ('Informatyka2', 6, 4, TRUE),
 ('Informatyka3', 6, 6, TRUE),
 ('Fizyka1', 6, 2, TRUE),
 ('Fizyka2', 6, 4, TRUE),
 ('Fizyka3', 6, 6, TRUE),
 ('Jezykangielski1', 7, 1, TRUE),
 ('Jezykangielski1', 7, 2, TRUE),
 ('Jezykangielski3', 8, 3, TRUE),
 ('Jezykangielski2', 8, 4, TRUE),
 ('Jezykangielski2', 9, 5, TRUE),
 ('Jezykangielski3', 9, 6, TRUE),
 ('Religia1', 10, 1, TRUE),
 ('Religia1', 10, 2, TRUE),
 ('Religia3', 10, 3, TRUE),
 ('Religia2', 11, 4, TRUE),
 ('Religia2', 11, 5, TRUE),
 ('Religia3', 11, 6, TRUE),
 ('Religia1', 11, 4, FALSE),
 ('Religia1', 11, 5, FALSE),
 ('Matematyka2', 1, 6, FALSE),
 ('Matematyka1', 1, 4, FALSE),
 ('Matematyka1', 1, 6, FALSE);

INSERT INTO uczniowie (imie, nazwisko, telefon_do_rodzica, pesel, id_klasy,aktywny) VALUES
 ('Llrbbmqb', 'Mdarzow', 140383426, 96091227824, 5, TRUE),
 ('Liddq', 'Mdxrjmow', 169133069, 95080364878, 4, TRUE),
 ('Gjybld', 'Jfsarcbynec', 149241873, 96080786581, 3, TRUE),
 ('Vxxpklo', 'Vllnmpapqfw', 185990364, 95010881893, 4, TRUE),
 ('Mkmcoqh', 'Enkuewhsqmg', 156297539, 96061849746, 4, TRUE),
 ('Jcljjiv', 'Cmdkqt', 194953865, 95112464312, 6, TRUE),
 ('Tmvtr', 'Vljptnsnf', 127254586, 96121214718, 6, TRUE),
 ('Ijmafad', 'Twsofsbcn', 117142618, 95121345237, 2, TRUE),
 ('Bffbsaq', 'Apqcace', 108936987, 96112772823, 3, TRUE),
 ('Qvfrkmln', 'Ajkpqpxrjx', 176065818, 95041617599, 3, TRUE),
 ('Lyxacbhh', 'Gcqcoend', 104569917, 95012352911, 1, TRUE),
 ('Sgdwd', 'Acgpxiqvku', 120388464, 95072542383, 2, TRUE),
 ('Fcgdewht', 'Siohordtqk', 146811305, 95033043384, 1, TRUE),
 ('Tgspq', 'Hmsboaguwn', 131419379, 96102639141, 5, TRUE),
 ('Vnzlg', 'Twpbtrw', 160152959, 95102874947, 4, TRUE),
 ('Sadeug', 'Pmoqcd', 149517445, 95072878983, 1, TRUE),
 ('Stokyxho', 'Rhwdvmxx', 196864819, 95101912891, 2, TRUE),
 ('Exlmnd', 'Cukwag', 131602422, 95010444377, 6, TRUE),
 ('Guukw', 'Abxubume', 146340713, 96031111259, 3, TRUE),
 ('Yatdrmy', 'Tajxlog', 146247255, 96101136953, 5, TRUE),
 ('Emzhlvi', 'Louvsuy', 114723506, 95041512269, 3, TRUE),
 ('Ryulye', 'Xuoteh', 129033333, 95032259784, 2, TRUE),
 ('Pcfsk', 'Agkbbipzz', 178012497, 96030623564, 6, TRUE),
 ('Lxaml', 'Hfykgruo', 196060028, 96082215155, 2, TRUE),
 ('Xooobpp', 'Cqlwphapjna', 128104339, 96021036696, 3, TRUE),
 ('Ccnvwdtx', 'Cmyppph', 161717988, 96051382936, 1, TRUE),
 ('Sspusgdh', 'Hxqmbfjx', 175526309, 96092833275, 1, TRUE),
 ('Vdjsuy', 'Hyebmwsiqy', 130634994, 95051864411, 5, TRUE),
 ('Dxymz', 'Bypzvjegeb', 105193512, 95100458567, 3, TRUE),
 ('Eufts', 'Qixtigsieeh', 151300606, 96031317839, 5, TRUE),
 ('Mdflil', 'Xqfnxztqr', 147149314, 95012953891, 4, TRUE),
 ('Apkyhs', 'Ibppkq', 169110699, 95052642234, 2, TRUE),
 ('Tbuotbbq', 'Pivrfx', 172796157, 95060591234, 5, TRUE),
 ('Wddntgei', 'Adgaijvw', 173785404, 95072417689, 3, TRUE),
 ('Sbwew', 'Cvygehljx', 135889744, 95111757574, 4, TRUE),
 ('Ciwuqzdz', 'Ldubzvaf', 159343768, 96070275499, 4, TRUE),
 ('Fqwuzif', 'Bvyddwyv', 146478179, 96022821662, 6, TRUE),
 ('Aczmgyj', 'Kdxvtnun', 130449291, 95110386759, 3, TRUE),
 ('Rsplwui', 'Vfxlzb', 155722604, 95012088724, 2, TRUE),
 ('Awppan', 'Ycfirjcddso', 190127955, 95020374257, 1, TRUE),
 ('Legurfw', 'Wfmoxeqm', 110901063, 95061034769, 6, TRUE),
 ('Frghwlk', 'Kmeahk', 164945486, 95112693987, 3, TRUE),
 ('Jaehhsv', 'Wmqpxhlr', 103591171, 95040663263, 3, TRUE),
 ('Sfdzrh', 'Dsjeuygaf', 117076376, 95100358126, 1, TRUE),
 ('Ctpnimuw', 'Oqsjxvk', 111671338, 95012973118, 6, TRUE),
 ('Rxxvrwc', 'Asneogv', 170973813, 96082581696, 4, TRUE),
 ('Glpgdir', 'Pcriqifpg', 108399134, 95072279579, 4, TRUE),
 ('Prefxsn', 'Bcftpwctg', 130313563, 95091673574, 5, TRUE),
 ('Lnupycf', 'Buqunu', 151538839, 96120624512, 6, TRUE),
 ('Liitnck', 'Kfszbexra', 167107722, 95040785541, 4, TRUE),
 ('Hvhqndd', 'Kqvuygpnk', 138498976, 95012325779, 2, TRUE),
 ('Grpjv', 'Cxdpcwmjob', 160975266, 95042836962, 5, TRUE),
 ('Dkfojne', 'Ugxnno', 195466127, 95081373343, 1, TRUE),
 ('Swjwnn', 'Hwjckdmeouu', 102550399, 95021079236, 4, TRUE),
 ('Xhgvwuj', 'Wxxpitc', 134576987, 96111026657, 3, TRUE),
 ('Qaiddvh', 'Idsycqhklee', 158136104, 96011677676, 4, TRUE),
 ('Qembaqwq', 'Yqhsue', 134660183, 95010473528, 4, TRUE),
 ('Kgvjwd', 'Gjafqzzxlcx', 150099355, 96120359669, 6, TRUE),
 ('Sqgjla', 'Ipkvxfgvi', 125084100, 96072599191, 3, TRUE),
 ('Omkbljop', 'Bqvvhbgs', 130365981, 95070387425, 4, TRUE),
 ('Lhesnkq', 'Cwrqidr', 116945487, 96053033335, 5, TRUE),
 ('Hubbry', 'Qheyen', 155843485, 95032677397, 1, TRUE),
 ('Fbdeyq', 'Tgluaiihve', 121303708, 96032298331, 2, TRUE),
 ('Hjrqopu', 'Qguxhxdipfz', 155843024, 95062139456, 1, TRUE),
 ('Lbgfylq', 'Nzharvrlyau', 172312086, 96071567719, 2, TRUE),
 ('Pcnjkp', 'Wlffrkeecbp', 193552063, 96051296837, 5, TRUE),
 ('Mfhidj', 'Tjhrnxcx', 167974802, 96022448858, 2, TRUE),
 ('Oohqanx', 'Dmgzebhnlmw', 129834447, 96052212678, 1, TRUE),
 ('Hdvths', 'Bueeexg', 104665417, 95112182278, 3, TRUE),
 ('Ugskmv', 'Igfwvrftwap', 151201745, 96032315157, 6, TRUE),
 ('Vpbztyg', 'Prxajjngcom', 199885196, 95041756795, 3, TRUE),
 ('Nsdwss', 'Qovdruy', 144169939, 96121463686, 5, TRUE),
 ('Gulkfu', 'Nxnafamespc', 131190952, 95103033497, 4, TRUE),
 ('Vzxdr', 'Agyrqsc', 147407330, 96030586551, 2, TRUE),
 ('Nnvqqcq', 'Eitlvcnv', 191714937, 96040861934, 3, TRUE),
 ('Pidzg', 'Jaatzzwp', 173002606, 96031417539, 5, TRUE),
 ('Bfjkncvk', 'Ahhzjchp', 144804919, 96081494917, 2, TRUE),
 ('Dnmppn', 'Sjznkew', 106851320, 95070789869, 3, TRUE),
 ('Lgefone', 'Emmsbao', 159382853, 96050475262, 1, TRUE),
 ('Xzqmkq', 'Cuvtqvnxb', 153048498, 95080123574, 6, TRUE),
 ('Lkglzam', 'Ndnsjolvy', 173595097, 96091982499, 5, TRUE),
 ('Yttqog', 'Abaiakqllsz', 131596366, 95102776522, 2, TRUE),
 ('Iconnmoq', 'Epeefsnsmo', 163043320, 96101155712, 5, TRUE),
 ('Podsgcf', 'Desyshmgxw', 196095815, 96062216499, 3, TRUE),
 ('Yuvno', 'Sjftqtwkbap', 113823293, 95110414531, 1, TRUE),
 ('Kimqw', 'Nslgvlcsaq', 151008693, 95111862951, 2, TRUE),
 ('Fwtbseet', 'Ndnfnbyjvpd', 124048977, 96091338313, 2, TRUE),
 ('Ozqxsta', 'Xzpctth', 130546620, 96082527113, 3, TRUE),
 ('Vemgfkrb', 'Rkzvgbof', 137180529, 96042777613, 2, TRUE),
 ('Rjhdnay', 'Snbitora', 192277052, 96120729644, 3, TRUE),
 ('Ednezw', 'Fdawlohssvt', 127793660, 96090943383, 2, TRUE),
 ('Rvsyl', 'Dlucqxswy', 101422376, 96091623736, 2, TRUE),
 ('Ddmfrt', 'Eqsekejhz', 160144854, 95101222222, 3, TRUE),
 ('Jfepxch', 'Izysvdgcx', 129363923, 96033086362, 6, TRUE),
 ('Uwmea', 'Hzifktmo', 173521090, 95042777524, 5, TRUE),
 ('Ofxtgpo', 'Nqiysrs', 195266356, 95062218296, 2, TRUE),
 ('Sdjqnqc', 'Fqrnll', 124722490, 95020965295, 5, TRUE),
 ('Nzvmw', 'Hufnnxv', 163880569, 95112635929, 1, TRUE),
 ('Ogmli', 'Randly', 133480550, 96111836496, 2, TRUE),
 ('Nuaosn', 'Ivacsvpiumo', 115387142, 95012064472, 5, TRUE),
 ('Wqxswkq', 'Cxyazntnai', 104438548, 97021375213, 1, TRUE),
 ('Fybnuqb', 'Xaggxach', 189537797, 97060473428, 5, TRUE),
 ('Txqqmlfo', 'Rqhvokiia', 137140292, 97111931983, 3, TRUE),
 ('Ovxjvbs', 'Pifzyxnjcb', 149757806, 97092746929, 4, TRUE),
 ('Lmixxs', 'Thovengb', 159067697, 97072626399, 3, TRUE),
 ('Oixqg', 'Rrygxrxkfh', 118150212, 97102726569, 3, TRUE),
 ('Pnhwilk', 'Fbpeszdi', 152327934, 97042933434, 6, TRUE),
 ('Nxtzqsjw', 'Lycbmjawwm', 177511625, 97112413112, 3, TRUE),
 ('Cpfdup', 'Kcltxmkpv', 172190528, 97032668825, 2, TRUE),
 ('Btuseu', 'Lgeltkc', 144834684, 97122159752, 4, TRUE),
 ('Kbqromq', 'Dixezqkv', 159112711, 97030435623, 2, TRUE),
 ('Hwcocp', 'Krmbpbegvsu', 185859963, 97010853852, 5, TRUE),
 ('Cuuvkes', 'Htdhvtjmexf', 140106892, 97101943857, 4, TRUE),
 ('Mfdpaxcw', 'Gqjtbplyz', 109907854, 97082912721, 2, TRUE),
 ('Iwsod', 'Otqrpyu', 117244564, 97122378881, 3, TRUE),
 ('Swgfnpaq', 'Oofrsotq', 136864840, 97071174923, 3, TRUE),
 ('Xipqzeqv', 'Emuoubb', 139199093, 97031268712, 2, TRUE),
 ('Bmixfc', 'Wstnosvdkuj', 189409560, 97092994162, 4, TRUE),
 ('Odqhx', 'Riueziowo', 186713846, 97090982121, 2, TRUE),
 ('Tecwxxbj', 'Fmkjgncpmva', 198911786, 97013184775, 5, TRUE),
 ('Uausokb', 'Tgjtfiu', 119480878, 97070311699, 2, TRUE),
 ('Ilvlazam', 'Iimicn', 110058106, 97022656485, 1, TRUE),
 ('Exjlfuem', 'Adgkhuf', 117869388, 97012561225, 1, TRUE),
 ('Bjaxrni', 'Horhfrqqwnu', 176967137, 97072697124, 5, TRUE),
 ('Kyevslq', 'Olyskrh', 110411310, 97041137242, 2, TRUE),
 ('Igsoxl', 'Ayyfqu', 129841549, 97111496752, 1, TRUE),
 ('Rhmgye', 'Iyepfaesj', 123524763, 97091122416, 3, TRUE),
 ('Svdevdll', 'Mazxjndjrx', 171935247, 97081581991, 4, TRUE),
 ('Fyddqnqd', 'Jyshwxsh', 190503441, 97030243385, 4, TRUE),
 ('Kwumbffa', 'Mdnxjqoyir', 120071006, 97101891884, 5, TRUE),
 ('Nrnekxdl', 'Gjfqkkvnxu', 111111544, 97070154256, 5, TRUE),
 ('Lcixm', 'Xwsqoiwyf', 121608488, 97040933986, 2, TRUE),
 ('Vuuugfrt', 'Mmqinu', 173177440, 97082994253, 6, TRUE),
 ('Vxelpst', 'Haodqs', 166747319, 97070924789, 3, TRUE),
 ('Brfbxtn', 'Tbltqtmpy', 100313522, 97032161922, 3, TRUE),
 ('Nujuiok', 'Twswqy', 137046647, 97011543994, 2, TRUE),
 ('Tdxqqsgk', 'Jihbaawju', 116391568, 97032223172, 1, TRUE),
 ('Toddk', 'Ljizyny', 130121288, 97102049248, 5, TRUE),
 ('Qozryit', 'Prifximkyr', 191321676, 97021896499, 1, TRUE),
 ('Ovusuiq', 'Wjfcky', 133469976, 97091882765, 6, TRUE),
 ('Cekijksv', 'Dokcye', 188510062, 97111439528, 6, TRUE),
 ('Efpct', 'Kxkixdbx', 186015033, 97100924655, 5, TRUE),
 ('Iwcqq', 'Mbbfhbadv', 153744777, 97030656297, 1, TRUE),
 ('Lujxfrw', 'Ruuhep', 106740259, 97062158981, 5, TRUE),
 ('Hfkyhs', 'Quleafg', 179575260, 97011699473, 1, TRUE),
 ('Ghjwtesp', 'Seqfmnm', 131557302, 97090113262, 5, TRUE),
 ('Ereleink', 'Omfpvomq', 126782912, 97120841653, 5, TRUE),
 ('Hdmxk', 'Cwxzqnswax', 120084148, 97012394483, 2, TRUE),
 ('Edxbuu', 'Ekmnqwqdva', 197510827, 97071518583, 5, TRUE),
 ('Fhoqakq', 'Rgkmlhq', 183989693, 97011178549, 6, TRUE),
 ('Xnwzgsp', 'Crownpgeh', 194124046, 97042079545, 1, TRUE),
 ('Thfrvq', 'Kwdtkssl', 187638368, 97022857398, 1, TRUE),
 ('Catax', 'Idmyldxukd', 192469147, 97081296332, 4, TRUE),
 ('Hrrumb', 'Cmlrowrhwo', 145552368, 97093033916, 6, TRUE),
 ('Klghlc', 'Lrzhgsb', 112268428, 97011997427, 1, TRUE),
 ('Jlpccdy', 'Kxmdmfhao', 159726503, 97042296757, 4, TRUE),
 ('Rzkhi', 'Gjtimitdkx', 113877140, 97011867865, 3, TRUE),
 ('Cjecw', 'Xwabhsliev', 155191614, 97090263967, 2, TRUE),
 ('Nqeqazt', 'Jdwrbgxd', 181672606, 97111949311, 2, TRUE),
 ('Alshge', 'Rzhhvlxcbxd', 146810336, 97031895475, 6, TRUE),
 ('Bgtdoqi', 'Wyspqzvuqi', 124897797, 97041287619, 6, TRUE),
 ('Qlpvooyn', 'Kpgvswoa', 116903580, 97021067648, 1, TRUE),
 ('Nhrff', 'Tnjyeeltzai', 157242587, 97030692882, 2, TRUE),
 ('Acozw', 'Ewyhzgpq', 179629507, 97061998331, 3, TRUE),
 ('Djqipuuj', 'Wtxlbznry', 159970879, 97060354877, 6, TRUE),
 ('Cbvghmy', 'Fggtyqjtmu', 112526508, 97122573811, 5, TRUE),
 ('Ptqmih', 'Dkddnal', 198119944, 97112593137, 6, TRUE),
 ('Uxsat', 'Weldacnn', 173207249, 97012136117, 2, TRUE),
 ('Yrmrny', 'Unwbjjpdjh', 107964193, 97060847896, 3, TRUE),
 ('Rknyk', 'Ixhxclqqe', 176270887, 97121867449, 5, TRUE),
 ('Jdwzo', 'Nrrwwxyr', 179339467, 97032448474, 6, TRUE),
 ('Pdgqk', 'Uvtmzzc', 113908251, 97120861123, 1, TRUE),
 ('Wtvfio', 'Lkvederv', 171690579, 97111067138, 1, TRUE),
 ('Meghbc', 'Ebxdxezrzgb', 162361873, 97120677135, 4, TRUE),
 ('Oanffecc', 'Iqfmzjqtlrs', 177415389, 97012372638, 2, TRUE),
 ('Viywjobs', 'Efujlxn', 181195176, 97101789332, 2, TRUE),
 ('Frddiy', 'Gqfspv', 126257224, 97102464322, 1, TRUE),
 ('Wcvdr', 'Smkwlyiqdch', 132719348, 97081186622, 6, TRUE),
 ('Qytzdn', 'Dqcvdeqj', 191639518, 97030716179, 3, TRUE),
 ('Lepxca', 'Vewqmoxkj', 102497640, 97081217537, 2, TRUE),
 ('Sqorl', 'Iedvywhcog', 147795651, 97102444975, 3, TRUE),
 ('Wusfgies', 'Akrpaig', 151164576, 97031115533, 1, TRUE),
 ('Dfbubiyr', 'Pfmwaeeim', 129190168, 97030964572, 2, TRUE),
 ('Vnzcphkf', 'Bbqsvtdwl', 152262092, 97101986371, 2, TRUE),
 ('Vaungfz', 'Khbxif', 191644042, 97052715994, 2, TRUE),
 ('Mcjzsdxn', 'Qacwtj', 139193736, 97040815824, 2, TRUE),
 ('Cuxvegy', 'Tgsfxqhipbo', 132646386, 97091216124, 4, TRUE),
 ('Cpxckic', 'Fhufcz', 101004340, 97052321278, 1, TRUE),
 ('Lgwigmr', 'Oteqkbwbaa', 111608254, 97081779471, 1, TRUE),
 ('Wqlivnj', 'Komwkuc', 173365509, 97101193726, 6, TRUE),
 ('Agztqa', 'Yargkwu', 168455932, 97062582852, 4, TRUE),
 ('Hvohl', 'Wjqpop', 180476021, 97010643725, 2, TRUE),
 ('Dkoel', 'Cnzeavaacea', 138823523, 97042215547, 3, TRUE),
 ('Nydyp', 'Hgyxblh', 187337023, 97042772295, 4, TRUE),
 ('Dnkttkq', 'Hvanuuvjv', 158787454, 97012857793, 6, TRUE),
 ('Lvuvs', 'Azkywhmgc', 192095745, 97010397938, 5, TRUE),
 ('Ecqdpmzm', 'Fneikzf', 121734132, 97011235794, 4, TRUE),
 ('Htnlpwz', 'Bhnvkplpf', 151205738, 97052399499, 3, FALSE),
 ('Rngexr', 'Szzdmuszl', 105624150, 97030481129, 2, FALSE),
 ('Bkvkw', 'Flrxbl', 185622011, 97041054897, 1,FALSE);



 INSERT INTO plan_lekcji(id_przedmiotu, nr_lekcji, dzien_tygodnia) VALUES
 
 --klasaKamila(id5)
 (33,0,2),
 (33,1,2),
 (22,2,2),
 (19,3,2),
 (11,4,2),
 (39,4,3),
 (5,5,3),
 (5,6,3),
 (11,7,3),
 (42,8,3),
 (39,8,3),
 (33,4,4),
 (5,5,4),
 (5,6,4),
 (11,7,4),
 (39,8,4),
 (11,2,5),
 (5,3,5),
 (5,4,5),
 (33,5,5),
 (22,0,6),
 (39,1,6),
 (5,2,6),
 (5,3,6),

--inne
  (1,0,2),
 (2,1,2),
 (3,2,2),
 (4,3,2),
 (6,4,2),
 (7,1,2),
 (8,2,2),
 (9,3,2),
 (10,7,2),
 (12,5,2),
 (13,0,3),
 (13,1,3),
 (14,2,3),
 (14,3,3),
 (15,4,3),
 (15,5,3),
 (16,6,3),
 (16,7,3),
 (23,0,4),
 (26,1,4),
 (24,2,4),
 (27,3,4),
 (25,4,4),
 (28,5,4),
 (23,0,5),
 (26,1,5),
 (24,2,5),
 (27,3,5),
 (25,4,5),
 (28,5,5),
 (7,0,6),
 (8,1,6),
 (9,2,6),
 (10,3,6),
 (12,4,6),
 (12,5,6),
 (34,0,6),
 (29,1,6),
 (30,2,6),
 (31,3,6),
 (32,4,6),
 (32,5,6);




 INSERT INTO przeprowadzone_lekcje(data, temat_zajec, id_prowadzacego, id_lekcji) VALUES
 ('2014-12-15'::date, 'xfgu hjutyfdwqdfv', 1, 1),
 ('2014-12-15'::date, 'fdsfqeytry dfv', 2, 2),
 ('2014-12-15'::date, 'fdsfqfdw qdfv', 3, 3),
 ('2014-12-15'::date, 'ddg jktrtwehtjblr fqfdwqdfv', 4, 4),
 ('2014-12-15'::date, 'fdsfq hgfh fdwqdfv', 5, 5),
 ('2014-12-15'::date, 'fdsfqfdwqdfv', 6, 25),
 ('2014-12-15'::date, 'pdsf nhgfju qeytry dfv', 7, 26),
 ('2014-12-15'::date, 'kdsfqfdw qdfv', 8, 27),
 ('2014-12-15'::date, 'fdg jklr fqfdwqdfv', 9, 28),
 ('2014-12-15'::date, 'fkdsfq hgfh fdwqdfv', 10, 29),
 ('2014-12-15'::date, 'kfdsffdw qdfv', 11, 30),
 ('2014-12-15'::date, 'fpdqytry dpiopfv', 12, 31),
 ('2014-12-15'::date, 'kfspiofdw qdfv', 13, 32),
 ('2014-12-15'::date, 'mfdg jklr fqfdwqdfv', 14, 33),
 ('2014-12-15'::date, 'gfdsfq hgfh fdwqdfv', 15, 34),
 ('2014-12-16'::date, 'lsfqfqwe dw qdfv', 16, 6),
 ('2014-12-16'::date, 'pfbvdg jklr fqfdwqdfv', 17, 7),
 ('2014-12-16'::date, 'qfdsfq hgfh fdwqkhjkdfv', 18, 8),
 ('2014-12-16'::date, 'lsfqfqwe dw qdfv', 19, 9),
 ('2014-12-16'::date, 'pfbvdg jklr fqfdwqdfv', 20, 10),
 ('2014-12-17'::date, 'xfgu hjutyfdwqdfv', 1, 13),
 ('2014-12-17'::date, 'xfgu hjutyfdwqdfv', 1, 14);


INSERT INTO uwagi (id_ucznia, id_nauczyciela, opis, czy_pozytywna, data_wystawienia) VALUES
 (97041054897, 16, 'tis in lacus eu dictum. Nullam ut imperdiet e', FALSE, '2014-04-10'::date),
 (97041054897, 11, 'dolor sit amet, consectetur adipiscing elit. Praesent venenatis in lacus eu dic', FALSE, '2014-04-10'::date),
 (97041054897, 10, ' ipsum dolor sit amet, consectetur adipiscing elit. Praesent venenatis in lacus eu dictum', FALSE, '2014-04-10'::date),
 (95112464312, 8, 'cus eu dictum. Nullam ut imperdiet est, in mollis orci.', TRUE, '2014-04-10'::date),
 (95112464312, 16, 'rci.', TRUE, '2014-04-10'::date),
 (95112464312, 7, 'ut imperdiet est, in mollis orci.', FALSE, '2014-04-10'::date),
 (96121214718, 5, ' consectetur adipiscing elit. Praesent venenatis in lacus eu dictum. Nullam ut imperdiet', FALSE, '2014-04-10'::date),
 (96121214718, 15, 'imperdiet est, in mollis orci.', TRUE, '2014-04-10'::date),
 (96121214718, 15, 'tur adipiscing elit. Praesent venenatis in lacus ', TRUE, '2014-04-10'::date),
 (96121214718, 10, 'onsectetur adipiscing elit. Praesent venenati', TRUE, '2014-04-10'::date),
 (95101912891, 8, 'tum. Nullam ut imperdiet est, in mollis orci.', TRUE, '2014-04-10'::date),
 (95101912891, 15, ' elit. Praesent venenatis in lacus eu dictum. Nullam ut imperdiet est, in mollis orci.', FALSE, '2014-04-10'::date),
 (95101912891, 10, 'lor sit amet, consectetur adipiscing elit. Praesent venen', TRUE, '2014-04-10'::date),
 (95101912891, 6, ' adipiscing elit. Praesent venenatis in lac', FALSE, '2014-04-10'::date),
 (95101912891, 14, 'tis in lacus eu dictum. Nullam ut imperdiet est, in mollis orci.', TRUE, '2014-04-10'::date),
 (96031317839, 6, 't imperdiet est, in mollis orci.', TRUE, '2014-04-10'::date),
 (96031317839, 14, 'Nullam ut imperdiet est, in mollis orci.', TRUE, '2014-04-10'::date),
 (96031317839, 15, 'm ut imperdiet est, in mollis orci.', FALSE, '2014-04-10'::date),
 (96031317839, 19, 'atis in lacus eu dictum. Nullam ut imperdiet est, in mollis orci.', FALSE, '2014-04-10'::date),
 (96031317839, 12, 'tur adipiscing elit. Praesent venenatis in lacus eu dictum. Nullam ut imperdiet est, in mollis orci.', FALSE, '2014-04-10'::date),
 (96022821662, 5, 's in lacus eu dictum. Nullam ut imperdiet est, in mollis orci.', FALSE, '2014-04-10'::date),
 (96022821662, 4, 'um. Nullam ut imperdiet est, in mollis orci.', TRUE, '2014-04-10'::date),
 (96022821662, 3, 'r sit amet, consectetur adipiscing elit. Praesent venenatis in lacus eu dictum. Nullam ut imperdiet est, in mo', TRUE, '2014-04-10'::date),
 (96022821662, 14, 'lor sit amet, consectetur adipiscing elit. Praesent venenatis in lacus eu ', FALSE, '2014-04-10'::date),
 (96022821662, 12, 'cus eu dictum. Nullam ut imperdiet est, in moll', FALSE, '2014-04-10'::date),
 (96120624512, 11, ' venenatis in lacus eu dictum. Nullam u', FALSE, '2014-04-10'::date),
 (96120624512, 3, 'n mollis orci.', TRUE, '2014-04-10'::date),
 (96120624512, 5, 's eu dictum. Nullam ut imperdiet est, in mollis o', TRUE, '2014-04-10'::date),
 (96120624512, 12, 'rem ipsum dolor sit amet, consectetur adipiscing elit. Prae', FALSE, '2014-04-10'::date),
 (96120624512, 18, 'nt venenatis in lacus eu dictum. Nulla', FALSE, '2014-04-10'::date),
 (96120624512, 6, 'Nullam ut imperdiet est, in mollis orci.', TRUE, '2014-04-10'::date),
 (96120624512, 9, 'ipsum dolor sit amet, consectetur adipiscing elit. ', FALSE, '2014-04-10'::date),
 (96032298331, 16, 'ictum. Nullam ut imperdiet est, in mollis orci.', FALSE, '2014-04-10'::date),
 (96032298331, 15, ' orci.', TRUE, '2014-04-10'::date),
 (96120729644, 10, 'n mollis orci.', FALSE, '2014-04-10'::date),
 (96120729644, 19, 'eu dictum. Nullam ut imperdiet est, in mollis orci.', TRUE, '2014-04-10'::date),
 (97111931983, 3, 'mperdiet est, in mollis orci.', FALSE, '2014-04-10'::date),
 (95101222222, 9, 'imperdiet est, in mollis orci.', FALSE, '2014-04-10'::date),
 (95101222222, 14, ' in lacus eu dictum. Nullam ut imperdiet est, in mollis orci.', TRUE, '2014-04-10'::date),
 (95101222222, 9, 'Nullam ut imperdiet est, in mollis orci.', FALSE, '2014-04-10'::date),
 (95101222222, 5, 'ci.', FALSE, '2014-04-10'::date),
 (95101222222, 5, ' est, in mollis orci.', TRUE, '2014-04-10'::date),
 (95101222222, 8, 't est, in mollis orci.', FALSE, '2014-04-10'::date),
 (95101222222, 19, 'm. Nullam ut imperdiet est, in mollis orci.', FALSE, '2014-04-10'::date),
 (95101222222, 19, 'lis orci.', TRUE, '2014-04-10'::date),
 (97070924789, 4, 'onsectetur adipiscing elit. Praesent venenatis in lacus eu dictum. Nullam ut imperdi', TRUE, '2014-04-10'::date),
 (97070924789, 5, ' dictum. Nullam ut imperdiet est, in mollis orci.', FALSE, '2014-04-10'::date),
 (97070924789, 10, 'g elit. Praesent venenatis in lacus eu dictum. Nullam ut imperdiet est, in mol', FALSE, '2014-04-10'::date),
 (97070924789, 4, 'lor sit amet, consectetur adipiscing elit. Praesent venenatis in lacus eu', TRUE, '2014-04-10'::date),
 (97070924789, 8, 'amet, consectetur adipiscing elit. Praese', TRUE, '2014-04-10'::date),
 (97070924789, 10, 'in lacus eu dictum. Nullam ut imperdiet est, in mollis orci.', TRUE, '2014-04-10'::date),
 (97070924789, 17, ', consectetur adipiscing elit. Praesent venenatis in lacus eu dictum. Null', TRUE, '2014-04-10'::date),
 (97070924789, 5, 'met, consectetur adipiscing elit. Praesent ven', TRUE, '2014-04-10'::date),
 (97081779471, 10, 'ipiscing elit. Praesent venenatis in lacus eu dictum. Nullam ut imperdiet est, in mollis orc', TRUE, '2014-04-10'::date),
 (97081779471, 4, ' sit amet, consectetur adipiscing elit. Praesent venenatis in lacus eu dictum. Nullam ut imperdiet est, in mollis orci.', FALSE, '2014-04-10'::date),
 (97081779471, 14, 'est, in mollis orci.', FALSE, '2014-04-10'::date),
 (97081779471, 1, 'dictum. Nullam ut imperdiet est, in mollis orci.', TRUE, '2014-04-10'::date),
 (97081779471, 18, 'm ut imperdiet est, in mollis orci.', TRUE, '2014-04-10'::date),
 (97081779471, 5, 'is in lacus eu dictum. Nullam ut imperdiet est, in mollis orci.', TRUE, '2014-04-10'::date),
 (97081779471, 2, 'm ut imperdiet est, in mollis orci.', TRUE, '2014-04-10'::date),
 (97010397938, 9, 'llis orci.', TRUE, '2014-04-10'::date),
 (97010397938, 1, 'elit. Praesent venenatis in lacus eu dictum. Nullam ut imperdiet est, in mollis orci.', TRUE, '2014-04-10'::date),
 (97010397938, 7, 'raesent venenatis in lacus eu dictum. Nullam ut imperdiet est, in mollis orci.', FALSE, '2014-04-10'::date),
 (97010397938, 18, 'acus eu dictum. Nullam ut imperdiet est, in mollis orci.', FALSE, '2014-04-10'::date),
 (97010397938, 12, 't, in mollis orci.', FALSE, '2014-04-10'::date),
 (97010397938, 4, '. Nullam ut imperdiet est, in mollis orci.', TRUE, '2014-04-10'::date),
 (97011235794, 13, 'rdiet est, in mollis orci.', FALSE, '2014-04-10'::date),
 (97011235794, 14, 'ollis orci.', TRUE, '2014-04-10'::date),
 (97011235794, 17, 'enenatis in lacus eu dictum. Nullam ut imperdiet est, in mollis orci.', TRUE, '2014-04-10'::date),
 (97011235794, 4, 's in lacus eu dictum. Nullam ut imperdiet est, in mollis orci.', TRUE, '2014-04-10'::date);


 INSERT INTO oceny_uczniow (wartosc, id_ucznia, id_przedmiotu, id_aktywnosci, tematyka) VALUES
 (1, '97041054897', 1, 1,'logika'),
 (1, '97041054897', 1, 2,'algebra'),
 (3, '95012352911', 1, 1,'logika'),
 (4, '95012352911', 1, 2,'algebra'),
 (5, '95012352911', 1, 3,'geometria'),
 (5, '95100358126', 1, 1,'logika'),
 (2, '95100358126', 1, 1,'algebra'),
 (5, '96092833275', 1, 1,'logika'),
 (5, '96092833275', 1, 1,'algebra'),
 (4, '97111067138', 1, 1,'logika'),
 (6, '97030656297', 1, 1,'logika'),
 (2, '96051382936', 1, 1,'logika'),
 (2, '96051382936', 1, 1,'logika'),
 (4, '95080123574', 6, 3,'antyk'),
 (5, '95080123574', 6, 4,'polska'),
 (3, '96032315157', 6, 3,'polska'),
 (3, '96121214718', 6, 3,'lalka'),
 (1, '96121214718', 6, 5,'antyk'),
 (1, '95091673574', 5, 5,'test'),
 (1, '95091673574', 11, 5,'dzuma'),
 (1, '95091673574', 22, 1,'Karboksyhemoglobina'),
 (5, '96022821662', 6, 3,'przediowsnie');

INSERT INTO nieobecnosci(id_ucznia,id_lekcji) VALUES
 (95091673574,1),
 (95091673574,2),
 (95091673574,3),
 (95091673574,4),
 (95091673574,5),
 (97010397938,21),
 (97010397938,22),
 (96031317839,19),
 (96031317839,18),
 (96031317839,17);






UPDATE uczniowie SET id_uzytkownika='UNMY7J' where pesel = '96091227824'	;
UPDATE uczniowie SET id_uzytkownika='P8OF5' where pesel = '95080364878'	;
UPDATE uczniowie SET id_uzytkownika='KK4GH7SWDXC' where pesel = '96080786581'	;
UPDATE uczniowie SET id_uzytkownika='J2GF1QM5BRMF4TJ' where pesel = '95010881893'	;
UPDATE uczniowie SET id_uzytkownika='PXCNCOTO8LO0P15K2' where pesel = '96061849746'	;
UPDATE uczniowie SET id_uzytkownika='L7XKBEDFLWN' where pesel = '95112464312'	;
UPDATE uczniowie SET id_uzytkownika='5SBVRWM' where pesel = '96121214718'	;
UPDATE uczniowie SET id_uzytkownika='3MSD2M6RK2J1MQ' where pesel = '95121345237'	;
UPDATE uczniowie SET id_uzytkownika='U9EICGLOYW' where pesel = '96112772823'	;
UPDATE uczniowie SET id_uzytkownika='ER3XYX1L' where pesel = '95041617599'	;
UPDATE uczniowie SET id_uzytkownika='UXUE3VYQVUN5J' where pesel = '95012352911'	;
UPDATE uczniowie SET id_uzytkownika='VNNE6STBFT806XWEND' where pesel = '95072542383'	;
UPDATE uczniowie SET id_uzytkownika='BOCPOSTFXX6X0MY5MH' where pesel = '95033043384'	;
UPDATE uczniowie SET id_uzytkownika='8GNNQ26DTNDGEMY9' where pesel = '96102639141'	;
UPDATE uczniowie SET id_uzytkownika='ERTSXA0D' where pesel = '95102874947'	;
UPDATE uczniowie SET id_uzytkownika='Y83YM8W' where pesel = '95072878983'	;
UPDATE uczniowie SET id_uzytkownika='AS0EXENCPPFUG' where pesel = '95101912891'	;
UPDATE uczniowie SET id_uzytkownika='OJAWWC7UNKMV' where pesel = '95010444377'	;
UPDATE uczniowie SET id_uzytkownika='UBHI612NM' where pesel = '96031111259'	;
UPDATE uczniowie SET id_uzytkownika='7V3KIQLFVE3K4A' where pesel = '96101136953'	;
UPDATE uczniowie SET id_uzytkownika='DHSCCRQ0' where pesel = '95041512269'	;
UPDATE uczniowie SET id_uzytkownika='MQE7X' where pesel = '95032259784'	;
UPDATE uczniowie SET id_uzytkownika='4RBK3QQFW4QKG4' where pesel = '96030623564'	;
UPDATE uczniowie SET id_uzytkownika='S2SJ9EJ48' where pesel = '96082215155'	;
UPDATE uczniowie SET id_uzytkownika='YK125LX5NB' where pesel = '96021036696'	;
UPDATE uczniowie SET id_uzytkownika='YV03F' where pesel = '96051382936'	;
UPDATE uczniowie SET id_uzytkownika='IK3L0Q' where pesel = '96092833275'	;
UPDATE uczniowie SET id_uzytkownika='HTSG6L7R19' where pesel = '95051864411'	;
UPDATE uczniowie SET id_uzytkownika='CYGL8CS' where pesel = '95100458567'	;
UPDATE uczniowie SET id_uzytkownika='4U96N3N1R0WDWO' where pesel = '96031317839'	;
UPDATE uczniowie SET id_uzytkownika='6FWV6AXO4' where pesel = '97010397938';
UPDATE uczniowie SET id_uzytkownika='kamil' where pesel = '95091673574';

commit;