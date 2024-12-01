class MessageSplitterError < StandardError; end

class MessageSplitter
  MESSAGE_MAX_LENGTH = 160
  MESSAGE_SUFFIX = "- part "

  def self.call!(raw_message)
    new(raw_message).call!
  end

  def initialize(raw_message)
    @raw_message = raw_message
    @message_counter = 0
    @partition_word = next_partition_word
    @page_length = 0
  end

  def call!
    words_per_message_pages.map { |page_number, words| "#{words}#{fetch_partition_word(page_number)}" }
  end

  private

  def words_per_message_pages
    @words_per_message_pages ||= words.each_with_object(Hash.new("")) do |word, message_page|
      validate_word_length!(word)
      if word_appendable?(word)
        append_word_to_current_message_page(word, message_page)
      else
        append_word_to_next_message_page(word, message_page)
      end
    end
  end

  def append_word_to_current_message_page(word, message_frame)
    message_frame[@message_counter] += word
    @page_length += word.length
  end

  def append_word_to_next_message_page(word, message_frame)
    @partition_word = next_partition_word
    message_frame[@message_counter] += word
    @page_length = 0
  end

  def validate_word_length!(word)
    return if word.length <= available_message_length

    raise MessageSplitterError.new("Word #{word} is too long. Sending failed")
  end

  def word_appendable?(word)
    @page_length + word.length <= available_message_length
  end

  def available_message_length
    MESSAGE_MAX_LENGTH - @partition_word.length
  end

  def next_partition_word
    @message_counter += 1
    fetch_partition_word(@message_counter)
  end

  def fetch_partition_word(message_counter)
    [ MESSAGE_SUFFIX, message_counter ].join
  end

  def words
    @words ||= @raw_message.split(/(\s+)/)
  end
end
