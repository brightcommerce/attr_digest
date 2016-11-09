require 'argon2'
require 'active_record'
require 'active_support/all'

module AttrDigest
  extend ActiveSupport::Concern

  class Error < ::StandardError
  end

  class NoDigestException < Error
  end

  class InvalidMemoryCost < Error
  end

  class InvalidTimeCost < Error
  end

  class << self
    attr_accessor :time_cost
    attr_accessor :memory_cost
    attr_accessor :secret
  end

  self.time_cost = 2 # 1..10
  self.memory_cost = 16 # 1..31

  module ClassMethods
    def attr_digest(meth, *args, &block)
      attribute_sym = meth.to_sym
      attr_reader attribute_sym

      options = {
        validations: true,
        protected: false,
        case_sensitive: true,
        confirmation: true,
        time_cost: AttrDigest.time_cost,
        memory_cost: AttrDigest.memory_cost,
        secret: AttrDigest.secret
      }
      options.merge! args[0] unless args.blank?

      if options[:validations]
        add_confirmation_validation(attribute_sym) if options[:confirmation]
        validates attribute_sym, presence: true, on: :create
        before_create { raise "#{attribute_sym}_digest missing on new record" if send("#{attribute_sym}_digest").blank? }
      end

      if options[:format]
        add_format_validation(attribute_sym, options)
      end

      define_setter(attribute_sym, options)
      protect_setter(attribute_sym) if options[:protected]
      define_authenticate_method(attribute_sym, options)
    end

    def add_confirmation_validation(attribute_sym)
      validates attribute_sym, confirmation: true, if: lambda { |m| m.send(attribute_sym).present? }
      validates "#{attribute_sym}_confirmation".to_sym, presence: true, if: lambda { |m| m.send(attribute_sym).present? }
    end

    def add_format_validation(attribute_sym, options)
      validates attribute_sym, format: options[:format], if: lambda { |m| m.send(attribute_sym).present? }
    end

    def define_setter(attribute_sym, options)
      define_method "#{attribute_sym.to_s}=" do |unencrypted_value|
        if options[:memory_cost] < 1 || options[:memory_cost] > 31
          raise InvalidMemoryCost.new("Invalid memory cost, min 1 and max 31")
        end

        if options[:time_cost] < 1 || options[:time_cost] > 31
          raise InvalidTimeCost.new("Invalid time cost, min 1 and max 10")
        end

        password = if options[:secret]
          Argon2::Password.new(t_cost: options[:time_cost], m_cost: options[:memory_cost], secret: options[:secret])
        else
          Argon2::Password.new(t_cost: options[:time_cost], m_cost: options[:memory_cost])
        end

        if options[:validations] == true
          unless unencrypted_value.blank?
            instance_variable_set("@#{attribute_sym.to_s}".to_sym, unencrypted_value)
            send("#{attribute_sym.to_s}_digest=".to_sym, password.create(options[:case_sensitive] ? unencrypted_value : unencrypted_value.downcase))
          end
        else
          instance_variable_set("@#{attribute_sym.to_s}".to_sym, "#{unencrypted_value}")
          send("#{attribute_sym.to_s}_digest=".to_sym, password.create(options[:case_sensitive] ? "#{unencrypted_value}" : "#{unencrypted_value}".downcase))
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
        digest = send("#{attribute_sym}_digest")
        if digest.blank?
          raise NoDigestException.new("Digest for #{attribute_sym} is nil, there is nothing to authenticate with.")
        end
        if options[:secret]
          Argon2::Password.verify_password((options[:case_sensitive] ? "#{value}" : "#{value}".downcase), digest, options[:secret])
        else
          Argon2::Password.verify_password((options[:case_sensitive] ? "#{value}" : "#{value}".downcase), digest)
        end
      end
    end

    protected :attr_digest
    protected :add_confirmation_validation
    protected :add_format_validation
    protected :define_setter
    protected :protect_setter
    protected :define_authenticate_method
  end
end

ActiveRecord::Base.send :include, AttrDigest
