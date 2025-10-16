pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/isrikanthchintu/cognixProject.git',
                    credentialsId: 'github-credentials'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh '/usr/local/bin/docker build -t cognix-app:latest .'
            }
        }

        stage('Run Tests in Docker') {
            steps {
                echo 'Running tests inside Docker...'
                sh '/usr/local/bin/docker run --rm cognix-app:latest ./mvnw test'
            }
        }
    }

    post {
        success {
            echo '✅ Build and tests completed successfully!'
        }
        failure {
            echo '❌ Build or tests failed. Check logs!'
        }
    }
}
