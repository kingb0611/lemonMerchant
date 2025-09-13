pipeline {
  agent any

  parameters {
    string(name: 'DOCKERHUB_REPO', defaultValue: 'kbkn1106/lemonmerchant', description: 'Docker Hub repo (user/repo)')
    string(name: 'AWS_REGION', defaultValue: 'ap-south-1', description: 'AWS Region')
    string(name: 'ECS_CLUSTER', defaultValue: 'lemon-cluster', description: 'ECS Cluster name')
    string(name: 'ECS_SERVICE', defaultValue: 'lemon-service', description: 'ECS Service name')
    string(name: 'TASK_FAMILY', defaultValue: 'lemonmerchant', description: 'ECS Task definition family')
    string(name: 'SUBNET_IDS', defaultValue: '["subnet-123","subnet-456"]', description: 'Subnets for ECS tasks (JSON list)')
    string(name: 'SECURITY_GROUP_IDS', defaultValue: '["sg-abc123"]', description: 'Security groups for ECS tasks (JSON list)')
    booleanParam(name: 'ASSIGN_PUBLIC_IP', defaultValue: true, description: 'Assign public IP to tasks?')
  }

  environment {
    DOCKERHUB_REPO = "${params.DOCKERHUB_REPO}"
    AWS_REGION     = "${params.AWS_REGION}"
    ECS_CLUSTER    = "${params.ECS_CLUSTER}"
    ECS_SERVICE    = "${params.ECS_SERVICE}"
    TASK_FAMILY    = "${params.TASK_FAMILY}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        script {
          GIT_COMMIT_SHORT = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          env.IMAGE_TAG = "${GIT_COMMIT_SHORT}-${env.BUILD_NUMBER}"
        }
      }
    }

    stage('Build (Maven)') {
      steps {
        sh './mvnw -B -DskipTests clean package'
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
        withCredentials([usernamePassword(credentialsId: 'dockerhub-kbkn', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
          sh '''
            echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
            docker push ${DOCKERHUB_REPO}:${IMAGE_TAG}
            docker push ${DOCKERHUB_REPO}:latest
          '''
        }
      }
    }

    stage('Terraform Apply (main only)') {
      when {
        branch 'main'
      }
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws-kbkn', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          dir('terraform') {
            sh '''
              export AWS_DEFAULT_REGION=${AWS_REGION}
              terraform init -input=false
              terraform apply -auto-approve \
                -var "aws_region=${AWS_REGION}" \
                -var "cluster_name=${ECS_CLUSTER}" \
                -var "service_name=${ECS_SERVICE}" \
                -var "task_family=${TASK_FAMILY}" \
                -var "initial_image=${DOCKERHUB_REPO}:latest" \
                -var 'subnet_ids=${SUBNET_IDS}' \
                -var 'security_group_ids=${SECURITY_GROUP_IDS}' \
                -var "assign_public_ip=${ASSIGN_PUBLIC_IP}"
            '''
          }
        }
      }
    }

    stage('Fetch Terraform Outputs (main only)') {
      when {
        branch 'main'
      }
      steps {
        dir('terraform') {
          sh 'terraform output -json > tf_outputs.json'
        }
        script {
          def tfOutputs = readJSON file: 'terraform/tf_outputs.json'
          env.TASK_EXECUTION_ROLE_ARN = tfOutputs.task_execution_role_arn.value
          env.TASK_ROLE_ARN           = tfOutputs.task_role_arn.value
          env.LOG_GROUP               = tfOutputs.log_group.value
        }
      }
    }

    stage('Deploy to ECS (main only)') {
      when {
        branch 'main'
      }
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws-kbkn', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          sh '''
            export AWS_DEFAULT_REGION=${AWS_REGION}
            IMAGE_FULL=${DOCKERHUB_REPO}:${IMAGE_TAG}

            cp taskdef-template.json taskdef.json
            sed -i "s|__IMAGE__|${IMAGE_FULL}|g" taskdef.json
            sed -i "s|__EXEC_ROLE__|${TASK_EXECUTION_ROLE_ARN}|g" taskdef.json
            sed -i "s|__TASK_ROLE__|${TASK_ROLE_ARN}|g" taskdef.json
            sed -i "s|__AWS_REGION__|${AWS_REGION}|g" taskdef.json
            sed -i "s|__TASK_FAMILY__|${TASK_FAMILY}|g" taskdef.json
            sed -i "s|__LOG_GROUP__|${LOG_GROUP}|g" taskdef.json

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
    }
    failure {
      echo "❌ Pipeline failed — check logs."
    }
  }
}
