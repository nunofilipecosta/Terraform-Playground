variable "whitelist" {
  type        = list(string)
  default     = ["0.0.0.0"]
  description = "a list of ip's addressess that wil be white listed"
}
