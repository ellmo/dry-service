require "dry-monads"
require "dry-struct"
require "dry-types"

require_relative "./dsl/dry_service_helpers"
require_relative "./dsl/dry_service_pipe"
require_relative "./dsl/dry_service_steps"

class DryService < Dry::Struct
  include DryServiceDSL::DryServiceSteps
  include DryServiceDSL::DryServiceHelpers
  include Dry::Monads[:result]

  module Types
    include Dry.Types()
  end

  def initialize(_)
    raise NotImplementedError unless self.class < DryService

    super
  end

  def call
    result = nil

    if defined? ActiveRecord::Base
      ActiveRecord::Base.transaction do
        result = perform_steps

        raise ActiveRecord::Rollback if result.failure?
      end
    else
      result = perform_steps
    end

    result
  end

  def self.pipe(desc, &block)
    raise ArgumentError, "missing block" unless block_given?

    pipepart = DryServiceDSL::Pipe.new(desc, &block)

    service_steps << pipepart
  end
end
