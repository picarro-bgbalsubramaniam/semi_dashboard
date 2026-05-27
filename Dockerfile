FROM jupyterhub/jupyterhub:4.0

ARG SAT_JUP_USER
ARG SAT_JUP_PASS
ARG JFROG_USER
ARG JFROG_API_KEY

ENV SAT_JUP_USER $SAT_JUP_USER
ENV SAT_JUP_PASS $SAT_JUP_PASS

RUN apt-get update \
&& apt-get install gcc -y \
&& apt-get install -y gfortran \
&& apt-get install -y build-essential \ 
&& apt-get install -y python3-dev \
&& apt-get clean

COPY requirements.txt .
COPY . .

RUN pip install \
    --index-url=https://${JFROG_USER}:${JFROG_API_KEY}@picarro.jfrog.io/artifactory/api/pypi/python/simple \
    --extra-index-url=https://pypi.python.org/simple/ \
    -r requirements.txt 

RUN pip install \
    --index-url=https://${JFROG_USER}:${JFROG_API_KEY}@picarro.jfrog.io/artifactory/api/pypi/python/simple \
    --extra-index-url=https://pypi.python.org/simple/ \
    .

RUN adduser $SAT_JUP_USER --gecos " "; echo $SAT_JUP_USER:$SAT_JUP_PASS | chpasswd

COPY templates /usr/local/lib/python3.10/dist-packages/jupyterlab_templates/templates/
RUN mkdir /home/$SAT_JUP_USER/notebook_work

# CMD ["jupyterhub", "--Spawner.notebook_dir=/home/picarro/notebook_work"]
