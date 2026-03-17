# 1. ALB (Application Load Balancer) 본체 생성
resource "aws_lb" "main" {
  name               = "shopeasy-alb"
  internal           = false               # 외부 인터넷과 통신하므로 false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  
  # 퍼블릭 서브넷 2곳에 걸쳐서 배치 (고가용성)
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_c.id]

  tags = {
    Name = "shopeasy-alb"
  }
}

# 2. 타겟 그룹 (트래픽을 전달받을 EC2들의 그룹)
resource "aws_lb_target_group" "app" {
  name     = "shopeasy-tg"
  port     = 8080                  # 앱 서버가 수신할 포트
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  # 헬스 체크 설정 (EC2가 살아있는지 주기적으로 확인)
  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
}

# 3. 리스너 (ALB로 들어온 80번 포트 요청을 타겟 그룹으로 토스)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}