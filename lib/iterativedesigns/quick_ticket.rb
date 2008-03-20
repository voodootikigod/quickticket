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
    
    
    def create_ticket
      if not params[:body].blank? and not params[:title].blank?
        body = params[:body]
        if responds_to?(current_user)
          body += "\n\nCreated from the web by #{current_user.login}"
        end
        body += "\nURL: #{params[:url]}"
        ticket = Lighthouse::Ticket.new(:project_id => IterativeDesigns::QuickTicket.project, :title=>params[:title], :body=>body)
        ticket.tags << "WebTicket"
        if ticket.save
          flash[:notice]="Your ticket was successfully posted, we will try to fix it."
        end
      end 
      respond_to do |format|
        format.html { redirect_back_or_default("/") }
        format.js  { render :action=>"create.js.rjs" }
      end
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


<script type="text/javascript">
// <![CDATA[
var QuickTicket = {
  toggle:function(invoke_action)	{
		if (invoke_action == "show")	{
			$('create_ticket_form').show();
			$('lighthouse_ticket_title_field').value="";
			$('lighthouse_ticket_body_field').value="";
			$('submitting_ticket').hide();
			$('submit_ticket').show();
		} else	{
			$('create_ticket_form').hide();
		}
	}
}

// ]]>
</script>
HTML

style = <<-HTML  
<style type="text/css" media="screen">
div#bug_button	{
	position:fixed;
	bottom:20px;
	right:20px;
}

div#create_ticket_form .field textarea	{
	height:60px;
}
div#create_ticket_form .field input,
div#create_ticket_form .field textarea	{
	
	width: 500px;
}

div#create_ticket_form input.submit_button	{
	margin:8px 0px;
	text-align:right;
}
div#create_ticket_form h2	{
	padding:0px;
	margin:8px 0px;
}

div#create_ticket_form label	{
	font-size:12px;
	font-weight:bold;
	display:block;
	margin:6px 0px;
}
div#create_ticket_form	form {
	text-align:left;
	width:500px;
	margin:0px auto
}

div#create_ticket_form	{
	position:fixed;
	bottom:0px;
	height:210px;
	left:0px;
	right:0px;
	padding:8px;
	border-top:3px solid #bababa;
	background:#ccc;
}
</style>
HTML

code = <<-HTML
<div id="bug_button">
			<a href="javascript:void(0);" onclick="QuickTicket.toggle('show')">Report Issue</a>
		</div>
<div id="create_ticket_form" style="display:none">
	<div style="float:right">
		<a href="javascript:void(0);" onclick="QuickTicket.toggle('hide')">close</a>
	</div>
	
	<form action="/create_ticket" method="GET">
		<h2>Create a ticket#{ "for "+site_name unless site_name.blank?}</h2>
		<div id="lighthouse_ticket_title" class="field">
			<label>Title</label>
			<input type="text" id="lighthouse_ticket_title_field" name="title" />
		</div>
		<input type="hidden" name="url" value="<%= request.request_uri -%>"/>
		
		<div id="lighthouse_ticket_body" class="field">
			<label>Body</label>
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
      str += style #if with_style
      str += code
      str
    end
  end
  
  
  class << self
      # Adds routes to your application necessary for the plugin to function correctly.
      # Simply add the following inside your Routes.draw block in routes.rb:
      #   UJS::routes
      # This is now *mandatory*.
      def routes
        ActionController::Routing::Routes.add_route "/quick_ticket", :controller => "quick_tickets", :action => "create"
      end

    end
  
end