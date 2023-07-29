FROM python:3.11

# Copy requirements file.
COPY requirements.txt /tmp/requirements.txt
COPY ./application /var/application

# Run installer commands
RUN pip install -U pip
RUN pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r /tmp/requirements.txt

WORKDIR /var

CMD ["gunicorn", "-w", "1", "--access-logfile", "-", "-b", ":5000", "-t", "30", "application.app:create_app()"]