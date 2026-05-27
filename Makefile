PROJ_BASE=$(shell pwd)
NB_CONFIG=$(HOME)/.jupyter/jupyter_lab_config.py
PYTHONVER=python3.10
PYTHONVENV=$(PROJ_BASE)/venv
VENVPYTHON=$(PYTHONVENV)/bin/$(PYTHONVER)
ARTIFACTORY_ENV_URL=https://picarro.jfrog.io/artifactory/picarro-generic-private/picarro-notebooks
DOCKER_URL=https://picarro.jfrog.io/artifactory/docker-repo/picarro-notebooks
CONTAINER_ID=`docker image ls | grep -m 1 debian-builder20 | awk -F '  +' '{print $$3}'`
CONTAINERNAME=jupyter_hub_sat
DOCKER_REPOSITORY=picarro-docker-repo.jfrog.io
CONTAINERVERSION=${docker_tag}

.PHONY: install
install: bootstrap
	@echo "Installing backend"
	$(VENVPYTHON) setup.py install
	@echo "\nYou may want to activate the virtual environmnent with 'source venv/bin/activate'\n"

.PHONY: bootstrap
bootstrap:
	@echo "Creating virtual environment 'venv' for development."
	python3 -m virtualenv -p $(PYTHONVER) venv
	@echo "Installing python modules from requirements.txt"
	$(VENVPYTHON) -m pip install -r requirements.txt


.PHONY: develop
develop: bootstrap
	@echo "Installing spectral-toolbox, with editible modules ('python setup.py develop')"
	$(VENVPYTHON) setup.py develop
	@echo "\n Activate the virtual environmnent with 'source venv/bin/activate'\n"

.PHONY: setup_env
setup_env:
	@echo "Creating Jupyter Environment"
	$(VENVPYTHON) -m nodeenv -p
	$(VENVPYTHON) -m ipykernel install --user --name=notebook-env
	jupyter labextension install jupyterlab_templates
	jupyter server extension enable --py jupyterlab_templates
	jupyter labextension install @jupyter-widgets/jupyterlab-manager
	jupyter lab --generate-config -y
	@echo 'c.JupyterLabTemplates.template_dirs = ["$(PROJ_BASE)/templates"]' >> $(NB_CONFIG)
	@echo 'c.JupyterLabTemplates.include_default = True' >> $(NB_CONFIG)
	@echo 'c.JupyterLabTemplates.include_core_paths = True' >> $(NB_CONFIG)


.PHONY: jup_env
jup_env:
	wget --output-document=./.env \
	--header='X-JFrog-Art-Api:'"$(JFROG_API_KEY)"'' \
	"$(ARTIFACTORY_ENV_URL)/notebook.env" \


.PHONY: docker_deploy
docker_deploy:
	@echo "Deploying image: ${CONTAINERNAME} - ID: ${CONTAINER_ID}"
	docker push ${DOCKER_REPOSITORY}/${CONTAINERNAME}:${CONTAINERVERSION}
