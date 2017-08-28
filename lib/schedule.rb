class Schedule
  RANGE = 0..1440
  private_constant :RANGE

  attr_reader :ranges

  def initialize
    @ranges = []
  end

  def add from, to
    update_ranges_with(from, to, &method(:add_new_range))
  end

  def remove from, to
    update_ranges_with(from, to, &method(:remove_range))
  end

  private
    def add_new_range new_range
      new_ranges = []

      n_from, n_to = new_range

      new_range_used = false

      ranges.each do |existed_range|
        e_from, e_to = existed_range

        if n_to < e_from
          new_ranges << [n_from, n_to] unless new_range_used
          new_ranges << existed_range
          new_range_used = true
        elsif n_from > e_to
          new_ranges << existed_range
        elsif n_from >= e_from && n_from <= e_to && n_to >= e_to
          n_from = e_from
        elsif n_from <= e_from && n_to <= e_to
          new_ranges << [n_from, e_to]
          new_range_used = true
        elsif e_from < n_from && n_to < e_to
          new_ranges << existed_range
          new_range_used = true
        end
      end

      new_ranges << [n_from, n_to] unless new_range_used
      new_ranges
    end

    def remove_range range_to_remove
      new_ranges = []

      r_from, r_to = range_to_remove

      ranges.each do |existed_range|
        e_from, e_to = existed_range

        if e_from < r_from && e_to > r_to
          new_ranges << [e_from, r_from]
          new_ranges << [r_to, e_to]
        elsif e_from >= r_from && e_to > r_to && e_from < r_to
          new_ranges << [r_to, e_to]
        elsif e_from < r_from && e_to < r_to && r_from < e_to
          new_ranges << [e_from, r_from]
        elsif e_to <= r_from || e_from >= r_to
          new_ranges << existed_range
        end
      end

      new_ranges
    end

    def update_ranges_with(from, to)
      validate_range!(from, to)

      @ranges = yield([from, to])
    end

    def validate_range! from, to
      valid_range?(from, to) || raise(ArgumentError)
    end

    def valid_range? from, to
      from < to && RANGE.cover?(from) && RANGE.cover?(to)
    end
end
