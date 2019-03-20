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

-- Dati un percorso e il codice di una attivita' formativa, controlla che una attivita' formativa sia proposta dal percorso. Tale funzione è utilizzata a livello applicativo per controllare che sia possibile attivare un corso per un percorso.

SELECT COUNT(*)
FROM propone as p 
WHERE p.corso_laurea = cod_corso
  AND p.coorte = coorte
  AND p.curriculum = curriculum
  AND p.attivita_formativa = cod_attivita_formativa;

-- dato una scuola e un tipo (LT/LM/CU) elencare i corsi di laurea e le loro classi di appartenenza
SELECT 
FROM corso_laurea AS c
LEFT JOIN appartiene AS a ON c.codice = a.corso_laurea
LEFT JOIN classe as cl ON cl.codice = a.classe
WHERE 