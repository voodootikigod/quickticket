module IterativeDesigns # :nodoc:
  module QuickTicketMixin
    def quick_ticket_code(request = nil)
      return unless QuickTicket.enabled?
      QuickTicket.ticket_pane(request)
    end
    
    # An after_filter to automatically add the analytics code.
    def add_quick_ticket_code
      code = quick_ticket_code(request)
      return if code.blank?
      response.body.gsub! '</body>', code + '</body>' if response.body.respond_to?(:gsub!)
    end
    
    
  end

  class QuickTicket
    
    @@project = nil
    cattr_accessor :project
    
    @@account = nil
    cattr_accessor :account
    
    @@token = nil
    cattr_accessor :token
    
    
    @@site_name = nil
    cattr_accessor :site_name
    
    
    @@with_style = true
    cattr_accessor :with_style

    # The environments in which to enable the Google Analytics code.  Defaults
    # to 'production' only.
    @@environments = ['production']
    cattr_accessor :environments

    # Return true if the Google Analytics system is enabled and configured
    # correctly.
    def self.enabled?
      (environments.include?(RAILS_ENV) and
        not project.blank? and
        not account.blank? and
        not token.blank?)
    end
    
    def self.ticket_pane(request = nil)
      
      javascript = <<-HTML
  		<script src="/javascripts/quickticket.js" type="text/javascript"></script>
      HTML

      style = <<-HTML  
      <link href="/stylesheets/quickticket.css" media="screen" rel="stylesheet" type="text/css" />
      HTML

      code = <<-HTML
    <div id="bug_button">
			<a href="javascript:void(0);" onclick="QuickTicket.toggle('show')"><span>Report Issue</span></a>
		</div>
    <div id="create_ticket_form" style="display:none">
    	<div style="float:right">
    		<a href="javascript:void(0);" onclick="QuickTicket.toggle('hide')">close</a>
    	</div>

    	<form action="/create_ticket" method="GET" onsubmit="return QuickTicket.submit(this);">
	  
    		<input type="hidden" name="url" value="#{request.request_uri}"/>
    		<h2>Create a ticket#{ " for "+site_name unless site_name.blank?}</h2>
    		<div id="lighthouse_ticket_title" class="field">
    			<label>Quick Description (less than 140 characters)</label>
    			<input type="text" id="lighthouse_ticket_title_field"  maxsize="140" name="title" />
    		</div>
		    <div id="lighthouse_ticket_priority" class="field">
    			<label class="inline">Priority</label>
    			<select name="priority" id="lighthouse_ticket_priority_field">
    			  <option value="CRITICAL">Critical</option>
    			  <option value="HIGH">High</option>
    			  <option value="MEDIUM" selected="selected">Medium</option>
    			  <option value="LOW">Low</option>
    			  <option value="NA">N/A</option>
  			  </select>
    		</div>
    		<div id="lighthouse_ticket_body" class="field">
    			<label>What went wrong or what change would you like?</label>
    			<textarea name="body" id="lighthouse_ticket_body_field"></textarea>
    		</div>
    		<div id="submitting_ticket" style="display:none">
    			Submitting ticket...
    		</div>
    		<div id="submit_ticket">
    		<input type="submit" class="submit_button" value="Register Ticket"/> or 
    			<a href="javascript:void(0);" onclick="QuickTicket.toggle('hide')">Cancel</a>
    		</div>
    	</form>
    </div>
      HTML
      
      str = javascript
      str += style if @@with_style
      str += code
      str
    end
  end
  
  
end