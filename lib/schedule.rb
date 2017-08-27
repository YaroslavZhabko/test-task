class Schedule
  attr_reader :ranges

  def initialize
    @ranges = []
  end

  def add from, to
    validate_range!(from, to)

    range = [from, to]
    @ranges = add_new_range(range)
  end

  def remove from, to
    validate_range!(from, to)

    range = [from, to]
    @ranges = remove_range(range)
  end

  private

    MAX_RANGE = 1440

    def add_new_range new_range
      new_ranges = []

      n_from = new_range[0]
      n_to   = new_range[1]

      new_range_used = false

      ranges.each do |existed_range|
        e_from = existed_range[0]
        e_to   = existed_range[1]

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

      r_from = range_to_remove[0]
      r_to   = range_to_remove[1]

      ranges.each do |existed_range|
        e_from = existed_range[0]
        e_to   = existed_range[1]

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

    def validate_range! from, to
      valid_range?(from, to) || raise(ArgumentError)
    end

    def valid_range? from, to
      from.is_a?(Integer) &&
      to.is_a?(Integer) &&
      from < to &&
      from >= 0 &&
      to <= MAX_RANGE
    end
end
