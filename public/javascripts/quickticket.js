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
	},
	submit:function(form)	{
		new Ajax.Request("/create_ticket", {asynchronous:true, evalScripts:true, parameters:Form.serialize(form), method: 'get'});
		return false;
	}, 
	notify:function(message)	{
		alert(message);
	}

}
