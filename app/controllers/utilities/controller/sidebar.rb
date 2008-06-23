module Utilities
  module Controller
    module Sidebar
      
      def self.included(base)
        base.send :include, Utilities::Controller::Sidebar::InstanceMethods
        base.helper_method :sidebar_widgets
      end

      module InstanceMethods
        
        def sidebar_widgets
          @sidebar_widgets ||= []
        end
        
        def sidebar_widget(w)
          sidebar_widgets << w
        end
      end
      
    end
  end
end