# 3tier-AWS-terraform
This repo contains code for a Node.js three-tier application. Web, API and DB layers are deployed using terraform version 1.0.8. ELK is being deployed on EC2 instance along with infra. We are using file and metric beats to forward the logs and metrics from Web and API instances.

├───api
│   └───bin
├───elk
│   ├───ConfigFiles
│   ├───pem-file
│   └───Scripts-elk
├───terraform
│   └───scripts
└───web
    ├───bin
    ├───public
    │   ├───images
    │   └───stylesheets
    ├───routes
    └───views
