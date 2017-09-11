class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  config.active_record.time_zone_aware_types = [:datetime, :time]
end
