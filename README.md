# territoireCadet
Territoire CADET en Nouvelle-Aquitaine


## Vue
drop view agr.agr_bettrave_na_geo;
CREATE OR REPLACE VIEW agr.agr_bettrave_na_geo
AS SELECT row_number() OVER () AS objectid, t1.numcadet,
    t1.nomcadet,
    t1.date_creation,
    t1.date_maj,
    st_union(t2.shape) AS shape
   FROM agr.agr_bettrave_na t1,
    referentiel.ign_ade_epci t2
  WHERE t1.numepci::text = t2.code_epci::text
  GROUP BY t1.numcadet, t1.nomcadet, t1.date_creation, t1.date_maj;
