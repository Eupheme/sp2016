var array = [];

function readURL(input) {
    if (input.files && input.files[0]) {
        var reader1 = new FileReader();
        reader1.onload = function (e) {
            $('#pic').attr('src', e.target.result);
        }
        reader1.readAsDataURL(input.files[0]);
        
    }
}

function checkInputs() {
	
	if($("input[name=pass1]").val().length != 0) {
		if ($("input[name=pass1]").val() != $("input[name=pass2]").val()) {
			alert("Passwords do not match."); 
			return false;
		}
	}
	
	if($("input[name=username]").val().length != 0 && $("input[name=first]").val().length != 0 && $("input[name=last]").val().length != 0 && $("input[name=email]").val().length != 0 ){
		return true;
	}
	else {
		alert("Please make sure all required fields are filled out correctly."); 
		return false;
	}
	
};

function getMyProfile() {
	$.ajax({
        	type: "GET",
        	contentType: "application/json",
        	url: "/api/profile",
        	success: function(data) {
        		console.log("success profile");
        		console.log(data);
        		
        		$("input[name=username]").val(data.username);
        		$("input[name=first]").val(data.first_name);
        		$("input[name=last]").val(data.last_name);
        		$("input[name=email]").val(data.email);
        		$("input[name=date]").val(data.birth_date);
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function postEditProfile(username, first, last, email, date, pass){
	console.log(array);
	$.ajax({
        	type: "POST",
        	contentType: "application/json",
        	url: "/api/edit_profile",
        	data: JSON.stringify({username:username, first:first, last:last, email:email, date:date, newpass:pass, picture:array}),
        	success: function(data) {
        		console.log("success");
        		console.log(data);
        		
        		alert("Profile was successfully edited.");
        		window.location.replace("settings.html");
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}


$(document).ready(function(){
	getMyProfile();
	$(document).on("change", "input[type=file]", function(){
		readURL(this);
		var reader2 = new FileReader();
		reader2.onload = function () {            
			var arrayBuffer = this.result;
			array = Array.from(new Int8Array(arrayBuffer));
			//array = arrayBuffer;
			console.log(array);
		}
		reader2.readAsArrayBuffer(this.files[0]);
	});

	$('#submitbtn').click(function() {
		var check = checkInputs();
		if (check == true) {
			var username = $("input[name=username]").val();
			var first = $("input[name=first]").val();
			var last = $("input[name=last]").val();
			var email = $("input[name=email]").val();
			
			var date = $("input[name=date]").val();
			var pass = $("input[name=pass1]").val();
			
			postEditProfile(username, first, last, email, date, pass);
		}
		
	});
});
