region="us-east-2"
instance_type="t3.micro"
security_group="terraform_test"
ingress_rules=[{
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}, {
    from_port = "3000"
    to_port = "3000"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
]
egress_rules = [{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}    
]

private_key="C:\\Users\\Fabrizzio\\.ssh\\aws_conn_creds.pem"