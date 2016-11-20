window.addEventListener("load", function() {
    document.getElementById('tab1').style.display = "block";
    document.getElementById('selectmenu1').disabled = true;
    document.getElementById('selectmenu2').disabled = true;
    document.getElementById('selectmenu3').disabled = true;
    document.getElementById('selectmenu4').disabled = true;
});

function openTab(evt, tabNum) {
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }
    document.getElementById(tabNum).style.display = "block";
    evt.currentTarget.className += " active";
}

function showMenu(value) {
    if (value == "1") {
        document.getElementById('selectmenu1').disabled = false;
        document.getElementById('selectmenu2').disabled = false;
    }
    else if (value == "0"){ document.getElementById('selectmenu1').disabled = true;
        document.getElementById('selectmenu2').disabled = true;
    }
    
    if (value == "3") {
        document.getElementById('selectmenu3').disabled = false;
        document.getElementById('selectmenu4').disabled = false;
    }
    else if (value == "2"){ document.getElementById('selectmenu3').disabled = true;
        document.getElementById('selectmenu4').disabled = true;
    }
}