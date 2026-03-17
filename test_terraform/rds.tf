# 1. DB 서브넷 그룹 (Private DB 서브넷 2개 묶기)
resource "aws_db_subnet_group" "main" {
  name       = "shopeasy-db-subnet-group"
  subnet_ids = [aws_subnet.private_db_a.id, aws_subnet.private_db_c.id]

  tags = {
    Name = "shopeasy-db-subnet-group"
  }
}

# 2. RDS 인스턴스 (MySQL)
resource "aws_db_instance" "main" {
  identifier             = "shopeasy-rds"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro" 
  allocated_storage      = 20
  
  db_name                = "shopeasydb"
  username               = "admin"
  password               = "password1234!" # 테스트용 임시 비밀번호
  
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id] # DB 보안 그룹 연결
  
  multi_az               = false
  publicly_accessible    = false # 외부 인터넷 접근 차단
  skip_final_snapshot    = true  # 테스트 환경 삭제 편의성을 위해 스냅샷 건너뛰기

  tags = {
    Name = "shopeasy-rds"
  }
}