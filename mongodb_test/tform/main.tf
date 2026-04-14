
resource "aws_security_group" "movies_sg" {
  name        = "movies_app_sg"
  description = "security groups movies"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5672
    to_port     = 5672
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 15672
    to_port     = 15672
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "movies_app_sg"
  }
}

resource "aws_instance" "api1" {
    ami                     = var.ami
    instance_type           = var.instance_type
    key_name                = var.key_name
    subnet_id               = var.subnet_id
    vpc_security_group_ids  = [aws_security_group.movies_sg.id]
    user_data               = file("${path.module}/scripts/api.sh")
    availability_zone       = var.availability_zone

    tags = {
        Name = "movies-api-1"
        Rule = "BackendAPI"
    }
    depends_on = [
        aws_ssm_parameter.rabbitmq_ip,
        aws_ssm_parameter.mongo_ip
    ]
    iam_instance_profile = "LabInstanceProfile"
}

resource "aws_instance" "api2" {
    ami                     = var.ami
    instance_type           = var.instance_type
    key_name                = var.key_name
    subnet_id               = var.subnet_id
    vpc_security_group_ids  = [aws_security_group.movies_sg.id]
    user_data               = file("${path.module}/scripts/api.sh")
    availability_zone       = var.availability_zone

    tags = {
        Name = "movies-api-2"
        Rule = "BackendAPI"    
    }
    depends_on = [
        aws_ssm_parameter.rabbitmq_ip,
        aws_ssm_parameter.mongo_ip
    ]
    iam_instance_profile = "LabInstanceProfile" 
}

resource "aws_instance" "rabbitmq" {
    ami                     = var.ami
    instance_type           = var.instance_type
    key_name                = var.key_name
    subnet_id               = var.subnet_id
    vpc_security_group_ids  = [aws_security_group.movies_sg.id]
    user_data               = file("${path.module}/scripts/rabbitmq.sh")
    availability_zone       = var.availability_zone

    tags = {
        Name = "rabbitmq-Server"
        Rule = "MessageBroker"
    } 
}

resource "aws_instance" "worker" {
    ami                     = var.ami
    instance_type           = var.instance_type
    key_name                = var.key_name
    subnet_id               = var.subnet_id
    vpc_security_group_ids  = [aws_security_group.movies_sg.id]
    user_data               = file("${path.module}/scripts/worker.sh")
    availability_zone       = var.availability_zone

    tags = {
        Name = "worker-Server"
        Rule = "AsyncWorker"
    } 

    depends_on = [
        aws_ssm_parameter.rabbitmq_ip,
        aws_ssm_parameter.mongo_ip
    ]
    iam_instance_profile = "LabInstanceProfile"
}

resource "aws_instance" "mongodb" {
    ami                     = var.ami
    instance_type           = var.instance_type
    key_name                = var.key_name
    subnet_id               = var.subnet_id
    vpc_security_group_ids  = [aws_security_group.movies_sg.id]
    user_data               = file("${path.module}/scripts/mongo.sh")
    availability_zone       = var.availability_zone

    tags = {
        Name = "mongodb-Server"
        Rule = "NoSQLDatabase"
    } 
}

resource "aws_lb" "api_lb" {
    name                = "movies-lb-api"
    internal            = false
    load_balancer_type  = "application"
    security_groups     = [aws_security_group.movies_sg.id]
    subnets             = [var.subnet_id, var.subnet_id2]

    tags = {
        Name = "movies-lb-api"
    }
}

resource "aws_lb_target_group" "api_tg" {
    name            = "movies-api-tg"
    port            = 5000
    protocol        = "HTTP"
    vpc_id          = var.vpc_id

    health_check {
        path                = "/movies"
        port                = "5000"
        protocol            = "HTTP"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        interval            = 30
        timeout             = 5
    }
}

resource "aws_lb_target_group_attachment" "api1" {
    target_group_arn    = aws_lb_target_group.api_tg.arn
    target_id           = aws_instance.api1.id
    port                = 5000
}

resource "aws_lb_target_group_attachment" "api2" {
    target_group_arn    = aws_lb_target_group.api_tg.arn
    target_id           = aws_instance.api2.id
    port                = 5000
}

resource "aws_lb_listener" "api_listener" {
    load_balancer_arn = aws_lb.api_lb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.api_tg.arn
    }
}

resource "aws_ssm_parameter" "rabbitmq_ip" {
  name  = "/movies/rabbitmq_ip"
  type  = "String"
  value = aws_eip.rabbitmq_eip.public_ip
}

resource "aws_ssm_parameter" "mongo_ip" {
  name  = "/movies/mongo_ip"
  type  = "String"
  value = aws_eip.mongodb_eip.public_ip
}

resource "aws_eip" "rabbitmq_eip" {
  instance = aws_instance.rabbitmq.id
  
  tags = {
    Name = "rabbitmq-static-ip"
  }
}

resource "aws_eip" "mongodb_eip" {
  instance = aws_instance.mongodb.id
  
  tags = {
    Name = "mongodb-static-ip"
  }
}