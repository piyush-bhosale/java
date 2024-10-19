pipeline {
    agent any

    tools {
        maven 'Maven'  // Make sure Maven is installed on Jenkins
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/your-username/my-java-app.git', branch: 'main'
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

        stage('Package') {
            steps {
                sh 'mvn package'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying the application...'
                // Placeholder for real deployment logic (e.g., copying to a server)
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

