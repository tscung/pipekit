RSpec.shared_examples "a field repository" do |parent_resource|
    subject(:repository) { described_class.new(request) }
    let(:request) { instance_double("Pipekit::Request") }
    let(:config) { class_double("Pipekit::Config").as_stubbed_const }

    it_behaves_like "a repository"

    describe "finding by key" do

      it "finds field details by key when it exists" do
        allow(config).to receive(:field_id).with(parent_resource, "age").and_return("fieldkey")

        response = [{"key" => "no"},{"key" => "fieldkey"}]
        stub_field_lookup(response)

        expect(repository.get_by_key("age")).to eq([response.last])
      end

      it "raises a error when it does not exist" do
        stub_field_lookup([])

        expect{ repository.get_by_key("non_existent") }.to raise_error(Pipekit::ResourceNotFoundError)
      end
    end

    describe "finding by name" do

      it "finds field details by name when it exists" do
        response = [{"name" => "no"},{"name" => "fieldname"}]
        stub_field_lookup(response)

        expect(repository.get_by_name("fieldname")).to eq([response.last])
      end
    end

    describe "finding by field value" do

      let(:response) do
        [{
          "name" => "Cohort",
          "options" => [
            { "id" => "cohort_id", "label" => "August 2016" }
          ]
        }]
      end

      it "finds field label by id" do
        stub_field_lookup(response)
        expect(repository.find_label(field: "Cohort", id: "cohort_id")).to eq "August 2016"
      end

      it "finds all the values for a field" do
        stub_field_lookup(response)

        expect(repository.find_values("Cohort")).to eq response.first["options"]
      end
    end

    def stub_field_lookup(response)
      allow(request).to receive(:get).and_return(response)
    end
end
