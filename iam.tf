resource "aws_iam_user" "user" {
  name = var.name
}

resource "aws_iam_access_key" "access_key" {
  user = aws_iam_user.user.name
}

resource "aws_iam_user_policy" "policy" {
  user = aws_iam_user.user.name
  name = "start-stop-instances"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:StartInstances",
          "ec2:StopInstances"
        ],
        "Resource" : "${aws_instance.instance.arn}"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeInstances"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role" "instance_role" {
  name = "${var.name}-instance-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = var.name
  role = aws_iam_role.instance_role.name
}

output "access_key" {
  value = aws_iam_access_key.access_key.id
}

output "secret_key" {
  value = aws_iam_access_key.access_key.secret
  sensitive = true
}
