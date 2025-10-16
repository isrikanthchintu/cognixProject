pipeline {
    agent any

    environment {
        APP_ENV = "production"
    }

    stages {

        stage('Checkout') {
            steps {
                // Pull code from GitHub
                git branch: 'main',
                    url: 'https://github.com/isrikanthchintu/cognixProject.git',
                    credentialsId: 'github-credentials'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the application...'
                // Maven clean and package
                sh './mvnw clean package'
            }
        }

        stage('Test') {
            steps {
                echo 'Running unit tests...'
                // Maven test
                sh './mvnw test'
            }
            post {
                always {
                    // Record test results
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }
    }

    post {
        success {
            echo '✅ Build and Tests completed successfully!'
        }
        failure {
            echo '❌ Build or Tests failed. Check logs in Jenkins.'
        }
    }
}
