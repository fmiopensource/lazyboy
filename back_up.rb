class BackUp

  attr_accessor :last_run
  attr_accessor :couch_db
  attr_accessor :couch_db_url

  def initialize
    puts "- Getting ready to start backups..."

    couchdb_info = ConfigBoy.couch_database_info.symbolize_keys
    @couch_db_url = "http://#{couchdb_info[:host]}"
    @couch_db     = "http://#{couchdb_info[:host]}/#{couchdb_info[:database]}"
  end


  # gets uuids from couch
  def get_uuids(count=1)
    url = "#{@couch_db_url}/_uuids"
    url << "?count=#{count}" if count > 1

    data = RestClient.get url
    JSON.parse(data)["uuids"]
  end

  def get_uuid
    get_uuids
  end

  # writes to couch
  def write_to_couch(objects)
    objects.each_with_index do |obj, i|
      RestClient.post("#{@couch_db}", (obj.attributes.merge(:class=>obj.class.to_s)).to_json )
      print "." if (i%10)==0
    end
    print "."
    puts "\n"
  end

  # logs time of the backup... duh
  def log_time_of_backup
    puts "- Logging the time of this backup"
    puts "You can find this by extracting the document with the class type of LastRunDoc"
    logger = {:class=>"LastRunLog",
      :logged_interval=>last_run,
      :ran_at=>Time.now}
    RestClient.post("#{@couch_db}", logger.to_json )
  end

  #interface for dynamic method missing
  def backup
    BACKUP_MODELS.each do |obj|
      puts "Preparing to back up #{obj}"
      self.send(obj.to_sym)
    end 
  end

  # intercepts any method call that matches our class array, then gets the data and sends it off to couchdb
  def method_missing(sym, *args, &block)
    method_sym = sym.to_s
    raise "InvalidMethodName" unless BACKUP_MODELS.include?(method_sym)
    method = method_sym.camelize
    backing_up_objects = method.constantize.all
    puts "Backing up #{backing_up_objects.count} #{method} objects to CouchDB."
    puts "This will take a while..." unless backing_up_objects.count < 200
    write_to_couch(backing_up_objects)
  end

end