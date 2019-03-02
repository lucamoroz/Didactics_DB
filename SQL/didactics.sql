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

-- Definizione tabella scuola

CREATE TABLE scuola(
  codice varchar(4) PRIMARY KEY,
  nome text
);

-- Definizione tabella Attività Formativa

CREATE TABLE attività_formativa(
  codice varchar(10) PRIMARY KEY,
  descrizione text,
  tipo text, /*enumerazione da controllare: viene dala specializzazione, aggiungere attributi*/
  tipo_valutazione text,
  dipartimento text, /*sul sito didattica specificano il dipartimento sarebbe da inserire come entità*/
  frequenza_obbligo boolean,
  lingua text,
  sede text,
  corso_singolo boolean,
  corso_libero boolean,
  prerequisiti text, /*dove il prof speifica quali conoscenze servano al di la di corsi specifici*/
  aquisire text,
  modalità_esame text,
  criterio_valutazione text,
  contenuti text,
  attività text,
  materiali text,
  testi text
);

-- Definizione tabella corte

CREATE TABLE corte(
  anno int PRIMARY KEY
);

-- Definizione tabella curriculum

CREATE TABLE curriculum(
  codice text PRIMARY KEY,
  nome text
);

-- Definizione tabella docente

CREATE TABLE docente(
  matricola int PRIMARY KEY,
  cognome text,
  nome text,
  email text,
  dipartimento text, /*sarebbe da legare a entità*/
  telefono text,
  qualifica text,
  ssd text, /*presente nella scheda del docente aggiungere relazione*/
  ufficio text,
  tesi text,
  aree_ricerca text,
  curriculum text,
  publicazioni text  
);
