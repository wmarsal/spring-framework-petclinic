pipeline {
    agent any
    tools {
        maven "maven 3.6"
    }
    options {
        parallelsAlwaysFailFast()
    }
    stages {
        stage('Non-Parallel Stage') {
            steps {
                echo 'This stage will be executed first.'
            }
        }
        stage('Parallel Stage') {
            parallel {
                   stage('Run Test image') {
                        steps{
                            sh "docker stop petclinic-test && docker rm petclinic-test"
                            sh "docker run -d --name petclinic-test -p 8090:8080 petclinic-project"
                         }
                     }
                    stage('Run uat image') {
                        steps {
                            sh "docker stop petclinic-uat && docker rm petclinic-uat"
                            sh 'docker run -d --name petclinic-uat -p 8090:8080 petclinic-project'
                         }
                    }
            }
        }
    }
}
