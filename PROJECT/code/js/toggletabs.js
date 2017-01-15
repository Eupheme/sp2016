window.addEventListener("load", function () {
    var i, alltabs, batch, sibs;
    alltabs = document.querySelectorAll('.tablinks');

    for (i = 0; i < alltabs.length; i++) {        
        //activate first button in batch
        batch = getButtons(alltabs[i].parentNode, alltabs[i].className);
        batch[0].className += " active";        

        //display first tab in batch
        sibs = getSiblings(batch[0].parentNode.parentNode, 'tabcontent');
        sibs[0].style.display = "block";
        i += batch.length - 1;
    }
});

function getSiblings(el, filter) {
    var siblings = [];
    while (el = el.nextSibling) {
        if (el.className === filter) {
            siblings.push(el);
        }
    }
    return siblings;
}

function getButtons(el, filter) {
    el = el.parentNode.firstChild;
    var buttons = [];
    do {
        if (el.className !== undefined) {
            string = el.children[0].className;
            if (string.match(filter)) {
                buttons.push(el.children[0]);
            }
        }
    }
    while (el = el.nextSibling);
    return buttons;
}

function openTab(evt) {
    var i, tabs, buttons;
    tabs = getSiblings(evt.currentTarget.parentNode.parentNode, 'tabcontent')
    buttons = getButtons(evt.currentTarget.parentNode, 'tablinks')
    for (i = 0; i < tabs.length; i++) {
        tabs[i].style.display = "none";
        buttons[i].className = buttons[i].className.replace(" active", "");
        if (buttons[i] == evt.currentTarget){
            tabs[i].style.display = "block";
            evt.currentTarget.className += " active";
        }
    }
    
    //no row is selected
    var trs = document.querySelectorAll("tr");
    for(var i = 0; i < trs.length; i++){
        trs[i].className = "";   
    }
}
