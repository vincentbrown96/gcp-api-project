# simple-api-project

## Materials needed for this project

- [Terraform](https://www.terraform.io/)
- [Google Cloud](https://cloud.google.com/)

## Directory structure

- `terraform`: Terraform configuration files
- `app`: Simple API project

## How to run Terraform

Firstly, you would need to add the appropriate roles for the service account for the Terraform context.

Roles needed:
- `roles/iam.serviceAccountUser` on the project
- `roles/container.admin` on the project
- `roles/compute.viewer` on the project

You would also need to set the `GOOGLE_CREDENTIALS` environment variable to the service account key JSON. You can retrieve this by either using the `gcloud` CLI:

```bash
gcloud iam service-accounts keys create --iam-account <SERVICE_ACCOUNT_EMAIL> credentials.json
```

or by going to the [Google Cloud Console](https://console.cloud.google.com/iam-admin/service-accounts), clicking on the service account, then clicking on the `Key` tab.

## Application

The application is a simple Python API that returns the current time, and runs containerized using `docker`. As an image, you can also run in Kubernetes.
