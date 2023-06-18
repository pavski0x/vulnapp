############################ 
#  Bastion Instance Policy #
############################

resource "aws_iam_policy" "MongoDB-Backup-S3-Access-Policy" {
  name        = "S3-Bucket-Access-Policy"
  description = "Provides permission to access S3"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${var.mongodb_backup_bucket}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.mongodb_backup_bucket}/*"
            ]
        }
    ]
})
}

resource "aws_iam_role" "MongoDB-Backup-S3-Access-Role" {
  name = "MongoDB-Backup-S3-Access-Role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
})
}

resource "aws_iam_policy_attachment" "MongoDB-Backup-S3-attach" {
  name       = "MongoDB-Backup-S3-attach"
  roles      = [aws_iam_role.MongoDB-Backup-S3-Access-Role.name]
  policy_arn = aws_iam_policy.MongoDB-Backup-S3-Access-Policy.arn
}

# Allow bastion to write to S3 bucket
resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name = "bastion_instance_profile"
  role = aws_iam_role.MongoDB-Backup-S3-Access-Role.name
}



#############################
#  Database Instance Policy #
#############################

resource "aws_iam_policy" "MongoDB-EC2-Star-Access-Policy" {
  name        = "MongoDB-EC2-Star-Access-Policy"
  description = "Provides permission to access S3"

  policy = jsonencode({
    "Version": "2012-10-17",
     "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    }
  ]
}
)
}

resource "aws_iam_role" "MongoDB-EC2-Star-Access-Role" {
  name = "MongoDB-EC2-Star-Access-Role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
})
}

resource "aws_iam_policy_attachment" "MongoDB-EC2-Star-attach" {
  name       = "MongoDB-EC2-Star-attach"
  roles      = [aws_iam_role.MongoDB-EC2-Star-Access-Role.name]
  policy_arn = aws_iam_policy.MongoDB-EC2-Star-Access-Policy.arn
}

resource "aws_iam_instance_profile" "mongodb_instance_profile" {
  name = "mongodb_instance_profile"
  role = aws_iam_role.MongoDB-EC2-Star-Access-Role.name
}