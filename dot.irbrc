# ~/.irbrc
# DrNic has some good ideas: http://drnicwilliams.com/2006/10/12/my-irbrc-for-consoleirb/
# Lots of good stuff here: http://www.ruby-forum.com/topic/84414#new

puts "Loading Dan's custom irbrc file..."
#############################################################################
# From: https://gist.github.com/794915
# Add all gems in the global gemset to the $LOAD_PATH so they can be used even
# in places like 'rails console'.
if defined?(::Bundler)
  $LOAD_PATH.concat Dir.glob("#{ENV['rvm_path']}/gems/#{ENV['rvm_ruby_string']}@global/gems/*/lib")
end
#############################################################################
require 'irb/completion'
require 'rubygems'

require 'ap'
require 'wirble'
Wirble.init(:skip_prompt => true, :skip_history => true)
# This page has info for changing Wirble colors: http://pablotron.org/software/wirble/README
Wirble.colorize

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


if ENV['RAILS_ENV']
  rails_env = ENV['RAILS_ENV']
  rails_root = File.basename(Dir.pwd)
  prompt = "#{rails_root}[#{rails_env.sub('production', 'prod').sub('development', 'dev')}]"
  IRB.conf[:PROMPT] ||= {}

  IRB.conf[:PROMPT][:RAILS] = {
    :PROMPT_I => "#{prompt}>> ",
    :PROMPT_S => "#{prompt}* ",
    :PROMPT_C => "#{prompt}? ",
    :RETURN   => "=> %s\n"
  }

  IRB.conf[:PROMPT_MODE] = :RAILS

  #Redirect log to STDOUT, which means the console itself
  IRB.conf[:IRB_RC] = Proc.new do
    logger = Logger.new(STDOUT)
    ActiveRecord::Base.logger = logger
    ActiveResource::Base.logger = logger
    ActiveRecord::Base.instance_eval { alias :[] :find }
  end

end



# Local Variables:
# mode: ruby
# End:
