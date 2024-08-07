-- Create the keycloak database
CREATE DATABASE keycloak;
CREATE ROLE keycloak_role VALID UNTIL 'infinity';
CREATE ROLE keycloak LOGIN PASSWORD '${HOMEKUBE_PG_PASSWORD}' VALID UNTIL 'infinity';

GRANT keycloak_role TO keycloak;
GRANT ALL PRIVILEGES ON DATABASE keycloak TO keycloak_role;

-- Switch to keycloak db to grant all privileges on db level to keycloak_user
\c keycloak -U admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO keycloak_role;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO keycloak_role;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO keycloak_role;
GRANT ALL PRIVILEGES ON ALL PROCEDURES IN SCHEMA public TO keycloak_role;

GRANT USAGE ON SCHEMA public TO keycloak_role;
GRANT CREATE ON SCHEMA public TO keycloak_role;
