## Jupyter-r data science Docker image

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

All command in container that requires `root` such as `apt-get` can be easily run with `sudo` while all Python packages as well as R packages can be installed as normal user:
```
pip install numpy pandas
```

Jupyter lab extensions can also be installed as normal user, for example:
```
jupyter labextension install @jupyter-widgets/jupyterlab-manager ipyleaflet
jupyter nbextension enable ipyleaflet --py
```