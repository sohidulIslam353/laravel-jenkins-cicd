pipeline {
    agent any
    stages {
        stage('Check PHP and Composer Installation') {
            steps {
                sh 'which php'
                sh 'php -v'
                sh 'which composer'
                sh 'composer -V'
            }
        }
    }
}
