require "amber"
require "./controller"

include Amber
include Naidira::Server

Server.configure do |app|
  pipeline :api do
    plug Pipe::CORS.new
  end

  routes :api do
    get "/", ApiController, :index
    get "/search/:query", ApiController, :search
    get "/alphabetical", ApiController, :alphabetical
  end

  app.port = ENV["FUNCTIONS_CUSTOMHANDLER_PORT"].to_i if ENV["FUNCTIONS_CUSTOMHANDLER_PORT"]?
end

Server.start