var sear = "";

function getSearchItems(s){
	$.ajax({
        	type: "GET",
        	contentType: "application/json",
        	url: "/api/search_items",
        	data: {search: s},
        	success: function(data) {
        		console.log(data);
        		$(".entry").remove();
        		
        		var results = $(".searchresults");
        		for (var k in data) {
        			var wrapper = $("<div id=\"bookwrapper\" class=\"entry\"/>");
        			var picture = $("<div id=\"picture\"/>");
        			var imgpath = data[k].picture;
        			if (imgpath == "")
        				imgpath = "item_default";
        			var img = $("<img src=\"/backend/files/" + imgpath + ".jpg\" alt = \"book image\"/>");
        			picture.append(img);
        			
        			var about = $("<div id=\"about\"/>");
        			about.append($("<h3/>").text(data[k].title));
        			about.append($("<h4/>").text(data[k].author));
        			about.append($("<h5/>").text(data[k].published_date + "; " + data[k].subject + "; " + data[k].isbn));
        			about.append($("<p/>").text(data[k].description));
        			
        			wrapper.append(picture);
        			wrapper.append(about);
        			
        			results.append(wrapper);
        		}
        		
        	},
        	error: function() {
        		console.log("fail");
        	}
        });
}

$(document).ready(function(){
	$('.searchbar').keydown(function(e) {
		if (e.keyCode == 13) {
			sear = this.value;
			getSearchItems(sear);
		}
	});
});
