require 'yaml'
require "awesome_print"

module Helper

  def secrets
    secrets = YAML.load_file('./.secrets.yml')
  end

  def method_missing(method, *args, &block)
    if method.match(/^[A-Za-z_]+_key$/)
      secrets['api_key']["#{method.to_s.gsub(/_key/,'')}"]
    elsif method.match(/^[A-Za-z_]+_uuid$/)
      secrets['_id']["#{method}"]
    else
      super
    end
  end

end