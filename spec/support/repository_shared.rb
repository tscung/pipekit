RSpec.shared_examples "a repository" do

  subject(:repository) { described_class.new(request) }
  let(:request) { instance_spy("Pipedrive::Request") }

  describe "#all" do
    it "returns all records from the repository" do
      repository.all
      expect(request).to have_received(:get).with("/#{uri}")
    end
  end

  describe "#where" do
    it "returns records matching given field" do
      search_data = {type: uri, field: "fake_field", value: "fake value"}
      response = {id: 123, name: "Test"}

      allow(request).to receive(:search_by_field).with(search_data).and_return([{"id" => 123}])
      allow(repository).to receive(:get_by_id).and_return(response)

      expect(repository.where(fake_field: "fake value")).to eq([response])
    end
  end

  describe "find_by" do
    it "returns the first record matching given field" do
      data = {foo: :bar}
      expect(repository).to receive(:get_by_fake_field).with("fake value").and_return([data])
      expect(repository.find_by(fake_field: "fake value")).to eq(data)
    end
  end

  describe "create" do
    it "creates a record in a repository" do
      fields = {foo: :bar}
      expect(request).to receive(:post).with("/#{uri}", fields)
      repository.create(fields)
    end
  end

  describe "update" do
    it "updates a record in a repository" do
      id = 1
      fields = {foo: :bar}
      expect(request).to receive(:put).with("/#{uri}/#{id}", fields)
      repository.update(id, fields)
    end
  end
end