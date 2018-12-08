resource "aws_iam_role" "ecs_cluster_instance_role" {
  name = "${local.unique_id}-ecs-cluster-instance-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ecs_cluster_instance_profile" {
  role = "${aws_iam_role.ecs_cluster_instance_role.name}"
}

resource "aws_iam_role_policy_attachment" "ecs-cluster-instance-policy" {
  role = "${aws_iam_role.ecs_cluster_instance_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  depends_on = ["aws_iam_role.ecs_cluster_instance_role"]
}