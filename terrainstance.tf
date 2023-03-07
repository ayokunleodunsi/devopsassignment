resource "aws_key_pair" "newkeypair" {
  key_name   = "newkeypair"
  public_key = file("/home/ayoadmin/assignmtlast/keypair.pub")
}

resource "aws_instance" "hqwebserver" {
  ami           = "ami-09cd747c78a9add63"
  instance_type = "t2.micro"
  subnet_id = "aws_subnet.hqsubnet.id"
  key_name = "aws_key_pair.newkeypair.key_name"
  associate_public_ip_address = true

  tags = {
    Name = "HelloWorld"
  }
}