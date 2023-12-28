data "aws_ami" "customami_latest" {

  most_recent = true
  owners = ["self"]

  filter {
    name = "name"
    values = ["${var.project_name}-${var.project_env}-*"]

}

  filter {
    name = "tag:Project"
    values = ["${var.project_name}"]

}
  filter {
    name = "tag:Environment"
    values = ["${var.project_env}"]

}

}
