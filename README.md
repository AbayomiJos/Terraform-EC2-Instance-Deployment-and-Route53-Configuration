# Mini Project

This project demonstrates how to use Terraform to create 3 EC2 instances behind an Elastic Load Balancer, export the public IP addresses of the instances to a file called host-inventory, set up a domain name with AWS Route53, and create an A record for a subdomain that points to the ELB IP address. Additionally, it includes an Ansible playbook to install Apache, set timezone to Africa/Lagos, and display a simple HTML page that clearly identifies the content on all 3 EC2 instances. 

## Technologies used
1. <b>Terraform</b> was used to define and manage the infrastructure.
2. <b>Ansible</b> was used to manage the configuration and installation within the servers.
3. <b>Amazon S3</b> bucket was used to store the terraform state files.
4. <b>Amazon DynamoDB</b> was used to provide locking and consistency for the state files stored in Amazon S3.
5. <b>Amazon VPC</b> was used to provide a secure and isolated environment for the resources to run in.
6. <b>Amazon Route 53</b> was used to manage and configure DNS records.
7. <b>Amazon Load Balancer</b> was used to distribute incoming traffic across multiple targets(EC2 instances) to improve availability and scalability.


