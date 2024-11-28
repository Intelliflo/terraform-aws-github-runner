resource "aws_iam_role_policy" "gh_artifacts_bucket" {
  name = "github-ci-loop-artifacts-bucket"
  role = aws_iam_role.runner.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "githubActionArtifacts",
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:GetObjectTagging",
          "s3:DeleteObject",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:PutObjectTagging"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::github-ci-loop-artifacts/*",
          "arn:aws:s3:::github-ci-loop-artifacts",
          "arn:aws:s3:::packages.shs-ie-01.intelliflo.services/*",
          "arn:aws:s3:::packages.shs-ie-01.intelliflo.services",
          "arn:aws:s3:::mssql-migrations.shs-ie-01.intelliflo.services/*",
          "arn:aws:s3:::mssql-migrations.shs-ie-01.intelliflo.services"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "runner_ecr_scan_push_access" {
  name = "ecr-scan-push-access"
  role = aws_iam_role.runner.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "githubActionEcr",
        Action = [
          "ecr:DescribeImageScanFindings",
          "ecr:StartImageScan",
          "ecr:GetDownloadUrlForLayer",
          "ecr:DescribeRegistry",
          "ecr:GetAuthorizationToken",
          "ecr:ListTagsForResource",
          "ecr:UploadLayerPart",
          "ecr:BatchDeleteImage",
          "ecr:ListImages",
          "ecr:PutImage",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeImages",
          "ecr:DescribeRepositories",
          "ecr:InitiateLayerUpload",
          "ecr:BatchCheckLayerAvailability"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "runner_code_artifact_admin_access" {
  role       = aws_iam_role.runner.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeArtifactAdminAccess"
}

resource "aws_iam_role_policy_attachment" "runner_basic_ecr_access" {
  role       = aws_iam_role.runner.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}
