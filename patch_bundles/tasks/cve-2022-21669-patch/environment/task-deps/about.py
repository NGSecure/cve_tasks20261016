#!/usr/bin/env python
# pylint: disable=C0116,W0613

import version
import config
from utils import escape_md

ORG  = "https://github.com/puddingBot"
REPO = "https://git.io/JygBe"
DOCS = "https://puddingbot.github.io"

ANIMATION = f"{config.ASSETS}About.gif"
TEXT = ("Pudding {} \n \n" 
        "Made with much love and German engineering ❤️ \n \n"
        f"GitHub: {REPO}").format(version.CURRENT)

WELCOME_TEXT =  escape_md("Welcome to @PuddingBot 😺 \n \n"
                         "@PuddingBot is your feline group management bot, made with love and German engineering 💕\n \n"
                         "This bot is proudly released under the terms of the AGPL3 Free Software License. \n \n")

GROUP_ADD_TEXT = escape_md("Hello and Meow 😸 \n \n"
                         "@PuddingBot is your feline group management bot, made with love and German engineering 💕\n \n"
                         "The bot is Free Software under the AGPL3. \n \n"
                         f"Source code: {REPO} \n"
                         f"Docs: {DOCS}")
