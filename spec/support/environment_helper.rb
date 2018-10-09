module EnvironmentHelper
  def with_modified_env(options, &block)
    unless options.all? { |_k, v| v.is_a? String }
      raise "values must all be strings"
    end

    ClimateControl.modify(options, &block)
  end
end
