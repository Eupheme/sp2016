var order = 0;
var by = 0;

function getMyProfile() {
	$.ajax({
        	type: "GET",
        	contentType: "application/json",
        	url: "/api/profile",
        	success: function(data) {        		
        		
        		var results = $("#picture");
        		var imgpath = data.picture;
        		if (data.picture == "")
        			imgpath = "user_default";
        		var img = $("<img src=\"/backend/files/" + imgpath + ".jpg\" alt = \"book image\"/>");
        		results.append(img);
        		
        		var results = $("#text");
        		results.append($("<h5/>").text(data.username));
        		results.append($("<h6/>").text(data.first_name + " " + data.last_name));
        		
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function getTransactionHistory(o, b){
	$.ajax({
        	type: "GET",
        	contentType: "application/json",
        	url: "/api/transaction_history",
        	data: {order: o, by: b},
        	success: function(data) {
        		$("tr.entry").remove();
        		
        		var table = $("tbody.tableBody");
        		for (var k in data) {
        			var tr = $("<tr class=\"entry\" onmousedown=\"chooseElement(event)\"/>");
        			tr.append($("<td/>").text(data[k].title));
        			tr.append($("<td/>").text(data[k].author));
        			tr.append($("<td/>").text(data[k].borrowed_date));
        			tr.append($("<td/>").text(data[k].returned_date));
        			table.append(tr);
        		}
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

$(document).ready(function(){
	$('input[type=radio][name=orderby]').change(function() {
		if (this.value == "title") {
			by = 0;
		}
		else if (this.value == "author") {
			by = 1;
		}
		else if (this.value == "borrowed") {
			by = 2;
		}
		else if (this.value == "returned") {
			by = 3;
		}
		getTransactionHistory(order, by);
	});
	
	$('input[type=radio][name=ascdesc]').change(function() {
		if (this.value == "ascending") {
			order = 0;
		}
		else if (this.value == "descending") {
			order = 1;
		}
		getTransactionHistory(order, by);
	});
	
	getMyProfile();
	getTransactionHistory(order, by);
});
