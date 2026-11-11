#!/usr/bin/env python
# pylint: disable=C0116,W0613

from telegram import Bot
from telegram.utils.helpers import escape_markdown
import config

bot = Bot(config.TOKEN)

def escape_md(text):
    return escape_markdown(text, version=2)