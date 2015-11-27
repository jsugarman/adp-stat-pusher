require 'yaml'

module Helpers

  SERVICE_NAME             = "advocate-defence-payments-agfs"
  TRANSACTIONS_BY_CHANNEL  = 'transactions-by-channel'
  COMPLETION_RATE          = 'completion-rate'

  def secrets
    secrets = YAML.load(ERB.new(File.read('./.secrets.yml')).result)
  end

  def method_missing(method, *args, &block)
    if method.match(/^[A-Za-z_]+_key$/)
      secrets['api_key']["#{method.to_s.gsub(/_key/,'')}"]
    else
      super
    end
  end

end
