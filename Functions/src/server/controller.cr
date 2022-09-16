require "amber"
require "../naidira"

include Amber

module Naidira::Server
  class ApiController < Amber::Controller::Base
    def index
      response.status_code = 501
    end
  
    def search
      query = params[:query]
      results = DICTIONARY.search(query).map do |word|
        WordResult.new(word.spelling, word.type, word.simple_meaning)
      end

      context.response.content_type = "application/json"
      SearchResults.new(results.to_a).to_json
    end

    def alphabetical
      context.response.content_type = "application/json"
      DICTIONARY.alphabetical.to_json
    end
  end

  struct WordResult
    include JSON::Serializable

    property spelling : String
    property word_type : WordType
    property meaning : String

    def initialize(@spelling, @word_type, @meaning)
    end
  end

  struct SearchResults
    include JSON::Serializable

    property word_results : Array(WordResult)

    def initialize(@word_results)
    end
  end
end