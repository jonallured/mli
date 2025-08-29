RSpec.shared_context "use test adapter" do
  let(:faraday_stubs) { Faraday::Adapter::Test::Stubs.new }

  before do
    env = {"MLI_CLIENT_TOKEN" => "shhh"}
    adapter_args = [:test, faraday_stubs]
    config = Mli::Config.new(env, adapter_args)
    Mli.reset(config)
  end
end
