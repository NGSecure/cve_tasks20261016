# Handles all the configuration things.
module Yuko

  class << self
    attr_accessor :conf
  end

  class ConfError < StandardError
    attr_accessor :messages

    def initialize(messages)
      @messages = messages
    end
  end

  class GlobalConf
    attr_accessor :irc, :mal

    def initialize
      @irc = IrcConf.new
      @mal = MyAnimeList::Credentials.new
    end

    def check
      errors = []
      errors << 'Invalid server              (irc)' unless @irc.server.is_a? String
      errors << 'Invalid port                (irc)' unless @irc.port.is_a?(String) || @irc.port.is_a?(Numeric)
      errors << 'Invalid boolean, value: ssl (irc)' unless @irc.ssl.is_a?(TrueClass) || @irc.ssl.is_a?(FalseClass)
      errors << 'Invalid channel             (irc)' unless @irc.channel.is_a? String
      errors << 'Invalid nickname            (irc)' unless @irc.nickname.is_a? String
      errors << 'Invalid username            (mal)' unless @mal.username.is_a? String
      errors << 'Invalid password            (mal)' unless @mal.password.is_a? String
      raise ConfError, errors if errors.any?
    end

    def mal_configured?
      !@mal.username.nil? && !@mal.password.nil?
    end

    def prompt_mal_config
      if @mal.username.nil?
        print 'MyAnimeList username: '
        @mal.username = gets.chomp
      end
      if @mal.password.nil?
        print 'MyAnimeList password: '
        @mal.password = STDIN.noecho(&:gets).chomp
        print "\n"
      end
    end

  end

  class IrcConf
    attr_accessor :server, :port, :ssl, :channel, :nickname, :greeting
  end

  def self.configure
    self.conf ||= GlobalConf.new
    yield(conf)
  end

end
