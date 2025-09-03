RSpec.describe Mli::VanishingMessages do
  describe ".create" do
    let(:endpoint) { "/api/v1/vanishing_messages" }
    let(:response) { double(:mock_response, status: status) }

    before do
      expect(Mli.connection).to receive(:post).with(endpoint, attrs).and_return(response)
    end

    context "without required attrs" do
      let(:attrs) { nil }
      let(:status) { 400 }

      it "posts attrs and returns bad request error" do
        vanishing_message_data = Mli::VanishingMessages.create(attrs)
        expect(vanishing_message_data).to eq({error: "bad request"})
      end
    end

    context "with required attrs" do
      let(:attrs) { {body: "shhh"} }
      let(:status) { 201 }

      it "posts attrs and returns success" do
        vanishing_message_data = Mli::VanishingMessages.create(attrs)
        expect(vanishing_message_data).to eq({abracadabra: "poof!"})
      end
    end
  end
end
