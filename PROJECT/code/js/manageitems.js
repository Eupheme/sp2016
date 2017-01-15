var order1 = 0;
var by1 = 0;
var order2 = 0;
var by2 = 0;
var sear = "";
var req = 0;

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

function postAddItem(title, author, isbn, date, subject, desc){
	$.ajax({
        	type: "POST",
        	contentType: "application/json",
        	url: "/api/add_item",
        	data: JSON.stringify({title: title, author:author, date:date, isbn:isbn, subject:subject, description:desc}),
        	success: function(data) {
        		console.log("success");
        		console.log(data);
        		
        		alert("Item was successfully added.");
        		window.location.replace("manageitems.html");
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function getSubjects() {
	$.ajax({
        	type: "GET",
        	contentType: "application/json",
        	url: "/api/subjects",
        	success: function(data) {
        		console.log("success");
        		console.log(data);
        		
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

function getSearchItems(s, o, b){
	$.ajax({
        	type: "GET",
        	contentType: "application/json",
        	url: "/api/search_items",
        	data: {search: s, order: o, by: b},
        	success: function(data) {
        		console.log("success");
        		console.log(data);
        		
        		$("tr.entrysearch").remove();
        		
        		var table = $("tbody.tableBody1");
        		for (var k in data) {
        			var tr = $("<tr class=\"entrysearch\" onmousedown=\"chooseElement(event)\"/>");
        			tr.append($("<input type=\"hidden\"/>").val(data[k].item_id));
        			tr.append($("<td/>").text(data[k].title));
        			tr.append($("<td/>").text(data[k].author));
        			tr.append($("<td/>").text(data[k].isbn));
        			tr.append($("<td/>").text(data[k].published_date));
        			        			
        			if (data[k].status == 0) {
        				tr.append($("<td/>").text("available"));
        			}
        			else if (data[k].status == 1) {
        				tr.append($("<td/>").text("borrowed"));
        			}
        			
        			table.append(tr);
        		}
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function getRequestedItems(o, b){
	$.ajax({
        	type: "GET",
        	contentType: "application/json",
        	url: "/api/requested_items",
        	data: {order: o, by: b},
        	success: function(data) {
        		console.log("success");
        		console.log(data);
        		
        		$("tr.entry").remove();
        		
        		var table = $("tbody.tableBody2");
        		for (var k in data) {
        			var tr = $("<tr class=\"entry\" onmousedown=\"chooseElement(event)\"/>");
        			tr.append($("<input type=\"hidden\"/>").val(data[k].request_id));
        			tr.append($("<td/>").text(data[k].username));
        			tr.append($("<td/>").text(data[k].title));
        			tr.append($("<td/>").text(data[k].author));
        			tr.append($("<td/>").text(data[k].subject));
        			tr.append($("<td/>").text(data[k].requested_date));
        			table.append(tr);
        		}
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

function postDeleteItem(i) {
	var ii = parseInt(i);
	$.ajax({
        	type: "POST",
        	contentType: "application/json",
        	url: "/api/delete_item",
        	data: JSON.stringify({itm: ii}),
        	success: function(data) {
        		console.log("success");
        		console.log(data);
        		
        		alert("Item was successfully deleted.");
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
        		console.log("success");
        		console.log(data);
        		
        		alert("Request was successfully deleted.");
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

$(document).ready(function(){
	$('.searchbar').keyup(function() {
		sear = this.value;
		getSearchItems(sear, order1, by1);
	});

	$('input[type=radio][name=orderby1]').change(function() {
		if (this.value == "title") {
			by1 = 0;
		}
		else if (this.value == "author") {
			by1 = 1;
		}
		else if (this.value == "date") {
			by1 = 8;
		}
		else if (this.value == "status") {
			by1 = 9;
		}
		getSearchItems(sear, order1, by1);
	});
	
	$('input[type=radio][name=ascdesc1]').change(function() {
		if (this.value == "ascending") {
			order1 = 0;
		}
		else if (this.value == "descending") {
			order1 = 1;
		}
		getSearchItems(sear, order1, by1);
	});
	
	getSearchItems(sear, order1, by1);
	
	$('input[type=radio][name=orderby2]').change(function() {
		if (this.value == "title") {
			by2 = 0;
		}
		else if (this.value == "author") {
			by2 = 1;
		}
		else if (this.value == "borrowed") {
			by2 = 2;
		}
		else if (this.value == "return") {
			by2 = 3;
		}
		getRequestedItems(order2, by2);
	});
	
	$('input[type=radio][name=ascdesc2]').change(function() {
		if (this.value == "ascending") {
			order2 = 0;
		}
		else if (this.value == "descending") {
			order2 = 1;
		}
		getRequestedItems(order2, by2);
	});
	
	getRequestedItems(order2, by2);
	
	$('#returnbtn').click(function() {
		if (returnitem != 0 && returnuser != 0)
			postReturn(returnuser, returnitem);
		else
			alert("User or item has not been chosen.");
	});
	
	$('input[type=radio][name=request]').change(function() {
		if (this.value == "accept") {
			req = 0;
		}
		else if (this.value == "deny") {
			req = 1;
		}
	});
	
	$('#submitbtn').click(function() {
		var x = $('.selected');
		if (x.length != 0){
			var id = x.find("input")[0].value;
			if (req == 0) {
				window.location.replace("edit.html?req=" + id);
			}
			else if (req == 1) {
				postDeleteRequest(id);
			}
		}
		else {
			alert("No row was chosen.");
		}
	});
	
	$('#editbtn').click(function() {
		var x = $('.selected');
		if (x.length != 0){
			var id = x.find("input")[0].value;
			window.location.replace("edit.html?itm=" + id);
		}
		else {
			alert("No row was chosen.");
		}
	});
	
	$('#deletebtn').click(function() {
		var x = $('.selected');
		if (x.length != 0){
			var id = x.find("input")[0].value;
			postDeleteItem(id);
		}
		else {
			alert("No row was chosen.");
		}
	});
	
	getSubjects();
	
	$('#addbtn').click(function() {
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
		
			postAddItem(title, author, isbn, date, subject, desc);
		}
	});
});
