var order = 0;
var by = 0;

function getMyItems(o, b){
	$.ajax({
        	type: "GET",
        	contentType: "application/json",
        	url: "/api/my_items",
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
		else if (this.value == "return") {
			by = 3;
		}
		getMyItems(order, by);
	});
	
	$('input[type=radio][name=ascdesc]').change(function() {
		if (this.value == "ascending") {
			order = 0;
		}
		else if (this.value == "descending") {
			order = 1;
		}
		getMyItems(order, by);
	});
	
	getMyItems(order, by);
});
