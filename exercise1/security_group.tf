data "aws_vpc" "vpc" {

  filter {
    name = "tag:Name"
    values = ["dev-ecs-workshop"]
  }
}

resource "aws_security_group" "ecs-instance-security" {
  name = "${local.unique_id}-ecs-instance-sg"
  vpc_id = "${data.aws_vpc.vpc.id}"

  tags {
    Name = "${local.unique_id}-ecs-instance-sg"
  }
}

resource "aws_security_group_rule" "allow_all_traffic_ephemeral_port_range" {
  from_port = 31000
  protocol = "tcp"
  security_group_id = "${aws_security_group.ecs-instance-security.id}"
  to_port = 61000
  type = "ingress"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_outgoing_traffic" {
  from_port = 0
  protocol = "-1"
  security_group_id = "${aws_security_group.ecs-instance-security.id}"
  to_port = 0
  type = "egress"

  cidr_blocks = ["0.0.0.0/0"]
}