var req = undefined;
var id = undefined;

function readURL(input) {
    if (input.files && input.files[0]) {
        var reader1 = new FileReader();
        reader1.onload = function (e) {
            $('#pic').attr('src', e.target.result);
        }
        reader1.readAsDataURL(input.files[0]);
    }
}

function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};

function checkInputs() {

	if ($("input[name=newsubject]").val().length == 0 && $("#selectmenu5").val().length == 0) {
		alert("Please make sure all required fields are filled out correctly.");
		return false;
	}
	
	if($("input[name=title]").val().length != 0 && $("input[name=author]").val().length != 0 && $("input[name=isbn]").val().length != 0 && $("input[name=date]").val().length != 0 && $("textarea[name=content]").val().length != 0){
		return true;
	}
	else {
		alert("Please make sure all required fields are filled out correctly."); 
		return false;
	}
	
};

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

function getEditItem(i) {
	var ii = parseInt(i);
	$.ajax({
        	type: "GET",
        	contentType: "application/json",
        	url: "/api/edit_item",
        	data: {itm: ii},
        	success: function(data) {
        		$("input[name=title]").val(data.title);
        		$("input[name=author]").val(data.author);
        		$("input[name=isbn]").val(data.isbn);
        		$("input[name=date]").val(data.published_date);
        		$("textarea[name=content]").val(data.description);
        		$("#selectmenu5").val(data.subject);
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function getEditRequestedItem(r) {
	var rr = parseInt(r);
	$.ajax({
        	type: "GET",
        	contentType: "application/json",
        	url: "/api/edit_requested_item",
        	data: {req: rr},
        	success: function(data) {
        		$("input[name=title]").val(data.title);
        		$("input[name=author]").val(data.author);
        		$("textarea[name=content]").val(data.description);
        		$("#selectmenu5").val(data.subject);
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function postAddItem(title, author, isbn, date, subject, desc){
	$.ajax({
        	type: "POST",
        	contentType: "application/json",
        	url: "/api/add_item",
        	data: JSON.stringify({title: title, author:author, date:date, isbn:isbn, subject:subject, description:desc}),
        	success: function(data) {
        		alert("Item was successfully added.");
        		window.location.replace("manageitems.html");
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function postEditItem(title, author, isbn, date, subject, desc){
	var ii = parseInt(id);
	$.ajax({
        	type: "POST",
        	contentType: "application/json",
        	url: "/api/edit_item",
        	data: JSON.stringify({itm:ii, title: title, author:author, published_date:date, isbn:isbn, subject:subject, description:desc}),
        	success: function(data) {
        		alert("Item was successfully edited.");
        		window.location.replace("manageitems.html");
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function postDeleteRequest(r) {
	var rr = parseInt(r);
	$.ajax({
        	type: "POST",
        	contentType: "application/json",
        	url: "/api/delete_request",
        	data: JSON.stringify({req: rr}),
        	success: function(data) {
        		alert("Request was successfully deleted.");
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function oc() {
	var input = checkInputs();
	if (input == true) {
		var title = $("input[name=title]").val();
		var author = $("input[name=author]").val();
		var isbn = parseInt($("input[name=isbn]").val());
		var date = $("input[name=date]").val();
		var desc = $("textarea[name=content]").val();
		
		if ($("input[name=newsubject]").val().length != 0) {
			var subject = $("input[name=newsubject]").val();
		}
		else {
			var subject = $("#selectmenu5").val();
		}
		
		if (req !== undefined) {
			postAddItem(title, author, isbn, date, subject, desc);
			postDeleteRequest(req);
		}
		else if (id !== undefined) {
			postEditItem(title, author, isbn, date, subject, desc);
		}
	}
};

$(document).ready(function(){
	getSubjects();
	
	req = getUrlParameter('req'); // request
	id = getUrlParameter('itm'); // book
	
	if (req !== undefined) {
		getEditRequestedItem(req);
	}
	else if (id !== undefined) {
		getEditItem(id);
	}
	
	$(document).on("change", "input[type=file]", function(){
		readURL(this);
	});
});
