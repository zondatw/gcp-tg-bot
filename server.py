from pprint import pprint

from flask import Flask, request
from flask.views import MethodView

import setting

app = Flask(__name__)


class BotCommand:
    def parse(self, dict_data):
        if dict_data["text"] == "/start":
            app.logger.debug(f"Get Bot command 'start' request")
            self.start(dict_data)

    def start(self, dict_data):
        username = dict_data["from"]["username"]
        chat_id = dict_data["chat"]["id"]
        app.logger.info(
            f"New user join: {username}\n"
            f"chat id: {chat_id}"
        )


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
    app.run()