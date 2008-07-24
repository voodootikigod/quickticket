var QuickTicket = {
  toggle:function(invoke_action)	{
		if (invoke_action == "show")	{
			$('create_ticket_form').show();
			$('lighthouse_ticket_title_field').value="";
			$('lighthouse_ticket_body_field').value="";
			$('lighthouse_ticket_priority_field').selectedindex=2;
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
/*

JQUERY VERSION USING FACEBOX AND AJAXFORM

var QuickTicket = {
  toggle:function(invoke_action)	{
		if (invoke_action == "show")	{
			$('#create_ticket_form').show();
			$('#lighthouse_ticket_title_field').value="";
			$('#lighthouse_ticket_body_field').value="";
			$('#lighthouse_ticket_priority_field').selectedindex=2;
			$('#submitting_ticket').hide();
			$('#submit_ticket').show();
		} else	{
			$('#create_ticket_form').hide();
		}
	},
	submit:function(quick_ticket_form)	{
		try	{
			$(quick_ticket_form).ajaxSubmit({dataType: "script"});
			
		} catch (e)	{
			alert(e);
		}
		return false;
	}, 
	notify:function(message)	{
		$("#create_ticket_form form").resetForm();
		jQuery.facebox("<h1>"+message+"</h1>");
		setTimeout(jQuery.facebox.close, 4000);
	}

}


*/