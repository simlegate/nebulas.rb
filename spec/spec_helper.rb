require "bundler/setup"
require "nebulas"

module SpecHelpers
	def file_fixture path
		Pathname.new(File.join(Dir.pwd, 'spec', 'fixtures', path))
	end

  def hex_str? string
    !string[/\H/]
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

 	config.include SpecHelpers

 	config.filter_run_when_matching :focus
end
