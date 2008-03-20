class QuickTicketsController < ActionController::Base
  include AuthenticatedSystem
  before_filter :login_required
  
  def index
    redirect_back_or_default("/")
  end
  
  def new
    redirect_back_or_default("/")
  end
  
  def create 
    if not params[:body].blank? and not params[:title].blank?
      body = params[:body]
      
      body += "\n\nCreated from the web by #{current_user.name}"
      body += "\nURL: #{params[:url]}"
      ticket = Lighthouse::Ticket.new(:project_id => QuickTicket.project, :title=>params[:title], :body=>body)
      ticket.tags << "WebTicket"
      if ticket.save
        flash[:notice]="Your ticket was successfully posted, we will try to fix it."
      else
        puts ticket.errors
      end
    end 
    respond_to do |format|
      format.html { redirect_back_or_default("/") }
      format.js  { render :action=>"create.js.rjs" }
    end
  end
  
  
  def edit
    redirect_back_or_default("/")
  end
  
  def update
    redirect_back_or_default("/")
  end
  
  def delete
    redirect_back_or_default("/")
  end
  
end
