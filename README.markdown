QuickTicket
===========

QuickTicket is a Rails plugin that utilizes the Lighthouse API to provide ticket creation within a Rails application. This will create a little icon on the bottom right of the application screen (which scrolls) that will display a pane when clicked. This will allow the user to provide their comments/issues/bug into  the pane which is then submitted to your Lighthouse account for the project.

What gets installed
===================

Once you have the plugin installed, you will find the following two new assets created into your application

* ./public/stylesheets/quickticket.css - This holds the default (and configurable) styling for the application, update it as you see fit or configure it not to be loaded.
* ./public/javascripts/quickticket.js  - This holds the necessary javascript, written to work with the Prototype library. You can enhance or modify it (switch to jQuery) but keep the namespace and methods the same.

Also new parameters have been added to your environment.rb file which will allow you to configure QuickTicket. You should probably go update those now, otherwise it will act like its working, but fail.

What you need to do
===================

It feels dirty adding routes to your application, so we are just going to make you do it. This route will just allow the app to call back into the lighthouse ticket controller, which IF the environment is correct, will execute, otherwise it will redirect back. Essentially said, if someone tries to access the route when not in the right environment, the system will block it (p0wn3d). So make sure you add this line to your routes.rb file:

map.create\_ticket "create\_ticket", :controller=>"quick_tickets", :action=>"create"