# This class doesn't contain any bussines logic, only UI part for console

class Presenter
  attr_reader :schedule

  def initialize schedule
    @schedule = schedule
    @continue = true
  end

  def start
    while @continue
      info
      answer = gets.chomp.to_i
      case answer
      when 1
        add_to_schedule
      when 2
        remove_from_schedule
      when 3
        print_status
      when 4
        @continue = false
      end
    end
  end

  private
    def print_status
      puts divider
      puts schedule.ranges.to_s
      puts divider
    end

    def add_to_schedule
      puts '(Add) Please write range from'
      from = gets.chomp.to_i
      puts '(Add) Please write range to'
      to = gets.chomp.to_i
      schedule.add(from, to)
    rescue ArgumentError => e
      puts 'Sorry, but range is not correct, please try again'
    end

    def remove_from_schedule
      puts '(Remove) Please write range from'
      from = gets.chomp.to_i
      puts '(Remove) Please write range to'
      to = gets.chomp.to_i
      schedule.remove(from, to)
    rescue ArgumentError => e
      puts 'Sorry, but range is not correct, please try again'
    end

    def info
      puts 'Available operations:'
      puts 'Press 1 to add new time range'
      puts 'Press 2 to remove some range'
      puts 'Press 3 to show current state of schedule'
      puts 'Press 4 to exit'
    end

    def divider
      '=' * 20
    end
end
