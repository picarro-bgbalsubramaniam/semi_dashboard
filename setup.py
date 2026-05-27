from os import getenv
from setuptools import setup, find_packages

with open("README.md", "r") as f:
    readme = f.read()

def get_version():
    # Check for these environment variables, set by the build system
    major = getenv('majorVersion')
    minor = getenv('minorVersion')
    patch = getenv('patchVersion')
    major = minor = patch = '1'
    return ".".join((major, minor, patch))

version = get_version()

setup(
    name='picarro-notebooks',
    version=version,
    license="Copyright Picarro internal use only",
    author="Adam Egger",
    author_email="aegger@picarro.com",
    project_urls={
        "Code": "https://github.com/picarro/picarro-notebooks",
    },
    description="repository for commonly shared analysis and custom scripts",
    long_description=readme,
    long_description_content_type="text/markdown",
    maintainer="Picarro",
    packages=find_packages("src"),
    package_dir={"": "src"},
    install_requires=[],
    python_requires=">=3.9",
)
