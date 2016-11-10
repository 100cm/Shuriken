require 'singleton'
require 'Shuriken/router_mapper'
module Shuriken
  class Router
    attr_accessor :routes

    @@instance = Router.new

    def initialize
      @routes = [1,3]
    end

    # routers为单例
    def self.instance
      return @@instance
    end

    def self.new
      return @@instance
    end

    def draw(&block)
      mapper = RouterMapper.new
      mapper.instance_exec(&block)
    end

  end

end



