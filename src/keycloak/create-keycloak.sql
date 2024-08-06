-- Create the keycloak database
CREATE DATABASE keycloak;
CREATE USER keycloak WITH PASSWORD '${HOMEKUBE_PG_PASSWORD}';
GRANT ALL PRIVILEGES ON DATABASE keycloak TO keycloak;
