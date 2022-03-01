#!/bin/bash
echo "Carrying out Flyway Build Tasks"
echo "The migrations directory is ${env.flywayLocations}"
flyway clean migrate info "-url=jdbc:sqlserver://database-1.cjwkywqzgyd0.ap-south-1.rds.amazonaws.com:1433;databaseName=AdventureWorks_Build" '-locations=/var/lib/jenkins/workspace/AdventureWorks_Flyway_main/Test/migrations' "-user=admin" "-password=admin1234"