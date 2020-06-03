require 'rails_helper'
require 'requests/status_helper'
require 'requests/users_helper'

RSpec.configure do |c|
  c.include StatusHelper
  c.include UsersHelper
end