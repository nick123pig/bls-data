require 'curb'
require 'ruby-progressbar'
require 'set'

module BlsData
  class Client
    
    def initialize
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

    def supersectors
      @constants.supersectors
    end

    def parse_file
      file = Set.new
      series = determine_series
      series_codes = series.map{|a| a[:code]}
      puts "Beginning Download"
      dl = Curl.get("http://download.bls.gov/pub/time.series/sm/sm.data.0.Current").body_str
      puts "Download complete"
      total_lines = dl.lines.count
      puts "Starting transform"
      progressbar = ProgressBar.create(title: "Progress", starting_at: 0, total: total_lines, throttle_rate: 1, format: "%a |%b>>%i| %p%% %t Processed: %c from %C")
      dl.each_line do |line|
        parsed_line = line.split("\t")
        if series_codes.include? parsed_line.first.strip.chomp
          res = series.detect{|a| a[:code].strip.chomp == parsed_line.first.strip.chomp}
          file << {code: res[:code], state: res[:state], industry: res[:industry], date: "#{parsed_line[1]}-#{parsed_line[2].gsub('M','')}", value: (parsed_line[3].to_f*1000).round(0) } 
        end
        progressbar.increment
      end
      generate_csv(file)
    end

    def determine_series
      series = []
      states.each do |state|
        industries.each do |industry|
          code = "SMU#{state['state_code']}00000#{industry['industry_code']}01"
          series.push( {code: code, state: state['state_name'], industry: industry['industry_name'] } ) 
        end
      end
      series
    end

    def generate_csv(array)
      path = "/tmp/data#{Time.now.to_i}.csv"
      CSV.open(path, "wb") do |csv| 
        csv << array.first.keys
        array.each do |elem| 
          csv << elem.values
        end
      end
      puts path
    end
  end
end
