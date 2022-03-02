//This is an example Jenkinsfile Declarative Pipeline for Flyway. It has been designed to showcase the power of Jenkins, alongside Flyway, using PowerShell scripts to carry out the actions
//Although this pipeline will require the use of Windows based Jenkins agents, the script logic can be ported to Linux with the use of BASH scripts

pipeline {
    agent any
    environment {
	EXAMPLEVARIABLE = '1.3.0' //Can be used in both this script and PowerShell. Syntax is as follows ${env:EXAMPLEVARIABLE} to use within the PowerShell script
	//buildDirectory = "/var/lib/Redgate/Build/AdventureWorks/Build-${BUILD_NUMBER}" //Directory location for build files to be written to
	buildDirectory = "/home/Redgate/Build/Build-${BUILD_NUMBER}"
	releaseName = "Build_${env.BUILD_NUMBER}"
	PATH = "/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/ec2-user/.local/bin:/home/ec2-user/bin"
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
				databaseUsername = "admin" //Add Username If Applicable
				databasePassword = "admin1234" //Add Password If Applicable. For security, this could be entered within Jenkins credential manager and called.
				flywayJDBC = "-url=jdbc:sqlserver://${env.databaseHost}:${env.databasePort};databaseName=${env.databaseName}" //Add ;integratedSecurity=true to the end of this string if you do not require a Username/Password - Add ;instanceName=$(env.databaseinstance) to the end of this string if you have a named instance you'd like to use
				flywayLocations = "-locations=\"${env.buildDirectory}/Test\"" //This is the location of the local cloned GIT repo. {env.WORKSPACE} refers to the Jenkins Agent workspace area. It might be necessary to add some sub-folders to point to the migrations folder

			}	
            steps {
                echo 'Carrying Out Build Activities'
				
				dir("${env.buildDirectory}") {
						checkout scm //Checkout latest changes from GIT to Build Directory variable, as set in global evironment variable section.
						}
						
				echo "Current stage is - ${env.STAGE_NAME}"
				
				echo "Running Flyway Build Script"
				
				script {				
					if (env.databaseUsername == null ) { //If a Database Username is not passed in as an Environmental Variable, used Integrated Security

					echo "Running Flyway Build Using Intergrated Security"
					def buildStatus //Define Variable to capture script outcome status and assign it below
					buildStatus = sh returnStatus: true, label: "Run Flyway Build Process Against: ${env.DatabaseName}", script: """
						#!/bin/bash
						flyway clean migrate info ${env.flywayJDBC};integratedSecurity=true ${env.flywayLocations}
						"""
				
					echo "Status of Running CI build: $buildStatus"
       				if (buildStatus != 0) { error('Running CI build failed') }


					}

					else {
							 withEnv(['PATH+EXTRA=/usr/local/bin']) {
						echo "Running Flyway Build Using Username and Password"
						def buildStatus 
						buildStatus = sh(returnStatus: true, label: "Run Flyway Build Process Against: ${env.DatabaseName}", script: """
							#!/bin/bash
							echo "The migrations directory is ${env.flywayLocations}"
							cd '${env.buildDirectory}/Test'
							echo "PATH values currently are $PATH"
							flyway -configFiles=\"${env.buildDirectory}/Flyway_Build.conf\" clean migrate info
							""")

						echo "Status of Running CI build: $buildStatus"
						if (buildStatus != 0) { error('Running CI build failed') }
							 }
					}

				}
				
            }
        }	
    }
}
