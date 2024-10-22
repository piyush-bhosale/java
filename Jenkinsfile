pipeline {
    agent any

    tools {
        maven 'Maven'  // Make sure Maven is installed on Jenkins
        jdk 'JDK'
    }
    
    environment {
       SONAR_HOST_URL = 'http://34.230.51.176:9000'
       SONAR_TOKEN = credentials('SonarQube-token')
       IMAGE_NAME = "my-java-app:latest"
       
   }

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/piyush-bhosale/java.git', branch: 'main'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('SonarQube Analysis') {
            steps {
               withSonarQubeEnv('SonarQube') {
                   sh '''
                       mvn sonar:sonar \
                         -Dsonar.projectKey=my-java-app \
                         -Dsonar.host.url=$SONAR_HOST_URL \
                         -Dsonar.login=$SONAR_TOKEN
                   '''
               }
           }
       }

        stage('Package') {
            steps {
                sh 'mvn package'
            }
        }

        stage('Building docker file') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
                sh 'docker ps'
              
            }
        }

        stage('Scan Docker Image with Trivy') {
           steps {
               script {
                   // Run the Trivy scan on the built image
                   sh "trivy image --exit-code 1 --severity HIGH,CRITICAL ${IMAGE_NAME}"
               }
           }
       }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
    }
}
