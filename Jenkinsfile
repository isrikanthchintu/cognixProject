pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "cognix-app:${env.BUILD_NUMBER}"
        DOCKER_HUB = "<your-dockerhub-username>/cognix-app"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/isrikanthchintu/cognixProject.git',
                    credentialsId: 'github-credentials'
            }
        }

        stage('Build & Test Docker Image') {
            steps {
                echo "Building Docker image and running tests..."
                sh "docker build -t $DOCKER_IMAGE ."
                # Tests already run in Dockerfile via `mvn package` stage
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "Pushing Docker image to Docker Hub..."
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker tag $DOCKER_IMAGE $DOCKER_HUB:${env.BUILD_NUMBER}"
                    sh "docker push $DOCKER_HUB:${env.BUILD_NUMBER}"
                }
            }
        }
    }

    post {
        success {
            echo '✅ Build, tests passed, Docker image pushed!'
        }
        failure {
            echo '❌ Build or tests failed!'
        }
    }
}
