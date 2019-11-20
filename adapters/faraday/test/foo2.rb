puts "#{__LINE__} spec version: #{Gem.loaded_specs['faraday']&.version.to_s}"

puts "#{__LINE__} requiring faraday: #{require 'faraday'}"

puts "#{__LINE__} spec version: #{Gem.loaded_specs['faraday']&.version.to_s}"
