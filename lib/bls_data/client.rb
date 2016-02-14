require 'curb'
require 'json'

module BlsData
  class Client
    BASE_URL = "http://api.bls.gov/publicAPI/v2/timeseries/data/"
    attr_accessor :key
    
    def initialize(params={})
      @key = params[:key]
      @constants = BlsData::Constants.new
    end

    def states
      @constants.states
    end

    def areas
      @constants.areas
    end

    def industries
      @constants.industries
    end

    def data_types
      @constants.data_types
    end

    def query(params)
      params.merge!( 'registrationKey': @key )
      JSON.parse(Curl.post(BASE_URL, params).body_str)['Results']
    end

  end

end
