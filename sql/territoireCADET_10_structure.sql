/* TERRITOIRE CADET V1.0 */
/* Creation de la structure des données (tables, séquences, triggers,...) */
/* territoireCADET_10_structure.sql */
/* PostgreSQL/PostGIS */
/* Conseil régional Nouvelle-Aquitaine - https://cartographie.nouvelle-aquitaine.fr/ */
/* Auteur : Tony VINCENT */


------------------------------------------------------------------------
-- Table: referentiel.na_territoire_cadet;

-- DROP TABLE referentiel.na_territoire_cadet;
CREATE TABLE referentiel.na_territoire_cadet (
	objectid int4 NOT NULL,
	code_cadet varchar(20) NULL,
	nom_cadet varchar(122) NULL,
	siren_epci varchar(18) NULL,
	nom_epci varchar(84) NULL
);
CREATE UNIQUE INDEX r567_sde_rowid_uk ON referentiel.na_territoire_cadet USING btree (objectid) WITH (fillfactor='75');

------------------------------------------------------------------------
-- Table: referentiel.na_territoire_cadet;

-- DROP TABLE referentiel.ign_ade_territoire_cadet;
CREATE TABLE referentiel.ign_ade_territoire_cadet (
	objectid int4 NOT NULL,
	code_cadet varchar(20) NULL,
	arcgis_referentiel_na_territo_1 varchar(122) NULL,
	shape sde.st_geometry NULL
);
CREATE INDEX a465_ix1 ON referentiel.ign_ade_territoire_cadet USING gist (shape);
CREATE UNIQUE INDEX r636_sde_rowid_uk ON referentiel.ign_ade_territoire_cadet USING btree (objectid) WITH (fillfactor='75');


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
