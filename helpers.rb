require 'yaml'
require 'date'

module Helpers

  SERVICE_NAME             = "advocate-defence-payments-agfs"
  TRANSACTIONS_BY_CHANNEL  = 'transactions-by-channel'
  COMPLETION_RATE          = 'completion-rate'

  TBC_CHANNELS = %w( paper digital )
  CR_STAGES    = %w( complete start )

  def performance_service_url
    "https://www.performance.service.gov.uk/data/#{SERVICE_NAME}"
  end

end

# extend date class (rather than use activesupport extensions)
class Date

  def monday_of_week
    week_start(self,1)
  end

private

  # For weekdays to start on Monday use 1 for the offset; for Tuesday use 2, etc.
  def week_start(date, offset_from_sunday=0 )
    date - (date.wday - offset_from_sunday)%7
  end

end
