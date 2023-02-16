resource "null_resource" "lambdas" {

  provisioner "local-exec" {
    command = "cd ../aws/lambdas && /bin/bash build_lambdas.sh"
  }
}
