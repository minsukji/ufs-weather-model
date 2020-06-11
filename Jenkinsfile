pipeline {
  agent any

  stages {
    stage('Build image') {
      steps {
        sh '''
          printf '{\n    "experimental": true\n}' \
          | sudo tee /etc/docker/daemon.json >/dev/null
          sudo systemctl restart docker
          sleep 10
        '''
        sh 'cd tests && ./ci.sh -b -c restart'
      }

    }

    stage('Free up space') {
      steps {
        sh 'docker image ls'
        sh 'docker rmi $(docker image ls | grep -E -m1 '<none>' | awk '{ print $3 }')'
        sh 'docker rmi $(docker image ls | awk '/fv3-input-data/ { print $3 }')'
        sh 'docker rmi $(docker image ls | awk '/ci-test-base/ { print $3 }')'
        sh 'docker image ls'
      }
    }

    stage('Run image') {
      steps {
        sh 'cd tests && ./ci.sh -r'
      }
    }
  }
