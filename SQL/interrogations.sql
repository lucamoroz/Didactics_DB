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

-- Dati un 'corso di studi' e una 'coorte': trovare le attività formative attivate ordinate per anno
-- mostrando codice, nome, canale e anno accademico dell'istanza attività formativa e nome + cognome del responsabile
SELECT af.codice, af.nome, i.canale, i.anno_accademico, CONCAT(d.nome, ' ', d.cognome) as responsabile
FROM attiva as a JOIN istanza_attivita_formativa as i 
    ON a.attivita_formativa = i.attivita_formativa 
        AND a.canale = i.canale 
        AND a.anno_accademico = i.anno_accademico 
        AND a.responsabile = i.responsabile
JOIN attivita_formativa as af ON i.attivita_formativa = af.codice
JOIN docente as d ON i.responsabile = d.matricola
WHERE a.coorte = 2015 and a.corso_laurea = 'IN0508'
ORDER BY i.anno_accademico ASC;

-- Dati il codice di una attivita' formativa, il canale, l'anno accademico e il responsabile ritorna i dettagli dell'attivita' formativa
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

-- Dati un percorso e il codice di una attivita' formativa, controlla che una attivita' formativa sia proposta dal percorso. Tale funzione è utilizzata a livello applicativo per controllare che sia possibile attivare un corso per un percorso.

SELECT COUNT(*)
FROM propone as p 
WHERE p.corso_laurea = cod_corso
  AND p.coorte = coorte
  AND p.curriculum = curriculum
  AND p.attivita_formativa = cod_attivita_formativa;

-- dato una scuola e un tipo (LT/LM/CU) elencare i corsi di laurea
SELECT c.codice, c.nome, c.ordinamento, c.cfu
FROM corso_laurea AS c
WHERE c.scuola = 'IN' AND c.tipo = 'LT';

-- dato un corso di laurea elencare le classi di appartenenza
SELECT cl.codice, cl.descrizione
FROM classe AS cl
JOIN appartiene AS a ON cl.codice = a.classe
WHERE a.corso_laurea = 'IN2374';