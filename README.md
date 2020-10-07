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



=======================

--
grant usage on schema referentiel to viewer_all_schema_ro;
grant select on all tables in schema referentiel to viewer_all_schema_ro;
alter default privileges in schema referentiel grant select on tables to viewer_all_schema_ro;

grant usage on schema agr to agriculture_ro;
grant select on all tables in schema agr to agriculture_ro;
alter default privileges in schema agr grant select on tables to agriculture_ro;

grant usage on schema referentiel to referentiel_viewer;
grant select on all tables in schema referentiel to referentiel_viewer;
alter default privileges in schema referentiel grant select on tables to referentiel_viewer;

grant usage on schema cul to culture_ro;
grant select on all tables in schema cul to culture_ro;
alter default privileges in schema cul grant select on tables to culture_ro;

grant usage on schema env to environnement_ro;
grant select on all tables in schema env to environnement_ro;
alter default privileges in schema env grant select on tables to environnement_ro;

grant usage on schema inf to infrastructure_ro;
grant select on all tables in schema inf to infrastructure_ro;
alter default privileges in schema inf grant select on tables to infrastructure_ro;

-- Création des rôles
create role culture_ro nosuperuser inherit nocreatedb  nocreaterole;
create role economie_ro nosuperuser inherit nocreatedb  nocreaterole;
create role environnement_ro nosuperuser inherit nocreatedb  nocreaterole;
create role infrastructure_ro nosuperuser inherit nocreatedb  nocreaterole;

-- Création des utilisateurs
create user carto_cul with password 'carto' nosuperuser nocreatedb nocreaterole inherit;
create user carto_eco with password 'carto' nosuperuser nocreatedb nocreaterole inherit;
create user carto_env with password 'carto' nosuperuser nocreatedb nocreaterole inherit;
create user carto_inf with password 'carto' nosuperuser nocreatedb nocreaterole inherit;
create user referentiel_viewer with password 'carto' nosuperuser nocreatedb nocreaterole inherit;

-- Ajouter des membres à un rôle
grant culture_ro to carto_cul;
grant economie_ro to carto_eco;
grant environnement_ro to carto_env;
grant infrastructure_ro to carto_inf;

grant viewer_all_schema_ro to carto_cul;
grant viewer_all_schema_ro to carto_eco;
grant viewer_all_schema_ro to carto_env;
grant viewer_all_schema_ro to carto_inf;

-- Supprimer des membres à un rôle
revoke viewer_all_schema_ro from agr;
revoke viewer_all_schema_ro from cul;
revoke viewer_all_schema_ro from eco;
revoke viewer_all_schema_ro from env;
revoke viewer_all_schema_ro from inf;

revoke viewer_all_schema_ro from carto_agr;
revoke viewer_all_schema_ro from carto_env;
