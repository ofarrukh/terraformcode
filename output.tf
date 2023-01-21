# output "Myec2" {
#   value = "${element(aws_instance.Myec2.*.id,0)}"
# }

output "Myec2" {
  value = aws_instance.Myec2.*
}
