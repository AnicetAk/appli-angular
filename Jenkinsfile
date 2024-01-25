pipeline {
  agent {
    label 'jenkins-agent-jdk17-nodejs18.18.2-docker-alpine'
  }
  environment {
    DOCKER_REGISTRY_CREDENTIALS = credentials('DOCKER_REGISTRY_CREDENTIALS')
    SERVER_USER = credentials('OP_SERVER_USER')
    SERVER_HOST = credentials('OP_SERVER_HOST')
    SSH_PORT = credentials('OP_SSH_PORT')
    NPM_CACHE_PATH = '/home/jenkins/.npm'
    DOCKER_REGISTRY = "registry.nticagileconsulting.fr"
    DIR = "/home/operantic/projettest/angular-front"
  }
  stages {
    stage('Install dependencies') {
      steps {
        sh "export npm_config_cache=${NPM_CACHE_PATH}"
        sh "npm install --cache ${NPM_CACHE_PATH}"
      }
    }
    stage('Test App') {
      steps {
        sh 'npm run test:ci'
      }
    }
    stage('Lint App') {
      steps {
        sh 'npm run lint:fix'
      }
    }
    stage('Build & release App') {
      steps {
        script {
          env.IMAGE_NAME = sh(script: 'echo $DOCKER_REGISTRY/feat-angular-front:$(date +%s)', returnStdout: true).trim()
          env.CONST_IMAGE_NAME = "FEAT_IMAGE_NAME"
          env.SERVICE_NAME = "feat-angular-front"
          if (env.BRANCH_NAME.startsWith('dev')) {
            env.IMAGE_NAME = sh(script: 'echo $DOCKER_REGISTRY/dev-angular-front:$(date +%s)', returnStdout: true).trim()
            env.CONST_IMAGE_NAME = "DEV_IMAGE_NAME"
            env.SERVICE_NAME = "dev-angular-front"
          }
          sh 'chmod +x ci-cd/build_and_release'
          sh 'bash ci-cd/build_and_release'
        }
      }
    }
    stage('Deploy App') {
      agent {
        label 'jenkins-agent-openssh-alpine'
      }
      steps {
        sshagent(credentials: ['OP_SERVER_SSH_CREDENTIALS']) {
          sh 'chmod +x ci-cd/deploy'
          sh 'bash ci-cd/deploy'
        }
      }
    }
  }
}
