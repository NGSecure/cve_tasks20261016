#!/usr/bin/env python
# pylint: disable=C0116,W0613

from telegram import Update

def check_perm (update: Update):
    # Check user permission. Might be hard to generalize.
    # Maybe we need check_perm_pin() and others instead.
    # Or check_perm(update, perm: Type_CONST)
    bot = update.message.chat.bot
    chat = bot.get_chat(update.message.chat.id)
    user = update.message.from_user.id
    admin = chat.get_member(user)
    return (admin.status in ('administrator', 'creator'))

def check_admin(update: Update):
    bot = update.message.chat.bot
    chat = bot.get_chat(update.message.chat.id)
    user = update.message.from_user.id
    admin = chat.get_member(user)
    # if admin.status in ('administrator', 'creator') == True:
    return (admin.status in ('administrator', 'creator'))

    # admins = [
    #     f"@{admin.user.username}"
    #     for admin in chat.get_administrators()
    #     if admin.user.id != user
    #         pass
    #     else:
    # ]
    # admins = [
    #     f"@{admin.user.username}"
    #     for admin in chat.get_administrators()
    #     if admin.user.id != bot.get_me().id
    # ]
    # return False
