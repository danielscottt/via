require 'rake'
require 'yaml'
require 'bcrypt'
require 'mongo'

require 'pathname'
root_path = Pathname(__FILE__).parent.to_s
CONFIG = YAML.load_file(File.join(root_path, 'settings/config.yaml'))

task :default do
  exec('rake -T')
end

class String
  
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

end

def init_mongo(username, password)
  STDOUT.puts "Initializing db..."
  conn  = CONFIG[:mongo] ? Mongo::MongoClient.new(CONFIG[:mongo][:address], CONFIG[:mongo][:port]) : Mongo::MongoClient.new
  db    = conn[CONFIG[:mongo][:db_name]]
  users = db['users']
  STDOUT.puts "Generating password hash..."
  salt  = BCrypt::Engine.generate_salt
  hash  = BCrypt::Engine.hash_secret(password, salt)
  STDOUT.puts "Saving user..."
  users.update({'username' => username}, {
    '$set' => {
      'user' => username, 
      'password' => hash,
      'salt'     => salt,
    }
  }, :upsert => true)
end

def handle_passwords
  print 'Enter your password: '
  `stty -echo`
  pw_one = STDIN.gets.chomp
  STDOUT.puts "\n"
  print 'Confirm password: '
  pw_two = STDIN.gets.chomp
  STDOUT.puts "\n"
  `stty echo`
  if pw_one == pw_two
      return pw_one
  else
      STDERR.puts 'Passwords did not match, please try again.'.red
      handle_passwords
  end
end

desc "initialize Mongo for Via, and set up first user"
task :init do
  print 'Enter a username: '
  user = STDIN.gets.chomp
  pw = handle_passwords
  init_mongo(user, pw)
  STDOUT.puts "done."
end
