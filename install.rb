require 'fileutils'

# Install JS file
js_path   = '/public/javascripts/quickticket.js'
js_target = File.dirname(__FILE__) + "/../../..#{js_path}"
FileUtils.cp File.dirname(__FILE__) + js_path, js_target unless File.exist?(js_target)

# Install CSS file
css_path   = '/public/stylesheets/quickticket.css'
css_target = File.dirname(__FILE__) + "/../../..#{css_path}"
FileUtils.cp File.dirname(__FILE__) + css_path, css_target unless File.exist?(css_target)


#dump sample values into environment.rb

default_values = <<-VALUES

###################################################
#
# QuickTicket Configuration
#

#replace with your account name (first part of the domain name for Lighthouse)
IterativeDesigns::QuickTicket.account = "iterativedesigns"		

#replace with your valid Lighthouse Token (from the "My Profile" section in Lighthouse)
IterativeDesigns::QuickTicket.token   = "12j3hl4jkh4jk13h2jk4h2jk1"

# You can find this through your URL when you click on the project
IterativeDesigns::QuickTicket.project = 1234					

# The name of your application to make it feel localized, leave blank if you do not care.
IterativeDesigns::QuickTicket.site_name = "QuickTicket"	

# If set to false, the quickticket.css file (located in RAILS_ROOT/public/stylesheets) will not be dynamically included.
IterativeDesigns::QuickTicket.with_style=true

# The environments you want your QuickTicket to show up in, list as many or as few as you want.
IterativeDesigns::QuickTicket.environments = ['production']	

VALUES

File.open(File.dirname(__FILE__) + "/../../../config/environment.rb", File::WRONLY | File::APPEND) do |environment_rb|
  environment_rb << default_values
end

puts IO.read(File.join(File.dirname(__FILE__), 'README.markdown'))