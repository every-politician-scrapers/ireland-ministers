#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      noko.text.tidy
    end

    def position
      noko.xpath('preceding-sibling::text()').text.tidy.delete_suffix(':')
        .gsub('Department', 'Minister')
        .gsub('; and', '|Minister of')
        .gsub('Tánaiste and', 'Tánaiste|')
        .split('|')
        .map(&:tidy)
    end
  end

  class Members
    def member_container
      noko.css('.row ul').first.css('li a')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
