## Creation of the ec2 instances and running the ansible playbook

locals {
  ssh_user         = "ubuntu"
  key_name         = "test"
  private_key_path = "/home/vagrant/terraform-project/test.pem"
}

## Create instance
resource "aws_instance" "server" {
  for_each = var.subnets

  ami                         = data.aws_ami.server_ami.id
  instance_type               = var.instance_type
  associate_public_ip_address = var.enable_public_ip
  key_name                    = local.key_name
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
  subnet_id                   = aws_subnet.public_subnets[each.key].id

  ## Sends the public IP of the instances to a host-inventory file
  provisioner "local-exec" {
    command = "echo '${self.public_ip}' >> ./host-inventory"
  }
}

# Run ansible playbook
resource "null_resource" "playbook" {
  provisioner "local-exec" {
    command = "ansible-playbook --private-key ${local.private_key_path} playbook.yml"
  }
  depends_on = [aws_instance.server]
}

