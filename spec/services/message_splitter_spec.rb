require 'rails_helper'

RSpec.describe MessageSplitter do
  describe '#call!' do
    subject(:call!) { described_class.new(message).call!  }

    context 'with text not exceeding the message length limit' do
      let(:message) { 'hello, how are you' }
      let(:split_message) { 'hello, how are you- part 1' }

      it { is_expected.to include(split_message) }
    end

    context 'with text exceeding the message length limit' do
      let(:message) do
        'hello, how are you hello, how are you hello, how are you hello, how are you hello, how are you hello, how '\
        'are you hello, how are you hello, how are you hello, how are you hello'
      end
      let(:split_message_a) do
        'hello, how are you hello, how are you hello, how are you hello, how are you hello, how are you hello, how '\
        'are you hello, how are you hello, how are you - part 1'
      end
      let(:split_message_b) do
        'hello, how are you hello- part 2'
      end

      it { is_expected.to include(split_message_a) }
      it { is_expected.to include(split_message_b) }
    end

    context 'with first word in message longer than allowed length' do
      let(:message) do
        'Donaudampfschifffahrtselektrizitätenhauptbetriebswerkbauunternehmenbeamtengesellschaft' \
        'Donaudampfschifffahrtselektrizitätenhauptbetriebswerkbauunternehmenbeamtengesellschaft'
      end

      it 'raises a MessageSplitterError' do
        expect { call! }.to raise_error(MessageSplitterError, "Word #{message} is too long. Sending failed")
      end
    end

    context 'with second word in message longer than allowed length' do
      let(:message) { "Hello #{word}" }
      let(:word) do
        'Donaudampfschifffahrtselektrizitätenhauptbetriebswerkbauunternehmenbeamtengesellschaft' \
        'Donaudampfschifffahrtselektrizitätenhauptbetriebswerkbauunternehmenbeamtengesellschaft'
      end

      it 'raises a MessageSplitterError' do
        expect { call! }.to raise_error(MessageSplitterError, "Word #{word} is too long. Sending failed")
      end
    end
  end
end
