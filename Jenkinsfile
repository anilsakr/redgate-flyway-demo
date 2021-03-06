//This is an example Jenkinsfile Declarative Pipeline for Flyway. It has been designed to showcase the power of Jenkins, alongside Flyway, using PowerShell scripts to carry out the actions
//Although this pipeline will require the use of Windows based Jenkins agents, the script logic can be ported to Linux with the use of BASH scripts

pipeline {
    agent any
    environment {
	EXAMPLEVARIABLE = '1.3.0' //Can be used in both this script and PowerShell. Syntax is as follows ${env:EXAMPLEVARIABLE} to use within the PowerShell script
	//buildDirectory = "/var/lib/Redgate/Build/AdventureWorks/Build-${BUILD_NUMBER}" //Directory location for build files to be written to
	buildDirectory = "/home/Redgate/Build/Build-${BUILD_NUMBER}"
	releaseName = "Build_${env.BUILD_NUMBER}"
	PATH = "/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/ec2-user/.local/bin:/home/ec2-user/bin:/home/ec2-user/flyway-8.5.1"
	FLYWAY_LICENSE_KEY="FL012036A0544BE0E99868462E0E3B26E68D9192F08BE6633772243EEDFD5BE23476101ACFDD93ABD87D9E3BF027382EC9C556B4870FD6DBC0E9595DD281C81A626E47C40CCB62DE865CD9A60877F5D2DFD30362536BAB8F090AF1765DC392324100B5C916CEFA6B8B78027D9E277C2091E04D78D7E80666E7E8D82F5814D980CF8E7015A169D273FF2DA6788897122FE1980B7B305AC76E8FFC148B702393E7944196993358D66DE212B9FA8E0BA977E5A912902241400DA47656C885F71952151D15F7F8E8EA333301E4B2E7C6F62B5A6D8929E3C7AD9A29667F06B6C97851AFB1B580937C94A5887E1D4D65ED6567D731FA37B9F017B542809B66C4921B526FDF"
       }
	   triggers {
			pollSCM('') // GIT can be polled every minute for changes, simply insert * * * * * - This has been disabled for testing, therefore manually trigger the pipeline run - Best Practice - GIT Repo to inform Jenkins when a PUSH request is made to preferred branch.
		}
stages {
        stage('Build') {
			environment {
				databaseHost = "database-1.cjwkywqzgyd0.ap-south-1.rds.amazonaws.com" //Database Host Address for Build Database
				databasePort = "1433" //Database Port Address for Build Database
				databaseInstance = "" //Optional - Database Instance Address for Build Database
				databaseName = "AdventureWorks_${env.STAGE_NAME}" //Build Database Name - {env.STAGE_NAME} will take the active stage name to append to DB name
				databaseUsername = "admin" //Add Username If Applicable - This is redundant if config file is used
				databasePassword = "admin1234" //Add Password If Applicable. For security, this could be entered within Jenkins credential manager and called. - This is redundant if config file is used
				flywayJDBC = "-url=jdbc:sqlserver://${env.databaseHost}:${env.databasePort};databaseName=${env.databaseName}" //Add ;integratedSecurity=true to the end of this string if you do not require a Username/Password - Add ;instanceName=$(env.databaseinstance) to the end of this string if you have a named instance you'd like to use
				flywayLocations = "-locations=filesystem:migrations" //This is the location of the local cloned GIT repo. {env.WORKSPACE} refers to the Jenkins Agent workspace area. It might be necessary to add some sub-folders to point to the migrations folder

			}	
            steps {
                echo 'Carrying Out Build Activities'
				
				dir("${env.buildDirectory}") {
						checkout scm //Checkout latest changes from GIT to Build Directory variable, as set in global evironment variable section.
						}
						
				echo "Current stage is - ${env.STAGE_NAME}"
				
				echo "Running Flyway Build Script"
				
				script {				

						echo "Running Flyway Build Using Username and Password"
						def buildStatus 
						buildStatus = sh(returnStatus: true, label: "Run Flyway Build Process Against: ${env.DatabaseName}", script: """#!/bin/bash

							echo "Running Flyway Build Commands on: '${env.flywayJDBC}' '${env.flywayLocations}'"

							cd '${env.buildDirectory}/Test'

							flyway clean migrate info '${env.flywayJDBC}' '${env.flywayLocations}' '-user=${env.databaseUsername}' '-password=${env.databasePassword}'
							""")

						echo "Status of Running CI build: $buildStatus"
						if (buildStatus != 0) { error('Running CI build failed') }

				}
				
            }
        }	
			stage('Prod') {
				environment {
					databaseHost = "database-1.cjwkywqzgyd0.ap-south-1.rds.amazonaws.com" //Database Host Address for Build Database
					databasePort = "1433" //Database Port Address for Build Database
					databaseInstance = "" //Optional - Database Instance Address for Build Database
					databaseName = "AdventureWorks_${env.STAGE_NAME}" //Build Database Name - {env.STAGE_NAME} will take the active stage name to append to DB name
					databaseUsername = "admin" //Add Username If Applicable
					databasePassword = "admin1234" //Add Password If Applicable. For security, this could be entered within Jenkins credential manager and called.
					flywayJDBC = "-url=jdbc:sqlserver://${env.databaseHost}:${env.databasePort};databaseName=${env.databaseName}" //Add ;integratedSecurity=true to the end of this string if you do not require a Username/Password - Add ;instanceName=$(env.databaseinstance) to the end of this string if you have a named instance you'd like to use
					flywayLocations = "-locations=filesystem:migrations" //This is the location of the local cloned GIT repo. {env.WORKSPACE} refers to the Jenkins Agent workspace area. It might be necessary to add some sub-folders to point to the migrations folder
					}
				input {
					message "Do you want to proceed for production deployment?"
					}	
				steps {
                echo 'Carrying Out Production Migration Activities'
						
								echo "Current stage is - ${env.STAGE_NAME}"
								
								echo "Running Flyway Production Script"
				
				script 	{			

						echo "Running Flyway Build Using Username and Password"
						def buildStatus 
						buildStatus = sh(returnStatus: true, label: "Run Flyway Production Process Against: ${env.DatabaseName}", script: """#!/bin/bash

							echo "Running Flyway Migrate Commands on: '${env.flywayJDBC}' '${env.flywayLocations}'"

							cd '${env.buildDirectory}/Test'

							flyway migrate info '${env.flywayJDBC}' '${env.flywayLocations}' '-user=${env.databaseUsername}' '-password=${env.databasePassword}'
							""")

						echo "Status of Running CI build: $buildStatus"
						if (buildStatus != 0) { error('Running CI build failed') }

							}
				
            }
        }	
    }
}
