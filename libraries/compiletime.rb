# Run apt-get update before installing build-essential.

module BuildEssential
  module Timing
    #
    # Potentially evaluate the given block at compile time, depending on the
    # value of the +node['build-essential']['compile_time']+ attribute.
    #
    # @example
    #   potentially_at_compile_time do
    #     package 'apache2'
    #   end
    #
    # @param [Proc] block
    #   the thing to eval
    #
    def potentially_at_compile_time(&block)
      if compile_time?

        include_recipe 'apt'

        execute 'pre-build-essential apt-get-update' do
          command 'apt-get update'
          ignore_failure true
        end.run_action(:run)

        CompileTime.new(self).evaluate(&block)
      else
        instance_eval(&block)
      end
    end
  end
end
