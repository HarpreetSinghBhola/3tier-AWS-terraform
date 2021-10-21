resource "aws_launch_configuration" "api-launchconfig" {
  name_prefix          = "api-launchconfig-"
  image_id             = var.API_INSTANCE_AMI
  instance_type        = "t2.micro"
  security_groups      = [aws_security_group.api-instance.id]
  key_name             = var.keyname

  user_data = data.template_file.api-shell-script.rendered

  iam_instance_profile = aws_iam_instance_profile.CloudWatchAgentServerRole-instanceprofile.name

  connection {
    user = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "api-autoscaling" {
  name = "${aws_launch_configuration.api-launchconfig.name}-asg"

  vpc_zone_identifier  = [aws_subnet.main-private-3.id, aws_subnet.main-private-4.id]
  launch_configuration = aws_launch_configuration.api-launchconfig.name
  min_size             = 2
  max_size             = 2
  health_check_grace_period = 300
  health_check_type = "ELB"
  target_group_arns = [aws_lb_target_group.api_servers.arn]
  force_delete = true

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key = "Name"
    value = "API-Server"
    propagate_at_launch = true
  }
  depends_on = [
    aws_instance.elk-server
  ]
}

