require 'singleton'
require 'Shuriken/route'
module Shuriken
  class Router

    attr_accessor :routes

    @@instance = Router.new

    def initialize(routes)
      @routes = routes
    end

    # routers为单例
    def self.instance
      return @@instance
    end

    def self.new
      return @@instance
    end

    def draw(&block)
      mapper =RouterGenerator.new
      mapper.instance_exec(&block)
    end

  end

  class RouterGenerator
    #add restful 7 rules

    attr_accessor :regex

    def initialize
      #匹配到具体id name等
      @namespace = []
      @resource = ''
      @method =''
      @action = ''

      @regex = /{([^:]+)\s*:\s*(.+?)(?<!\\)}/
      @resource_routes = [#show
          {action: :show, url: '/{id:[\dA-f]+}', method: :get},
          #index
          {action: :index, url: '/', method: :get},
          #update
          {action: :update, url: '/{id:[\dA-f]+}', method: :put},
          #new
          {action: :new, url: '/new', method: :get},
          #destroy
          {action: :delete, url: '/{id:[\dA-f]+}', method: :delete},
          #create
          {action: :create, url: '/', method: :post},
          #edit
          {action: :edit, url: '/{id:[\dA-f]+}/edit', method: :get}]
    end

#解析路由并且存储
    def resources(name, &block)
      @resource = name.to_s
      @resource_routes.each do |r|
        url = r[:url]
        # route = Route.new(action: r[:action], url: url, method: r[:method], controller: "#{name.capitalize}Controller")
        #
        if Router.new.routes.nil?
          Router.new.routes = []
        end

        case r[:method]
          when :get
            get(url, "#{name.capitalize}Controller##{r[:action]}")

        end
      end
      instance_eval &block if block_given?
      #clear resource
      @resource = ''
    end

    def get(url, handle=nil, &block)
      if Router.new.routes.nil?
        Router.new.routes = []
      end
      if @resource == ''
        scaner = url+'/'
        p scaner
        scaner.scan(/:([^\/]*)\//).each do |x|
          url.gsub!(":#{x[0]}",'{'+x[0]+':(.*)}')
        end
      end

      namespaces = @namespace.join('/')+'/' if @namespace.length > 0

      namespaces = '' if namespaces.nil?

      url = url[1..-1] if url.start_with?('/')

      url = '/'+ namespaces +@resource + url

      if handle.nil? && @resource != ''
        handle = "#{@resource.capitalize}Controller##{url}"
      end

      controller, action = handle.split("#")

      controller = "#{controller.capitalize}Controller" if @resource == ''

      route = Route.new(action: action, url: url, method: :get, controller: controller,namespace: namespaces)
      Router.new.routes.push(route)

    end


    def post(url, handle=nil, &block)
      if Router.new.routes.nil?
        Router.new.routes = []
      end

      namespaces = @namespace.join('/')+'/' if @namespace.length > 0

      namespaces = '' if namespaces.nil?

      url = url[1..-1] if url.start_with?('/')

      url = '/'+ namespaces +@resource + url

      if handle.nil? && @resource != ''
        handle = "#{@resource.capitalize}Controller##{url}"
      end

      controller, action = handle.split("#")

      route = Route.new(action: action, url: url, method: :get, controller: controller,namespace: namespaces)
      Router.new.routes.push(route)
    end


    def namespace(namespace, &block)
      @namespace = @namespace.push(namespace.to_s)

      instance_eval &block if block_given?

      #clear the namespace
      @namespace = []
    end


  end
end


# str = '/api/{name:(.*)}/{id:[\dA-f]+}'
# reg_str = '/api/{name:(.*)}/{id:[\dA-f]+}'
# p str.split('/')
# str.scan(/{([^:]+)\s*:\s*(.+?)(?<!\\)}/).each do |match|
#   str.gsub!("{#{match.join(":")}}",match[1])
# end
# reg = Regexp.new(str)
# p reg
# p api = "/api/hello/323"
#
# params = {}
# if (api =~ reg) == 0
#   reg_str.split('/').each_with_index do |rs,index|
#     name = rs.scan(/{([^:]+)\s*:\s*(.+?)(?<!\\)}/)
#     p name
#     if name.length == 1
#       v = name[0][0]
#       p v
#       params.merge!({"#{v}": api.split('/')[index]})
#     end
#   end
#   p params
# end


# p '{name:(.*)}'.scan(/{([^:]+)\s*:\s*(.+?)(?<!\\)}/)[0][0]

# Shuriken::Router.new.draw do
#
#   resources :users do
#
#   end
#
#
#
# end
#
#
#  Shuriken::Router.new.routes.each do |r|
#   p r.url
# end
#

