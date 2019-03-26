-- Dati un 'corso di studi' e una 'coorte' trovare tutte le attività formative ordinate per anno e semestre;
SELECT a.nome, p.anno, p.semestre
FROM propone as p JOIN attivita_formativa as a ON p.attivita_formativa = a.codice
WHERE p.coorte = 2015 and p.corso_laurea = 'IN0508'
ORDER BY p.anno ASC, p.semestre ASC;

-- Dati un 'corso di studi' e una 'coorte' trovare tutte le attività formative ordinate per anno e semestre,
-- mostrare canale, anno accademico, nome e cognome del docente se il corso è attivato
SELECT af.nome, p.anno, p.semestre, a.canale, a.anno_accademico, d.nome, d.cognome
FROM propone as p 
JOIN attivita_formativa as af ON p.attivita_formativa = af.codice
LEFT JOIN attiva as a 
    ON p.corso_laurea = a.corso_laurea
        AND p.curriculum = a.curriculum
        AND p.coorte = a.coorte
        AND p.attivita_formativa = a.attivita_formativa
LEFT JOIN docente as d ON a.responsabile = d.matricola
WHERE p.coorte = 2015 and p.corso_laurea = 'IN0508'
ORDER BY p.anno ASC, p.semestre ASC;

-- Dati il codice di una attivita' formativa, il canale, l'anno accademico e il responsabile trovare i dettagli dell'attivita' formativa
SELECT af.nome as nome, iaf.canale as canale, iaf.anno_accademico as anno_accademico, CONCAT(d.nome, ' ', d.cognome) as responsabile, iaf.acquisire as acquisire, iaf.contenuti as contenuti, iaf.testi as testi
FROM istanza_attivita_formativa as iaf JOIN attivita_formativa as af
	ON iaf.attivita_formativa = af.codice
	JOIN docente as d ON d.matricola = iaf.responsabile
WHERE iaf.attivita_formativa = $1
	AND iaf.canale = $2
	AND iaf.anno_accademico = $3
	AND iaf.responsabile = $4;

-- Ritorna tutti i corsi attivati con il relativo codice, nome, anno accademico, canale e responsabile
SELECT iaf.attivita_formativa as codice, af.nome as nome, iaf.anno_accademico as anno_accademico, iaf.canale as canale, CONCAT(d.nome, ' ', d.cognome) as responsabile, d.matricola as matricola
FROM istanza_attivita_formativa as iaf JOIN attivita_formativa as af
	ON iaf.attivita_formativa =af.codice
	JOIN docente as d ON d.matricola = iaf.responsabile;

-- dato una scuola e un tipo (LT/LM/CU) elencare i corsi di laurea
SELECT c.codice, c.nome, c.ordinamento, c.cfu
FROM corso_laurea AS c
WHERE c.scuola = 'IN' AND c.tipo = 'LT';

-- dato un corso di laurea elencare le classi di appartenenza
SELECT cl.codice, cl.descrizione
FROM classe AS cl
JOIN appartiene AS a ON cl.codice = a.classe
WHERE a.corso_laurea = 'IN2374';

--Dati un curriculum, un corso di laurea e una coorte mostrare la somma dei
-- crediti delle attività formative divisi per SSD
SELECT c.ssd AS ssd, s.descrizione AS descrizione, SUM(c.cfu) AS cfu
FROM propone AS p
    JOIN comprende AS c
	    ON p.attivita_formativa = c.attivita_formativa
    JOIN ssd AS s
        ON c.ssd = s.codice AND c.descrizione = s.descrizione
WHERE p.curriculum='COMUNE' AND p.corso_laurea='IN0508' AND p.coorte=2015
GROUP BY c.ssd, s.descrizione;

--Dati due corsi di laurea e una coorte mostrare le attività formative non in comune tra i due corsi
SELECT af.nome AS "Attivita_Formativa", o1.attivita_formativa AS "codice", cl.nome AS "Corso_di_Laurea", o1.corso_laurea AS "codice"
FROM (	SELECT *
	FROM offre
	WHERE corso_laurea='IN0508' OR corso_laurea='IN2374') AS o1
		LEFT OUTER JOIN (SELECT *
				FROM offre
				WHERE corso_laurea='IN0508' OR corso_laurea='IN2374') AS o2
			ON o1.attivita_formativa=o2.attivita_formativa and not o1.corso_laurea=o2.corso_laurea
		INNER JOIN attivita_formativa AS af
			ON o1.attivita_formativa=af.codice
		INNER JOIN corso_laurea AS cl
			ON o1.corso_laurea=cl.codice
WHERE o2.attivita_formativa IS NULL AND o1.coorte=2015;

--QUERY REGOLA DI VINCOLO RV4
-- Data una attivita' formativa che vuole essere proposta per un percorso, permette di controllare che il corso di laurea associato al percorso preveda l'attivita' formativa
SELECT COUNT(*)
FROM offre
WHERE corso_laurea = $1
    AND coorte = $2
    AND attivita_formativa = $3;

-- QUERY REGOLA DI VINCOLO RV5
-- Dati un percorso e il codice di una attivita' formativa, permette di controllare che una attivita' formativa sia proposta dal percorso. Tale funzione è utilizzata a livello applicativo per controllare che sia possibile attivare un corso per un percorso.
SELECT COUNT(*)
FROM propone as p 
WHERE p.corso_laurea = $1
  AND p.coorte = $2
  AND p.curriculum = $3
  AND p.attivita_formativa = $4;


