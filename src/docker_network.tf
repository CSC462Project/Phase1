
#TODO: use for/for-each to try to loop and create multiple worker nodes
# For now, just manually create 5 nodes
#nodes = 5


resource "docker_network" "private_network" {
  name = "mr-network"
  attachable = true
}

# Find the latest Ubuntu precise image.
resource "docker_image" "go_image" {
  name = "golang:1.13"
}


#Volumes

//resource "docker_volume" "master_data" {}
//
//resource "docker_volume" "worker_data" {}

# Master UUID
//resource "random_uuid" "master" { }

# Worker UUIDs
//resource "random_uuid" "worker1_id" { }
//resource "random_uuid" "worker2_id" { }
//resource "random_uuid" "worker3_id" { }
//resource "random_uuid" "worker4_id" { }
//resource "random_uuid" "worker5_id" { }




#Master Container

# Start a container
resource "docker_container" "go_master" {
  name  = "master"//-${random_uuid.master.result}"
  image = docker_image.go_image.name
  networks_advanced  {
    name = docker_network.private_network.name
  }

  start = true

  # Mount project directory as a shared directory with the container
  mounts  {
      type = "bind"
      target = "/go/master"
      source = "/Users/cameronwilson/go/src/PhaseIProject/master"
  }

  must_run = true
  publish_all_ports = true
  ports {
    internal = 80
    external = 4000
  }

  # Test command to keep a docker container running upon creation and launch
    command = [
      "tail",
      "-f",
      "/dev/null"
    ]

//  provisioner "remote-exec" {
//    inline = [
//      "go run /go/master/mrmaster.go pg-grimm.txt &",
//
//    ]

//  }

}




# Worker containers

resource "docker_container" "go_worker1" {
  name  = "worker1"
  image = docker_image.go_image.name
  networks_advanced  {
    name = docker_network.private_network.name
  }

  start = true
  must_run = true
  publish_all_ports = true


  # Test command to keep a docker container running upon creation and launch
  command = [
    "tail",
    "-f",
    "/dev/null"
  ]
  //  command = [
  //    "go",
  //    "run",
  //    "/go/src/worker.go",
  //    ">",
  //    "/go/src/worker_output_file",
  //    "&&",
  //    "tail",
  //    "-f",
  //    "/dev/null"
  //  ]
  mounts  {
    type = "bind"
    target = "/go/worker"
    source = "/Users/cameronwilson/go/src/PhaseIProject/worker"
  }
  //  entrypoint = ['go run /go/src/worker.go']

  env = ["MASTER_HOSTNAME=${docker_container.go_master.id}\n"]


}

resource "docker_container" "go_worker2" {
  name  = "worker2"
  image = docker_image.go_image.name
  networks_advanced  {
    name = docker_network.private_network.name
  }
//  upload {
//    source = "${path.module}/worker/worker.go"
//    file = "/go/src/worker.go"
//    executable = true
//  }
  start = true
  must_run = true
  publish_all_ports = true


  # Test command to keep a docker container running upon creation and launch
  command = [
    "tail",
    "-f",
    "/dev/null"
  ]
  //  command = [
  //    "go",
  //    "run",
  //    "/go/src/worker.go",
  //    ">",
  //    "/go/src/worker_output_file",
  //    "&&",
  //    "tail",
  //    "-f",
  //    "/dev/null"
  //  ]
  mounts  {
    type = "bind"
    target = "/go/worker"
    source = "/Users/cameronwilson/go/src/PhaseIProject/worker"
  }
  //  entrypoint = ['go run /go/src/worker.go']

  env = ["MASTER_HOSTNAME=${docker_container.go_master.id}\n"]


}

resource "docker_container" "go_worker3" {
  name  = "worker3"
  image = docker_image.go_image.name
  networks_advanced  {
    name = docker_network.private_network.name
  }

  start = true
  must_run = true
  publish_all_ports = true

  # Test command to keep a docker container running upon creation and launch
  command = [
    "tail",
    "-f",
    "/dev/null"
  ]
  //  command = [
  //    "go",
  //    "run",
  //    "/go/src/worker.go",
  //    ">",
  //    "/go/src/worker_output_file",
  //  ]
  mounts  {
    type = "bind"
    target = "/go/worker"
    source = "/Users/cameronwilson/go/src/PhaseIProject/worker"
  }
  //  entrypoint = ['go run /go/src/worker.go']

  env = ["MASTER_HOSTNAME=${docker_container.go_master.id}\n"]


}