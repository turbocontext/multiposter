module HstoreMethods
  module ClassMethods
    def define_boolean(*attributes)
      attributes.each do |key|
        attr_accessible key
        scope "has_#{key}", lambda { |value| where("settings @> (? => ?)", key, value) }

        define_method(key) do
          settings && settings[key.to_s] == 'true'
        end

        define_method("#{key}=") do |value|
          self.settings = (settings || {}).merge(key => value)
        end
      end
    end

    def define_integer(*attributes)
      attributes.each do |key|
        attr_accessible key
        scope "has_#{key}", lambda { |value| where("settings @> (? => ?)", key, value) }

        define_method(key) do
          settings && settings[key.to_s].to_i
        end

        define_method("#{key}=") do |value|
          self.settings = (settings || {}).merge(key => value)
        end
      end
    end

      def define_string(*attributes)
      attributes.each do |key|
        attr_accessible key
        scope "has_#{key}", lambda { |value| where("settings @> (? => ?)", key, value) }

        define_method(key) do
          settings && settings[key.to_s].to_s
        end

        define_method("#{key}=") do |value|
          self.settings = (settings || {}).merge(key.to_s => value)
        end
      end
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
  end
end
