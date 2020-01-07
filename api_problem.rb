# frozen_string_literal: true

require 'httparty'
require 'csv'

# Simple program to list google api most and least used languages
class GraphUrl
  attr_reader :url
  attr_accessor :result

  def initialize
    @url = 'https://api.github.com/orgs/google/repos'
    @result = Hash.new(0)
  end

  def find_result
    response = fetch_url
    find_language_count(response)
    result = sort_result
    display_most_used_languages(result)
    display_least_used_languages(result)
    generate_csv(response)
  end

  private

  def fetch_url
    HTTParty.get(url)
  end

  def find_language_count(response)
    response.each do |value|
      result[value['language']] += 1
    end
  end

  def sort_result
    result.sort_by { |_key, value| value }.to_h
  end

  def display_most_used_languages(result)
    puts "\tThe mostly used 5 languages are \n \t ----------------------------\n
     #{result.max_by(5, &:last).to_h.keys}"
  end

  def display_least_used_languages(result)
    puts "\n \t The least used 5 languages are \n\t --------------------------\n
     #{result.first(5).to_h.keys}\n"
  end

  def generate_csv(response)
    CSV.open('/tmp/api_result.csv', 'wb') do |csv|
      csv << ['Repository name', 'language', 'created_date']
      response.each do |value|
        csv << [value['name'], value['created_at'], value['language']]
      end
    end
  end
end
GraphUrl.new.find_result
