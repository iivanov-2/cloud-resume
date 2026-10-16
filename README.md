# AWS Cloud Resume

This is my version of [The Cloud Resume Challenge](https://cloudresumechallenge.dev).

The main goal is to create and deploy a serverless environment using cloud solutions. This involves combining multiple AWS resources to build and deploy a static website.

[Live Site](https://d6hzvrrkeasjd.cloudfront.net)

## Architecture

![Architecture Diagram](Cloud%20Resume%20Architecture.drawio.png)

Technologies used:

- **Frontend:** S3, CloudFront
- **Backend:** Lambda, API Gateway
- **Database:** DynamoDB
- **IaC:** Terraform
- **CI/CD:** GitHub Actions

## Design Decisions

The main reason for building the project with these services is that they are part of the AWS Free Tier. Additionally, this approach eliminates the need for on-premises infrastructure. My main focus is on DevOps and Infrastructure, so I used AI tools to help me generate the HTML, CSS, and JavaScript for the frontend. This allowed me to focus and spend more time on building the cloud infrastructure and CI/CD pipelines.

## Why this exists

The project uses a private S3 bucket behind CloudFront using Origin Access Control, infrastructure fully defined in Terraform, and three independent GitHub Actions pipelines authenticated via OIDC with no stored credentials.

Beyond being a learning project, it is a working starting point to deploy a static website, landing page, or documentation site the right way, without re-solving the IaC and CI/CD from scratch.

## Lessons Learned

This project changed my mindset on how services interact. I learned it is better to separate the flows for frontend, backend, and infrastructure, so each one handles its own part.
Also, I got practical experience working with Terraform and GitHub Actions.

## Future Improvements

This is an ongoing project and I'm planning on adding more features later.

- ~~**Monitoring** - Set up a dashboard to track the website~~ - Completed
- **Containerization** - Containerize the website and run it using Kubernetes
- **Custom Domain** - Buy a domain name and set it up with Route53
