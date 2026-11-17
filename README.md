
# AWS ECS Deployment using Terraform and GitHub Actions

## Project Overview

This project demonstrates an automated and scalable container deployment
on AWS using Terraform, Docker, Amazon ECS and GitHub Actions.

The objective is to implement production-oriented DevOps practices
including Infrastructure as Code, CI/CD automation, security,
monitoring and deployment management.

## Technology Stack

- AWS
- Terraform
- Docker
- Amazon ECS (EC2 launch type)
- Amazon ECR
- Application Load Balancer
- GitHub Actions
- AWS IAM and OIDC
- Amazon CloudWatch

## Current Implementation

- Sample web application created.
- Dockerfile configured using Nginx.
- Docker image built successfully.
- Application running inside a Docker container.
- Health endpoint configured at /health.
- Source code maintained in GitHub.

## Planned Architecture

GitHub
  |
GitHub Actions
  |
Docker Build
  |
Amazon ECR
  |
Amazon ECS
  |
Application Load Balancer
  |
Users

Terraform will provision and manage the AWS infrastructure.

## Local Docker Execution

Build the image:

```bash
docker build -t aws-ecs-portfolio-demo:v1 .
```

Run the container:

```bash
docker run -d --name ecs-portfolio-demo -p 8080:80 aws-ecs-portfolio-demo:v1
```

Application:

http://localhost:8080

Health check:

http://localhost:8080/health

Stop the container:

```bash
docker stop ecs-portfolio-demo
```

## Upcoming Enhancements

- Reusable Terraform modules
- AWS VPC and networking
- Amazon ECR integration
- ECS EC2 cluster
- Application Load Balancer
- GitHub Actions CI/CD with OIDC
- CloudWatch monitoring and alarms
- Multi-environment deployment
- Security and cost optimization

## Project Status

Phase 1: Docker application and GitHub integration completed.

Phase 2: Terraform infrastructure development in progress.
