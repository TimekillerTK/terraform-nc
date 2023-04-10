resource "aws_iam_role" "ec2_session_manager" {
    name = "${var.environment}-${var.namespace}-instance-profile-role"
    assume_role_policy = file("${path.module}/iam/assume_role_policy.json")
    tags = merge(local.common_tags, {
        Name = "${var.environment}-${var.namespace}-instance-profile-role"
    })
}

resource "aws_iam_policy" "session_manager_permissions" {
    name = "${var.environment}-${var.namespace}-instance-profile-policy"
    policy = file("${path.module}/iam/session_manager_permissions_policy.json")
    tags = merge(local.common_tags, {
        Name = "${var.environment}-${var.namespace}-instance-profile-policy"
    })
}

resource "aws_iam_role_policy_attachment" "session_manager_permissions_attachment" {
    policy_arn = aws_iam_policy.session_manager_permissions.arn
    role       = aws_iam_role.ec2_session_manager.name
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
    role = aws_iam_role.ec2_session_manager.name
    tags = merge(local.common_tags, {
        Name = "${var.environment}-${var.namespace}-instance-profile"
    })
}