from flask import Blueprint

public = Blueprint("public", __name__)

VERSION="1"

@public.route("/")
def hello():
    return f"Hello World! Version #{VERSION} is running"