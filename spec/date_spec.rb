require 'pry-byebug'
require 'simplecov'
SimpleCov.start

# Ensure that the proper Date class is loaded
begin
  require_relative "../date/date"
rescue LoadError => e
  if e.message =~ /date/
    describe "Date" do
      it "Date file not found" do
        fail
      end
    end
  else
    raise e
  end
end

# rubocop:disable Metrics/BlockLength
describe "Date", :date do
  context "without attributes" do
    context "without previous class instance" do
      it "returns an error if there isn't any previous instance" do
        expect { Date.new }.to(raise_error) do |error|
          expect(error).to be_a(Date.const_get(:InvalidDateError))
            .and having_attributes({ message: "Please enter a hash with the format: day: d/dd, month: m/mm, year: yyyy" })
        end
      end
    end

    context "after having an instance" do
      let(:attrs) { { day: 28, month: 2, year: 2021 } }
      let!(:date) { Date.new(attrs) }
      let!(:default_date) { Date.new }

      it "returns a date instance based on the last created date instance" do
        expect(default_date).to be_a(Date)
        expect(default_date.day).to eq 1
        expect(default_date.month).to eq 3
        expect(default_date.year).to eq 2021
      end
    end
  end

  context "with valid attributes" do
    let(:attrs) { { day: 28, month: 2, year: 2021 } }
    let!(:date) { Date.new(attrs) }

    it "returns a date instance" do
      expect(date).to be_a(Date)
      expect(date.day).to eq 28
      expect(date.month).to eq 2
      expect(date.year).to eq 2021
      expect(Date.new(day: 31, month: 1, year: 2021)).to be_a(Date)
      expect(Date.new(day: 31, month: 5, year: 2021)).to be_a(Date)
      expect(Date.new(day: 30, month: 6, year: 2021)).to be_a(Date)
      expect(Date.new(day: 31, month: 7, year: 2021)).to be_a(Date)
      expect(Date.new(day: 31, month: 8, year: 2021)).to be_a(Date)
      expect(Date.new(day: 30, month: 9, year: 2021)).to be_a(Date)
      expect(Date.new(day: 31, month: 10, year: 2021)).to be_a(Date)
      expect(Date.new(day: 30, month: 11, year: 2021)).to be_a(Date)
      expect(Date.new(day: 31, month: 12, year: 2021)).to be_a(Date)
    end
  end

  context "with invalid attributes" do
    let(:attrs) { { day: 28, month: 2, year: 2021 } }
    let!(:date) { Date.new(attrs) }
    let!(:default_date) { Date.new }

    context "invalid days" do
      it "raises InvalidDateError for invalid days" do
        expect { Date.new(day: "25", month: "1", year: "2021") }.to(raise_error) do |error|
          expect(error).to be_a(Date.const_get(:InvalidDateError))
            .and having_attributes({ message: "Please enter a hash with the format: day: d/dd, month: m/mm, year: yyyy" })
        end

        expect { Date.new(day: 0, month: 1, year: 2021) }.to(raise_error) do |error|
          expect(error).to be_a(Date.const_get(:InvalidDateError))
            .and having_attributes({ message: "Day must be between 1 and 31." })
        end

        expect { Date.new(day: 32, month: 1, year: 2021) }.to(raise_error) do |error|
          expect(error).to be_a(Date.const_get(:InvalidDateError))
            .and having_attributes({ message: "Day must be between 1 and 31." })
        end

        expect { Date.new(day: 31, month: 4, year: 2021) }.to(raise_error) do |error|
          expect(error).to be_a(Date.const_get(:InvalidDateError))
            .and having_attributes({ message: "Invalid Date." })
        end
      end

      context "Febuary" do
        it "raises InvalidDateError when day is higher than 28 for non-leap years" do
          expect { Date.new(day: 29, month: 2, year: 2021) }.to(raise_error) do |error|
            expect(error).to be_a(Date.const_get(:InvalidDateError))
              .and having_attributes({ message: "Feb has only 28 days on normal years or 29 days in leap years." })
          end
        end

        it "raises InvalidDateError when day is higher than 29 for leap years" do
          expect { Date.new(day: 30, month: 2, year: 2020) }.to(raise_error) do |error|
            expect(error).to be_a(Date.const_get(:InvalidDateError))
              .and having_attributes({ message: "Feb has only 28 days on normal years or 29 days in leap years." })
          end
        end
      end
    end

    context "invalid months" do
      it "raises InvalidDateError for invalid months" do
        expect { Date.new(day: 25, month: 0, year: 2021) }.to(raise_error) do |error|
          expect(error).to be_a(Date.const_get(:InvalidDateError))
            .and having_attributes({ message: "Month must be between 1 and 12." })
        end

        expect { Date.new(day: 25, month: 13, year: 2021) }.to(raise_error) do |error|
          expect(error).to be_a(Date.const_get(:InvalidDateError))
            .and having_attributes({ message: "Month must be between 1 and 12." })
        end
      end
    end

    context "invalid years" do
      it "raises InvalidDateError for invalid years" do
        expect { Date.new(day: 25, month: 1, year: 1899) }.to(raise_error) do |error|
          expect(error).to be_a(Date.const_get(:InvalidDateError))
            .and having_attributes({ message: "Year must be at least 1900." })
        end
      end
    end
  end

  context "class methods" do
    let(:attrs) { { day: 28, month: 2, year: 2021 } }
    let!(:date) { Date.new(attrs) }
    let!(:default_date) { Date.new }

    context "all_dates" do
      it "returns an array containing all instances" do
        expect(Date.all_dates).to be_a(Array)

        expect(Date.all_dates[0]).to be_a(Date)
        expect(Date.all_dates[0].day).to eq date.day
        expect(Date.all_dates[0].month).to eq date.month
        expect(Date.all_dates[0].year).to eq date.year

        expect(Date.all_dates[1]).to be_a(Date)
        expect(Date.all_dates[1].day).to eq default_date.day
        expect(Date.all_dates[1].month).to eq default_date.month
        expect(Date.all_dates[1].year).to eq default_date.year
      end
    end

    context "leap_years" do
      it "returns true for leap years" do
        leap_years = [2020, 2024, 2400]
        leap_years.each do |year|
          expect(Date.leap_year?(year)).to eq true
        end
      end

      it "returns false for non-leap years" do
        leap_years = [2021, 2100, 2200]
        leap_years.each do |year|
          expect(Date.leap_year?(year)).to eq false
        end
      end
    end

    context "convert_to_days" do
      it "returns the correct day number" do
        expected_day_for_date = 738_154
        expected_day_for_default_date = 738_155

        expect(Date.convert_to_days(date)).to eq expected_day_for_date
        expect(Date.convert_to_days(default_date)).to eq expected_day_for_default_date
      end
    end

    context "convert_to_date" do
      it 'returns a date instance if type is not specified' do
        expected_day_for_date = 738_154
        expected_date = Date.convert_to_date(expected_day_for_date)
        expect(expected_date).to be_a(Date)
        expect(expected_date.day).to eq 28
        expect(expected_date.month).to eq 2
        expect(expected_date.year).to eq 2021
      end

      it 'returns a date instance if type = "object"' do
        expected_day_for_date = 738_154
        expected_date = Date.convert_to_date(expected_day_for_date, "object")
        expect(expected_date).to be_a(Date)
        expect(expected_date.day).to eq 28
        expect(expected_date.month).to eq 2
        expect(expected_date.year).to eq 2021
      end

      it 'returns a string if type = "string"' do
        expected_day_for_date = 738_154
        expected_date = Date.convert_to_date(expected_day_for_date, "string")
        expect(expected_date).to be_a(String)
        expect(expected_date).to eq "28/2/2021"
      end
    end

    context "offset" do
      it "returns the correct offset number" do
        expected_offset = 1
        expect(Date.offset(date, default_date)).to be_a(Integer)
        expect(Date.offset(date, default_date)).to eq expected_offset
        expect(Date.offset(default_date, date)).to eq expected_offset

        lier = Date.new(day: 1, month: 4, year: 2021)
        expected_offset = 32
        expect(Date.offset(date, lier)).to be_a(Integer)
        expect(Date.offset(date, lier)).to eq expected_offset
        expect(Date.offset(lier, date)).to eq expected_offset
      end
    end
  end

  context "istance methods" do
    let(:attrs) { { day: 28, month: 2, year: 2021 } }
    let!(:date) { Date.new(attrs) }
    let!(:default_date) { Date.new }

    context "to_str" do
      it "returns a string" do
        expect(date.to_str).to eq "28/02/2021"
        expect(default_date.to_str).to eq "01/03/2021"
      end
    end

    context "new_date_from" do
      it "returns a new date instance based on the current instance" do
        new_date = date.new_date_from(20)

        expect(new_date).to be_a(Date)
        expect(new_date.day).to eq 20
        expect(new_date.month).to eq 3
        expect(new_date.year).to eq 2021
      end
    end

    context "before?" do
      it "returns true if the current istance is before the passed instance" do
        expect(date.before?(default_date)).to eq true
      end

      it "returns false if the current istance isn't before the passed instance" do
        expect(default_date.before?(date)).to eq false
      end

      it "returns false if the current istance is equal to passed instance" do
        expect(default_date.before?(default_date)).to eq false
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
