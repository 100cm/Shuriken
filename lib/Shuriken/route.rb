module Shuriken

  class Route
    attr_accessor :namespace, :url, :controller, :action, :method ,:resource_name,:params

    def initialize(array={})
      @namespace = array[:namespace]
      @url = array[:url]
      @controller = array[:controller]
      @action = array[:action]
      @method = array[:method]
      @params = array[:params]
    end
  end


end

