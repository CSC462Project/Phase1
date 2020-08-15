# Phase1

_NOTE_: Terraform will work as a binary on linux.csc.uvic.ca, but needs Docker to create containers. Docker cannot be
installed on linux.csc.uvic.ca, so a different testing environment is required. 

##Requirements:

- Docker must be installed, and the docker daemon must be running

This can be done by using a service such as Docker Desktop, which provides
a GUI interface to Docker and runs the daemon on startup, or by running one of these commands:

systemctl:

$ sudo systemctl start docker


###OR

service:

$ sudo service docker start

- Golang 1.13

- The project to be placed within the go/src folder


NOTE: Terraform is provided as binary, and will install packages in the working directory. However, this
 will require read/write permissions in the working directory.

The binaries provided in the terraform zip files are for 32-bit and 64-bit 
Linux. If you would like a binary for a different operating system, follow
this link: https://www.terraform.io/downloads.html


NOTE: Make sure the Terraform binary is in the project directory (i.e. src/) before running the script. 

Guide: 

1. Checkout directory from GitHub and place within the go/src folder

2. Run the following command:

    ./terraform init (if using the local binary, other use 'terraform init')
    
this will allow Terraform to acquire the necessary packages to use in the Terraform script, 'docker_network.tf'


3. Run the command:

bash test-mr.sh <user_directory>

or change the permissions of the file to run it as an executable using:

chmod +x test-mr.sh

./test-mr.sh <user_directory>



<user_directory> should be replaced with the directory in which the go/ folder in contained in. This MUST be an absolute
path (i.e. do not use $HOME or $PWD when providing this value. It isn't supported when coded into Terraform and has not been
tested as a command line argument)

Files should shortly appear in the worker/ directory.

The program is finished when there are 10 files in each of the 10 reduce categories and 10 final output files. 



NOTE: To run the program with different amounts of worker nodes, either move the terraform binary into the specific folder in the terraform_plans directory or if you have the binary added to your PATH, simply run terraform in any of the test scenario directories in terraform_plans.
