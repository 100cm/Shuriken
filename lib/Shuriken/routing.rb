module Shuriken
  class Application
    def get_controller_and_action(env)
      # _, cont, action, after =
      #     env["PATH_INFO"].split('/', 4)
      #
      #
      # cont = cont.capitalize # "People"
      # cont += "Controller" # "PeopleController"
      # [Object.const_get(cont), action]
      p env["PATH_INFO"]

    end


  end


end