require 'argon2'
require 'active_record'
require 'active_support/all'

module AttrDigest
  extend ActiveSupport::Concern

  class << self
    attr_accessor :time_cost
    attr_accessor :memory_cost
  end

  self.time_cost = 2
  self.memory_cost = 16

  module ClassMethods
    def attr_digest(meth, *args, &block)
      attribute_sym = meth.to_sym
      attr_reader attribute_sym

      options = { validations: true, protected: false, case_sensitive: true, confirmation: true }
      options.merge! args[0] unless args.blank?

      if options[:validations]
        confirm attribute_sym if options[:confirmation]
        validates attribute_sym, presence: true, on: :create
        before_create { raise "#{attribute_sym}_digest missing on new record" if send("#{attribute_sym}_digest").blank? }
      end

      define_setter(attribute_sym, options)
      protect_setter(attribute_sym) if options[:protected]
      define_authenticate_method(attribute_sym, options)
    end

    def confirm(attribute_sym)
      validates attribute_sym, confirmation: true, if: lambda { |m| m.send(attribute_sym).present? }
      validates "#{attribute_sym}_confirmation".to_sym, presence: true, if: lambda { |m| m.send(attribute_sym).present? }
    end

    def define_setter(attribute_sym, options)
      define_method "#{attribute_sym.to_s}=" do |unencrypted_value|
        unless unencrypted_value.blank?
          instance_variable_set("@#{attribute_sym.to_s}".to_sym, unencrypted_value)
          password = Argon2::Password.new(t_cost: AttrDigest.time_cost, m_cost: AttrDigest.memory_cost)
          send("#{attribute_sym.to_s}_digest=".to_sym, password.create(options[:case_sensitive] ? unencrypted_value : unencrypted_value.downcase))
        end
      end
    end

    def protect_setter(attribute_sym)
      define_method "#{attribute_sym}_digest=" do |value|
        write_attribute "#{attribute_sym}_digest".to_sym, value
      end
      protected "#{attribute_sym}_digest=".to_sym
    end

    def define_authenticate_method(attribute_sym, options)
      define_method "authenticate_#{attribute_sym}" do |value|
        Argon2::Password.verify_password((options[:case_sensitive] ? value : value.downcase), send("#{attribute_sym}_digest"))
      end
    end

    protected :attr_digest
    protected :confirm
    protected :define_setter
    protected :protect_setter
    protected :define_authenticate_method
  end
end

ActiveRecord::Base.send :include, AttrDigest
