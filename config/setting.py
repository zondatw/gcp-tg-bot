import os

from logging.config import dictConfig

from dotenv import load_dotenv

load_dotenv(".env")
load_dotenv(".local.env")

BOT_TOKEN = os.getenv("BOT_TOKEN")

dictConfig({
    "version": 1,
    "formatters": {
        "default": {
            "format": "[%(asctime)s] %(levelname)s in %(module)s: %(message)s",
        }
    },
    "handlers": {
        "wsgi": {
            "class": "logging.StreamHandler",
            "stream": "ext://flask.logging.wsgi_errors_stream",
            "formatter": "default"
        }
    },
    "root": {
        "level": "INFO",
        "handlers": ["wsgi"]
    }
})