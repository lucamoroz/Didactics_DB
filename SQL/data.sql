-- Inserimento dati

INSERT INTO coorte (anno)
VALUES
    (2015),
    (2016),
    (2017),
    (2018);


INSERT INTO scuola (codice,nome)
VALUES
    ('IN', 'Scuola di Ingegneria'),
    ('ME', 'Scuola di Medicina e Chirurgia'),
    ('SC', 'Scuola di Scienze');
    
    
INSERT INTO curriculum (codice, nome)
VALUES
    ('COMUNE', 'Percorso Comune'),
    ('001PD', 'Curriculum Generale'),
    ('002PD', 'Curriculum Applicativo');


INSERT INTO attivita_formativa(codice, nome, tipo)
VALUES 
    ('IN10100190', 'Analisi Matematica 1', 'insegnamento'),
    ('IN05122464', 'Architettura degli elaboratori', 'insegnamento'),
    ('IN04111234', 'Dati e Algoritmi 1', 'insegnamento'),
    ('INN1031400', 'Lingua Inglese B2 (Abilità ricettive)', 'lingua'),
    ('INL1004099', 'Tirocinio', 'tirocinio'),
    ('INM0014874', 'Prova Finale', 'prova_finale');



INSERT INTO corso_laurea (codice,nome,scuola,ordinamento,cfu,tipo)
VALUES
    ('IN0508', 'Ingegneria Informatica', 'IN', 2011, 180, 'LT'),
    ('IN2374', 'Ingegneria Biomedica', 'IN', 2017, 180, 'LT'),
    ('SC1167', 'Informatica', 'SC', 2011, 180, 'LT');
    
    
INSERT INTO percorso (corso_laurea, curriculum, coorte)
VALUES
    ('IN0508', 'COMUNE', '2015'),
    ('IN0508', '001PD', '2015');


INSERT INTO docente(matricola, cognome, nome, email, dipartimento, telefono, qualifica, ssd, ufficio)
VALUES
    ('1139048', 'cogDoc', 'nomeDoc', 'email', 'dip', '12334', 'Ricercatore', 'ssd', 'DEI A - 7'),
    ('1139049', 'cogDoc2', 'nomeDoc2', 'email', 'dip', '12334', 'Docente', 'ssd', 'DEI A - 8');
    

INSERT INTO istanza_attivita_formativa(attivita_formativa, canale, anno_accademico, responsabile, tipo_valutazione, prerequisiti, acquisire, modalita_esame, criterio_valutazione, contenuti)
VALUES
    ('IN10100190', 1, 2015, '1139048', 'lorem', 'lorem', 'lorem', 'lorem', 'lorem', 'lorem'),
    ('IN10100190', 2, 2015, '1139049', 'lorem', 'lorem', 'lorem', 'lorem', 'lorem', 'lorem'),
    ('IN04111234', 1, 2016, '1139048', 'lorem', 'lorem', 'lorem', 'lorem', 'lorem', 'lorem');
    
INSERT INTO propone(corso_laurea, curriculum, coorte, attivita_formativa, anno, semestre, canali_previsti)
VALUES
    ('IN0508', 'COMUNE', '2015', 'IN05122464', '1', 'II', '2'), -- architettura elab
    ('IN0508', 'COMUNE', '2015', 'IN10100190', '1', 'I', '4'), -- analisi
    ('IN0508', 'COMUNE', '2015', 'IN04111234', '2', 'I', '2'), -- dati e alg
    ('IN0508', 'COMUNE', '2015', 'INM0014874', '3', 'II', '0'); -- prova finale
    
INSERT INTO attiva(corso_laurea, curriculum, coorte, attivita_formativa, canale, anno_accademico, responsabile)
VALUES
    ('IN0508', 'COMUNE', '2015', 'IN10100190', 1, 2015, '1139048'), -- analisi
    ('IN0508', 'COMUNE', '2015', 'IN10100190', 2, 2015, '1139049'), -- analisi
    ('IN0508', 'COMUNE', '2015', 'IN04111234', 1, 2016, '1139048'); -- dati e alg
    
INSERT INTO classe(codice, descrizione)
VALUES
    ('L-8', 'Ingegneria dell''informazione'),
    ('L-9', 'Ingegneria industriale'),
    ('L-31', 'Scienze e tecnologie informatiche');

INSERT INTO appartiene(classe, corso_laurea)
VALUES
    ('L-8','IN0508'),
    ('L-8','IN2374'),
    ('L-9','IN2374'),
    ('L-31','SC1167');