provider "aws" {
    region = "us-east-1"
    shared_credentials_file = "/Users/emerson.santos/.aws/credentials"
    profile = "terraform"
}

# example é o nome da instancia
resource "aws_instance" "example" {
    ami = "ami-064a0193585662d74"
    instance_type = "t2.micro"
    key_name = "${aws_key_pair.terraform_key.key_name}"
    security_groups = ["${aws_security_group.permite_ssh.name}"]
}

resource "aws_key_pair" "terraform_key" {
   key_name = "terraform_key"
   # Irá postar minha chave publica na instancia a ser criada.
   public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_security_group" "permite_ssh" {
    name = "permite_ssh"
    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
      from_port = 0
      to_port = 0
      protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
}

output "example_public_dns" {
    value = "${aws_instance.example.public_dns}"
}
