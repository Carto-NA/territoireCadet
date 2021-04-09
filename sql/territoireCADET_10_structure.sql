/* TERRITOIRE CADET V1.0 */
/* Creation de la structure des données (tables, séquences, triggers,...) */
/* territoire_cadet_10_structure.sql */
/* PostgreSQL/PostGIS */
/* Conseil régional Nouvelle-Aquitaine - https://cartographie.nouvelle-aquitaine.fr/ */
/* Auteur : Tony VINCENT */


------------------------------------------------------------------------
-- Table: met_pat.m_pat_lycee_p_construction

--DROP TABLE met_pat.m_pat_lycee_p_construction;


------------------------------------------------------------------------
------------------------------------------------------------------------
-- Trigger
CREATE OR REPLACE FUNCTION referentiel.create_ign_ade_territoire_cadet() RETURNS TRIGGER AS $create_ign_ade_territoire_cadet$
BEGIN
	-- On vide la table
	TRUNCATE TABLE referentiel.ign_ade_territoire_cadet; 
	-- 
	INSERT INTO referentiel.ign_ade_territoire_cadet(code_cadet, nom_cadet, shape)    
		SELECT a.code_cadet, a.nom_cadet, ST_Union(b.shape) AS shape
		FROM 
    		referentiel.ign_ade_epci b
    	INNER JOIN
    		referentiel.na_territoire_cadet a
		ON 
    		b.code_epci = a.siren_epci
		GROUP BY a.code_cadet, a.nom_cadet;    
    RETURN NULL; -- le résultat est ignoré car il s'agit d'un trigger AFTER
END;
$create_ign_ade_territoire_cadet$ language plpgsql;

DROP TRIGGER IF EXISTS create_ign_ade_territoire_cadet ON referentiel.na_territoire_cadet;
CREATE TRIGGER create_na_territoire_cadet
AFTER INSERT OR UPDATE OR DELETE ON referentiel.na_territoire_cadet
FOR EACH ROW
  EXECUTE PROCEDURE referentiel.create_na_territoire_cadet();
