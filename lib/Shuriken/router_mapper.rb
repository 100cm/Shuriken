require 'Shuriken/router'
module Shuriken
  class RouterMapper
    def self.get_action_and_controller(url, env)
      routes = []
      Router.new.routes.each do |route|
        p route.namespace
        route_url_regex = route.url
        if route_url_regex == url
            return route
        end
        route_url_regex.scan(/{([^:]+)\s*:\s*(.+?)(?<!\\)}/).each do |match|
          route_url_regex.gsub!("{#{match.join(":")}}", match[1])
        end
        reg = Regexp.new(route_url_regex)
        if (url =~ reg) == 0 && url.split('/').length == route.url.split('/').length && route.method.to_s.upcase == env['REQUEST_METHOD']
          routes.push(route)
        end
      end
      return routes
    end
  end
end