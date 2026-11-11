#!/usr/bin/env python
# pylint: disable=C0116,W0613

from telegram import BotCommand

Commands = {
    1: BotCommand("about", "About this bot."),
    2: BotCommand("admins", "List and tag group admins."),
    3: BotCommand("id", "Reply to a message to get user ID."),
    4: BotCommand("sticker", "Reply to a sticker to get sticker ID and stickerset."),
    5: BotCommand("cat", "Display a random cat pic."),
    6: BotCommand("dog", "Display a random dog pic."),
}

AdminCommands = {
    1: BotCommand("id", "Reply to a message to get user ID."),
    2: BotCommand("pin", "Pin a message."),
    3: BotCommand("mute", "Mute a user."),
    4: BotCommand("unmute", "Unmute a user."),
    5: BotCommand("ban", "Ban a user."),
    6: BotCommand("unban", "Unban a user."),
    7: BotCommand("chat", "Display group information."),
}

DmCommands = {
    1: BotCommand("about", "About this bot."),
    2: BotCommand("uptime", "Display bot uptime."),
}

OwnerCommands = {
    1: BotCommand("about", "About this bot."),
    2: BotCommand("uptime", "Display bot uptime."),
    3: BotCommand("chat", "Display group information."),
    4: BotCommand("id", "Reply to a message to get user ID."),
    5: BotCommand("pin", "Pin a message."),
    6: BotCommand("mute", "Mute a user."),
    7: BotCommand("unmute", "Unmute a user."),
    8: BotCommand("ban", "Ban a user."),
    9: BotCommand("unban", "Unban a user."),
    10: BotCommand("perms", "Display default user permissions."),
}
