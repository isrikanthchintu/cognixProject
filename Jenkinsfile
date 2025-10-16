pipeline {
    agent any

    environment {
        APP_ENV = "production"
        PATH = "/usr/local/bin:${env.PATH}" // Ensure docker is in PATH
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
                // Pull base images without credentials, build image
                sh '/usr/local/bin/docker build --pull --no-cache -t cognix-app:latest .'
            }
        }

        stage('Run Tests in Docker') {
            steps {
                echo "Running tests inside Docker container..."
                // Run container, build & test inside, remove container after run
                sh '/usr/local/bin/docker run --rm cognix-app:latest ./mvnw test'
            }
            post {
                always {
                    // If Maven generates surefire reports, archive them
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }
    }

    post {
        success {
            echo "✅ Build and tests completed successfully!"
        }
        failure {
            echo "❌ Build or tests failed. Check logs!"
        }
    }
}
