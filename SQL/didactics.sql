-- Pulitura db
DROP TABLE IF EXISTS classe, ssd, scuola, attivita_formativa, coorte, docente, percorso, corsolaurea, curriculum, istanza_attivita_formativa, attiva, propone CASCADE;

-- Definizione tabella Classe ministeriale (MIUR)
CREATE TABLE classe(
  codice varchar(5) PRIMARY KEY,
  descrizione text
);

-- Definizione tabella SSD
CREATE TABLE ssd(
  codice text PRIMARY KEY,
  descrizione text
);

-- Definizione tabella Attivita Formativa
-- Enumerazione tipi di insegnamento
CREATE TYPE tipo_insegnamento AS ENUM ('insegnamento', 'tirocinio', 'lingua', 'prova_finale');

CREATE TABLE attivita_formativa(
  codice varchar(10) PRIMARY KEY,
  descrizione text,
  tipo tipo_insegnamento NOT NULL, -- ENUM
  tipo_valutazione text,
  dipartimento text, /*sul sito didattica specificano il dipartimento sarebbe da inserire come entita*/
  frequenza_obbligo boolean,
  lingua varchar(10),
  sede text, /* se e' un indirizzo va modificato*/
  corso_singolo boolean, --Se e' possibile iscriversi come corso singolo
  corso_libero boolean,  --Se e' possiile utilizzare l'insegnamento come libera scelta
  -- Seguono attributi relativi alla scheda del corso
  prerequisiti text, /*dove il prof speifica quali conoscenze servano al di la di corsi specifici*/
  aquisire text, -- Conoscenze e abilita' da acquisire
  modalita_esame text, 
  criterio_valutazione text,
  contenuti text,
  attivita text, -- Attivita' di apprendimento previste
  materiali text,
  testi text
);

-- Definizione tabella coorte

CREATE TABLE coorte(
  anno smallint PRIMARY KEY
);

-- Definizione tabella curriculum
CREATE TABLE curriculum(
  codice varchar(10) PRIMARY KEY,
  nome text
);

-- Definizione tabella docente
CREATE TABLE docente(
  matricola varchar(10) PRIMARY KEY,
  cognome varchar(20),
  nome varchar(20),
  email varchar(30),
  dipartimento text, /*sarebbe da legare a entita*/
  telefono varchar(15),
  qualifica varchar(100),
  ssd text, /*presente nella scheda del docente aggiungere relazione*/
  ufficio text,
  tesi text,
  aree_ricerca text,
  curriculum text,
  publicazioni text  
);


-- Definizione entita' scuola
CREATE TABLE scuola(
  codice varchar(5) PRIMARY KEY, -- sul sito i codici sono tutti lunghi 2, scelgo 5 per sicurezza
  nome varchar(30)
);

-- Definizione entita' corso di laurea
CREATE TYPE tipo_corsolaurea AS ENUM ('LT', 'LM', 'CU');
CREATE TABLE corsolaurea(
  codice varchar(10) PRIMARY KEY, -- sul sito i codici sono tutti lunghi 6, scelgo 10 per sicurezza
  scuola varchar(5) NOT NULL, -- FK scuola
  ordinamento smallint NOT NULL, -- dovrebbe essere un anno, controllare
  cfu smallint NOT NULL, -- potrebbe essere un ENUM
  tipo tipo_corsolaurea NOT NULL, -- e' un ENUM: LT laurea triennale, LM magistrale, CU ciclo unico
  FOREIGN KEY (scuola) REFERENCES scuola(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Definizione entita' percorso

CREATE TABLE percorso(
  corsolaurea varchar(10) NOT NULL,
  curriculum varchar(10) NOT NULL,
  coorte smallint NOT NULL,
  PRIMARY KEY (corsolaurea, curriculum, coorte),
  FOREIGN KEY (corsolaurea) REFERENCES corsolaurea(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (curriculum) REFERENCES curriculum(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (coorte) REFERENCES coorte(anno)
    ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Definizione relazione propone
CREATE TABLE propone(
  corsolaurea varchar(10) NOT NULL,
  curriculum varchar(10) NOT NULL,
  coorte smallint NOT NULL,
  attivita_formativa varchar(10) NOT NULL,
  anno smallint NOT NULL,
  semestre smallint NOT NULL, -- potrebbe essere anche varchar: 'I', 'II'
  canali_previsti smallint NOT NULL,
  PRIMARY KEY (corsolaurea, curriculum, coorte, attivita_formativa),
  FOREIGN KEY (corsolaurea) REFERENCES corsolaurea(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (curriculum) REFERENCES curriculum(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (coorte) REFERENCES coorte(anno)
    ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (attivita_formativa) REFERENCES attivita_formativa(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Definizione entita' istanza
CREATE TABLE istanza_attivita_formativa(
  attivita_formativa varchar(10) NOT NULL,
  canale smallint NOT NULL,
  anno_accademico smallint NOT NULL,
  responsabile varchar(10) NOT NULL,
  PRIMARY KEY (attivita_formativa, canale, anno_accademico, responsabile),
  FOREIGN KEY (attivita_formativa) REFERENCES attivita_formativa(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (responsabile) REFERENCES docente(matricola)
    ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Definizione relazione attiva
CREATE TABLE attiva(
  corsolaurea varchar(10) NOT NULL,
  coorte smallint NOT NULL,
  curriculum varchar(10) NOT NULL,
  attivita_formativa varchar(10) NOT NULL,
  canale smallint NOT NULL,
  anno_accademico smallint NOT NULL,
  responsabile varchar(10) NOT NULL,
  PRIMARY KEY (corsolaurea, coorte, curriculum, attivita_formativa, canale, anno_accademico, responsabile),
  -- percorso FKs
  FOREIGN KEY (corsolaurea, coorte, curriculum) REFERENCES percorso(corsolaurea, coorte, curriculum)
    ON DELETE NO ACTION ON UPDATE CASCADE,
  -- instanza att. form. FKs
  FOREIGN KEY (attivita_formativa, canale, anno_accademico, responsabile) REFERENCES istanza_attivita_formativa(attivita_formativa, canale, anno_accademico, responsabile)
    ON DELETE NO ACTION ON UPDATE CASCADE
)




CREATE TABLE appartiene(
  classe varchar(5),
  corso_laurea varchar(6),
  PRIMARY KEY (classe, corso_laurea),
  FOREIGN KEY (classe) REFERENCES classe(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (corso_laurea) REFERENCES corso_laurea(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE
);
-- Definizione tabella APPARTIENE
-- Definizione tabella OFFRE
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