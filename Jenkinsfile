pipeline {
    agent any 
    options {
        timeout(time: 2, unit: 'HOURS')
        buildDiscarder(logRotator(numToKeepStr: '100'))
    }
     stages {
        stage('Building AMIs'){
            steps{
                Cleanup()
		        checkout scm
		        sh "git clean -xdf"
                sh '''
                cd terraform
                ls -l
                ls -l Scripts-elk
                ARTIFACT_API=`packer build -machine-readable packer-ami-api.json  |awk -F, '\$0 ~/artifact,0,id/ {print \$6}'`
                AMI_ID_API=`echo \$ARTIFACT_API | cut -d ':' -f2`
                echo 'variable "API_INSTANCE_AMI" { default = "'\${AMI_ID_API}'" }' > amivar_api.tf
                ARTIFACT_WEB=`packer build -machine-readable packer-ami-web.json  |awk -F, '\$0 ~/artifact,0,id/ {print \$6}'`
                AMI_ID_WEB=`echo \$ARTIFACT_WEB | cut -d ':' -f2`
                echo 'variable "WEB_INSTANCE_AMI" { default = "'\${AMI_ID_WEB}'" }' > amivar_web.tf
                '''
            }
        }
        stage('Deploying Stack') {
            environment { 
                RDS_PASSWORD = credentials('RDS_PASSWORD')
            }
            steps {
                echo 'Creating plan'
                sh '''
                set +x
                cd terraform
                terraform init --reconfigure
                terraform plan
                terraform apply --auto-approve -var RDS_PASSWORD=\$RDS_PASSWORD
                echo "Running Invalidation for Cloudfront"
                aws cloudfront create-invalidation --distribution-id `terraform output -raw WEB-CDN-ID` --paths "/*"
                '''
            }
        }
    }

    post {
        always {
            node('') { // Allocates any node that is available.
                echo "Do e.g. cleanup steps here"
            }
        }
    }
}

def Cleanup() {
	echo "Cleaning up"
	sh """#!/bin/bash
		rm -rf *
		rm -rf .*
		ls -a
	"""
	echo "End of cleanup"
}