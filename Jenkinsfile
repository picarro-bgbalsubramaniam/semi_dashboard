pipeline {
    agent {
        node{
            label 'host_slave-pdap-stage-1'
        }
    }
    environment {
        majorVersion = 1
        minorVersion = 2
        patchVersion = VersionNumber (versionNumberString: '${BUILDS_ALL_TIME}')
        tag = sh (returnStdout: true, script: "echo $majorVersion.$minorVersion.$patchVersion")
        GITHUB_REPO_NAME = sh (returnStdout: true, script: "echo ${GIT_URL} | grep -Eo '[^/]+/?\$' | cut -d / -f1").trim()
        GITHUB_STATUS_API_ENDPOINT = sh(returnStdout: true, script: "echo https://api.github.com/repos/picarro/${GITHUB_REPO_NAME}/statuses/${GIT_COMMIT}").trim()
    }
    stages {
        stage("Send Slack Notification") {
            when {
                environment name: 'GIT_BRANCH', value: 'main'
            }
            steps {
                slackSend color: "good", message: "CI/CD Started: ${JOB_NAME} ${BUILD_DISPLAY_NAME} - ${BUILD_URL}"
            }
        }
        stage("Get env file") {
            when {
                environment name: 'GIT_BRANCH', value: 'main'
            }
            steps {
                sh '''curl -LH "X-JFrog-Art-Api:${JFROG_PTOKEN}" https://picarro.jfrog.io/artifactory/picarro-generic-private/picarro-notebooks/notebook.env -o .env'''
            }
        }
        stage("Build Container") {
            when {
                environment name: 'GIT_BRANCH', value: 'main'
            }
            steps {
                sh "docker-compose build --no-cache jupyter_hub_sat"
                sh "docker tag jupyter_hub_sat:latest picarro-docker-repo.jfrog.io/jupyter_hub_sat:${tag}"
                sh "docker rmi jupyter_hub_sat:latest"
            }
        }
        stage("Deploy Container") {
            when {
                environment name: 'GIT_BRANCH', value: 'main'
            }
            steps {
                sh "make -f Makefile docker_deploy docker_tag=${tag}"
            }
        }
    }
    post {
        success {
            slackSend color: "good", message: "CI/CD passed: ${JOB_NAME} ${BUILD_DISPLAY_NAME} - ${BUILD_URL}"
            sh "curl -H  'Authorization: token ${GITHUB_PTOKEN}' ${GITHUB_STATUS_API_ENDPOINT} \
                -H 'Content-Type: application/json' \
                -X POST \
                    -d  '{\"state\": \"success\",\"context\": \"jenkins/${GITHUB_REPO_NAME}\", \"description\": \"Jenkins\", \"target_url\": \"${JOB_URL}${BUILD_NUMBER}/console\"}'"
        }
        failure {
            slackSend color: "danger", message: "CI/CD failed: ${JOB_NAME} ${BUILD_DISPLAY_NAME} - ${BUILD_URL}"
            sh "curl -H  'Authorization: token ${GITHUB_PTOKEN}' ${GITHUB_STATUS_API_ENDPOINT} \
                -H 'Content-Type: application/json' \
                -X POST \
                -d  '{\"state\": \"failure\",\"context\": \"jenkins/${GITHUB_REPO_NAME}\", \"description\": \"Jenkins\", \"target_url\": \"${JOB_URL}${BUILD_NUMBER}/console\"}'"
        }
        aborted {
            slackSend color: "warning", message: "CI/CD Aborted: ${JOB_NAME} ${BUILD_DISPLAY_NAME} - ${BUILD_URL}"
        }
        unstable {
            slackSend color: "warning", message: "Unstable build: ${JOB_NAME} ${BUILD_DISPLAY_NAME} - Check Build Log: ${BUILD_URL}"
        }
    }
}
