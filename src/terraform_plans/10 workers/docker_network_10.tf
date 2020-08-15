
variable home {}


resource "docker_network" "private_network" {
  name = "mr-network"
  attachable = true
}

# Find the golang 1.13 image.
resource "docker_image" "go_image" {
  name = "golang:1.13"
}

#Master Container

# Start a container
resource "docker_container" "go_master" {
  name  = "master"
  image = docker_image.go_image.name
  networks_advanced  {
    name = docker_network.private_network.name
  }

  start = true

  # Mount project directory as a shared directory with the container
  mounts  {
      type = "bind"
      target = "/go/master"
      source = "${var.home}/go/src/Phase1/src/master"
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

  mounts  {
    type = "bind"
    target = "/go/worker"
    source = "${var.home}/go/src/Phase1/src/worker"
  }


}

resource "docker_container" "go_worker2" {
  name  = "worker2"
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

  mounts  {
    type = "bind"
    target = "/go/worker"
    source = "${var.home}/go/src/Phase1/src/worker"
  }




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

  mounts  {
    type = "bind"
    target = "/go/worker"
    source = "${var.home}/go/src/Phase1/src/worker"
  }

}

resource "docker_container" "go_worker4" {
  name  = "worker4"
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

  mounts  {
    type = "bind"
    target = "/go/worker"
    source = "${var.home}/go/src/Phase1/src/worker"
  }

}
resource "docker_container" "go_worker5" {
  name  = "worker5"
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

  mounts  {
    type = "bind"
    target = "/go/worker"
    source = "${var.home}/go/src/Phase1/src/worker"
  }

}
resource "docker_container" "go_worker6" {
  name  = "worker6"
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

  mounts  {
    type = "bind"
    target = "/go/worker"
    source = "${var.home}/go/src/Phase1/src/worker"
  }

}

resource "docker_container" "go_worker7" {
  name  = "worker7"
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

  mounts  {
    type = "bind"
    target = "/go/worker"
    source = "${var.home}/go/src/Phase1/src/worker"
  }

}
resource "docker_container" "go_worker8" {
  name  = "worker8"
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

  mounts  {
    type = "bind"
    target = "/go/worker"
    source = "${var.home}/go/src/Phase1/src/worker"
  }

}
resource "docker_container" "go_worker9" {
  name  = "worker9"
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

  mounts  {
    type = "bind"
    target = "/go/worker"
    source = "${var.home}/go/src/Phase1/src/worker"
  }

}
resource "docker_container" "go_worker10" {
  name  = "worker10"
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

  mounts  {
    type = "bind"
    target = "/go/worker"
    source = "${var.home}/go/src/Phase1/src/worker"
  }

}