require_relative './schedule'
require_relative './presenter'

presenter = Presenter.new(Schedule.new)
presenter.start
