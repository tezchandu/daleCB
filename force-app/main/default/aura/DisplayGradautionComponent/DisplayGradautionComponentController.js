({
    handleClose: function (component, event, helper) {
        $A.get("e.force:refreshView").fire();
        $A.get("e.force:closeQuickAction").fire();
      },
      modalclosed: function(component, event, helper) {
            // Handle the cancel action in the Aura component
            // You can call a function or perform any necessary action here
            console.log('Cancel button in LWC was clicked');
           // var navigate = component.get("v.navigateFlow");
           // navigate("FINISH");
            var redirectToNewRecord = $A.get( "e.force:navigateToSObject" );
            redirectToNewRecord.setParams({
              "recordId": component.get( "v.recordId" ),
              "slideDevName": "detail"
              });
              redirectToNewRecord.fire();
      },
      closeScreen: function(component, event, helper) {
        // Use Flow's navigation to close the screen
        var navigate = component.get("v.navigateFlow");
        navigate("FINISH"); // Use appropriate navigation value based on your flow design
      }
    
})