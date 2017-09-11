class Player < ActiveRecord::Base

  default_scope order('id ASC')

  establish_connection "rust_#{Rails.env}"

end
