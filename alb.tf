resource "aws_lb" "ecs-alb" {
  name               = "soon-ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_id]
  subnets            = toset(data.aws_subnets.existing_subnets.ids)
  # Luqman put the statement here and set to true. This caused an error because terraform will not
  # be able to destroy the application load balancer since it is deletion protected.
  # To resolve this, I set the value to false. Note that if you do not include this line, the default
  # value of enable_deletion_protection is false. 
  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "ecs-alb-tg" {
  name        = "soon-ecs-target-group"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = data.aws_vpc.existing_vpc.id
  health_check {
    path      = "/"
    protocol  = "HTTP"
    interval = 300
  } 
}
