resource "aws_iam_role" "rent_habesha_eks_iam_role" {
  name = "eks-iam-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "eks.amazonaws.com"
            }
        }
    ]
  })
  tags = {
    enviroment = var.enviroment
  }
}
data "aws_iam_policy" "rent_habesha_eks_iam_policy" {
  name = "AmazonEKSClusterPolicy"
}
resource "aws_iam_role_policy_attachment" "rent_habesha_eks_iam_role_attachment" {
  role = aws_iam_role.rent_habesha_eks_iam_role.name
  policy_arn = data.aws_iam_policy.rent_habesha_eks_iam_policy.arn
}

resource "aws_eks_cluster" "rent_habesha_eks_cluster" {
  name = "rent-habesha-cluster"
  access_config {
    authentication_mode = "API"
    bootstrap_cluster_creator_admin_permissions = true # 
  }
  role_arn = aws_iam_role.rent_habesha_eks_iam_role.arn
  version = var.cluster_version
  bootstrap_self_managed_addons = true
  vpc_config {
    endpoint_private_access = true
    endpoint_public_access = true
    subnet_ids = var.rent_habesha_private_subnet
  }
  depends_on = [ 
    aws_iam_role_policy_attachment.rent_habesha_eks_iam_role_attachment
   ]
}

resource "aws_iam_role" "rent_habesha_worker_node_iam_role" {
  name = "worker-node-iam-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [ 
      {
        
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      
      }
    ]
  })
  tags = {
    enviroment = var.enviroment
  }
}

data "aws_iam_policy" "rent_habesha_woker_node_policy" {
  for_each = var.worker_node_policy
  name = each.value
}
resource "aws_iam_role_policy_attachment" "rent_habesha_worker_node_policy_attachment" {
  for_each = var.worker_node_policy
  role = aws_iam_role.rent_habesha_worker_node_iam_role.name
  policy_arn = data.aws_iam_policy.rent_habesha_woker_node_policy[each.key].arn
}
resource "aws_eks_node_group" "rent_habesha_node_group" {
  cluster_name = aws_eks_cluster.rent_habesha_eks_cluster.name
  node_role_arn = aws_iam_role.rent_habesha_worker_node_iam_role.arn
  subnet_ids = var.rent_habesha_private_subnet
  scaling_config {
    desired_size = 1
    max_size = 2
    min_size = 1
  }
  update_config {
    max_unavailable = 1
  }
  depends_on = [ 
    aws_iam_role_policy_attachment.rent_habesha_worker_node_policy_attachment
   ]
}

resource "aws_security_group" "rent_habesha_alb_sg" {
  vpc_id = var.rent_habesha_vpc
  tags = {
    enviroment = var.enviroment
  }
}
resource "aws_security_group" "rent_habesha_worker_node_sg" {
  vpc_id = var.rent_habesha_vpc
  tags = {
    enviroment = var.enviroment
  }
}

# ----Fix VPC referrencing on module
resource "aws_vpc_security_group_ingress_rule" "rent_habesha_alb_ingress" {
  for_each = var.rent_habesha_alb_ingress_rule
  security_group_id = aws_security_group.rent_habesha_alb_sg.id
  cidr_ipv4 = each.value.cidr_ipv4
  from_port = each.value.from_port
  to_port = each.value.to_port
  ip_protocol = each.value.ip_protocol
}

//----------------Need to be configured once the destination port identified (WN or Application)
# resource "aws_vpc_security_group_egress_rule" "rent_habesha_alb_egress" {
#   security_group_id = aws_security_group.rent_habesha_alb_sg.id
#   from_port = 
#   to_port = 
#   ip_protocol = 
# }

