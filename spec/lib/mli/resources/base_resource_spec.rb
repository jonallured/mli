RSpec.describe Mli::BaseResource do
  describe ".page_from" do
    let(:records) { [{"id" => 1}] }
    let(:response) { double(:mock_response, headers: headers, body: records) }

    context "with a next page" do
      let(:headers) { {"X-Next-Page" => "2", "X-Total-Count" => "150"} }

      it "returns the records with paging details as integers" do
        data = Mli::BaseResource.page_from(response)
        expect(data).to eq(next_page: 2, records: records, total_count: 150)
      end
    end

    context "on the last page" do
      let(:headers) { {"X-Total-Count" => "1"} }

      it "returns the records with a nil next_page" do
        data = Mli::BaseResource.page_from(response)
        expect(data).to eq(next_page: nil, records: records, total_count: 1)
      end
    end
  end
end
