require 'rake'
require 'yaml'
require 'json'
require 'bcrypt'
require 'mongo'

require 'pathname'
ROOT_PATH = Pathname.new(__FILE__).expand_path.parent.to_s
CONFIG    = YAML.load_file(File.join(ROOT_PATH, 'settings/config.yaml'))

@conn  = CONFIG[:mongo] ? Mongo::MongoClient.new(CONFIG[:mongo][:address], CONFIG[:mongo][:port]) : Mongo::MongoClient.new
@db    = @conn[CONFIG[:mongo][:db_name]]

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
  users = @db['users'] 
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
  pw   = handle_passwords
  init_mongo(user, pw)
  STDOUT.puts "done."
end

desc "import from a via export use \`file=\"/path/to/export.json\"\`"
task :import do
  post_data = File.read(ENV['file'])
  posts     = JSON.parse(post_data)
  posts_db  = @db['posts'] 
  posts["posts"].each do |post|
    post              = post.delete_if{|k, v| k == '_id'}
    post['timestamp'] = Time.at(post['timestamp'].to_i)
    puts "adding post \"#{post["title"]}\""
    posts_db.update({"id" => post['id']}, {"$set" => post}, :upsert => true)
  end
end


desc "export blog data to a json file"
task :export do
  posts     = []
  posts_db  = @db['posts'] 
  post_data = posts_db.find.to_a
  post_data.each do |p| 
    p['timestamp'] = p['timestamp'].to_i 
    posts << p
  end
  post_json = {:posts => posts}.to_json
  File.open(File.join(ROOT_PATH, "via.json"), 'w') {|f| f.write(post_json) }
end
