provider "local" {

}

resource "local_file" "hello-world" {
    filename = "${path.module}/hw.txt"
    content = "Hello world"
    file_permission = "0640"

}

output "hw_file" {
    value = local_file.hello-world.content

}
