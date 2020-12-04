require 'active_job/logging'

ActiveJob::Base.logger = Logger.new(IO::NULL)
