require 'config/environment'
require 'config_boy'
require 'ar_classes'
require 'back_up'

puts "Time for me to go to work!"
puts "========================="

ENVIRONMENT = ConfigBoy.parse_env(ARGV)

ARClasses.init_classes              # creates dynamic ActiveRecord Classes from config var
ConfigBoy.activate_record           # activates ActiveRecord
backem_up = BackUp.new              # inits the backup routines and preps them for dynamic generation
backem_up.backup                    # Calls the backup routine. WOO
backem_up.log_time_of_backup        #log time of backups

puts "========================="
puts "Looks like I'm done here. Time to relax"