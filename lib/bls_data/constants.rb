require 'curb'
require 'csv'

module BlsData
  class Constants

    CONSTANTS_URL = "http://download.bls.gov/pub/time.series/sm"

    def states
      parse_constants(Curl.get("#{CONSTANTS_URL}/sm.state").body_str)
    end

    def areas
      parse_constants(Curl.get("#{CONSTANTS_URL}/sm.area").body_str).
      delete_if{|a| a['area_code'].to_s == "00000"}      
    end

    def industries
      parse_constants(Curl.get("#{CONSTANTS_URL}/sm.industry").body_str).
      delete_if{|a| a['industry_code'].to_s[0].to_s == "0"}.  # The codes that start with zero seem to be "blanket categories"
      delete_if{|a| a['industry_code'].to_s[1..7].to_s == "0000000"}  # The codes that end with 0000000 seem to be category headers
    end

    def data_types
      parse_constants(Curl.get("#{CONSTANTS_URL}/sm.data_type").body_str)
    end

    def supersectors
      parse_constants(Curl.get("#{CONSTANTS_URL}/sm.supersector").body_str)
    end

    def parse_constants(payload)
      payload = payload.split("\r\n")
      payload = payload.keep_if{|a| a.include? "\t"}
      keys = payload.shift.split("\t")
      result = []
      payload.each do |item|
        element = {}
        items = item.split("\t")
        keys.each_with_index do |key,index|
          element[key] = items[index]
        end
        result << element
      end
      result
    end

  end
end