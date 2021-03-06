function getProfile() {
	$.ajax({
        	type: "GET",
        	contentType: "application/json",
        	url: "/api/profile",
        	success: function(data) {        		
        		var usr1 = $("#banner1");
        		usr1.append($("<p/>").text(data.username));
        		var usr2 = $("#banner2");
        		usr2.append($("<p/>").text(data.username));
        		if (data.status == 1){ // admin
        			$("#asadmin").show();
        		}
        		
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function postLogout(){
	$.ajax({
        	type: "POST",
        	contentType: "application/json",
        	url: "/api/logout",
        	success: function(data) {
        		window.location.replace("index.html");
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

getProfile();

$(document).on("click", "#logout", function() {
	postLogout();
});
