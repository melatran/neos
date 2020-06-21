require 'faraday'
require 'figaro'
require 'pry'
# Load ENV vars via Figaro
Figaro.application = Figaro::Application.new(environment: 'production', path: File.expand_path('../config/application.yml', __FILE__))
Figaro.load

class NearEarthObjects
  attr_reader :parsed_asteroids_data, :date

  def initialize(date)
    @date = date
    @parsed_asteroids_data = parsed_asteroids_data
  end

  def parsed_asteroids_data
    conn = Faraday.new(
        url: 'https://api.nasa.gov',
        params: { start_date: date, api_key: ENV['nasa_api_key']}
      )
      asteroids_list_data = conn.get('/neo/rest/v1/feed')

      JSON.parse(asteroids_list_data.body, symbolize_names: true)[:near_earth_objects][:"#{date}"]
  end

  def largest_diameter
    parsed_asteroids_data.map do |astroid|
      astroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i
    end.max { |a,b| a<=> b}
  end

  def total_number_of_astroids
    parsed_asteroids_data.count
  end

  def formatted_asteroid_data
    parsed_asteroids_data.map do |astroid|
      {
        name: astroid[:name],
        diameter: "#{astroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i} ft",
        miss_distance: "#{astroid[:close_approach_data][0][:miss_distance][:miles].to_i} miles"
      }
    end
  end

  def display_information_from_date
    {
      astroid_list: formatted_asteroid_data,
      biggest_astroid: largest_diameter,
      total_number_of_astroids: total_number_of_astroids
    }
  end
end
