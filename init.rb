require 'lighthouse'
require 'iterativedesigns/quick_ticket'

ActionController::Base.send :include, Lighthouse
ActionController::Base.send :include, IterativeDesigns::QuickTicketMixin
ActionController::Base.send :after_filter, :add_quick_ticket_code


require 'controllers/quick_tickets_controller'