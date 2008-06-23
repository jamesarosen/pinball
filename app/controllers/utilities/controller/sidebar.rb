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
        
        def delete_sidebar_widget(name = nil, &block)
          if name.nil? && block.nil?
            raise ArgumentError.new('delete_sidebar_widget requires a widget name or block')
          elsif name && block
            raise ArgumentError.new("cannot pass both widget name and block to delete_sidebar_widget")
          elsif name
            sidebar_widgets.delete(name)
          else
            sidebar_widgets.delete_if(&block)
          end
          nil
        end
      end
      
    end
  end
end