# territoireCadet
Territoire CADET en Nouvelle-Aquitaine


## Vue
CREATE OR REPLACE VIEW metier.datar_cadet_na_geo
AS SELECT t1.numcadet,
    t1.nomcadet,
    t1.date_creation,
    t1.date_maj,
    st_union(t2.shape) AS shape
   FROM metier.datar_cadet_na t1,
    referentiel.ign_ade_epci t2
  WHERE t1.numepci::text = t2.code_epci::text
  GROUP BY t1.numcadet, t1.nomcadet, t1.date_creation, t1.date_maj;
