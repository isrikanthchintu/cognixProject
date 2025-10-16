pipeline {
    agent any

    environment {
        APP_ENV = "production"
        PATH = "/usr/local/bin:${env.PATH}" // Ensure docker is in PATH
        IMAGE_NAME = "cognix-app"
        IMAGE_TAG = "latest"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "📥 Checking out the code..."
                git branch: 'main',
                    url: 'https://github.com/isrikanthchintu/cognixProject.git',
                    credentialsId: 'github-credentials'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Building Docker image with tests..."
                // This builds the image and runs `mvn clean install` inside it (as per your Dockerfile)
                sh """
                    /usr/local/bin/docker build --pull --no-cache -t ${IMAGE_NAME}:${IMAGE_TAG} .
                """
                script {
                    // Tag the image with the commit SHA for traceability (optional)
                    def commitSha = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    sh "/usr/local/bin/docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:${commitSha}"
                    env.DOCKER_TAG = commitSha
                }
            }
        }

        stage('Run Tests in Docker') {
            steps {
                echo "🧪 Running tests inside Docker container..."
                // Run the JAR inside the container or run tests explicitly (if needed)
                sh """
                    /usr/local/bin/docker run --rm ${IMAGE_NAME}:${IMAGE_TAG} java -jar app.jar
                """
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

        // ❌ Removed Push Docker Image stage
    }

    post {
        success {
            echo "✅ Build and tests completed successfully! (Image stored locally only)"
        }
        failure {
            echo "❌ Build or tests failed. Check logs!"
        }
    }
}
