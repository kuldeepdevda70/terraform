output "target_group_arn" { value = aws_lb_target_group.react_tg.arn }
output "alb_dns" { value = aws_lb.react_alb.dns_name }