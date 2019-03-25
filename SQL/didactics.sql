-- Pulitura db
DROP TABLE IF EXISTS classe, ssd, scuola, attivita_formativa, coorte, docente, percorso, corso_laurea, curriculum, istanza_attivita_formativa, attiva, propone, comprende, requisito, partecipa, appartiene, offre CASCADE;

DROP TYPE IF EXISTS tipo_insegnamento, tipo_corso_laurea, semestre, tipo_crediti, ruolo_docente CASCADE;


-- Definizione tabella Classe ministeriale (MIUR)
CREATE TABLE classe(
  codice varchar(5) PRIMARY KEY,
  descrizione text
);

-- Definizione entita' SSD
CREATE TABLE ssd(
  codice varchar(10),
  ambito text,
  PRIMARY KEY(codice, ambito)
);

-- -- Definizione entita' Attivita Formativa con relativa enumerazione
CREATE TYPE tipo_insegnamento AS ENUM ('insegnamento', 'tirocinio', 'lingua', 'prova_finale');
CREATE TABLE attivita_formativa(
  codice varchar(10) PRIMARY KEY,
  nome text,
  tipo tipo_insegnamento NOT NULL -- ENUM
);

-- Definizione entita' coorte
CREATE TABLE coorte(
  anno smallint PRIMARY KEY
);

-- Definizione entita' curriculum
CREATE TABLE curriculum(
  codice varchar(10) PRIMARY KEY
);

-- Definizione entita' docente
CREATE TABLE docente(
  matricola varchar(10) PRIMARY KEY,
  cognome varchar(20) NOT NULL,
  nome varchar(20) NOT NULL,
  email varchar(30) NOT NULL,
  dipartimento text  NOT NULL, /*sarebbe da legare a entita*/
  telefono varchar(15)  NOT NULL,
  qualifica varchar(100)  NOT NULL,
  ssd text NOT NULL, /*presente nella scheda del docente aggiungere relazione*/
  ufficio text NOT NULL,
  tesi text,
  aree_ricerca text,
  curriculum text,
  publicazioni text  
);

-- Definizione entita' scuola
CREATE TABLE scuola(
  codice varchar(5) PRIMARY KEY, -- sul sito i codici sono tutti lunghi 2, scelgo 5 per sicurezza
  nome varchar(50) NOT NULL
);

-- Definizione entita' corso di laurea e relativa enumerazione
CREATE TYPE tipo_corso_laurea AS ENUM ('LT', 'LM', 'CU');
CREATE TABLE corso_laurea(
  codice varchar(10) PRIMARY KEY, -- sul sito i codici sono tutti lunghi 6, scelgo 10 per sicurezza
  nome varchar(40) NOT NULL,
  scuola varchar(5) NOT NULL, -- FK scuola
  ordinamento smallint NOT NULL, -- dovrebbe essere un anno, controllare
  cfu smallint NOT NULL, -- potrebbe essere un ENUM
  tipo tipo_corso_laurea NOT NULL, -- e' un ENUM: LT laurea triennale, LM magistrale, CU ciclo unico
  FOREIGN KEY (scuola) REFERENCES scuola(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Definizione associazione percorso
CREATE TABLE percorso(
  corso_laurea varchar(10),
  curriculum varchar(10),
  coorte smallint,
  descrizione varchar(30) NOT NULL,
  PRIMARY KEY (corso_laurea, curriculum, coorte),
  FOREIGN KEY (corso_laurea) REFERENCES corso_laurea(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (curriculum) REFERENCES curriculum(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (coorte) REFERENCES coorte(anno)
    ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Definizione associazione propone con relativa enumerazione semestre
CREATE TYPE semestre AS ENUM ('I', 'II');
CREATE TABLE propone(
  corso_laurea varchar(10),
  curriculum varchar(10),
  coorte smallint,
  attivita_formativa varchar(10),
  anno smallint NOT NULL,
  semestre semestre NOT NULL, -- potrebbe essere anche varchar: 'I', 'II'
  canali_previsti smallint NOT NULL,
  PRIMARY KEY (corso_laurea, curriculum, coorte, attivita_formativa),
  FOREIGN KEY (corso_laurea, curriculum, coorte) REFERENCES percorso(corso_laurea,curriculum,coorte)
    ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (attivita_formativa) REFERENCES attivita_formativa(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Definizione entita' istanza
CREATE TABLE istanza_attivita_formativa(
  attivita_formativa varchar(10),
  canale smallint,
  anno_accademico smallint,
  responsabile varchar(10),
  tipo_valutazione text,
  dipartimento text, /*sul sito didattica specificano il dipartimento sarebbe da inserire come entita*/
  frequenza_obbligo boolean,
  sede text, /* se e' un indirizzo va modificato*/
  corso_singolo boolean, --Se e' possibile iscriversi come corso singolo
  corso_libero boolean,  --Se e' possibile utilizzare l'insegnamento come libera scelta
  -- Seguono attributi relativi alla scheda del corso
  prerequisiti text, /*dove il prof speifica quali conoscenze servano al di la di corsi specifici*/
  acquisire text, -- Conoscenze e abilita' da acquisire
  modalita_esame text, 
  criterio_valutazione text,
  contenuti text,
  attivita text, -- Attivita' di apprendimento previste
  materiali text,
  testi text,
  lingua varchar(10),
  PRIMARY KEY (attivita_formativa, canale, anno_accademico, responsabile),
  FOREIGN KEY (attivita_formativa) REFERENCES attivita_formativa(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (responsabile) REFERENCES docente(matricola)
    ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Definizione associazione attiva
CREATE TABLE attiva(
  corso_laurea varchar(10),
  coorte smallint,
  curriculum varchar(10),
  attivita_formativa varchar(10),
  canale smallint,
  anno_accademico smallint,
  responsabile varchar(10),
  PRIMARY KEY (corso_laurea, coorte, curriculum, attivita_formativa, canale, anno_accademico, responsabile),
  -- percorso FKs
  FOREIGN KEY (corso_laurea, coorte, curriculum) REFERENCES percorso(corso_laurea, coorte, curriculum)
    ON DELETE NO ACTION ON UPDATE CASCADE,
  -- instanza att. form. FKs
  FOREIGN KEY (attivita_formativa, canale, anno_accademico, responsabile) REFERENCES istanza_attivita_formativa(attivita_formativa, canale, anno_accademico, responsabile)
    ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Definizione associazione comprende e relativa enumerazione tipo di crediti
CREATE TYPE tipo_crediti AS ENUM ('base', 'affine', 'caratterizzante', 'ALTRO');
CREATE TABLE comprende(
	attivita_formativa varchar(10), --foreign key
	ssd varchar(10), --foreign key
	ambito text, --foreign key
	gruppo tipo_crediti NOT NULL, --enum
	cfu smallint NOT NULL, --intero compreso tra 0 e 20/50(?)
	PRIMARY KEY(attivita_formativa, ssd, ambito),
	FOREIGN KEY (attivita_formativa) REFERENCES attivita_formativa(codice)
		ON DELETE NO ACTION ON UPDATE CASCADE,
	FOREIGN KEY (ssd, ambito) REFERENCES ssd(codice, ambito)
		ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Definizione associazione ricorsiva requisito su attività formativa
CREATE TABLE requisito(
	attivita_formativa varchar(10), --foreign key attivita con requisito
	attivita_formativa_richiesta varchar(10), --foreign key attivita richiesta
	PRIMARY KEY (attivita_formativa, attivita_formativa_richiesta),
	FOREIGN KEY (attivita_formativa) REFERENCES attivita_formativa(codice)
		ON DELETE NO ACTION ON UPDATE CASCADE,
	FOREIGN KEY (attivita_formativa_richiesta) REFERENCES attivita_formativa(codice)
		ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Definizione associazione partecipa e relativa enumerazione ruolo docente
CREATE TYPE ruolo_docente AS ENUM ('presidente', 'membro_effettivo', 'supplente');
CREATE TABLE partecipa(
	attivita_formativa varchar(10),
	canale smallint,
	anno_accademico smallint,
	responsabile varchar(10),
	docente varchar(10),
	ruolo ruolo_docente NOT NULL,
	PRIMARY KEY (attivita_formativa, canale, anno_accademico, responsabile, docente),
	FOREIGN KEY (attivita_formativa, canale, anno_accademico, responsabile) REFERENCES istanza_attivita_formativa(attivita_formativa, canale, anno_accademico, responsabile)
		ON DELETE NO ACTION ON UPDATE CASCADE,
	FOREIGN KEY (docente) REFERENCES docente(matricola)
		ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Definizione associazione appartiene
CREATE TABLE appartiene(
  classe varchar(5),
  corso_laurea varchar(6),
  PRIMARY KEY (classe, corso_laurea),
  FOREIGN KEY (classe) REFERENCES classe(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (corso_laurea) REFERENCES corso_laurea(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Definizione associazione OFFRE
CREATE TABLE offre(
  corso_laurea varchar(6),
  attivita_formativa varchar(10),
  coorte smallint,
  PRIMARY KEY (corso_laurea, coorte, attivita_formativa),
  FOREIGN KEY (corso_laurea) REFERENCES corso_laurea(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (coorte) REFERENCES coorte(anno)
    ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (attivita_formativa) REFERENCES attivita_formativa(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE
);


