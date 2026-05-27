# semi_dashboard
The repo consists of Millipede and Rcubed notebooks and dashboard for semi application.

Environment Setup in Linux: py311_env_linux
Environment Setup in windows: py311_env.yml

Procedure to install environment:

Notebooks Installation on Linux:
	1. If no miniconda then:
	2. wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
	3. bash Miniconda3-latest-Linux-x86_64.sh
	4. source ~/miniconda3/bin/activate
	5. conda --version
	6. ~/miniconda3/bin/conda init bash
	7. source ~/.bashrc
	8. conda create -n py311_env python=3.11 -c conda-forge
	9. conda env update -n py311_env -f py311_env_linux.yml --prune
	10. If above conda command doesn't work then use following pip command
	11. python -m pip install jupyterlab
	12. For picarro-xarray installation
	13. conda install -c conda-forge h5py
	14. sudo apt update
	15. sudo apt install pkg-config libhdf5-dev
	16. conda install -c conda-forge h5py
	17. Pip install --no-deps .
	18. Install holoviews, hvplot, h5py
	19. If still error exists, then attempt to repair:Conda activate py311_env
	20. conda update -n base -c defaults conda
	21. Conda install python=3.11 --force-reinstall
	22. Conda install -c conda-forge h5py numpy pandas --force-reinstall
	23. Conda clean -all -y
	24. Python -c "import h5py; print(h5py.__version__)"
	25. Pip install plotly, flox, fastparquet, ray, bottleneck, dotenv, pyarrow
	26. Match the env if stuck
		a. conda install -c conda-forge \
		b. numpy=2.3.5 \
		c. pandas=2.2.3 \
		d. xarray=2025.12.0 \
		e. zarr=3.1.5
	27. If issue with spectral-toolkit
		a. Pip install pymongo 
		b. Pip install -e . --no-deps (Inside spectral-toolkit)
		c. pip install streamlit --only-binary=:all:
		d. conda install h5py
