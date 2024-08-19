## SSM parameters
##### ssm read policy

{
    "Version": "2012-10.17",
    "Statemetn": [
        {
            "Sid": "SSMListParams",
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeParameters"
            ],
            "Resource": "*"
        },
            "Sid": "SSMGetParams",
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameters"
            ],
            "Resource": "arm:aws:ssm:eu-central-1:
    ]
}
