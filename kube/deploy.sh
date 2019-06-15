#!/usr/bin/env bash

# Exit on any error
set -e

# Kubernetes stuff for deploying to google cloud

# Detect deployment type and set image name
export NAME="react-rails-app"
export TAG=$1
export APP_ENV=$2
export PROJECT=$3
export IMAGE="gcr.io/$PROJECT/$NAME:$TAG"
export REPLICAS=1
export NAMESPACE=react-rails-${APP_ENV}

echo "deploying $IMAGE"

if [ "${APP_ENV}" == "prod" ]; then
 eval "echo \"$(cat kube/production/deploy-tasks-job.yml)\"" > temp.yml && kubectl create --namespace=${NAMESPACE} -f temp.yml && rm temp.yml
else
 eval "echo \"$(cat kube/production/deploy-tasks-job.yml)\"" > temp.yml && kubectl create --namespace=${NAMESPACE} -f temp.yml && rm temp.yml
fi

echo '=============== Waiting for the task to complete'
sleep 3m # Waits 3 minutes.
echo '==============='

kubectl delete job react-rails-deploy-tasks --namespace=${NAMESPACE} || true

kubectl set image deployment react-rails-app "react-rails-app=$IMAGE" --namespace=${NAMESPACE} --record
kubectl describe deployment react-rails-app --namespace=${NAMESPACE}
kubectl rollout status deployment react-rails-app --namespace=${NAMESPACE}
echo "Deployment finished"
