pipeline {
    agent any
    tools {
        maven "maven 3.6"
        sonar "SonarQube"
    }
    stages {
        stage('Build') {
           steps{
              // Run the maven build
              sh "mvn clean package"
           }
        }
         stage('Checkstyle') {
           steps{
              // Run the maven build with checkstyle
              sh "mvn clean package checkstyle:checkstyle"
           }
        }
        stage('Sonarqube') {
            environment {
                scannerHome = tool 'SonarQubeScanner'
            }
            steps {
                   withSonarQubeEnv('sonarqube') {
                     sh "${scannerHome}/bin/sonar-scanner"
                   }
                   timeout(time: 10, unit: 'MINUTES') {
                      waitForQualityGate abortPipeline: true
                   }
            }
        }
    }
}
