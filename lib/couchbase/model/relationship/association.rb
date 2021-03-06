module Couchbase
  class Model
    module Relationship
      class Association
        attr_accessor :name
        attr_reader :auto_save, :auto_delete, :auto_load, :class_name

        def initialize(name, options = {})
          self.name = name.to_s
          @auto_save = options[:auto_save]
          @auto_delete = options[:auto_delete]
          @class_name = options[:class_name]
          @auto_load = options.key?(:auto_load) ? options[:auto_load] : true
        end

        def loaded?(parent)
          parent.send("#{name}_loaded?")
        end

        def fetch(parent)
          parent.send(name)
        end

        def load(parent)
          child_id = child_class.prefixed_id(parent.id)

          child_class.find_by_id(child_id)
        end

        def child_klass
          @class_name || name.classify
        end

        def child_class
          child_klass.constantize
        end

        def prefix
          child_class.id_prefix
        end
      end
    end
  end
end
