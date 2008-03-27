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
    redirect_back_or_default("/") and return unless IterativeDesigns::QuickTicket.enabled?
    
    if not params[:body].blank? and not params[:title].blank?
      body = params[:body]
      if self.respond_to?(:logged_in?) and logged_in?
        body += "\n\nCreated from the web by #{current_user.login}"
      end
      body += "\nURL: #{params[:url]}"
      Lighthouse.account = IterativeDesigns::QuickTicket.account
      Lighthouse.token   = IterativeDesigns::QuickTicket.token
      ticket = Lighthouse::Ticket.new(:project_id => IterativeDesigns::QuickTicket.project, :title=>params[:title], :body=>body)
      ticket.tags << "WebTicket"
      if ticket.save
        flash[:notice]="Your ticket was successfully posted, we will try to fix it."
      else
        puts ticket.errors
      end
    end 
    respond_to do |format|
      format.html { redirect_back_or_default("/") }
      format.js  { 
        render :update do |page| 
          page << "QuickTicket.toggle('hide');"
          page.alert(flash[:notice]) unless flash[:notice].blank?
        end
      }
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
