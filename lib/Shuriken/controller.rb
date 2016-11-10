module Shuriken
  class Controller
    def initialize(env)
      @env = env
      @routing_params = {}
    end

    def env
      @env
    end

    def request
      @request ||= Rack::Request.new(@env)
    end

    def response(text, status = 200, headers = {})
      raise "already responsed" if @response
      res = [text].flatten
      @response = Rack::Response.new(res, status,
                                     headers)
    end

    def get_response
      @response
    end

    def render(view_name, locals={})
      response(render_view(view_name, locals))
    end

    def params
      request.params.merge @routing_params
    end

    def instance_vars
      vars = {}
      instance_variables.each do |i|
        vars[i] = instance_variable_get i
      end
      vars
    end

    def render_view(view_name, locals = {})
      # 渲染模板
      html_filename = File.join "app", "views", controller_name,
                                "#{view_name.to_s}.html.erb"
      erb_filename = File.join "app", "views", controller_name, "#{view_name.to_s}.erb"

      #erb ／ html 渲染
      begin
        template = File.read html_filename
      rescue
        template = File.read erb_filename
      end
      v = View.new
      locals.merge! instance_vars
      v.set_vars locals
      v.evaluate template
    end

    #渲染对应的controller下面的view
    def controller_name
      klass = self.class
      klass = klass.to_s.gsub /Controller$/, ""
      Shuriken.to_underscore klass
    end

  end
end