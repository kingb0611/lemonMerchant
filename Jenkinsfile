pipeline {
  agent any

  parameters {
    // Docker & ECS
    string(name: 'DOCKERHUB_REPO', defaultValue: 'kbkn1106/lemonmerchant', description: 'Docker Hub repo (user/repo)')
    string(name: 'AWS_REGION', defaultValue: 'ap-south-1', description: 'AWS region')
    string(name: 'ECS_CLUSTER', defaultValue: 'lemon-cluster', description: 'ECS Cluster name')
    string(name: 'ECS_SERVICE', defaultValue: 'lemon-service', description: 'ECS Service name')
    string(name: 'TASK_FAMILY', defaultValue: 'lemonmerchant', description: 'ECS Task definition family')

    // ECS network configuration
    string(name: 'SUBNET_IDS', defaultValue: 'subnet-0d6a7e801ac724083,subnet-08956fdaa29acf672', description: 'Comma-separated subnet IDs for ECS tasks')
    string(name: 'SECURITY_GROUP_IDS', defaultValue: 'sg-0cc4381d9ea62a731', description: 'Comma-separated Security Group IDs for ECS tasks')
    booleanParam(name: 'ASSIGN_PUBLIC_IP', defaultValue: true, description: 'Assign public IP to ECS tasks?')

    // ALB configuration
    string(name: 'ALB_SUBNET_IDS', defaultValue: 'subnet-0d6a7e801ac724083,subnet-08956fdaa29acf672', description: 'Comma-separated public subnet IDs for ALB')
    string(name: 'ALB_SECURITY_GROUP_IDS', defaultValue: 'sg-0cc4381d9ea62a731', description: 'Comma-separated security group IDs for ALB')
    
    // VPC
    string(name: 'VPC_ID', defaultValue: 'vpc-08bb20cc06ca3c5d5', description: 'VPC ID for ALB and ECS')
  }

  environment {
    DOCKERHUB_REPO = "${params.DOCKERHUB_REPO}"
    AWS_REGION     = "${params.AWS_REGION}"
    ECS_CLUSTER    = "${params.ECS_CLUSTER}"
    ECS_SERVICE    = "${params.ECS_SERVICE}"
    TASK_FAMILY    = "${params.TASK_FAMILY}"
    CONTAINER_PORT = "8080"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        script {
          env.IMAGE_TAG = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim() + "-${env.BUILD_NUMBER}"
        }
      }
    }

    stage('Build (Maven)') {
      steps {
        sh '''
          chmod +x mvnw
          ./mvnw -B -DskipTests clean package
        '''
      }
    }

    stage('Build Docker image') {
      steps {
        sh """
          docker build -t ${DOCKERHUB_REPO}:${IMAGE_TAG} -t ${DOCKERHUB_REPO}:latest .
        """
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([string(credentialsId: 'dockerhub-kbkn', variable: 'DOCKERHUB_PAT')]) {
          sh '''
            echo "$DOCKERHUB_PAT" | docker login -u kbkn1106 --password-stdin
            docker push ${DOCKERHUB_REPO}:${IMAGE_TAG}
            docker push ${DOCKERHUB_REPO}:latest
          '''
        }
      }
    }

    stage('Terraform Apply') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-kbkn']]) {
          dir('terraform') {
            script {
              // Convert ECS subnet and SG input into HCL-compatible list
              def subnetList = params.SUBNET_IDS.split(',').collect { "\"${it.trim()}\"" }.join(',')
              def sgList = params.SECURITY_GROUP_IDS.split(',').collect { "\"${it.trim()}\"" }.join(',')

              // Convert ALB subnet and SG input into HCL-compatible list
              def albSubnetList = params.ALB_SUBNET_IDS.split(',').collect { "\"${it.trim()}\"" }.join(',')
              def albSgList = params.ALB_SECURITY_GROUP_IDS.split(',').collect { "\"${it.trim()}\"" }.join(',')

              sh """
                docker run --rm -v \$(pwd):/workspace -w /workspace \
                  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
                  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
                  -e AWS_DEFAULT_REGION=${AWS_REGION} \
                  hashicorp/terraform:1.6.0 init -input=false

                docker run --rm -v \$(pwd):/workspace -w /workspace \
                  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
                  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
                  -e AWS_DEFAULT_REGION=${AWS_REGION} \
                  hashicorp/terraform:1.6.0 apply -auto-approve \
                    -var 'aws_region=${AWS_REGION}' \
                    -var 'cluster_name=${ECS_CLUSTER}' \
                    -var 'service_name=${ECS_SERVICE}' \
                    -var 'task_family=${TASK_FAMILY}' \
                    -var 'initial_image=${DOCKERHUB_REPO}:latest' \
                    -var 'subnet_ids=[${subnetList}]' \
                    -var 'security_group_ids=[${sgList}]' \
                    -var 'assign_public_ip=${ASSIGN_PUBLIC_IP}' \
                    -var 'alb_subnets=[${albSubnetList}]' \
                    -var 'alb_security_group_ids=[${albSgList}]' \
                    -var 'vpc_id=${params.VPC_ID}' \
                    -var 'container_port=${CONTAINER_PORT}'
              """
            }
          }
        }
      }
    }

    stage('Fetch Terraform Outputs') {
      steps {
        dir('terraform') {
          sh """
            docker run --rm -v \$(pwd):/workspace -w /workspace hashicorp/terraform:1.6.0 output -json > tf_outputs.json
          """
        }
        script {
          def tfOutputs = readJSON file: 'terraform/tf_outputs.json'
          env.TASK_EXECUTION_ROLE_ARN = tfOutputs.task_execution_role_arn.value
          env.TASK_ROLE_ARN           = tfOutputs.task_role_arn.value
          env.LOG_GROUP               = tfOutputs.log_group.value
          env.ALB_DNS                 = tfOutputs.alb_dns_name.value
        }
      }
    }

    stage('Deploy to ECS') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-kbkn']]) {
          sh '''
            IMAGE_FULL=${DOCKERHUB_REPO}:${IMAGE_TAG}
            cp taskdef-template.json taskdef.json
            sed -i "s|__IMAGE__|${IMAGE_FULL}|g" taskdef.json
            sed -i "s|__EXEC_ROLE__|${TASK_EXECUTION_ROLE_ARN}|g" taskdef.json
            sed -i "s|__TASK_ROLE__|${TASK_ROLE_ARN}|g" taskdef.json
            sed -i "s|__AWS_REGION__|${AWS_REGION}|g" taskdef.json
            sed -i "s|__TASK_FAMILY__|${TASK_FAMILY}|g" taskdef.json
            sed -i "s|__LOG_GROUP__|${LOG_GROUP}|g" taskdef.json
            sed -i "s|__CONTAINER_NAME__|lemon-service|g" taskdef.json
            sed -i "s|__CONTAINER_PORT__|${CONTAINER_PORT}|g" taskdef.json

            aws ecs register-task-definition --cli-input-json file://taskdef.json --region ${AWS_REGION}
            aws ecs update-service --cluster ${ECS_CLUSTER} --service ${ECS_SERVICE} --force-new-deployment --region ${AWS_REGION}
          '''
        }
      }
    }
  }

  post {
    success {
      echo "✅ Pipeline finished."
      echo "🌐 Application available at: http://${env.ALB_DNS}"
    }
    failure {
      echo "❌ Pipeline failed — check logs."
    }
  }
}
