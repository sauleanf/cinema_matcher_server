module ControllerHelpers
  def expect_auth_to_fail
    expect(response.body).to eq({ message: "Authentication is required" }.to_json)
  end
end

RSpec.configure do |c|
  c.include ControllerHelpers
end
