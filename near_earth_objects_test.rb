require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative 'near_earth_objects'

class NearEarthObjectsTest < Minitest::Test

  def setup
    @neos = NearEarthObjects.new("1994-03-18")
  end

  def test_it_exists
    assert_instance_of NearEarthObjects, @neos
  end

  def test_it_has_attributes
    assert_equal "1994-03-18", @neos.date
  end

  def test_it_can_find_largest_asteroid_diameter
    assert_equal 616, @neos.largest_diameter
  end

  def test_it_can_calculate_total_number_of_asteroids
    assert_equal 3, @neos.total_number_of_astroids
  end

  def test_it_can_format_asteroid_data
    expected = [{:name=>"(2003 TT9)", :diameter=>"512 ft", :miss_distance=>"31259733 miles"}, {:name=>"(2013 FQ10)", :diameter=>"616 ft", :miss_distance=>"13695519 miles"}, {:name=>"(2019 RC2)", :diameter=>"616 ft", :miss_distance=>"3015139 miles"}]

    assert_equal expected, @neos.formatted_asteroid_data
  end

  def test_it_can_display_information_from_that_date
    expected = {:astroid_list=> [{:name=>"(2003 TT9)", :diameter=>"512 ft", :miss_distance=>"31259733 miles"},
              {:name=>"(2013 FQ10)", :diameter=>"616 ft", :miss_distance=>"13695519 miles"},
              {:name=>"(2019 RC2)", :diameter=>"616 ft", :miss_distance=>"3015139 miles"}],
              :biggest_astroid=>616,
              :total_number_of_astroids=>3}

    assert_equal expected, @neos.display_information_from_date
  end
end
