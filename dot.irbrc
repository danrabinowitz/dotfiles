# ~/.irbrc
# DrNic has some good ideas: http://drnicwilliams.com/2006/10/12/my-irbrc-for-consoleirb/
# Lots of good stuff here: http://www.ruby-forum.com/topic/84414#new

puts "Loading Dan's custom irbrc file..."
if defined? ETC_IRBRC_LOADED
  puts "WARNING: It seems that there is a global /etc/irbrc file already loaded!"
end

#############################################################################
# From: https://gist.github.com/794915
# Add all gems in the global gemset to the $LOAD_PATH so they can be used even
# in places like 'rails console'.
if defined?(::Bundler)
  if ENV['rvm_path'] && ENV['rvm_ruby_string']
    $LOAD_PATH.concat Dir.glob("#{ENV['rvm_path']}/gems/#{ENV['rvm_ruby_string']}@global/gems/*/lib")
  else
    $LOAD_PATH.concat Dir.glob("#{Gem::path.detect{ |p| p=~/global$/ }}/gems/*/lib")
  end
end

# When I do not use rvm, I use this next line to provide access to gems which are outside bundler
$LOAD_PATH.concat Gem.path.map{ |p| Dir.glob("#{p}/gems/*/lib") }.flatten

#############################################################################
# On machines where I do not have the ability (or do not want) to add gems, add this line to .bashrc_local:
# export djr_local_gems=$HOME'/.gems'
# and then run this to install a gem:
# gem install awesome_print --install-dir $djr_local_gems
# Then, the next few lines will ensure that these gems get loaded.

if ENV['djr_local_gems']
  puts "Using custom djr_local_gems path"
  $LOAD_PATH.concat Dir.glob("#{ENV['djr_local_gems']}/gems/*/lib")
end
#############################################################################
$LOAD_PATH.uniq!
#############################################################################
require 'irb/completion'

%w(rubygems awesome_print).each do |lib|
  begin
    require lib
  rescue LoadError
#    rvm_current = `rvm current`.strip.split('@').last
#    puts "Unable to load #{lib}. Continuing, but you may want to run 'rvm gemset use global && gem install #{lib} && rvm gemset use #{rvm_current}'"
    puts "Unable to load #{lib}. Continuing, but you may want to run 'gem install #{lib}'"
  end
end

begin
if defined?(AwesomePrint)
  require "awesome_print"
  AwesomePrint.irb!
end
rescue Exception => e
  puts "Exception: #{e}"
end

#IRB.conf[:AUTO_INDENT]=true

#############################################################################
class Dan
  def self.age
    @@birthdate = Time.new(1973,11,24,6,15,0,"-07:00").utc
    lbd = last_birthday
    today = Time.new

    yy = lbd.year - @@birthdate.year

    mm = today.month - @@birthdate.month
    mm += 12 if mm < 0

    return "%d years and %d months" % [yy, mm]
  end

  private

  def self.birthday_in_year(year)
    return Time.utc(year,@@birthdate.month,@@birthdate.day,@@birthdate.hour,@@birthdate.min,@@birthdate.sec)
  end

  def self.last_birthday
    if birthday_in_year(Time.new.year) > Time.new
      return birthday_in_year(Time.new.year - 1)
    else
      return birthday_in_year(Time.new.year)
    end
  end

end
#############################################################################
class Object
  # Return a list of methods defined locally for a particular object.  Useful
  # for seeing what it does whilst losing all the guff that's implemented
  # by its parents (eg Object).
  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end
end
#############################################################################

# Cool: http://coderwall.com/p/6yqm-q?i=1&p=1&q=&t=shell
# copy [1,2,3,4]
# "[1, 2, 3, 4]" is now in your clipboard.
def copy(*args) IO.popen('pbcopy', 'r+') { |clipboard| clipboard.puts args.map(&:inspect) }; end
#############################################################################
# Rails-specific setup
rails_env = (defined? Rails) && Rails.env
if rails_env
  rails_appname = File.basename(Dir.pwd)
  if Dir.pwd =~ /\/([^\/]+)\/releases\/\d{14}$/
    rails_appname = $1
  end
  prompt = "#{rails_appname}[#{rails_env.sub('production', 'prod').sub('development', 'dev')}]"
  IRB.conf[:PROMPT] ||= {}

  IRB.conf[:PROMPT][:RAILS] = {
    :PROMPT_I => "#{prompt}>> ",
    :PROMPT_S => "#{prompt}* ",
    :PROMPT_C => "#{prompt}? ",
    :RETURN   => "=> %s\n"
  }

  IRB.conf[:PROMPT_MODE] = :RAILS

  #Redirect log to STDOUT, which means the console itself
  if defined? ActiveRecord
    IRB.conf[:IRB_RC] = Proc.new do
      logger = Logger.new(STDOUT)
      ActiveRecord::Base.logger = logger
      ActiveResource::Base.logger = logger if defined? ActiveResource
      ActiveRecord::Base.instance_eval { alias :[] :find }
    end

    def log
      ActiveRecord::Base.clear_active_connections!
      ActiveRecord::Base.logger = Logger.new(STDOUT)
    end
  end
end
#############################################################################
Kernel::at_exit do
  histfile = File::expand_path(".irb-history", ENV["HOME"])
  puts "TODO: Ensure that #{histfile} is a symlink to /dev/null"
  puts " This ensures that history does not get written to .irb-history and ONLY goes to the real history."
end

history_filename = "~/.irb-history#{'-' + rails_appname if rails_appname}.rb"
IRB.conf[:HISTORY_FILE] = File.expand_path(history_filename)
IRB.conf[:SAVE_HISTORY] = 10000

if defined?(BigDecimal)
  class BigDecimal
    def inspect
      "#<BigDecimal: #{to_f}>"
    end
  end
end

# Local Variables:
# mode: ruby
# End:
