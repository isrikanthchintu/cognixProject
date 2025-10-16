pipeline {
    agent any

    environment {
        APP_NAME = "cognix-app"
        IMAGE_TAG = "latest"
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out the code...'
                git branch: 'main',
                    url: 'https://github.com/isrikanthchintu/cognixProject.git',
                    credentialsId: 'github-credentials'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                // Build the Docker image
                sh "docker build -t ${env.APP_NAME}:${env.IMAGE_TAG} ."
                // Tests can already be run during Docker build if Maven runs tests in Dockerfile
            }
        }

        stage('Run Tests in Docker') {
            steps {
                echo 'Running tests inside Docker container...'
                // Run the container and execute Maven tests
                sh """
                   docker run --rm \
                   -v \$(pwd):/app \
                   -w /app \
                   ${env.APP_NAME}:${env.IMAGE_TAG} \
                   ./mvnw test
                   """
            }
            post {
                always {
                    // Capture JUnit reports if your Maven project generates them
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }
    }

    post {
        success {
            echo '✅ Docker build and tests completed successfully!'
        }
        failure {
            echo '❌ Build or tests failed. Check the logs!'
        }
    }
}
