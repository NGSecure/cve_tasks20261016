# <message>  ::= [':' <prefix> <SPACE> ] <command> <params> <crlf>
# <prefix>   ::= <servername> | <nick> [ '!' <user> ] [ '@' <host> ]
# <command>  ::= <letter> { <letter> } | <number> <number> <number>
# <SPACE>    ::= ' ' { ' ' }
# <params>   ::= <SPACE> [ ':' <trailing> | <middle> <params> ]
#
# <middle>   ::= <Any *non-empty* sequence of octets not including SPACE
#                or NUL or CR or LF, the first of which may not be ':'>
# <trailing> ::= <Any, possibly *empty*, sequence of octets not including
#                  NUL or CR or LF>
#
# <crlf>     ::= CR LF

# Message received from the server.
# Probably buggy... But who cares? :D
class Message
  attr_accessor :raw, :servername, :nick, :user, :host, :command, :params, :trailing

  def initialize(message)
    @raw = message.force_encoding('UTF-8').chars.select{|c| c.valid_encoding?}.join

    if @raw[0] == ':'
      match_data = @raw.match /^:(?<servername_or_nick>[^\s!@]+)(!(?<user>[^\s@]+))?(@(?<host>\S+))?[[:blank:]].*$/
      @servername = match_data[:servername_or_nick]
      @nick       = match_data[:servername_or_nick]
      @user       = match_data[:user]
      @host       = match_data[:host]
    end

    match_data = @raw.match /^(:\S+[[:blank:]]+)?(?<command>\S+)[[:blank:]]+(?<params>.*)?$/
    @command  = match_data[:command].upcase
    unless match_data[:params].nil?
      splitted = match_data[:params].split(/\s:/, 2)
      @params   = splitted.first.split
      @trailing = splitted.last
    end
  end

  def channel
    is_privmsg? ? @params[0] : nil
  end

  def is_ping?
    @command == 'PING'
  end

  def is_end_of_motd?
    @command == '376'
  end

  def is_privmsg?
    @command == 'PRIVMSG'
  end

end
