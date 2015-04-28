Dir[File.dirname(__FILE__) + "/roles/*.rb"].each { |file| require file }

module Roles

  def self.included(base)
    base.extend ClassMethods

    base.instance_eval do
      validates :role, inclusion: { in: roles }
    end

    base.roles.each do |role_name|
      define_method("#{role_name}?") do
        role == role_name
      end
    end
  end

  module ClassMethods
    def role_classes
      (Roles.constants.select { |c| Class === Roles.const_get(c) }).map do |role_class|
        "Roles::#{role_class}".constantize
      end
    end

    def admin_role_classes
      role_classes - [Roles::Normal]
    end

    def roles
      role_classes.sort_by(&:level).map(&:role_name)
    end
  end
end
