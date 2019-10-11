FROM debian:testing-slim AS python

ARG NB_USER="docker"
ARG NB_UID="1000"
ARG NB_GID="100"

USER root

ARG DPKGSCONF="wget sudo locales"
RUN apt-get update && apt-get -y dist-upgrade && \
  apt-get install -y --no-install-recommends ${DPKGSCONF} && \
  rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
  rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

ENV SHELL=/bin/bash NB_USER=$NB_USER NB_UID=$NB_UID NB_GID=$NB_GID LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8
ENV HOME=/home/$NB_USER

RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc

RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \
  useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
  echo "$NB_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$NB_USER && \
  chmod g+w /etc/passwd && \
  addgroup $NB_USER staff

ARG DPKGSPY="python3-pip python3-setuptools nodejs npm"
RUN apt-get update && apt-get install -y --no-install-recommends ${DPKGSPY} && \
  ln -s /usr/bin/pip3 /usr/bin/pip && \
  npm install npm@latest -g && \
  chown -R 1000:100 "/home/$NB_USER/.npm" && \
  rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
  rm -rf /var/lib/apt/lists/*

USER $NB_UID
WORKDIR $HOME/project

ENV PATH=/home/$NB_USER/.local/bin:$PATH

RUN pip install --no-cache-dir jupyter jupyterlab && \
  npm cache clean --force && \
  jupyter notebook --generate-config && \
  rm -rf /home/$NB_USER/.cache/yarn

EXPOSE 8888

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser"]

COPY .jupyter $HOME/.jupyter

USER root

ARG DPKGSR="r-base r-base-dev"
RUN apt-get update && apt-get install -y --no-install-recommends ${DPKGSR} && \
  rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
  rm -rf /var/lib/apt/lists/*

USER $NB_UID

ARG RPKGS="IRdisplay IRkernel data.table"
RUN Rscript -e "install.packages(commandArgs(TRUE), type = 'source')" ${RPKGS} && \
  Rscript -e "IRkernel::installspec()"