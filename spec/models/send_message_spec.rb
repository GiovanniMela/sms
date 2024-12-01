require 'rails_helper'

RSpec.describe SendMessage, type: :model do
  describe '.create' do
    subject { described_class.create(value:) }
    let(:value) { 'Hello, how are you' }

    it 'creates one entry' do
      expect { subject }.to change { described_class.count }.from(0).to(1)
    end

    context 'when value is not present' do
      let(:value) { nil }

      it 'raises a ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end
  end
end
