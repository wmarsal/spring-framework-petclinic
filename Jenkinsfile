pipeline {
    agent any
    tools {
        maven "maven 3.6"
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
            steps {
                   withSonarQubeEnv('SonarQube') {
                     sh "mvn  clean package sonar:sonar -Dsonar.host_url=$SONAR_HOST_URL "
                   }
                   timeout(time: 10, unit: 'MINUTES') {
                      waitForQualityGate abortPipeline: true
                   }
            }
        }
    }
}
