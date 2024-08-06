-- Create the keycloak database
CREATE DATABASE keycloak with encoding 'UTF8';
CREATE USER keycloak WITH PASSWORD '${HOMEKUBE_PG_PASSWORD}';
GRANT ALL PRIVILEGES ON DATABASE keycloak TO keycloak;
