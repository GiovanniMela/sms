require 'rails_helper'

RSpec.describe "SendMessagesController", type: :request do
  describe "POST /create" do
    subject(:send_message) do
      post '/api/v1/send_messages', params: { message: }, headers: { "ACCEPT" => "application/json" }
    end
    let(:message) { 'Hello, how are you?' }

    it 'persists message, splits it into smaller parts and returns them', aggregated_failures: true do
      expect(SendMessage.count).to be(0)
      send_message

      expect(SendMessage.count).to be(1)
      expect(response).to have_http_status(:created)
      expect(response.parsed_body).to include('messages' => ["#{message}- part 1"])
    end

    context "with a StandardError raised in MessageSplitter" do
      before do
        allow(MessageSplitter).to receive(:call!).and_raise(StandardError, 'some error')
      end

      it 'only persists message in database and returns error message', aggregated_failures: true do
        expect(SendMessage.count).to be(0)
        send_message

        expect(SendMessage.count).to be(1)
        expect(response).to have_http_status(:internal_server_error)
        expect(response.parsed_body).to include('error' => 'some error')
      end
    end

    context 'with a StandardError raised in SendMessage model' do
      before do
        allow(SendMessage).to receive(:create!).and_raise(StandardError, 'some error')
      end

      it 'only returns error message', aggregated_failures: true do
        expect(SendMessage.count).to be(0)
        send_message

        expect(SendMessage.count).to be(0)
        expect(response).to have_http_status(:internal_server_error)
        expect(response.parsed_body).to include('error' => 'some error')
      end
    end
  end
end
