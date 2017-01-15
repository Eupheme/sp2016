window.addEventListener("load", function () {
    //all menus on page automatically disabled
    var menus, i;
    menus = document.querySelectorAll(".dropdown");

    for(i = 0; i < menus.length; i++) {
        menus[i].disabled = true;
    }
});

function showMenu(value) {
    if (value === 1) {
        document.getElementById('selectmenu1').disabled = false;
        document.getElementById('selectmenu2').disabled = false;
    }
    else if (value === 0){          
        document.getElementById('selectmenu1').disabled = true;
        document.getElementById('selectmenu2').disabled = true;
    }

    if (value === 3) {
        document.getElementById('selectmenu3').disabled = false;
        document.getElementById('selectmenu4').disabled = false;
    }
    else if (value === 2){ 
        document.getElementById('selectmenu3').disabled = true;
        document.getElementById('selectmenu4').disabled = true;
    }
}

function chooseElement(evt) {
    var elclass, ctrlkey;
    elclass = evt.currentTarget.className;

    var trs = document.querySelectorAll("tr");
    for(var i = 0; i < trs.length; i++){
        trs[i].className = "";   
    }

    if (elclass === "selected") {
        evt.currentTarget.className = "";
    }
    else {
        evt.currentTarget.className = "selected";
    }
}

function getPage(evt) {
    var pages, tab;
    pages = document.querySelectorAll(".pagination");
    tab = evt.currentTarget.parentNode.className;
    for(var i = 0; i < pages.length; i++){
        if (pages[i].parentNode.className == tab) {
            pages[i].className = pages[i].className.replace(" active", "");
        }
    }
    evt.currentTarget.className += " active";
}
