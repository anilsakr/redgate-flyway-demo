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
	FLYWAY_LICENSE_KEY="FL015946F4D99D897B90C5721A6C7EB30461746CDBAA2613D26C5157D4F04BC837ACABDCED3C485F48776C5F7D528E12B962F5BB6EDBF9C3E5D87D3C31D5C1498A5538CF64139BFC5143D53B9946AC28145B01F3F3B1777D6EE4CBC2281FD1460868D2ACD305EBAF854F2FF2AFD04EBF32A4CA765E7C0ECD46B124F90782DC088E24EBF19C69DED86B30C909F37B9D0B115B5F4A792CF441A7C0019246AEFCCA922621EC372FB1D16DE1F1F084F19720637ED719EB13FB6D6FDC752985F54B58919FA8B92B10DBB5E9DEA0B6D03523A967C7179710CEAE5B7EC3023A102DBA79C3C285E4078D321E31138BCF1340C96CE7E7EAAB5EEF279C48A4A1E4B083F752A940"
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

							echo "This is the Flyway Command About to Run: flyway info '${env.flywayJDBC}' '${env.flywayLocations}' '-user=${env.databaseUsername}' '-password=${env.databasePassword}'"

							cd '${env.buildDirectory}/Test'

							flyway info '${env.flywayJDBC}' '${env.flywayLocations}' '-user=${env.databaseUsername}' '-password=${env.databasePassword}'
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
            steps {
                echo 'Carrying Out Production Migration Activities'
						
								echo "Current stage is - ${env.STAGE_NAME}"
								
								echo "Running Flyway Production Script"
				
				script 	{			

						echo "Running Flyway Build Using Username and Password"
						def buildStatus 
						buildStatus = sh(returnStatus: true, label: "Run Flyway Production Process Against: ${env.DatabaseName}", script: """#!/bin/bash

							echo "This is the Flyway Command About to Run: flyway migrate info '${env.flywayJDBC}' '${env.flywayLocations}' '-user=${env.databaseUsername}' '-password=${env.databasePassword}'"

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
