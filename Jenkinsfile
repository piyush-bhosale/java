pipeline {
    agent any

    tools {
        maven 'Maven'  // Make sure Maven is installed on Jenkins
        jdk 'JDK'
    }
    
    environment {
       SONAR_HOST_URL = 'http://34.203.195.30:9000'
       SONAR_TOKEN = credentials('SonarQube-token')
       DOCKERHUB_CREDENTIALS = 'piyushbhosale9226'
       DOCKERHUB_USERNAME = 'piyushbhosale9226'
       IMAGE_NAME = "${DOCKERHUB_USERNAME}/my-java-app:latest"
       ARTIFACTORY_SERVER = 'Jfrog-server'   // Artifactory server ID
       REPO_NAME = 'art-my-repo'              // Repository name
       JAR_FILE = 'target/my-java-app.jar'   // Artifact path
       CREDENTIALS_ID = 'Jfrog-server'  
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
                sh 'mvn clean package'
            }
        }

         stage('Upload to JFrog Artifactory') {
           steps {
               script {
                   def server = Artifactory.server(ARTIFACTORY_SERVER)
                   def uploadSpec = """{
                       "files": [
                           {
                               "pattern": "${JAR_FILE}",
                               "target": "${art-my-repo}/my-java-app/"
                           }
                       ]
                   }"""
                   server.upload(uploadSpec)
               }
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
                   sh "trivy image ${IMAGE_NAME}"
               }
           }
       }
       
       stage('Login to DockerHub') {
           steps {
               script {
                   // Login to DockerHub using credentials stored in Jenkins
                   withCredentials([usernamePassword(credentialsId: 'piyushbhosale9226',
                                                     usernameVariable: 'DOCKER_USER',
                                                     passwordVariable: 'DOCKER_PASS')]) {
                       sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                      }
               }
           }
       }
       stage('Push Docker Image to DockerHub') {
           steps {
               script {
                   // Push the Docker image to DockerHub
                   sh "docker push ${IMAGE_NAME}"
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
