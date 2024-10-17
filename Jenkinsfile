pipeline {
    agent any
    stages {
        stage("Verify Docker Setup") {
            steps {
                sh '''
                    docker info
                    docker version
                '''
            }
        }
    }
    post {
        success {
            echo 'Build succeeded!'
        }
        always {
            echo 'Cleaning up after build...'
        }
    }
}
