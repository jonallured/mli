RSpec.describe Mli do
  it "has a version number" do
    expect(Mli::VERSION).not_to be nil
  end

  describe ".config" do
    it "is cached" do
      expect(Mli.config.object_id).to eq Mli.config.object_id
    end
  end

  describe ".connection" do
    it "is cached" do
      expect(Mli.connection.object_id).to eq Mli.connection.object_id
    end
  end

  describe ".reset" do
    it "updates globals" do
      mock_config = double(:mock_config)
      mock_connection = double(:mock_connection)
      expect(Mli::Connection).to receive(:generate).and_return(mock_connection)

      Mli.reset(mock_config)

      expect(Mli.config).to eq mock_config
      expect(Mli.connection).to eq mock_connection
    end
  end
end
