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
        // Example for Node.js
        sh 'npm install'
        // or Maven: sh 'mvn clean install'
        // or Gradle: sh './gradlew build'
      }
    }

    stage('Test') {
      steps {
        echo 'Running unit tests...'
        sh 'npm test' 
        // or sh 'mvn test'
      }
      post {
        always {
          junit 'reports/**/*.xml' // optional if you generate test reports
        }
      }
    }

    stage('Deploy') {
      steps {
        echo "Deploying to ${env.APP_ENV} environment..."
        // Example deployment:
        sh 'scp -r ./dist user@server:/var/www/html/'
        // or Docker / Kubernetes deployment steps
      }
    }
  }

  post {
    success {
      echo '✅ Build, Test and Deployment completed successfully!'
    }
    failure {
      echo '❌ Build failed. Check logs in Jenkins.'
    }
  }
}
