require 'Shuriken/route'
module Shuriken
  class RouterMapper
    #add restful 7 rules
    def initialize
      @routers = Router.new.routes
      @resource_routes = %w{resource_name/:id  resource_name resource_name/edit resource_name/new}
    end


    def resources(name,&block)
      @resource_routes.each do |r|
        r.gsub!("resource_name",name.to_s)
        route = Route.new()
        route.action = r
        p Router.new.routes
        # @routers.push(route)
      end

      puts Router.new.routes
      instance_eval &block if block_given?
    end

    def get

    end


    def post

    end



  end


end