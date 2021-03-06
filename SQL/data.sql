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
    
    
INSERT INTO curriculum (codice)
VALUES
    ('COMUNE'),
    ('001PD'),
    ('002PD');


INSERT INTO attivita_formativa(codice, nome, tipo)
VALUES 
    ('IN10100190', 'Analisi Matematica 1', 'insegnamento'),
    ('IN05122464', 'Architettura degli elaboratori', 'insegnamento'),
    ('IN04111234', 'Dati e Algoritmi 1', 'insegnamento'),
    ('INN1031400', 'Lingua Inglese B2 (Abilità ricettive)', 'lingua'),
    ('INL1004099', 'Tirocinio', 'tirocinio'),
    ('INM0014874', 'Prova Finale', 'prova_finale'),
    ('IN03122522', 'Elementi di chimica', 'insegnamento'),
    ('IN08111231', 'Segnali e sistemi', 'insegnamento'),
    ('SC02105452', 'Logica', 'insegnamento'),
    ('INM0017605', 'Elettronica Digitale', 'insegnamento'),
    ('INL1000216', 'Bioeletromagnetismo', 'insegnamento'),
    ('INP3050962', 'Computer networks', 'insegnamento'),
    ('INP7079338', 'Digital signal processing', 'insegnamento'),
    ('IN11112347', 'Ricerca operativa', 'insegnamento'),
    ('INP7079233', 'Big data computing', 'insegnamento');
    
    


INSERT INTO corso_laurea (codice,nome,scuola,ordinamento,cfu,tipo)
VALUES
    ('IN0508', 'Ingegneria Informatica', 'IN', 2011, 180, 'LT'),
    ('IN0521', 'Ingegneria Informatica', 'IN', 2009, 120, 'LM'),
    ('IN2374', 'Ingegneria Biomedica', 'IN', 2017, 180, 'LT'),
    ('SC1167', 'Informatica', 'SC', 2011, 180, 'LT'),
    ('IF0375', 'Scienze Motorie', 'ME', '2013', '180', 'LT'),
    ('ME1853', 'Dietistica', 'ME', '2011', '180', 'LT'),
    ('IN0515', 'Ingegneria Dell''Energia', 'IN', 2014, 180, 'LT');
    
    
INSERT INTO percorso (corso_laurea, curriculum, coorte, descrizione)
VALUES
    ('IN0508', 'COMUNE', 2015, 'Percorso Comune'), -- Ing informatica triennale
    ('IN0508', '001PD', 2015, 'Curriculum Generale'),
    ('IN0515', '001PD', 2015, 'Termomeccanico'),
    ('IN0515', '002PD', 2015, 'Dell''energia elettrica'),
    ('IN0521', 'COMUNE', 2018, 'Percorso comune'), -- Ing informatica magistrale
    ('IN0515', 'COMUNE', 2015, 'Percorso Comune'),
    ('IN2374', 'COMUNE', 2015, 'Percorso Comune'),
    ('SC1167', 'COMUNE', 2015, 'Percorso Comune');
    


INSERT INTO docente(matricola, cognome, nome, email, dipartimento, telefono, qualifica, ssd, ufficio)
VALUES
    ('1139048', 'von Neumann', 'John', 'john.neumann@unipd.it', 'Dipartimento di informatica', '12334', 'Ricercatore', 'ssd', 'DEI A - 7'),
    ('1139049', 'Bayes', 'Thomas', 'thomas.bayes@unipd.it', 'Dipartimento di matematica', '12334', 'Ricercatore', 'ssd', 'Paolotti A - 8'),
    ('1216568', 'Verdi', 'Luigi', 'luigi.verdi@unipd.it', 'Dipartimento di matematica', '654321', 'Docente', 'ABCD/09', 'TA UFF.87'),
    ('8275599', 'Rossi', 'Marco', 'marco.rossi@unipd.it', '	Dipartimento di Ingegneria Civile', '04966565354', 'Docente', 'ICAR/08', 'IDEA UFF.405');
    

INSERT INTO istanza_attivita_formativa(attivita_formativa, canale, anno_accademico, responsabile, tipo_valutazione, prerequisiti, acquisire, modalita_esame, criterio_valutazione, contenuti)
VALUES
    ('IN10100190', 1, 2015, '1139048', 'Voto', 'Nessun prerequisito', 'Calcolo di base, analisi funzioni, integrali', 'Esame scritto + orale', 'Scritto per essere ammessi all orale', 'Analisi matematica di base'),
    ('IN10100190', 2, 2015, '1139049', 'Voto', 'Nessun prerequisito', 'Numeri complessi, serie e funzioni', 'Esame scritto + orale', 'Scritto per essere ammessi all orale', 'Analisi matematica di base'),
    ('IN04111234', 1, 2016, '1139048', 'Voto ', 'Analisi di funzioni', 'Strutture dati e algoritmi efficienti', 'Scritto', 'Esame scritto + orale opzionale', 'Complessità computazionale, algoritmi di ricerca, strutture dati: lista, hash map, alberi, grafi'),
    ('IN03122522', 1, 2017, '8275599', 'Voto', 'Nessuno', 'Comprendere le principali strutture organizzative', 'Scritta e orale', 'livello di conoscenza acquisita', 'L’azienda come sistema economico-finanziario em'),
    ('INM0017605', 1, 2015, '1139048', 'Voto', 'Nessuno', 'Maturare le competenze per lo sviluppo', 'Scritta', 'livello di conoscenza acquisita', 'Il processo di fabbricazione CMOS.'),
    ('INP3050962', 1, 2018, '1139048', 'Voto', 'Nessuno', 'Capire le reti', 'Scritta', 'livello di conoscenza acquisita', 'Comunicazione delle reti'),
    ('INP7079338', 1, 2018, '8275599', 'Voto', 'Nessuno', 'Segnali digitali', 'Scritta', 'livello di conoscenza acquisita', 'I segnali digitali'),
    ('IN11112347', 1, 2018, '1216568', 'Voto', 'Nessuno', 'Constraint programming, SAT, ..', 'Scritta', 'livello di conoscenza acquisita', 'Definizione problemi con vincoli e algoritmi');
    
INSERT INTO propone(corso_laurea, curriculum, coorte, attivita_formativa, anno, semestre, canali_previsti)
VALUES
    ('IN0508', 'COMUNE', 2015, 'IN05122464', '1', 'II', '2'), -- architettura elab
    ('IN0508', 'COMUNE', 2015, 'IN10100190', '1', 'I', '4'), -- analisi
    ('IN0508', 'COMUNE', 2015, 'IN04111234', '2', 'I', '2'), -- dati e alg
    ('IN0508', 'COMUNE', 2015, 'INM0017605', '3', 'II', '2'), -- elettronica digitale
    ('IN0508', 'COMUNE', 2015, 'INM0014874', '3', 'II', '0'), -- prova finale
    ('IN0515', 'COMUNE', 2015, 'IN03122522', '2', 'I', '2'), -- elementi di chimica energia
    ('IN0515', '001PD', 2015,'IN08111231', '2', 'II', '1'), -- segnali e sistemi
    ('SC1167', 'COMUNE', 2015,'SC02105452', '1', 'I', '3'), -- logica
    ('IN2374', 'COMUNE', 2015, 'IN10100190', '1', 'I', '4'), -- analisi 1 bio
    ('IN2374', 'COMUNE', 2015, 'IN05122464', '1', 'II', '2'), -- architettura bio
    ('IN2374', 'COMUNE', 2015, 'IN04111234', '2', 'I', '2'), -- dati bio
    ('IN2374', 'COMUNE', 2015, 'INN1031400', '3', 'II', '2'), -- lingua bio
    ('IN2374', 'COMUNE', 2015, 'INL1004099', '3', 'II', '0'), -- tirocinio bio
    ('IN2374', 'COMUNE', 2015, 'INM0014874', '3', 'II', '0'), -- prova finale bio
    ('IN2374', 'COMUNE', 2015, 'INL1000216', '3', 'II', '1'), -- bioelettromagnetismo
    ('IN0521', 'COMUNE', 2018, 'INP3050962', '1', 'I', '1'),
    ('IN0521', 'COMUNE', 2018, 'INP7079338', '1', 'I', '1'),
    ('IN0521', 'COMUNE', 2018, 'IN11112347', '1', 'I', '1');
    
INSERT INTO attiva(corso_laurea, curriculum, coorte, attivita_formativa, canale, anno_accademico, responsabile)
VALUES
    ('IN0508', 'COMUNE', 2015, 'IN10100190', 1, 2015, '1139048'), -- analisi
    ('IN0508', 'COMUNE', 2015, 'IN10100190', 2, 2015, '1139049'), -- analisi
    ('IN0508', 'COMUNE', 2015, 'INM0017605', 1, 2015, '1139048'), -- elettronica digitale
    ('IN0508', 'COMUNE', 2015, 'IN04111234', 1, 2016, '1139048'), -- dati e alg
    ('IN0515', 'COMUNE', 2015, 'IN03122522', 1, 2017, '8275599'), -- elementi di chimica energia
    ('IN0521', 'COMUNE', 2018, 'INP3050962', '1', '2018', '1139048'), --Reti
    ('IN0521', 'COMUNE', 2018, 'INP7079338', '1', '2018', '8275599'), --Segnali digitali
    ('IN0521', 'COMUNE', 2018, 'IN11112347', '1', '2018', '1216568'); -- Ricerca operativa
    
    
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
    ('L-31','SC1167'),
    ('L-9', 'IN0515');
    
INSERT INTO offre(corso_laurea, attivita_formativa, coorte)
VALUES 
    ('IN0508','IN10100190', 2015),
    ('IN0508','IN05122464', 2015),
    ('IN0508','IN04111234', 2015),
    ('IN0508','INN1031400', 2015),
    ('IN0508','INL1004099', 2015),
    ('IN0508','INM0014874', 2015),
    ('IN0508','INM0017605', 2015),
    ('IN2374','IN10100190', 2015),
    ('IN2374','IN05122464', 2015),
    ('IN2374','IN04111234', 2015),
    ('IN2374','INN1031400', 2015),
    ('IN2374','INL1004099', 2015),
    ('IN2374','INM0014874', 2015),
    ('IN2374','INL1000216', 2015),
    ('IN0515','IN03122522', 2015),
    ('IN0515','IN08111231', 2015),
    ('SC1167','SC02105452', 2015);
    
INSERT INTO ssd(codice, ambito)
VALUES 
    ('ING-INF/05', 'Matematica, informatica e statistica'),
    ('ING-INF/05', 'Abilità informatiche e telematiche'),
    ('MAT/01', 'Attivita formative affini o integrative'),
    ('MAT/05', 'Matematica, informatica e statistica'),
    ('ING-INF/01', 'Ingegneria Elettronica'),
    ('ING-INF/02', 'Ingegneria Elettronica'),
    ('PROVA_FIN', 'Prova finale'),
    ('CHIM/07', 'Fisica e chimica');
    
INSERT INTO comprende(attivita_formativa, ssd, ambito, gruppo, cfu)
VALUES
    ('IN05122464', 'ING-INF/05', 'Matematica, informatica e statistica', 'base', 9), -- architettura elab
    ('IN10100190', 'MAT/05', 'Matematica, informatica e statistica', 'base', 12), -- analisi
    ('IN04111234', 'ING-INF/05', 'Matematica, informatica e statistica', 'base', 9), -- dati e alg
    ('INM0017605', 'ING-INF/01', 'Ingegneria Elettronica', 'caratterizzante', 6), -- elettronica digitale
    ('INM0014874', 'PROVA_FIN', 'Prova finale', 'ALTRO', 3), -- prova finale
    ('INL1000216', 'ING-INF/02', 'Ingegneria Elettronica', 'caratterizzante', 6), -- bioelettromagnetismo 
    ('IN03122522', 'CHIM/07', 'Fisica e chimica', 'base', 6), -- elementi di chimica
    ('SC02105452', 'MAT/01', 'Attivita formative affini o integrative', 'base', 6);
