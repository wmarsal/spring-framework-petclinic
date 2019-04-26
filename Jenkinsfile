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
            #when {
            #    branch 'master'
           # }
            parallel {
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
                }
            }
        }
    }

