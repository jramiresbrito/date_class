class Date
  class InvalidDateError < StandardError
    def initialize(msg = "Invalid Date.")
      super(msg)
    end
  end

  private_constant :InvalidDateError

  attr_reader :day, :month, :year

  @@instance_collector = []

  def initialize(attrs = {})
    attrs = default_date(attrs) if attrs.empty?

    raise InvalidDateError unless valid?(attrs[:day], attrs[:month], attrs[:year])

    @day   = attrs[:day]
    @month = attrs[:month]
    @year  = attrs[:year]
    @@instance_collector << self
  end

  def self.all_dates
    @@instance_collector
  end

  def self.leap_year?(year)
    if (year % 4).positive?
      false
    elsif (year % 100).zero?
      false
    elsif (year % 400).zero?
      true
    else
      true
    end
  end

  def self.convert_to_days(date)
    raise InvalidDateError, "Please enter with a valid date instance" unless date.is_a?(Date)

    month = (date.month + 9) % 12
    year = (date.year - month / 10)
    (365 * year) + (year / 4) - (year / 100) + (year / 400) + ((month * 306 + 5) / 10) + (date.day - 1)
  end

  def self.convert_to_date(days_in_number, type = "object")
    raise InvalidDateError, "Please enter a integer" unless days_in_number.is_a?(Integer)

    year = (10_000 * days_in_number + 14_780) / 3_652_425
    d1 = (days_in_number - ((365 * year) + (year / 4) - (year / 100) + (year / 400)))

    if d1.negative?
      year = year - 1
      d1 = days_in_number - ((365 * year) + (year / 4) - (year / 100) + (year / 400))
    end

    m1 = (100 * d1 + 52) / 3060
    month = ((m1 + 2) % 12) + 1

    year = year + ((m1 + 2) / 12)

    day = d1 - ((m1 * 306 + 5) / 10) + 1

    return "#{day}/#{month}/#{year}" if type == "string"

    Date.new(day: day, month: month, year: year)
  end

  def self.offset(date1, date2)
    raise InvalidDateError, "Please enter with valid date instances" unless date1.is_a?(Date) && date2.is_a?(Date)

    (Date.convert_to_days(date1) - Date.convert_to_days(date2)).abs
  end

  def new_date_from(days)
    raise InvalidDateError, "Please enter a integer" unless days.is_a?(Integer)

    date_in_days = Date.convert_to_days(self)
    new_date_in_days = date_in_days + days

    Date.convert_to_date(new_date_in_days)
  end

  def before?(date)
    raise InvalidDateError, "Please enter with a valid date instance" unless date.is_a?(Date)

    Date.convert_to_days(self) < Date.convert_to_days(date)
  end

  def to_str
    day = @day < 10 ? "0#{@day}" : @day
    month = @month < 10 ? "0#{@month}" : @month
    "#{day}/#{month}/#{@year}"
  end

  private

  def valid?(day, month, year)
    unless day.is_a?(Integer) && month.is_a?(Integer) && year.is_a?(Integer)
      raise InvalidDateError, "Please enter a hash with the format: day: d/dd, month: m/mm, year: yyyy"
    end
    raise InvalidDateError, "Day must be between 1 and 31." if day < 1 || day > 31
    raise InvalidDateError, "Month must be between 1 and 12." if month < 1 || month > 12
    raise InvalidDateError, "Year must be at least 1900." if year < 1900

    case month
    when 1
      true
    when 2
      unless Date.leap_year?(year) ? day <= 29 : day <= 28
        raise InvalidDateError, "Feb has only 28 days on normal years or 29 days in leap years."
      end

      true
    when 3
      true
    when 4
      day < 31
    when 5
      true
    when 6
      day < 31
    when 7
      true
    when 8
      true
    when 9
      day < 31
    when 10
      true
    when 11
      day < 31
    else
      true
    end
  end

  def default_date(attrs)
    if @@instance_collector.empty?
      raise InvalidDateError, "Please enter a hash with the format: day: d/dd, month: m/mm, year: yyyy"
    end

    last_date = @@instance_collector.last
    aux = Date.convert_to_days(last_date) + 1

    aux = Date.convert_to_date(aux, "string")
    attrs[:day]   = aux.split('/')[0].to_i
    attrs[:month] = aux.split('/')[1].to_i
    attrs[:year]  = aux.split('/')[2].to_i

    attrs
  end
end
