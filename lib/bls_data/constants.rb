require 'curb'

module BlsData
  class Constants

    CONSTANTS_URL = "http://download.bls.gov/pub/time.series/sa"

    def states
      parse_constants(Curl.get("#{CONSTANTS_URL}/sa.state").body_str)
    end

    def areas
      parse_constants(Curl.get("#{CONSTANTS_URL}/sa.area").body_str)
    end

    def industries
      parse_constants(Curl.get("#{CONSTANTS_URL}/sa.industry").body_str)
    end

    def data_types
      parse_constants(Curl.get("#{CONSTANTS_URL}/sa.data_type").body_str)
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
