node {
   stage('Build') {
      checkout scm
      sh 'ls -la'
      def image = docker.build("apavlov123/test-nginx")
      docker.withRegistry("https://index.docker.io/v1/", 'docker-hub'){
         image.push('latest')
      }
   }
   stage('Deploy') {
     withCredentials([
    	[
      		$class: 'StringBinding',
      		credentialsId: 'amazonec2-access-key',
      		variable: 'amazonec2-access-key'
    	],
		[
      		$class: 'StringBinding',
      		credentialsId: 'amazonec2-secret-key',
      		variable: 'amazonec2-secret-key'
    	]
      ])
     {
        //sh "/usr/local/bin/docker-machine create --driver amazonec2 --amazonec2-open-port 80 --amazonec2-region us-west-2 --amazonec2-access-key ${amazonec2-access-key} --amazonec2-secret-key ${amazonec2-secret-key} aws-test-nginx"
        sh '/usr/local/bin/docker-machine ls'
        String dockerServer = sh returnStdout: true, script: '/usr/local/bin/docker-machine ip aws-test-nginx'
        println dockerServer
     } 
     docker.withServer('tcp://172.31.2.216:4243') {
         //sh returnStatus: true, script: 'docker stop test-nginx'
         //sh returnStatus: true, script: 'docker rm test-nginx'
         //sh 'docker run -d --name test-nginx -p 80:80 apavlov123/test-nginx:latest'
      }
   }
}
