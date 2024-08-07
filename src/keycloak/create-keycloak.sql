-- Create the keycloak database
CREATE DATABASE keycloak;
CREATE ROLE keycloak_role VALID UNTIL 'infinity';
CREATE ROLE keycloak LOGIN PASSWORD '${HOMEKUBE_PG_PASSWORD}' VALID UNTIL 'infinity';

GRANT keycloak_role TO keycloak;
GRANT ALL ON SCHEMA public TO admin;
GRANT USAGE on SCHEMA public to keycloak_role;
