module Api
  module V1
    class SendMessagesController < ApplicationController
      def create
        SendMessage.create!(value: message)
        messages = MessageSplitter.call!(message)
        render json: { messages: }, status: :created
      rescue StandardError => e
        render json: { error: e.message }, status: :internal_server_error
      end

      private

      def message
        @message ||= params.permit(:message)[:message]
      end
    end
  end
end
