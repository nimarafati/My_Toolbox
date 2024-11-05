# Introduction

-   Container is a standard unit of software package.  
-   To overcome issues related to installation of software on local
    machines and poetntial incompatibility with different OS.  
-   Containers solve:
    -   Application are packaged in an isolated environment
    -   All dependencies and configs are delivered together
    -   Same. command on all OS
    -   Standardized process

# Docker

-   It has containerization toolkit
-   Build, deploy and manage applications
-   Free for academic use.

## Terminology

-   Image: blueprints of the application and dependencies
-   Container: instance of a docker image
-   Daemon: a background service that runs on your system, managing all
    Docker operations.  
-   Client command line tool that allows the user to interact with the
    daemon.  
-   Hub a registry docker image.  
-   Host is the local machine or server running the image.

## Images vs Docker container

<table>
<colgroup>
<col style="width: 8%" />
<col style="width: 54%" />
<col style="width: 37%" />
</colgroup>
<thead>
<tr class="header">
<th>Feature</th>
<th>Docker Image</th>
<th>Docker Container</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Definition</td>
<td>Read-only templates that define the environment and include
application code, libraries, dependencies</td>
<td>Running instances of Docker images with an isolated environment</td>
</tr>
<tr class="even">
<td>Mutability</td>
<td>Immutable (read-only)</td>
<td>Mutable (can be changed during runtime)</td>
</tr>
<tr class="odd">
<td>Storage</td>
<td>Stored in Docker Hub or registry servers</td>
<td>Created on the host system temporarily</td>
</tr>
<tr class="even">
<td>Usage</td>
<td>Used to create containers</td>
<td>Runs the application or service in an isolated environment</td>
</tr>
</tbody>
</table>

# Principle

`Docker file`  
- FROM: set base image (e.g. ubuntu which make. your image to work with
linux environment or OS)  
- RUN: execute command in image  
- ENV: set environment variables  
- WORKDIR: set working directory  
- COPY: copies files from your local machine into image  
- CMD: what command will be executed when the container runs

# Container Registery

-   Storage location for your docker images  

-   Enables sharing and distribution of images  

-   Types: Private & Public

-   Dockerhub:

    -   Largest public registry  
    -   Public and private  
    -   Official Images: curated and maintained, ensuring high quality
        and security

# Docker Image Tags

`{image-repository}/{image-name}:{tag}`  
- Purpose: labels assigned to images to differentiate versions.  
- Avoid using latest tag for production.  
- Importance: Helps manage dependencies, rollbacks and updates
effectively.  
- Implement a Versioning strategy: like semantic or date-based.

# Commands:

-   `docker images`: List of images
-   `docker ps` : List all currently running images.  
-   `docker pull {name}:{tag}` :Pull image from registry.  
-   `docker top <container-name>` : Shows resource usage of running
    containers.  
-   `docker run -p <host-port>:<container-port> <image-name>:<tag>` :
    download image from registry and run the container.
-   `docker logs <container-name>`: Logs of running containers.  
-   `docker start <container-name>`: Starts a container.  
-   `docker stop <container-name>`: Stops a container.  
-   `docker restart <container-name>`: Restarts a container.  
-   `docker build -r {name}:{tag} .` : build docker image from
    Dockerfile in the current.
-   `docker push {name}:{tag}` : Push to dockerhub.
-   `docker login` : To log in to docker.

# Example

In this example we will create three files:  
- `Dockerfile`  
- `requirements.txt`  
- `app.py` a python script

## Dockerfile

    # Dockerfile
    FROM python:3.8-slim       # Use Python 3.8 slim version as the base image
    WORKDIR /app               # Set the working directory to /app
    COPY requirements.txt /app # Copy requirements.txt into the working directory
    RUN pip install -r requirements.txt  # Install dependencies from requirements.txt
    COPY app.py /app           # Copy app.py into the working directory
    EXPOSE 5000                # Expose port 5000 for the application
    CMD ["python", "app.py"]   # Run app.py using Python when the container starts

## `requirements.txt`

    # requirements.txt
    Flask

## `app.py`

    # app.py
    from flask import Flask
    app = Flask(__name__)

    @app.route('/')
    def hello():
        return "Hello, Welcome to the Docker Workshop. I am Flask!"

    if __name__ == "__main__":
        app.run(host="0.0.0.0", port=5000)

## Building

    docker build -t mtbio-example:v1.0 .
    docker build -t nimarafati/mtbio-example:v1.0 . # If you want to push to Dockerhub

## Running the container

    docker run -p 5000:5000 mtbio-example:v1.0
    docker build -t nimarafati/mtbio-example:v1.0 .

## Pushing container

    docker push nimarafati/mtbio-example:v1.0

# Packaging a shiny application

Clone the github repo developed for a project at ScilifeLab on survey
for people with ADHD diagnoses (age 0-19) that use medications in 2006.
The dataset is from *The Swedish National Board of Health and Welfare
(Socialstyrelsen)*.

    git clone https://github.com/ScilifelabDataCentre/shiny-adhd-medication-sweden.git -b container-workshop
    cd shiny-adhd-medication-sweden

We create a new `Dockerfile`.

    FROM rocker/shiny:4.2.0   # Use the Rocker Shiny image with R version 4.2.0 as the base image

    RUN apt-get update && \                        # Update the package lists for apt
        apt-get upgrade -y && \                    # Upgrade installed packages
        apt-get install -y git libxml2-dev libmagick++-dev && \  # Install git, libxml2-dev, and libmagick++-dev
        apt-get clean && \                         # Clean up unnecessary files
        rm -rf /var/lib/apt/lists/*                # Remove cached files in apt lists to reduce image size

    # Install standard R packages from CRAN
    RUN Rscript -e 'install.packages(c("shiny","tidyverse","BiocManager"), dependencies = TRUE)'

    # Install Bioconductor packages
    RUN Rscript -e 'BiocManager::install(c("Biostrings"), ask = FALSE)'

    RUN rm -rf /srv/shiny-server/*                  # Clear the default shiny-server directory
    COPY /app/ /srv/shiny-server/                   # Copy app files to the shiny-server directory  

    USER shiny                                      # Set the user to 'shiny'

    EXPOSE 3838                                     # Expose port 3838 for Shiny applications

    CMD ["/usr/bin/shiny-server"]                   # Start Shiny server when the container starts

-   Base Image: Uses `rocker/shiny:4.2.0` as the base image, which
    includes R version 4.2.0 and Shiny server.

-   System Dependencies:

    -   `git`: For version control and managing code.  
    -   `libxml2-dev`: Provides XML library support for R packages that
        require XML parsing.  
    -   `libmagick++-dev`: Provides image processing capabilities
        required by packages like magick.

-   R Packages:

    -   Installs CRAN packages: `shiny` (for web applications),
        `tidyverse` (a collection of data science packages), and
        `BiocManager` (for managing Bioconductor packages). s
    -   Installs Bioconductor package: `Biostrings` (used for biological
        string operations, essential for bioinformatics applications).  
    -   Application Files: Copies the contents of the local app/
        directory into the Shiny server directory
        (`/srv/shiny-server/`), where the application will run.

-   Environment and Server Configuration:

    -   Sets the server to run under the shiny user.  
    -   Exposes port 3838 to make the Shiny app accessible. \*\*Note
        that you need to use this port number for running. Check the
        `docker run` command below.  
    -   Configures the server to start the Shiny app when the container
        launches.

<!-- -->

    docker build --platform linux/amd64 -t nimarafati/adhd-shiny:v1.0 .

    docker run --rm -p 3838:3838 nimarafati/adhd-shiny:v1.0

# Tutorial from Scilife Lab Data Center held at Swedish Bioinformatics Workshop 2024

[Link to Tutorial](https://docker-workshop.serve.scilifelab.se/).
