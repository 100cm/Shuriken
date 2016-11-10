require "Shuriken/version"
require "Shuriken/routing"
require 'Shuriken/loader'
require 'Shuriken/util'
require 'Shuriken/controller'
require 'Shuriken/view'
require 'Shuriken/router'
require 'Shuriken/router_mapper'
module Shuriken
  class Application
    attr_accessor :application

    @application = Application.new

    def call(env)
      if env['PATH_INFO'] == '/favicon.ico'
        return [404,
                {'Content-Type' => 'text/html'}, []]
      end
      # klass, act = get_controller_and_action(env)
      # controller = klass.new(env)
      # text = controller.send(act)
      # r = controller.get_response
      # if r
      #   [r.status, r.headers, [r.body].flatten]
      # else
        [200, {'Content-Type' => 'text/html'},
         [text]]
      # end
    end


    def self.application
      return @application
    end

    def router
      return Shuriken::Router.new
    end

  end
end
