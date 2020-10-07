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


## Droits

grant usage on schema referentiel to viewer_all_schema_ro;
grant select on all tables in schema referentiel to viewer_all_schema_ro;
alter default privileges in schema referentiel grant select on tables to viewer_all_schema_ro;

grant usage on schema agr to agriculture_ro;
grant select on all tables in schema agr to agriculture_ro;
alter default privileges in schema agr grant select on tables to agriculture_ro;

## Utilisateurs

create user referentiel_viewer with password 'carto' nosuperuser nocreatedb nocreaterole inherit;
