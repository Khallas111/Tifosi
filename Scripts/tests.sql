-- Tests de verification de la base tifosi

USE tifosi;

-- ------------------------------------------------------------
-- Requete 1
--
-- But : afficher la liste des noms des focaccias par ordre alphabetique croissant.
--
-- Resultat attendu :
-- Americaine
-- Emmentalaccia
-- Gorgonzollaccia
-- Hawaienne
-- Mozaccia
-- Paysanne
-- Raclaccia
-- Tradizione
--
-- Resultat obtenu :
-- Americaine
-- Emmentalaccia
-- Gorgonzollaccia
-- Hawaienne
-- Mozaccia
-- Paysanne
-- Raclaccia
-- Tradizione
--
-- Commentaire : aucun ecart attendu.
SELECT nom
FROM focaccia
ORDER BY nom ASC;

-- ------------------------------------------------------------
-- Requete 2
--
-- But : afficher le nombre total d'ingredients.
--
-- Resultat attendu :
-- 25
--
-- Resultat obtenu :
-- 25
--
-- Commentaire : aucun ecart attendu.
SELECT COUNT(*) AS nombre_total_ingredients
FROM ingredient;

-- ------------------------------------------------------------
-- Requete 3
--
-- But : afficher le prix moyen des focaccias.
--
-- Resultat attendu :
-- 10.38
--
-- Resultat obtenu :
-- 10.38
--
-- Commentaire : la moyenne exacte est 10.375, arrondie ici a 10.38.
SELECT ROUND(AVG(prix), 2) AS prix_moyen_focaccias
FROM focaccia;

-- ------------------------------------------------------------
-- Requete 4
--
-- But : afficher la liste des boissons avec leur marque, triee par nom de boisson.
-- 
-- Resultat attendu :
-- Capri-sun | Coca-cola
-- Coca-cola original | Coca-cola
-- Coca-cola zero | Coca-cola
-- Eau de source | Cristalline
-- Fanta citron | Coca-cola
-- Fanta orange | Coca-cola
-- Lipton Peach | Pepsico
-- Lipton zero citron | Pepsico
-- Monster energy ultra blue | Monster
-- Monster energy ultra gold | Monster
-- Pepsi | Pepsico
-- Pepsi Max Zero | Pepsico
--
-- Resultat obtenu :
-- Capri-sun | Coca-cola
-- Coca-cola original | Coca-cola
-- Coca-cola zero | Coca-cola
-- Eau de source | Cristalline
-- Fanta citron | Coca-cola
-- Fanta orange | Coca-cola
-- Lipton Peach | Pepsico
-- Lipton zero citron | Pepsico
-- Monster energy ultra blue | Monster
-- Monster energy ultra gold | Monster
-- Pepsi | Pepsico
-- Pepsi Max Zero | Pepsico
--
-- Commentaire : aucun ecart attendu.
SELECT b.nom AS boisson, m.nom AS marque
FROM boisson b
JOIN marque m ON m.id_marque = b.id_marque
ORDER BY b.nom ASC;

-- ------------------------------------------------------------
-- Requete 5
--
-- But : afficher la liste des ingredients pour une Raclaccia.
-- 
-- Resultat attendu :
-- Ail
-- Base Tomate
-- Champignon
-- Cresson
-- Parmesan
-- Poivre
-- Raclette
--
-- Resultat obtenu :
-- Ail
-- Base Tomate
-- Champignon
-- Cresson
-- Parmesan
-- Poivre
-- Raclette
--
-- Commentaire : aucun ecart attendu.
SELECT i.nom AS ingredient
FROM focaccia f
JOIN comprend c ON c.id_focaccia = f.id_focaccia
JOIN ingredient i ON i.id_ingredient = c.id_ingredient
WHERE f.nom = 'Raclaccia'
ORDER BY i.nom ASC;

-- ------------------------------------------------------------
-- Requete 6
--
-- But : afficher le nom et le nombre d'ingredients pour chaque focaccia.
-- 
-- Resultat attendu :
-- Americaine | 8
-- Emmentalaccia | 7
-- Gorgonzollaccia | 8
-- Hawaienne | 9
-- Mozaccia | 10
-- Paysanne | 12
-- Raclaccia | 7
-- Tradizione | 9
--
-- Resultat obtenu :
-- Americaine | 8
-- Emmentalaccia | 7
-- Gorgonzollaccia | 8
-- Hawaienne | 9
-- Mozaccia | 10
-- Paysanne | 12
-- Raclaccia | 7
-- Tradizione | 9
--
-- Commentaire : aucun ecart attendu.
SELECT f.nom, COUNT(c.id_ingredient) AS nombre_ingredients
FROM focaccia f
LEFT JOIN comprend c ON c.id_focaccia = f.id_focaccia
GROUP BY f.id_focaccia, f.nom
ORDER BY f.nom ASC;

-- ------------------------------------------------------------
-- Requete 7
--
-- But : afficher le nom de la focaccia qui a le plus d'ingredients.
-- 
-- Resultat attendu :
-- Paysanne | 12
--
-- Resultat obtenu :
-- Paysanne | 12
--
-- Commentaire :  aucun ecart attendu.
SELECT resultat.nom, resultat.nombre_ingredients
FROM (
    SELECT f.nom, COUNT(c.id_ingredient) AS nombre_ingredients
    FROM focaccia f
    JOIN comprend c ON c.id_focaccia = f.id_focaccia
    GROUP BY f.id_focaccia, f.nom
) AS resultat
WHERE resultat.nombre_ingredients = (
    SELECT MAX(compte.nombre_ingredients)
    FROM (
        SELECT COUNT(c2.id_ingredient) AS nombre_ingredients
        FROM focaccia f2
        JOIN comprend c2 ON c2.id_focaccia = f2.id_focaccia
        GROUP BY f2.id_focaccia
    ) AS compte
);

-- ------------------------------------------------------------
-- Requete 8
--
-- But : afficher la liste des focaccias qui contiennent de l'ail.
-- 
-- Resultat attendu :
-- Gorgonzollaccia
-- Mozaccia
-- Paysanne
-- Raclaccia
--
-- Resultat obtenu :
-- Gorgonzollaccia
-- Mozaccia
-- Paysanne
-- Raclaccia
--
-- Commentaire : aucun ecart attendu.
SELECT DISTINCT f.nom
FROM focaccia f
JOIN comprend c ON c.id_focaccia = f.id_focaccia
JOIN ingredient i ON i.id_ingredient = c.id_ingredient
WHERE i.nom = 'Ail'
ORDER BY f.nom ASC;

-- ------------------------------------------------------------
-- Requete 9
--
-- But : afficher la liste des ingredients inutilises.
-- 
-- Resultat attendu :
-- Salami
-- Tomate cerise
--
-- Resultat obtenu :
-- Salami
-- Tomate cerise
--
-- Commentaire : aucun ecart attendu.
SELECT i.nom
FROM ingredient i
LEFT JOIN comprend c ON c.id_ingredient = i.id_ingredient
WHERE c.id_ingredient IS NULL
ORDER BY i.nom ASC;

-- ------------------------------------------------------------
-- Requete 10
--
-- But : afficher la liste des focaccias qui n'ont pas de champignons.
-- 
-- Resultat attendu :
-- Americaine
-- Hawaienne
--
-- Resultat obtenu :
-- Americaine
-- Hawaienne
--
-- Commentaire : aucun ecart attendu.
SELECT f.nom
FROM focaccia f
WHERE NOT EXISTS (
    SELECT 1
    FROM comprend c
    JOIN ingredient i ON i.id_ingredient = c.id_ingredient
    WHERE c.id_focaccia = f.id_focaccia
      AND i.nom = 'Champignon'
)
ORDER BY f.nom ASC;
