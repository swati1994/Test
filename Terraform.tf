resource "aws_key_pair" "terraform-demo" {
  key_name   = "terraform-demo"
  public_key = "${file("terraform-demo.pub")}"
}

resource "aws_instance" "my-instance" {
  count         = "2"
  ami           = "${lookup(var.ami,var.aws_region)}"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.terraform-demo.key_name}"
  user_data     = "${file("install_apache.sh")}"
  to_port       =  80
  to_port       = 443

  tags = {
    Name  = "Terraform-${count.index + 1}"
    Batch = "5AM"
  }
}

resource "aws_db_instance" "RDS1" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}
