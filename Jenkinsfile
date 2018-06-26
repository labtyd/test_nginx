node {
   def imageName = 'apavlov123/test-nginx'
   def manchineName = 'aws-test-nginx'
   def conatinerName = 'test-nginx'
	
   stage('Build') {
      checkout scm
      sh 'ls -la'
      def image = docker.build("${imageName}")
      docker.withRegistry("https://index.docker.io/v1/", 'docker-hub'){
         image.push('latest')
      }
   }
   stage('Deploy') {
     withCredentials([
    	[
      		$class: 'StringBinding',
      		credentialsId: 'amazonec2-access-key',
      		variable: 'amazonec2_access_key'
    	],
		[
      		$class: 'StringBinding',
      		credentialsId: 'amazonec2-secret-key',
      		variable: 'amazonec2_secret_key'
    	]
      ])
     {
	sh returnStatus: true, script: "/usr/local/bin/docker-machine rm --force -y ${manchineName}"
        sh "/usr/local/bin/docker-machine create --driver amazonec2 --amazonec2-open-port 80 --amazonec2-region eu-west-2 --amazonec2-access-key ${amazonec2_access_key} --amazonec2-secret-key ${amazonec2_secret_key} ${manchineName}"
        
	String listMachines = sh returnStdout: true, script: '/usr/local/bin/docker-machine ls'
	println listMachines
	     
	if (listMachines.contains(manchineName)){
	     	String dockerServer = sh returnStdout: true, script: "/usr/local/bin/docker-machine ip ${manchineName}"
		println "Deploying container ${conatinerName} to ${manchineName}"
		//docker.withServer("tcp://172.31.2.216:4243') {
		sh "/usr/local/bin/docker-machine ssh ${manchineName}"
	     	//sh returnStatus: true, script: "docker stop ${conatinerName}"
             	//sh returnStatus: true, script: "docker rm ${conatinerName}"
	     	sh "docker run -d --name ${conatinerName} -p 80:80 ${imageName}:latest"
      		//}
	} else {
		println "Machine ${manchineName} was not found."
	}
     } 
   }
}
