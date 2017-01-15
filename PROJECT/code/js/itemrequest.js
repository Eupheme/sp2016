function getSubjects() {
	$.ajax({
        	type: "GET",
        	contentType: "application/json",
        	url: "/api/subjects",
        	success: function(data) {
        		var menu = $("#selectmenu5");
        		for (var k in data) {
        			menu.append($("<option/>").text(data[k]));
        		}
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function checkInputs() {

	if ($("input[name=newsubject]").val().length == 0 && $("#selectmenu5").val().length == 0) {
		alert("Please make sure all required fields are filled out correctly.");
		return false;
	}
	if($("input[name=title]").val().length != 0 && $("input[name=author]").val().length != 0 && $("textarea[name=content]").val().length != 0){
		return true;
	}
	else {
		alert("Please make sure all required fields are filled out correctly."); 
		return false;
	}
	
};

function postRequestedItem(title, author, subject, desc){
	$.ajax({
        	type: "POST",
        	contentType: "application/json",
        	url: "/api/requested_item",
        	data: JSON.stringify({title: title, author:author, subject:subject, description:desc}),
        	success: function(data) {
        		alert("Item was successfully requested.");
        		window.location.replace("itemrequest.html");
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

$(document).ready(function(){
	getSubjects();
	
	$('#requestbtn').click(function() {
		var input = checkInputs();
		if (input == true) {
			var title = $("input[name=title]").val();
			var author = $("input[name=author]").val();
			var desc = $("textarea[name=content]").val();
		
			if ($("input[name=newsubject]").val().length != 0) {
				var subject = $("input[name=newsubject]").val();
			}
			else {
				var subject = $("#selectmenu5").val();
			}
		
			postRequestedItem(title, author, subject, desc);
		}
	});
});
