locals {
  unique_id = "shreyas"
}

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${local.unique_id}-ecs-cluster"
}

data "aws_subnet" "public_subnet" {
  filter {
    name   = "tag:Name"
    values = ["dev-ecs-workshop-public-subnet-0"]
  }
  vpc_id = "${data.aws_vpc.vpc.id}"
}

resource "aws_instance" "cluster-ec2-instance" {
  ami = "ami-0a6b7e0cc0b1f464f"
  instance_type = "t3.micro"
  iam_instance_profile = "${aws_iam_instance_profile.ecs_cluster_instance_profile.id}"
  security_groups = ["${aws_security_group.ecs-instance-security.id}"]
  subnet_id = "${data.aws_subnet.public_subnet.id}"

  user_data = <<-EOF
              #!/bin/bash
              cat <<'CONFIG' >> /etc/ecs/ecs.config
              ECS_CLUSTER=${aws_ecs_cluster.ecs-cluster.name}
              ECS_ENABLE_TASK_IAM_ROLE=true
              ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true
              CONFIG
              EOF

  root_block_device {
    volume_size = "30"
    delete_on_termination = true
  }

  tags {
    Name = "${local.unique_id}-ecs-cluster-instance"
  }
}