# -*- coding: utf-8 -*-
require 'spec_helper'

describe Cinch::Plugins::LinksTitles do
  include Cinch::Test

  before(:each) do
    @bot = make_bot(Cinch::Plugins::LinksTitles, { filename: '/dev/null' })
  end

  it 'should print titles' do
    reply = get_replies(make_message(@bot, 'http://github.com',
                                    { channel: '#foo', nick: 'bar' })).first

    expect(reply.text).to include('GitHub · Build software better, together.')
  end

  it 'should obey blacklist and not title blacklisted links' do
    bot = make_bot(Cinch::Plugins::LinksTitles,
                   { filename: '/dev/null',
                     blacklist: ['twitter'] })
    reply = get_replies(make_message(bot, 'http://twitter.com',
                                     { channel: '#foo', nick: 'bar' })).first
    expect(reply).to be_nil
  end

  it 'should obey blacklist and title unblacklisted links' do
    bot = make_bot(Cinch::Plugins::LinksTitles,
                   { filename: '/dev/null',
                     blacklist: ['twitter'] })
    reply = get_replies(make_message(bot, 'http://facebook.com',
                                     { channel: '#foo', nick: 'bar' })).first
    expect(reply).not_to be_nil
  end

  it 'should obey whitelist and title whitelisted links' do
    bot = make_bot(Cinch::Plugins::LinksTitles,
                   { filename: '/dev/null',
                     whitelist: ['twitter'] })
    reply = get_replies(make_message(bot, 'http://twitter.com',
                                     { channel: '#foo', nick: 'bar' })).first
    expect(reply).to_not be_nil
  end

  it 'should obey whitelist and not title unwhitelisted links' do
    bot = make_bot(Cinch::Plugins::LinksTitles,
                   { filename: '/dev/null',
                     whitelist: ['twitter'] })
    reply = get_replies(make_message(bot, 'http://facebook.com',
                                     { channel: '#foo', nick: 'bar' })).first
    expect(reply).to be_nil
  end

  it 'should not display stats if they are not enabled' do
    get_replies(make_message(@bot, 'http://facebook.com',
                             { channel: '#foo', nick: 'bar1' }))
    reply = get_replies(make_message(@bot, 'http://facebook.com',
                                     { channel: '#foo', nick: 'bar2' })).last
    expect(reply).to_not include('That was already linked by')
  end

  it 'should display stats if they are enabled' do
    bot = make_bot(Cinch::Plugins::LinksTitles,
                   { filename: '/dev/null', stats: true })
    get_replies(make_message(bot, 'http://facebook.com',
                             { channel: '#foo', nick: 'bar1' }))
    reply = get_replies(make_message(bot, 'http://facebook.com',
                                     { channel: '#foo', nick: 'bar2' })).last
    expect(reply.text).to include('That was already linked by')
  end
end
