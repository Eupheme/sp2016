function checkInputs(i) {
    if (i === 0) { //login
        var uname, passwd;
        uname = document.getElementById("username");
        passwd = document.getElementById("password");
        if (uname.value != "" && passwd.value != "") {
            return 1;
        } else {
            uname.style.backgroundColor = "rgba(153, 0, 0, 0.7)";
            passwd.style.backgroundColor = "rgba(153, 0, 0, 0.7)";
            setTimeout( function ( ) {
                alert("Please make sure all required fields are filled out correctly."); 
            }, 10);
            return 0;
        }
    }
    else if (i === 1) { //register new
        var allfields, i, email, correct, alertstring;
        correct = true;

        allfields = document.getElementsByTagName('input');
        for (i = 0; i < allfields.length; i++) {
            //if empty
            if (allfields[i].value == "") {
                correct = false;
                allfields[i].style.backgroundColor = "rgba(153, 0, 0, 0.7)";
            }
        }
        if (correct === false) {
            setTimeout( function ( ) {
                alert("Please make sure all required fields are filled out correctly."); 
            }, 10);
            return 0;
        }

        alertstring = "";

        // do passwords match
        if (allfields[4].value != allfields[5].value) {
            allfields[4].style.backgroundColor = "rgba(153, 0, 0, 0.7)";
            allfields[5].style.backgroundColor = "rgba(153, 0, 0, 0.7)";
            alertstring += "Passwords don't match!\n";
        }

        //length more than 7 characters (username, password)
        if (allfields[2].value.length < 7) {
            allfields[2].style.backgroundColor = "rgba(153, 0, 0, 0.7)";
            alertstring += "Username not long enough!\n";
        }
        if (allfields[4].value.length < 7 && allfields[5].value.length < 7) {
            allfields[4].style.backgroundColor = "rgba(153, 0, 0, 0.7)";
            allfields[5].style.backgroundColor = "rgba(153, 0, 0, 0.7)";
            alertstring += "Password not long enough!\n";
        }

        //check if email includes @
        email = allfields[3].value;
        if(!email.includes('@')){
            allfields[3].style.backgroundColor = "rgba(153, 0, 0, 0.7)";
            alertstring += "Enter a valid email!\n";
        }

        if (alertstring !== ""){
            setTimeout( function ( ) {
                alert(alertstring); 
            }, 10);
            return 0;
        }

        return 2;
    }
}

function validate(x){
    var allfields = document.getElementsByTagName('input');
    for (i = 0; i < allfields.length; i++) {
        allfields[i].style.backgroundColor = "#f2f2f2";
    }

    var check = checkInputs(x);
    if (check === 1){
        var uname, passwd;
        uname = document.getElementById("username");
        passwd = document.getElementById("password");
        
        $.ajax({
        	type: "POST",
        	contentType: "application/json",
        	url: "/api/login",
        	data: JSON.stringify({username: uname.value, password: passwd.value}),
        	success: function(data) {
        		console.log("success");
        		console.log(data);
        		if (data == ""){
        			uname.style.backgroundColor = "rgba(153, 0, 0, 0.7)";
				    passwd.style.backgroundColor = "rgba(153, 0, 0, 0.7)";
				    setTimeout( function ( ) {
				        alert("Wrong username or password");
				    }, 10);
        		}
        		else {
        			document.cookie = "sess=" + data;
        			window.location = "myitems.html";
        		}
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
    }

    if (check === 2){
    	
    	$.ajax({
        	type: "POST",
        	contentType: "application/json",
        	url: "/api/register",
        	data: JSON.stringify({first: allfields[0].value, last: allfields[1].value, username: allfields[2].value, email: allfields[3].value, password: allfields[4].value}),
        	success: function(data) {
        		console.log("success");
        		console.log(data);
        		if (data == true){
        			alert("You have been registered. Please wait for approval.");
        		}
        		else {
        			allfields[2].style.backgroundColor = "rgba(153, 0, 0, 0.7)";
        			alert("This username is taken.");
        		}
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
    }
}
