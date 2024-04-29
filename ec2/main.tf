data "aws_ami" "custom" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*jegbu*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.custom.id
  instance_type = "t2.micro"

  tags = {
    Name = "apache"
  }
}