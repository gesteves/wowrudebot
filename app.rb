# encoding: utf-8
require "sinatra"
require "json"
require "dotenv"


configure do
  # Load .env vars
  Dotenv.load
  # Disable output buffering
  $stdout.sync = true
  # Exclude messages that match this regex
  set :message_exclude_regex, /^(voxbot|tacobot|pkmn|cabot|cfbot|campfirebot|\/)/i
  # Respond to messages that match this
  set :reply_to_regex, /rude/i
end

get "/" do
  "hi."
end

post "/" do
  response = ""
  
  unless params[:text].nil? || params[:text].match(settings.message_exclude_regex) || params[:user_id] == "USLACKBOT" || params[:token] != ENV["OUTGOING_WEBHOOK_TOKEN"])
    if rand <= ENV["RESPONSE_CHANCE"].to_f || params[:text].match(settings.reply_to_regex)
      response = { text: "@#{params[:user_name]}: wow, rude.", link_names: 1 }
      response[:username] = ENV["BOT_USERNAME"] unless ENV["BOT_USERNAME"].nil?
      response[:icon_emoji] = ENV["BOT_ICON"] unless ENV["BOT_ICON"].nil?
      response = response.to_json
    end
  end
  
  status 200
  body response
end
