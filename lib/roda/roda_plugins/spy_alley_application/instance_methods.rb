class Roda
  module RodaPlugins
    module SpyAlleyApplication
      module InstanceMethods
        include SpyAlleyApplication::Actions
        include SpyAlleyApplication::Results
      end

      register_plugin :spy_alley_application, SpyAlleyApplication
    end
  end
end
