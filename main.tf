

resource "aws_instance" "Myec2" {
  ami               = data.aws_ami.amazon-linux-2.id
  instance_type     = var.instance_type
  availability_zone = var.availability_zone[0]
  subnet_id         = aws_subnet.public-subnet[0].id
  security_groups   = [aws_security_group.sgweb.id]
  tags = {
    Name = "MyEC2_public"
  }
}

# resource "aws_instance" "Myec2_priv"{
#       ami = data.aws_ami.amazon-linux-2.id
#       instance_type = "${var.instance_type}"
#       count = "${length(var.availability_zone)}" 
#       availability_zone = var.availability_zone[count.index]
#       key_name = "terraforminfy"
#       security_groups = [aws_security_group.privateSG.id]
#       subnet_id = aws_subnet.private-subnet[count.index].id
#       tags = {
#           Name = "MyEC2_Private-${count.index}"
#       }
# }

