from flask import Flask

from .views import public

def create_app():
    app = Flask(__name__)
    app.register_blueprint(public)
    return app

if __name__ == "__main__":
    app = create_app()
    app.run()
else:
    gunicorn_app = create_app() 
    
