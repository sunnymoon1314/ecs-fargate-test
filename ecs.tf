# Creates a task definition using the files/task-definition.json

resource "aws_ecs_task_definition" "own_task_definition" {
  family                = "luqmantesttaskdef"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn        = var.ex_role_arn
  cpu                   =   256
  memory                = 512

  container_definitions = templatefile("./files/task-definition.json", {
    image_url        = "nginx:latest"
    container_name   = "NGINX"
    log_group_region = "us-east-1"
    log_group_name   = "/ecs/luqmantesttaskdef"
    log_group_prefix = "ecs"
  })
}

# Creates an ecs cluster

resource "aws_ecs_cluster" "own_cluster" {
  name = "luqman-ecs-test-cluster"
}

# Creates an ecs service

resource "aws_ecs_service" "own_service" {
  name             = "my-ecs-service"
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