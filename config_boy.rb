class ConfigBoy

  def initialize()
  end

  # activates active record for all the dynamically created classes
  def self.activate_record
    puts "- initializing ActiveRecord Connections..."
    ActiveRecord::Base.establish_connection(ConfigBoy.database_info)
    puts "- ActiveRecord Online!"
  end

  # gets the DB connection info
  def self.database_info
    db = File.dirname(__FILE__) + "/config/database.yml"
    db_config = YAML.load(ERB.new(IO.read(db)).result)
    env = ENVIRONMENT
    (db_config[env]).symbolize_keys
  end

  # gets the CouchDB connection info
  def self.couch_database_info
    db = File.dirname(__FILE__) + "/config/couchdb.yml"
    db_config = YAML.load(ERB.new(IO.read(db)).result)
    env = ENVIRONMENT
    (db_config[env])
  end

  #parses command line arguments looking for a rails_env. if none is found, the default is development
  def self.parse_env(args)
    to_return = "development"
    args.each do |ar|
      if ar.include? "RAILS_ENV="
        env = ar.blank? ? [] : ar.split("=")[1]
        to_return = env != "development"  ? env : "development"
      end
    end
    puts "- Preparing to log items from the #{to_return.upcase} environment"
    return to_return
  end

end