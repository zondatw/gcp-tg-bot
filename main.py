from pprint import pprint

from flask import Flask, request
from flask.views import MethodView

import setting
from models import User

app = Flask(__name__)


class BotCommand:
    def parse(self, dict_data):
        if dict_data["text"] == "/start":
            app.logger.debug(f"Get Bot command 'start' request")
            self.start(dict_data)
        elif dict_data["text"] == "/leave":
            app.logger.debug(f"Get Bot command 'leave' request")
            self.leave(dict_data)

    def start(self, dict_data):
        username = dict_data["from"]["username"]
        first_name = dict_data["from"]["first_name"]
        last_name = dict_data["from"]["last_name"]
        chat_id = dict_data["chat"]["id"]
        user = User(username, first_name, last_name, chat_id)
        user.save()
        app.logger.info(user.to_dict())

    def leave(self, dict_data):
        username = dict_data["from"]["username"]
        first_name = dict_data["from"]["first_name"]
        last_name = dict_data["from"]["last_name"]
        chat_id = dict_data["chat"]["id"]
        user = User(username, first_name, last_name, chat_id)
        user.delete()


class HookAPI(MethodView):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.bot_command = BotCommand()

    def post(self):
        dict_data = request.get_json(force=True)
        app.logger.debug(f"dict_data: {dict_data}")

        try:
            if dict_data["message"]["entities"][0]["type"] == "bot_command":
                app.logger.debug(f"Get Bot command request")
                self.bot_command.parse(dict_data["message"])
        except KeyError:
            pass
        return "OK"


app.add_url_rule("/hook", view_func=HookAPI.as_view("hook"))

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=8080, debug=True)