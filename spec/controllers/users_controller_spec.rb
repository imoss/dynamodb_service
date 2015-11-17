require File.expand_path('../../spec_helper', __FILE__)

describe UsersController do
  before(:each) { User.create_table }
  after(:each) { User.delete_table }

  describe "GET /v1/users/:id" do
    let(:base) { "/#{id}" }

    context "record does not exist" do
      let(:id) { "NotAnID" }

      before { get(base) }

      it 'should return 500' do
        expect(last_response.status).to eq(500)
      end

      it 'should return error message' do
        expect(last_response.body).to eq("Record Not Found")
      end
    end

    context "record does exist" do
      let(:parsed_response) { JSON.parse(last_response.body) }
      let(:id) { "2" }

      before do
        User.create(id: id, name: "test")
        get(base)
      end

      it 'should return 200' do
        expect(last_response.status).to eq(200)
      end

      it 'should return correct record' do
        expect(parsed_response['id']).to eq('2')
        expect(parsed_response['name']).to eq('test')
      end
    end
  end

  describe "DELETE /v1/users/:id" do
    let(:base) { "/#{id}" }

    context "record does not exist" do
      let(:id) { "NotAnID" }

      before { delete(base) }

      it 'should return 500' do
        expect(last_response.status).to eq(500)
      end

      it 'should return error message' do
        expect(last_response.body).to eq("Record Not Found")
      end
    end

    context "record does exist" do
      let(:parsed_response) { JSON.parse(last_response.body) }
      let(:id) { "2" }

      before do
        User.create(id: id, body: "test")
        delete(base)
      end

      it 'should return 200' do
        expect(last_response.status).to eq(200)
      end

      it 'should return correct record' do
        expect(User.find(id: id)).to be_nil
      end
    end
  end

  describe "POST /v1/users/:id" do
    let(:base) { "/" }
    let(:body) { { user: { name: "SomethingElse" } }.to_json }
    let(:content_type) { {'CONTENT_TYPE' => 'application/json'} }
    let(:parsed_response) { JSON.parse(last_response.body) }

    before do
      allow(User).to receive(:generate_identifier) { "1234567890" }
      post(base, body, content_type)
    end

    it 'should return 200' do
      expect(last_response.status).to eq(200)
    end

    it 'generates a unique id' do
      expect(parsed_response['id']).to eq("1234567890")
    end

    it 'should update the record' do
      expect(parsed_response['name']).to eq("SomethingElse")
    end
  end

  describe "PUT /v1/users/:id" do
    let(:base) { "/#{id}" }
    let(:body) { { user: { id: "3", name: "SomethingElse" } }.to_json }
    let(:content_type) { {'CONTENT_TYPE' => 'application/json'} }
    let(:id) { "2" }
    let(:parsed_response) { JSON.parse(last_response.body) }

    context "record does not exist" do
      before do
        put(base, body, content_type)
      end

      let(:id) { "NotAnID" }

      it 'should return 500' do
        expect(last_response.status).to eq(500)
      end

      it 'should return error message' do
        expect(last_response.body).to eq("Record Not Found")
      end
    end

    context 'record does exist' do
      before do
        User.create(id: id, name: "SomeGuid")
        put(base, body, content_type)
      end

      it 'should return 200' do
        expect(last_response.status).to eq(200)
      end

      it 'should update the record' do
        expect(parsed_response['id']).to eq("3")
        expect(parsed_response['name']).to eq("SomethingElse")
      end
    end
  end
end
