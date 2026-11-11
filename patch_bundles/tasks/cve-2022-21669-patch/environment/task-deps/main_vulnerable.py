#!/usr/bin/env python
# pylint: disable=C0116,W0613

import logging
import atexit

import telegram
from telegram import Update, ForceReply, ChatPermissions, Bot, BotCommand, BotCommandScope, BotCommandScopeChatMember
from telegram.ext import Updater, CommandHandler, MessageHandler, Filters, CallbackContext
from commands import Commands, AdminCommands, DmCommands, OwnerCommands
from utils import escape_md
import dogpic
import catpic

from admin import check_admin
import messages
import statuses
import config
import about
import uptime
import utils

from exceptions import NotImplemented

# Enable logging
logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s', level=logging.INFO
)

logger = logging.getLogger(__name__)

def exit_handler():
    # Provide TOKEN and UPDATE_CHANNEL CONSTs in separate module.
    # chat = bot.get_chat(update.message.chat.id)
    # Add "logging" value in database to turn this off during development.
    utils.bot.sendMessage(config.UPDATE_CHANNEL, "I'm going down for maintenance. See ya!")

# Define a few command handlers. These usually take the two arguments update and
# context.
def start(update: Update, context: CallbackContext) -> None:
    """Send a message when the command /start is issued."""
    user = update.effective_user
    update.message.reply_markdown_v2(
        fr'Hi {user.mention_markdown_v2()}\!',
        reply_markup=ForceReply(selective=True),
    )

def about_command(update: Update, context: CallbackContext) -> None:
    update.message.reply_animation(animation=about.ANIMATION,
    caption=about.TEXT)


def help_command(update: Update, context: CallbackContext) -> None:
    """Send a message when the command /help is issued."""
    update.message.reply_text('Help!')

def dog_command(update: Update, context: CallbackContext) -> None:
    url = dogpic.get_url()
    update.message.reply_photo(photo=url)

def cat_command(update: Update, context: CallbackContext) -> None:
    url = catpic.get_url()
    update.message.reply_photo(photo=url)

def chat_info_command(update: Update, context: CallbackContext) -> None:
    chat = update.message.chat.bot.get_chat(update.message.chat.id)

    # chatinfo = Bot.get_chat(self, chat_id = update.message.chat.id)
    if chat.type == "private":
        update.message.reply_text("Run this command in a group or channel.")
    else:
        update.message.reply_text(
            f'Group Name: {chat.title}\n '
            f'Group Description: {chat.description}\n '
            f'Group Username: @{chat.username}\n '
            f'Group ID: {chat.id}\n '
            f'Invite link: {chat.invite_link}\n')

def admins_command(update: Update, context: CallbackContext) -> None:
    bot = update.message.chat.bot
    chat = bot.get_chat(update.message.chat.id)
    admins = [
        f"{admin.user.mention_markdown_v2()}"
        for admin in chat.get_administrators()
        if admin.user.id != bot.get_me().id
    ]
    update.message.reply_markdown_v2("Group Administrators: " + ", ".join(admins))

def perms_command(update: Update, context: CallbackContext) -> None:
    chat = update.message.chat.bot.get_chat(update.message.chat.id)

    # Roll the text into a textblock function call. We'll probably need this often.
    if chat.type == "private":
        update.message.reply_text("Run this command in a group or channel.")
    else:
        update.message.reply_text(
            f'Default user permissions: {chat.permissions}'
        )

def user_info_command(update: Update, context: CallbackContext) -> None:
    print(context.args)
    #Need the error handling still. This command should return a text whenever we don't respond to another user.
    if not context.args:
        reply = update.message.reply_to_message.from_user
        update.message.reply_markdown_v2(
        fr'{reply.mention_markdown_v2()}\'s\ ID is {reply.id}\.')
    else:
        raise NotImplemented()
        # reply = update.message.
        # update.message.reply_markdown_v2(
        # fr'{context.args}\'s\ ID is {context.args}\.')

def sticker_info_command(update: Update, context: CallbackContext) -> None:
    #Need the error handling still. This command should return a text whenever we don't respond to another user.
    if not context.args:
        reply = update.message.reply_to_message
        if reply.sticker:
            update.message.reply_markdown_v2(
            f'\n'
            f'Sticker ID: `{escape_md(reply.sticker.file_id)}`\n'
            f'\n'
            f'Stickerset: `{escape_md(reply.sticker.set_name)}`')
        else:
            update.message.reply_text(
            f'Not a sticker!')
    else:
        raise NotImplemented()
        # reply = update.message.
        # update.message.reply_markdown_v2(
        # fr'{context.args}\'s\ ID is {context.args}\.')

def pin_message_command(update: Update, context: CallbackContext) -> None:
    #Need the error handling still. This command should return a text whenever we don't respond to another message.
    # Inline pinning a possibility
    reply = update.message.reply_to_message
    if check_admin(update) == True:
        reply.pin()
    else: 
        update.message.reply_text("Only admins may pin messages.")
        # update.message.reply_text("You're not permitted to pin messages.")
        # # Text block version (general version)
        # update.message.reply_text("You don't have permission to perform this action.")

def del_message_command(update: Update, context: CallbackContext) -> None:
    #Need the error handling still. This command should return a text whenever we don't respond to another message.
    reply = update.message.reply_to_message
    if check_admin(update) == True:
        reply.delete()
        update.message.delete()
    else: 
        update.message.reply_text("Only admins may delete messages.")

def mute_command(update: Update, context: CallbackContext) -> None:
    # Handle muting admins here, too.
    reply = update.message.reply_to_message.from_user
    # perms = {"can_send_messages": False}
    if check_admin(update) == True:
        # reply.from_user.can_send_messages = False
        update.message.chat.bot.restrict_chat_member(update.message.chat.id, reply.id, ChatPermissions())
        update.message.reply_markdown_v2(
        fr'{reply.mention_markdown_v2()}\ was muted indefinitely\.')
    else: 
        update.message.reply_text(messages.PERM_LACK + statuses.IS_ADMIN)

def unmute_command(update: Update, context: CallbackContext) -> None:
    chat = update.message.chat.bot.get_chat(update.message.chat.id)
    reply = update.message.reply_to_message.from_user
    # perms = {"can_send_messages": False}
    if check_admin(update) == True:
        # reply.from_user.can_send_messages = False
        update.message.chat.bot.restrict_chat_member(update.message.chat.id, reply.id, ChatPermissions(**chat.permissions.to_dict()))
        update.message.reply_markdown_v2(
        fr'{reply.mention_markdown_v2()}\ was unmuted\.')
    else:
        # Should wrap this into a common function call "not_admin(update)"
        update.message.reply_text(messages.PERM_LACK + statuses.IS_ADMIN)

# def get_commands_command(update: Update, context: CallbackContext) -> None:
#     # bot = utils.get_bot() // return a Bot object
#     bot = Bot("5016982005:AAG6YJFXVkvyVha7_3cghe8gj-PIGAL9aXE")
#     commands = bot.get_my_commands()
#     update.message.reply_text(commands)


def ban_command(update: Update, context: CallbackContext) -> None:
    reply = update.message.reply_to_message.from_user
    # perms = {"can_send_messages": False}
    if check_admin(update) == True:
        # reply.from_user.can_send_messages = False
        update.message.chat.bot.ban_chat_member(update.message.chat.id, reply.id)
        update.message.reply_markdown_v2(
        fr'{reply.mention_markdown_v2()}\ was banned\.')
    else: 
        update.message.reply_text(messages.PERM_LACK + statuses.IS_ADMIN)


def unban_command(update: Update, context: CallbackContext) -> None:
    reply = update.message.reply_to_message.from_user
    # perms = {"can_send_messages": False}
    if check_admin(update) == True:
        # reply.from_user.can_send_messages = False
        update.message.chat.bot.unban_chat_member(update.message.chat.id, reply.id)
        update.message.reply_markdown_v2(
        fr'{reply.mention_markdown_v2()}\ was unbanned\.')
    else: 
        update.message.reply_text(messages.PERM_LACK + statuses.IS_ADMIN)

def uptime_command(update: Update, context: CallbackContext) -> None:
    update.message.reply_text(
        fr"Uptime: {uptime.get_uptime()}")


def echo(update: Update, context: CallbackContext) -> None:
    """Echo the user message."""
    update.message.reply_text(update.message.text)

def main() -> None:

    atexit.register(exit_handler)
    
    """Start the bot."""
    # Create the Updater and pass it your bot's token.
    updater = Updater(config.TOKEN)
    
    utils.bot.set_my_commands(list(Commands.values()))
    utils.bot.set_my_commands(list(AdminCommands.values()), scope=BotCommandScope(telegram.constants.BOT_COMMAND_SCOPE_ALL_CHAT_ADMINISTRATORS))
    utils.bot.set_my_commands(list(DmCommands.values()), scope=BotCommandScope(telegram.constants.BOT_COMMAND_SCOPE_ALL_PRIVATE_CHATS))

    # Get the dispatcher to register handlers
    dispatcher = updater.dispatcher

    # Basics
    dispatcher.add_handler(CommandHandler("start", start))
    dispatcher.add_handler(CommandHandler("about", about_command))
    dispatcher.add_handler(CommandHandler("help", help_command))
    dispatcher.add_handler(CommandHandler("uptime", uptime_command))
    # dispatcher.add_handler(CommandHandler("commands", get_commands_command))

    # Just for fun
    dispatcher.add_handler(CommandHandler("dog", dog_command))
    dispatcher.add_handler(CommandHandler("cat", cat_command))

    # Group info
    dispatcher.add_handler(CommandHandler("chat", chat_info_command))
    dispatcher.add_handler(CommandHandler("admins", admins_command))
    dispatcher.add_handler(CommandHandler("perms", perms_command))

    # Group management
    dispatcher.add_handler(CommandHandler("pin", pin_message_command))
    dispatcher.add_handler(CommandHandler("del", del_message_command))

    # User info
    dispatcher.add_handler(CommandHandler("id", user_info_command))
    dispatcher.add_handler(CommandHandler("sticker", sticker_info_command))

    # User management
    dispatcher.add_handler(CommandHandler("mute", mute_command))
    dispatcher.add_handler(CommandHandler("unmute", unmute_command))
    dispatcher.add_handler(CommandHandler("ban", ban_command))
    dispatcher.add_handler(CommandHandler("unban", unban_command))

    # Status filters
    dispatcher.add_handler(MessageHandler(Filters.status_update.new_chat_members, new_member_update))

    # on non command i.e message - echo the message on Telegram
    # Make /echo, /pudding or /parrot a command so I can write and pin Pudding messages without switching accounts. Delete the original message after.
    # dispatcher.add_handler(MessageHandler(Filters.text & ~Filters.command, echo))

    # Start the Bot
    updater.start_polling()

    # Run the bot until you press Ctrl-C or the process receives SIGINT,
    # SIGTERM or SIGABRT. This should be used most of the time, since
    # start_polling() is non-blocking and will stop the bot gracefully.
    updater.idle()

def new_member_update(update, context):
    bot = update.message.chat.bot
    chat = bot.get_chat(update.message.chat.id)

    for member in update.message.new_chat_members:

        if member.username == config.USERNAME:
            for admin in chat.get_administrators():
                if admin.status == "creator":
                    bot.set_my_commands(list(OwnerCommands.values()), scope=BotCommandScopeChatMember(
                        chat_id=chat.id,
                        user_id=admin.user.id))

            update.message.reply_markdown_v2(
                about.GROUP_ADD_TEXT
            )

if __name__ == '__main__':
    main()
