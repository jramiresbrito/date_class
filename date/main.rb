require_relative 'date'

today = Date.new(day: 24, month: 2, year: 2021)
tomorrow = Date.new(day: 25, month: 3, year: 2021)

puts "#{today.to_str} is before #{tomorrow.to_str} ? #{today.before?(tomorrow)}"
puts "The difference between #{today.to_str} and #{tomorrow.to_str} is #{tomorrow.offset(today)} day(s)"
# 2023 is not a leap_year
leap_year = Date.leap_year?(2023)
puts "2023 is leap year? #{leap_year}"
# 2024 is a leap_year
leap_year = Date.leap_year?(2024)
puts "2024 is leap year? #{leap_year}"
