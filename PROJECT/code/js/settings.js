function getProfile(){
	$.ajax({
        	type: "GET",
        	contentType: "application/json",
        	url: "/api/profile",
        	success: function(data) {
        		var added_date = data.added_date;
        		var age = data.birth_date;
        		var email = data.email;
        		var first = data.first_name;
        		var last = data.last_name;
        		var username = data.username;
        		var status = data.status;
        		
        		$('#sMember').html("MEMBER SINCE: " + added_date);
        		$('#sEmail').html("EMAIL: " + email);
        		$('#sName').html("NAME: " + first + ", " + last);
        		$('#sUsername').html(username);
        		
        		if (age !== "") {
        			$('#sAge').html("AGE: " + age);
        		}
        		
        		if (status == 0) {
        			$('#sStatus').html("STATUS: user");
        		}
        		else if (status == 1) {
        			$('#sStatus').html("STATUS: admin");
        		}
        		
        		var results = $("#profilepicture");
        		var imgpath = data.picture;
        		if (data.picture == "")
        			imgpath = "user_default";
        		var img = $("<img src=\"/backend/files/" + imgpath + ".jpg\" alt = \"book image\"/>");
        		results.append(img);
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

window.addEventListener("load", function () {
    getProfile();
});
