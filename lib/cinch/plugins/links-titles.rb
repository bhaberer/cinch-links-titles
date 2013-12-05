# -*- coding: utf-8 -*-
require 'open-uri'
require 'cinch'
require 'cinch/toolbox'
require 'cinch-storage'
require 'time-lord'

module Cinch::Plugins
  # Plugin to print URL titles in the channel.
  class LinksTitles
    include Cinch::Plugin

    # Simple struct object for tracking Links.
    class Link < Struct.new(:nick, :title, :count, :short_url, :time)
      def to_yaml
        {
          nick:       nick,
          title:      title,
          count:      count,
          short_url:  short_url,
          url:        url,
          time:       time
        }
      end
    end

    listen_to :channel

    def initialize(*args)
      super
      @storage = CinchStorage.new(config[:filename] ||
                                  'yaml/links-titles.yaml')
      @storage.data[:history] ||= {}
      @post_stats  = config[:stats].nil?  ? true : config[:stats]
    end

    def listen(m)
      urls = URI.extract(m.message, %w(http https))
      urls.each do |url|
        # Ensure we have a Channel Object in the History to dump links into.
        @storage.data[:history][m.channel.name] ||= Hash.new

        # Process link
        link = process_link(url, m.channel.name, m.user.nick)

        # Send link title to channel
        post_title(m, link)

        # Send link stats to channel
        post_stats(m, link)
      end

      # Don't save unless we found some urls to process
      @storage.synched_save(@bot) if urls
    end

    private

    def process_link(url, channel, nick)
      # Make sure it conforms to white/black lists before bothering.
      if whitelisted?(url) && !blacklisted?(url)
        return get_or_query_link(url, channel, nick)
      else
        if blacklisted?(url)
          debug "Blacklisted URL was not logged #{url}"
        else
          debug "Domain not Whitelisted #{url}"
        end
        return nil
      end
    end

    def get_or_query_link(url, channel, nick)
      # If the link was posted already, get the old info
      if @storage.data[:history][channel].key?(url)
        @storage.data[:history][channel][url][:count] += 1
        link = @storage.data[:history][channel][url]
      else
        link = Link.new(nick, Cinch::Toolbox.get_page_title(url) || nil,
                        1, Cinch::Toolbox.shorten(url), url, Time.now)
        @storage.data[:history][channel][url] = link
      end
      link
    end

    def post_title(m, link)
      # Only spam the channel if you have a title
      unless link.nil? || link.title.nil?
        m.reply "#{link.short_url || link.url} ∴  #{link.title}"
      end
    end

    def post_stats(m, link)
      # Check to see if we should post stats and if it's been linked
      # more than once.
      if @post_stats && link.count > 1
        # No stats if this person was the first one to link it
        unless link.nick == m.user.nick
          m.reply "That was already linked by #{link.nick}
                   #{link.time.ago.to_words}.", true
        end
      end
    end

    def whitelisted?(url)
      return true unless config[:whitelist]
      debug "Checking Whitelist! #{config[:whitelist]} url: #{url}"
      return true if url.match(Regexp.new("https:?\/\/.*\.?#{config[:whitelist]
        .join('|')}\."))
      false
    end

    def blacklisted?(url)
      return false unless config[:blacklist]
      debug "Checking Blacklist! #{config[:blacklist]} url: #{url}"
      return true if url.match(Regexp.new("https:?\/\/.*\.?#{config[:blacklist]
        .join('|')}\."))
      false
    end
  end
end
