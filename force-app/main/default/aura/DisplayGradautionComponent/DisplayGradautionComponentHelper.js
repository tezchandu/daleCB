({
    
    handleClose : function(component, event, helper) {
		alert('cancel');
		$A.get("e.force:closeQuickAction").fire();
	}
})