pipeline {
    agent any
    options { skipDefaultCheckout() }  // disables automatic checkout

    environment {
        APP_ENV = "production"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/isrikanthchintu/cognixProject.git',
                    credentialsId: 'github-credentials'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the application...'
                sh './mvnw clean package'
            }
        }

        stage('Test') {
            steps {
                echo 'Running unit tests...'
                sh './mvnw test'
            }
            post {
                always {
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
