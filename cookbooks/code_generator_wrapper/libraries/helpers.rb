module ChefDK
  module Command
    module GeneratorCommands
      class Cookbook < Base
        def emit_post_create_message
          msg("Your cookbook is ready. Type `cd #{cookbook_name_or_path}` to enter it.")
        end
      end
    end
  end
end
