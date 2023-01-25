# GCP-Project

### Project Details
Create 1 VPC
Create 2 subnets (management subnet & restricted subnet):
1. Management subnet has the following:
    - NAT gateway
    - Private VM
2. Restricted subnet has the following:
    - Private standard GKE cluster (private control plan)
##### Notes:
1. Restricted subnet must not have access to internet
2. All images deployed on GKE must come from GCR or Artifacts registry.
3. The VM must be private.
4. Deployment must be exposed to public internet with a public HTTP load balancer.
5. All infra is to be created on GCP using terraform.
6. Deployment on GKE can be done by terraform or manually by kubectl tool.
7. The code to be build/dockerized and pushed to GCR is on here:
https://github.com/atefhares/DevOps-Challenge-Demo-Code
8. Don’t use default compute service account while creating the gke cluster, create
custom SA and attach it to your nodes.
9. Only the management subnet can connect to the gke cluster.

### Tools Used
    - Terraform
    - GCP
    - Docker
    - Kubernetes
    - Python

### Get Started

1. You should create the infrastructure first
    - terraform init
    - terraform apply

2. Create your Docker images and push it in your Repo in Container Registery by using some commands after create your images, activate docker service account and docker configure:
    - docker tag python-app:latest us.gcr.io/nathan-eid/python-app:latest
    - docker push us.gcr.io/nathan-eid/python-app:latest

![ActivateDockerSA](https://user-images.githubusercontent.com/40915944/214638693-75383ddb-7e90-4c28-a58b-e543464e90ea.png)

![PushPythonImage](https://user-images.githubusercontent.com/40915944/214638977-2a257db6-598f-4107-92da-994b1a132164.png)

![PushRedisImage](https://user-images.githubusercontent.com/40915944/214639007-d058b597-e2c8-427a-aaf5-5217c6b06818.png)


3. SSH into the created VM to access the cluster and run the script "myscript.sh" and connect to the cluster

![image](https://user-images.githubusercontent.com/40915944/214639904-1999531f-aaa5-4794-af12-93c4e8e7ffa2.png)

4. Now the environment is ready to Create Kubernetes deployments and services by the Kubernetes .yaml files by using commands like:
    - kubectl apply -f redis.yaml
    - kubectl apply -f pythonAPP.yaml

![ManageClusterFromVM](https://user-images.githubusercontent.com/40915944/214640074-346ef823-5022-4428-b333-b5b9c3fbbcad.png)

5. Tack the Load Balancer IP from the cluster and hit in you browser to run the APP.

![image](https://user-images.githubusercontent.com/40915944/214640521-2b8076c2-a4d0-4be4-b1dd-4fff7930c513.png)

![FinalResult](https://user-images.githubusercontent.com/40915944/214640238-0811f8fc-dcd4-439a-a79d-a168dcc7e78b.png)

