pipeline {
    agent any

    environment {
        PATH = "/usr/local/bin:${env.PATH}"
        DOCKERHUB_REPO = 'yourdockerhubusername/cognix-app'
        DOCKERHUB_CREDENTIALS = 'docker-hub-credentials'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/isrikanthchintu/cognixProject.git',
                    credentialsId: 'github-credentials'
            }
        }

        stage('Build Docker Image (includes tests)') {
            steps {
                sh "/usr/local/bin/docker build -t ${DOCKERHUB_REPO}:latest ."
            }
        }

        stage('Push Docker Image') {
            when {
                expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: DOCKERHUB_CREDENTIALS, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '/usr/local/bin/docker login -u $DOCKER_USER -p $DOCKER_PASS'
                    sh "/usr/local/bin/docker push ${DOCKERHUB_REPO}:latest"
                }
            }
        }
    }

    post {
        success {
            echo "✅ Build, tests (inside Docker), and push completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed. Check logs!"
        }
    }
}
