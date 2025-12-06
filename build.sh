PROJECT_ID="${PROJECT_ID:-$(gcloud config get-value project)}"
LOCATION="us"
REPOSITORY="faq-product-sll"
FULL_REPO="${LOCATION}-docker.pkg.dev/${PROJECT_ID}/${REPOSITORY}"
IMAGE_NAME="faq-product-sll-app"

if ! gcloud artifacts repositories describe "${REPOSITORY}" --location="${LOCATION}" --project="${PROJECT_ID}" &>/dev/null; then
    echo "Repository '$REPOSITORY' does not exist. Creating..."

    gcloud artifacts repositories create "${REPOSITORY}" \
        --repository-format=docker \
        --location="${LOCATION}" \
        --project="${PROJECT_ID}"
    echo "Repository '$FULL_REPO' created successfully."
else
    echo "Repository '$FULL_REPO' already exists."
fi

gcloud builds submit --tag $FULL_REPO/$IMAGE_NAME:latest .

gcloud run deploy $IMAGE_NAME \
    --platform=managed \
    --allow-unauthenticated \
    --image=$FULL_REPO/$IMAGE_NAME:latest --region=us-central1