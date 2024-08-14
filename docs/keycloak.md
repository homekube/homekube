
Create DB and users
```
envsubst < create-keycloak.sql | kubectl exec psql-0 -i -n postgres -- psql -U admin -d postgres
```
Console
```
kubectl exec psql-0 -it -n postgres -- psql -U admin -d postgres
```
Drop DB and users
```
envsubst < drop-keycloak.sql | kubectl exec psql-0 -i -n postgres -- psql -U admin -d postgres
```


## Create a realm for Homekube

=> Switch to Homekube realm

## Create users
admin-user
simple-user
demo

Enable "Email verified"

### Create passwords
disable "Temporary"

## Create client
homekube-client

## Create groups
- admins
- demo
- readonly

## Client scope add "groups"

