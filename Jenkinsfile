pipeline {
    agent any

    environment {
        APP_ENV = "production"
        PATH = "/usr/local/bin:${env.PATH}" // Ensure docker is in PATH
        DOCKERHUB_CREDENTIALS = 'docker-hub-credentials'
        DOCKERHUB_REPO = 'yourdockerhubusername/cognix-app' // Change to your Docker Hub repo
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Checking out the code..."
                git branch: 'main',
                    url: 'https://github.com/isrikanthchintu/cognixProject.git',
                    credentialsId: 'github-credentials'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                // Tag image with 'latest' first
                sh '/usr/local/bin/docker build --pull --no-cache -t ${DOCKERHUB_REPO}:latest .'
                // Tag image with commit SHA
                script {
                    def commitSha = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    sh "/usr/local/bin/docker tag ${DOCKERHUB_REPO}:latest ${DOCKERHUB_REPO}:${commitSha}"
                    env.DOCKER_TAG = commitSha
                }
            }
        }

        stage('Run Tests in Docker') {
            steps {
                echo "Running tests inside Docker container..."
                sh '/usr/local/bin/docker run --rm ${DOCKERHUB_REPO}:latest ./mvnw test'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('Push Docker Image') {
            when {
                expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
            }
            steps {
                echo "Logging in and pushing Docker image to Docker Hub..."
                withCredentials([usernamePassword(credentialsId: DOCKERHUB_CREDENTIALS, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '/usr/local/bin/docker login -u $DOCKER_USER -p $DOCKER_PASS'
                    sh '/usr/local/bin/docker push ${DOCKERHUB_REPO}:latest'
                    sh '/usr/local/bin/docker push ${DOCKERHUB_REPO}:${DOCKER_TAG}'
                }
            }
        }
    }

    post {
        success {
            echo "✅ Build, tests, and Docker push completed successfully!"
        }
        failure {
            echo "❌ Build, tests, or Docker push failed. Check logs!"
        }
    }
}
