#!/bin/bash
set -euo pipefail

PASSWORD="freenet"
REGION="us-central1"
SERVICE_NAME="freenet-envoy"

rm -rf ~/freenet+envoy && mkdir -p ~/freenet+envoy && cd ~/freenet+envoy

# Paste all configs above here, or save files separately

gcloud services enable run.googleapis.com cloudbuild.googleapis.com --quiet

gcloud run deploy $SERVICE_NAME \
  --image docker.io/jthan/httpupgrade:latest \
  --region $REGION \
  --platform managed \
  --allow-unauthenticated \
  --memory 512Mi --cpu 0.5 --port 8080 \
  --execution-environment=gen2

echo -e "\n✅ Deployment complete."
SVC_URL=$(gcloud run services describe $SERVICE_NAME --region $REGION --format="value(status.url)")
echo "🔗 Service URL: $SVC_URL"
echo "📌 Path prefix: /freenet+envoy/"
echo "🔑 Password/ID: freenet"
