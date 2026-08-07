# Production-Grade AWS ECS DevSecOps Pipeline

![AWS ECS Architecture](https://img.shields.io/badge/AWS-ECS%20Fargate-orange?logo=amazon-aws)
![Terraform](https://img.shields.io/badge/IaC-Terraform-purple?logo=terraform)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-blue?logo=githubactions)
![Security](https://img.shields.io/badge/Security-AWS%20SSM%20%7C%20KMS-green)

A fully automated, production-ready Cloud Delivery & DevSecOps pipeline on **AWS ECS Fargate**, provisioned using **Terraform** and deployed via **GitHub Actions**.

---

## 🏗️ Architecture Diagram

```mermaid
flowchart TD
    subgraph Developer_Workflows ["Developer & CI/CD Pipeline"]
        DEV["Developer (git push)"] -->|Triggers| GHA["GitHub Actions Workflow"]
        GHA -->|1. Build & Test| GO["Go Application Binary"]
        GHA -->|2. Docker Build & Tag| ECR["Amazon ECR Repository"]
        GHA -->|3. Terraform Apply / Deploy| ECS_DEF["ECS Task Definition Revision"]
    end

    subgraph AWS_Cloud ["AWS Cloud (us-east-1)"]
        subgraph VPC ["Custom AWS VPC"]
            subgraph Public_Subnets ["Public Subnets"]
                ECS_FG["AWS ECS Fargate Service\n(Go App Container)"]
            end
        end

        SSM["AWS SSM Parameter Store\n(/devops-app/production/jwt_secret)"]
        CW["AWS CloudWatch Log Group\n(/ecs/devops-go-app)"]
        KMS["AWS KMS Encryption"]
    end

    ECR -->|Pull Image:latest| ECS_FG
    SSM -->|Inject JWT_SECRET at Boot| ECS_FG
    KMS -.->|Decrypts Secrets| SSM
    ECS_FG -->|Stream stdout/stderr| CW
    ECS_FG -->|Health Probe: wget http://localhost:8080/| ECS_FG
```

---

## 🛡️ Key Security & Architecture Features

* **Zero-Trust Secret Management:** Credentials stored in **AWS SSM Parameter Store** (KMS encrypted) and dynamically injected into container RAM at boot time. Zero hardcoded keys in code or image layers.
* **Tamper-Proof Observability:** Container logs stream directly to **AWS CloudWatch** (`awslogs` driver), isolating operational audit logs from host file systems.
* **Automated Self-Healing & Zero Downtime:** Integrated native container health checks (`wget` HTTP probes) ensure failed container builds trigger automated deployment rollbacks without affecting live traffic.
* **Serverless Execution:** Deployed on **AWS ECS Fargate** with custom VPC networking and IAM least-privilege execution roles.
* **Automated CI/CD:** GitHub Actions pipeline triggers automated compilation, containerization, ECR pushing, and rolling ECS deployments on every push to `main`.

---

## 📂 Repository Structure

```text
├── .github/
│   └── workflows/
│       └── deploy.yml          # Automated CI/CD deployment pipeline
├── terraform/
│   ├── main.tf                 # ECS Fargate, SSM, CloudWatch, & IAM resources
│   ├── variables.tf            # Configurable environment input variables
│   └── outputs.tf              # Terraform deployment outputs
├── main.go                     # Go web server source code
├── Dockerfile                  # Multi-stage Docker build file
└── README.md                   # System architecture documentation
```
