var sear = "";
var order = 0;
var by =5;
var usr = 0;
var req = 0;

function getSearchUser(s){
	$.ajax({
        	type: "GET",
        	contentType: "application/json",
        	url: "/api/search_user",
        	data: {search: s},
        	success: function(data) {
        		$(".entry").remove();
        		
	    		var results = $("#results");
	    		for (var k in data) {
	    			var wrapper = $("<option class=\"entry\" value=\"" + data[k].username + "\"/>");
	    			results.append(wrapper);
	    		}
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function getProfileAdmin(s){
	$.ajax({
        	type: "GET",
        	contentType: "application/json",
        	url: "/api/profile_admin",
        	data: {username: s},
        	success: function(data) {
        		$(".entry").remove();
        		$(".entryuser").remove();
        		
        		if (data.user_id != 0) {
		    		usr = data.user_id;
		    		
		    		var results = $(".userresults");
		    		
		    		var wrapper = $("<div id=\"userwrapper\" class=\"entryuser\"/>");
		    		var picture = $("<div id=\"userimage\"/>");
					var img = $("<img src=\"\" alt = \"user image\"/>");
					picture.append(img);
					
					var user = $("<div id=\"usertext\"/>");
					user.append($("<p id=\"sUsername\"/>").text(data.username));
					user.append($("<p id=\"sUserid\"/>").text("USER ID: " + data.user_id));
					user.append($("<p id=\"sName\"/>").text("NAME: " + data.last_name + " " + data.first_name));
					user.append($("<p id=\"sEmail\"/>").text("EMAIL: " + data.email));
					user.append($("<p id=\"sAge\"/>").text("BIRTH DATE: " + data.birth_date));
					user.append($("<p id=\"sMember\"/>").text("MEMBER SINCE: " + data.added_date));
					var button = $("<div id=\"statusbutton\"/>");
					button.append($("<input type=\"button\" id=\"deletebtn\" value=\"DELETE\" />"));
					
					if (data.status == 0) {
						user.append($("<p id=\"sStatus\"/>").text("STATUS: user"));
						button.append($("<input type=\"button\" id=\"adminbtn\" value=\"ADD AS ADMIN\" />"));
					}
					else if (data.status == 1) {
						user.append($("<p id=\"sStatus\"/>").text("STATUS: admin"));
						button.append($("<input type=\"button\" id=\"userbtn\" value=\"ADD AS USER\" />"));
					}
					
					user.append(button);
					
					wrapper.append(picture);
					wrapper.append(user);
					results.append(wrapper);
    			
    			}
		    	else {
		    		usr = 0;
		    		alert("This user does not exist.");
		    	}
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function postToUser(al){
	$.ajax({
        	type: "POST",
        	contentType: "application/json",
        	url: "/api/to_user",
        	data: JSON.stringify({usr:usr}),
        	success: function(data) {
        		if (al == 0)
        			alert("Status was changed to user.");
        		else
        			alert("User successfully added.");
        		window.location.replace("manageusers.html");
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function postToAdmin(al){
	$.ajax({
        	type: "POST",
        	contentType: "application/json",
        	url: "/api/to_admin",
        	data: JSON.stringify({usr:usr}),
        	success: function(data) {
        		if (al == 0)
        			alert("Status was changed to admin.");
        		else
        			alert("User successfully added as admin.");
        		window.location.replace("manageusers.html");
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function getPendingUsers(o, b){
	$.ajax({
        	type: "GET",
        	contentType: "application/json",
        	url: "/api/pending_users",
        	data: {order: o, by: b},
        	success: function(data) {
        		$("tr.entrytable").remove();
        		
        		var table = $("tbody.tableBody");
        		for (var k in data) {
        			var tr = $("<tr class=\"entrytable\" onmousedown=\"chooseElement(event)\"/>");
        			tr.append($("<input type=\"hidden\"/>").val(data[k].user_id));
        			tr.append($("<td/>").text(data[k].username));
        			tr.append($("<td/>").text(data[k].name));
        			tr.append($("<td/>").text(data[k].email));
        			tr.append($("<td/>").text(data[k].added_date));
        			table.append(tr);
        		}
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function postDeletePendingUser(){
	$.ajax({
        	type: "POST",
        	contentType: "application/json",
        	url: "/api/delete_pending_user",
        	data: JSON.stringify({usr:usr}),
        	success: function(data) {
        		alert("User was successfully deleted.");
        		window.location.replace("manageusers.html");
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function postDeleteUser(){
	$.ajax({
        	type: "POST",
        	contentType: "application/json",
        	url: "/api/delete_user",
        	data: JSON.stringify({usr:usr}),
        	success: function(data) {
        		alert("User was successfully deleted.");
        		window.location.replace("manageusers.html");
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

$(document).ready(function(){
	$('.searchbar').keyup(function(e) {
		if (e.keyCode == 13) {
			sear = this.value;
			getProfileAdmin(sear);
		}
	});

	$('.searchbar').on('input', function() {
		sear = this.value;
		getSearchUser(sear);
	});
    getSearchUser(sear);
    
    $(document).on("click", "#adminbtn", function() {
		if (usr != 0) {
			postToAdmin(0);
		}
	});
	
	$(document).on("click", "#userbtn", function() {
		if (usr != 0) {
			postToUser(0);
		}
	});
	
	$(document).on("click", "#deletebtn", function() {
		if (usr != 0) {
			postDeleteUser();
		}
	});

	$('input[type=radio][name=orderby]').change(function() {
		if (this.value == "username") {
			by = 5;
		}
		else if (this.value == "name") {
			by = 6;
		}
		else if (this.value == "date") {
			by = 7;
		}
		getPendingUsers(order, by);
	});
	
	$('input[type=radio][name=ascdesc]').change(function() {
		if (this.value == "ascending") {
			order = 0;
		}
		else if (this.value == "descending") {
			order = 1;
		}
		getPendingUsers(order, by);
	});
	
	getPendingUsers(order, by);
	
	$('input[type=radio][name=request]').change(function() {
		if (this.value == "accept") {
			req = 1;
		}
		else if (this.value == "deny") {
			req = 0;
		}
		else if (this.value == "acceptadmin") {
			req = 2;
		}
	});
	
	$('#submitbtn').click(function() {
		var x = $('.selected');
		if (x.length != 0){
			usr = parseInt(x.find("input")[0].value);
			if (req == 0) {
				postDeletePendingUser();
			}
			else if (req == 1) {
				postToUser(1);
			}
			else if (req == 2) {
				postToAdmin(1);
			}
		}
		else {
			alert("No row was chosen.");
		}
	});
});
