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

-- Definizione tabella Attivita Formativa
CREATE TABLE attivita_formativa(
  codice varchar(10) PRIMARY KEY,
  descrizione text,
  tipo ENUM('insegnamento', 'tirocinio', 'lingua', 'prova_finale') NOT NULL,
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

-- Definizione tabella corte
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

-- Definizione tabella CORSO LAUREA
CREATE TABLE corso_laurea(
  codice varchar(6) PRIMARY KEY,
  ordinamento varchar(10),
  CFU smallint,
  tipo varchar(50),
  scuola varchar(4) NOT NULL,
  FOREIGN KEY (scuola) REFERENCES scuola(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Definizione tabella APPARTIENE
CREATE TABLE appartiene(
  classe varchar(5),
  corso_laurea varchar(6),
  PRIMARY KEY (classe, corso_laurea),
  FOREIGN KEY (classe) REFERENCES classe(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (corso_laurea) REFERENCES corso_laurea(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Definizione tabella OFFRE
CREATE TABLE offre(
  corso_laurea varchar(6),
  coorte smallint,
  attivita_formativa varchar(10),
  PRIMARY KEY (corso_laurea, coorte, attivita_formativa),
  FOREIGN KEY (corso_laurea) REFERENCES corso_laurea(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (coorte) REFERENCES coorte(anno)
    ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (attivita_formativa) REFERENCES attivita_formativa(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Definizione tabella PERCORSO
CREATE TABLE percorso(
  corso_laurea varchar(6),
  curriculum varchar(10),
  coorte smallint,
  PRIMARY KEY (corso_laurea, curriculum, coorte),
  FOREIGN KEY (corso_laurea) REFERENCES corso_laurea(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (curriculum) REFERENCES curriculum(codice)
    ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (coorte) REFERENCES coorte(anno)
    ON DELETE NO ACTION ON UPDATE CASCADE
);