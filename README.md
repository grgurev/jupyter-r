## Jupyter-R data science Docker image

This image serves the purpose of being a boilerplate for creating simple and small data-science containers.  
It is based on the Debian testing slim image and Jupyter lab with Python 3 and R kernels. Everything else is on you.

### Installation
The simplest way of starting it is to download from the DockerHub:
```
docker pull grgurev/jupyter-r
```

### Usage
To start the container you just go the root directory of the project and run:
```
docker run --rm -v "$pwd":/home/docker/project -p 8888:8888 grgurev/jupyter-r
```
There is no tokens - default password for getting into container is: `tisimalavjeverica`