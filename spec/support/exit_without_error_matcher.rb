RSpec::Matchers.define :exit_without_error do
  match do |process|
    process.status == 0
  end

  failure_message do |process|
    "expected process #{process.pid} to exit without error\n#{process.output}"
  end

  description do
    'exits without error'
  end
end
