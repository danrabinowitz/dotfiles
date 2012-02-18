# ~/.irbrc
# DrNic has some good ideas: http://drnicwilliams.com/2006/10/12/my-irbrc-for-consoleirb/
# Lots of good stuff here: http://www.ruby-forum.com/topic/84414#new

puts "Loading Dan's custom irbrc file..."
require 'irb/completion'
require 'rubygems'
require 'wirble'
Wirble.init
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

# Local Variables:
# mode: ruby
# End:
