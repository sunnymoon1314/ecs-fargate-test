# Creates a task definition using the files/task-definition.json
# HINT: if you would like to use your own docker image, update the container_definitions image_url
# accordingly

resource "aws_ecs_task_definition" "own_task_definition" {
  family                = "soonecstaskdef" # Update accordingly
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn        = var.ex_role_arn
  cpu                   =   2048
  memory                = 4096

  # For custom ECR image
  # container_definitions = templatefile("./files/task-definition.json", {
  #   image_url        = "255945442255.dkr.ecr.us-east-1.amazonaws.com/soon-test-ecr-repo:latest"
  #   container_name   = "soon-test-ecs"
  #   port_name        = "soon-test-ecs-8080-tcp"
  #   log_group_region = "us-east-1"
  #   log_group_name   = "/ecs/soontesttaskdef"
  #   log_group_prefix = "ecs"
  # })

  # For nginx image
  container_definitions = templatefile("./files/task-definition.json", {
    image_url        = "nginx:latest"
    port_name        = "nginx80-tcp"
    container_name   = "NGINX"
    port_name        = "soon-test-ecs-8080-tcp"
    log_group_region = "us-east-1"
    log_group_name   = "/ecs/soontesttaskdef"
    log_group_prefix = "ecs"
  })
}

# Creates an ecs clustersctp-ce5-tfstate-bucket-1

resource "aws_ecs_cluster" "own_cluster" {
  name = "soon-ecs-test-cluster" # Update accordingly
}

# Creates an ecs service

resource "aws_ecs_service" "own_service" {
  name             = "soon-ecs-service" # Update accordingly
  cluster          = aws_ecs_cluster.own_cluster.arn
  task_definition  = aws_ecs_task_definition.own_task_definition.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  deployment_circuit_breaker {
    enable          = true
    rollback        = true
  }

  network_configuration {
    subnets          = data.aws_subnets.existing_subnets.ids
    assign_public_ip = true
    security_groups = [var.sg_id]
  }
}