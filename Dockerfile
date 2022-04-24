# Note that poetry should have been initialized (via virtual environment) before
# building docker image to produce lock and toml files
# A lot of this is based off of https://stackoverflow.com/a/54763270/5400084

# BUILD OFF OF BASE IMAGE
FROM python:3.9-slim

# Define variables to access from command line
ARG MY_POETRY_VERSION=1.1.13
ARG FIRST_RUN="False"
ARG YOUR_ENV="develop"

# Define environments based on arguments
ENV YOUR_ENV=${YOUR_ENV}
ENV POETRY_VERSION=${MY_POETRY_VERSION}

# Set bash as default shell
SHELL ["/bin/bash", "-c"]

# BUILD PYTHON ENVIRONMENT
# Install poetry let it handle python package managment
RUN pip install --upgrade pip
RUN pip install --no-cache-dir "poetry==$POETRY_VERSION"

# DEFINE WORKSPACE
WORKDIR /workspace/

# Helpers
# Get needed tools
RUN ["apt-get", "update"]
RUN ["apt-get", "install", "-y", "vim"]

# Set persistent bash history (from https://code.visualstudio.com/remote/advancedcontainers/persist-bash-history)
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/workspace/.docker_command_history/.bash_history" \
    && echo $SNIPPET >> "/root/.bashrc"

# Add in helpers to navigate history
RUN echo  ' \
  "\e[A": history-search-backward \
  "\e[B": history-search-forward \
  "\e[C": forward-char \
  "\e[D": backward-char \
'  >> /etc/inputrc

# Run poetry based on requirements.txt
#COPY requirements.txt ./
#RUN poetry init --no-interaction
#RUN cat requirements.txt | xargs poetry add

# Copy over poetry lock and toml files to only have them run if they're changed
COPY poetry.lock pyproject.toml ./
RUN poetry config virtualenvs.create false \
  && poetry install $(test "$YOUR_ENV" == production && echo "--no-dev") --no-interaction --no-ansi
#RUN poetry install $(test "$YOUR_ENV" == production && echo "--no-dev") --no-interaction --no-ansi

#EXPOSE 8501

# Develop: It's better to mount the current working directory instead of copying

# Production: It's better to copy the files that shouldn't change
#COPY . .

# Work inside Docker environment
#CMD bash
# Set bash as default shell
CMD source /root/.bashrc && bash



#CMD [ "python", "./main.py" ]
#ENTRYPOINT ["streamlit", "run"]
#CMD ["streamlit", "run", "app/sandbox.py"]