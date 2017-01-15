usear = "";
isear = "";
sear = "";

borrowuser = 0;
borrowitem = 0;
returnuser = 0;
returnitem = 0;

function getSearchUser(s, key){
	$.ajax({
        	type: "GET",
        	contentType: "application/json",
        	url: "/api/search_user",
        	data: {search: s},
        	success: function(data) {
        		console.log("success");
        		console.log(data);
        		
        		$(".uentry").remove();
        		
        		if (key == 1) {
        			if (data.length != 0) {
		    			$('input.usearchbar').val(data[0].username);
						$("#userimage1").remove();
						$("#usertext1").remove();
						
		    			var results = $(".userresults1");
		    			
		    			var picture = $("<div id=\"userimage1\"/>");
						var img = $("<img src=\"\" alt = \"user image\"/>");
						picture.append(img);
					
						var text = $("<div id=\"usertext1\"/>");
						text.append($("<h5/>").text(data[0].username));
						text.append($("<h6/>").text("NAME: " + data[0].name));
						text.append($("<h6/>").text("USER ID: " + data[0].id));
					
						results.append(picture);
						results.append(text);
						
						borrowuser = data[0].id;
					}
					else {
						borrowuser = 0;
						alert("This user does not exist.");
					}
        		}
        		else {
		    		var results = $("#rusers");
		    		for (var k in data) {
		    			var wrapper = $("<option class=\"uentry\" value=\"" + data[k].username + "\"/>");
		    			results.append(wrapper);
		    		}
        		}
        		
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function getSearchItem(s, key){
	$.ajax({
        	type: "GET",
        	contentType: "application/json",
        	url: "/api/search_item",
        	data: {search: s},
        	success: function(data) {
        		console.log("success");
        		console.log(data);
        		
        		$(".ientry").remove();
        		
        		if (key == 1) {
        			if (data.length != 0) {
		    			$('input.isearchbar').val(data[0].title);
		    			$("#itemimage1").remove();
		    			$("#itemtext1").remove();
		    			
		    			var results = $(".itemresults1");
		    			
		    			var picture = $("<div id=\"itemimage1\"/>");
						var img = $("<img src=\"\" alt = \"item image\"/>");
						picture.append(img);
					
						var text = $("<div id=\"itemtext1\"/>");
						text.append($("<h5/>").text(data[0].title));
						text.append($("<h6/>").text("ISBN: " + data[0].isbn));
					
						results.append(picture);
						results.append(text);
						
						borrowitem = data[0].id;
					}
					else {
						borrowitem = 0;
						alert("This item does not exist.");
					}
        		}
        		else {
		    		var results = $("#ritems");
		    		for (var k in data) {
		    			var wrapper = $("<option class=\"ientry\" value=\"" + data[k].title + "\"/>");
		    			results.append(wrapper);
		    		}
        		}
        		
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function getReturn(s, key){
	$.ajax({
        	type: "GET",
        	contentType: "application/json",
        	url: "/api/return",
        	data: {search: s},
        	success: function(data) {
        		console.log("success");
        		console.log(data);
        		
        		if (data.item.title != "" && data.user.username != "") {
		    		$('input.searchbar').val(data.item.title);
		    		$("#itemimage2").remove();
		    		$("#itemtext2").remove();
					$("#userimage2").remove();
		    		$("#usertext2").remove();
		    		
		    		var iresults = $(".itemresults2");
		    			
					var ipicture = $("<div id=\"itemimage2\"/>");
					var iimg = $("<img src=\"\" alt = \"item image\"/>");
					ipicture.append(iimg);
				
					var itext = $("<div id=\"itemtext2\"/>");
					itext.append($("<h5/>").text(data.item.title));
					itext.append($("<h6/>").text("ISBN: " + data.item.isbn));
				
					iresults.append(ipicture);
					iresults.append(itext);
					
        			var results = $(".userresults2");
        			
        			var picture = $("<div id=\"userimage2\"/>");
					var img = $("<img src=\"\" alt = \"user image\"/>");
					picture.append(img);
					
					var text = $("<div id=\"usertext2\"/>");
					text.append($("<h5/>").text(data.user.username));
					text.append($("<h6/>").text("NAME: " + data.user.name));
					text.append($("<h6/>").text("USER ID: " + data.user.id));
					
					results.append(picture);
					results.append(text);
					
					returnuser = data.user.id;
					returnitem = data.item.id;
					
        		}
        		else {
        			$('input.searchbar').val("");
		    		$("#itemimage2").remove();
		    		$("#itemtext2").remove();
					$("#userimage2").remove();
		    		$("#usertext2").remove();
		    		returnuser = 0;
					returnitem = 0;
        			alert("This item is not borrowed or does not exist.");
        		}
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function getReturnItem(s){
	$.ajax({
        	type: "GET",
        	contentType: "application/json",
        	url: "/api/return_item",
        	data: {search: s},
        	success: function(data) {
        		console.log("success");
        		console.log(data);
        		
        		$(".entry").remove();
        		
	    		var results = $("#items");
	    		for (var k in data) {
	    			var wrapper = $("<option class=\"entry\" value=\"" + data[k].title + "\"/>");
	    			results.append(wrapper);
	    		}
        		
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function postBorrow(u, i){
	$.ajax({
        	type: "POST",
        	contentType: "application/json",
        	url: "/api/borrow",
        	data: JSON.stringify({user: u, item: i}),
        	success: function(data) {
        		console.log("success");
        		console.log(data);
        		
        		alert("Item has been borrowed.");
        		
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function postReturn(u,i) {
	$.ajax({
        	type: "POST",
        	contentType: "application/json",
        	url: "/api/return",
        	data: JSON.stringify({user: u, item: i}),
        	success: function(data) {
        		console.log("success");
        		console.log(data);
        		alert("Item has been returned.");
        		
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

$(document).ready(function(){
	$('.usearchbar').keydown(function(e) {
		console.log(e.keyCode);
		if (e.keyCode == 13) {
			usear = this.value;
			getSearchUser(usear, 1);
		}
	});
	
	$('.isearchbar').keydown(function(e) {
		if (e.keyCode == 13) {
			isear = this.value;
			getSearchItem(isear, 1);
		}
	});
	
	$('.searchbar').keydown(function(e) {
		if (e.keyCode == 13) {
			sear = this.value;
			getReturn(sear, 1);
		}
	});

	$('.usearchbar').on('input', function() {
		usear = this.value;
		getSearchUser(usear, 0);
	});
    getSearchUser(usear, 0);
    
    $('.isearchbar').on('input', function() {
		isear = this.value;
		getSearchItem(isear, 0);
	});
    getSearchItem(isear, 0);
    
    $('.searchbar').on('input', function() {
		sear = this.value;
		getReturnItem(sear);
	});
	getReturnItem(sear);
	
	$(document).on("click", "#borrowbtn", function() {
		if (borrowitem != 0 && borrowuser != 0)
			postBorrow(borrowuser, borrowitem);
		else
			alert("User or item has not been chosen.");
	});
	
	$(document).on("click", "#returnbtn", function() {
		if (returnitem != 0 && returnuser != 0)
			postReturn(returnuser, returnitem);
		else
			alert("User or item has not been chosen.");
	});
});
