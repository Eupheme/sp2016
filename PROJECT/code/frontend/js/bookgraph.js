window.addEventListener("load", function () {
    var graphs;
    graphs = document.querySelectorAll(".graph");
    plotgraph(graphs[0].id);
    plotgraph(graphs[1].id);
});

var canvas, cnt, max, min, xScale, yScale, sections, y, itemName, itemVal;

itemName = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
itemVal = [15, 4, 3, 6, 11, 23, 4, 3, 10, 1, 2, 9]; //number of books/items

function plotgraph(canvasid) {
    var step, columnSize, rowSize, margin, width, height, c;

    sections = itemVal.length;    
    max = Math.max.apply(null, itemVal); //max number of books
    if (max%2 !== 0) {
        max +=1;
    }
    step = parseInt(max/20) + 1;

    columnSize = 30;
    rowSize = 30;
    margin = 10;

    canvas = document.getElementById(canvasid);
    cnt = canvas.getContext("2d");
    canvas.width = 800;
    canvas.height = 250;
    width = canvas.width;
    height = canvas.height;
    
    xScale = (width - rowSize) / (sections + 0.5);
    yScale = (height - columnSize - margin) / (max);

    cnt.fillStyle = "#990000"; //all
    cnt.strokeStyle="#cccccc"; // background lines
    cnt.font = '15px Calibri';
    cnt.beginPath();

    //draw background lines
    c = 0;
    for (s = max; s >= 0; s -= step) {
        y = (yScale * step * c) + columnSize;
        cnt.fillText(s, margin, y);
        cnt.moveTo(rowSize, y);
        cnt.lineTo(width - margin, y);
        c++;
    }
    cnt.stroke();

    // show month names
    for (i = 0; i < sections; i++) {
        y = height + margin;
        cnt.fillText(itemName[i], xScale * (i+1), y - margin);
    }

    cnt.fillStyle="#809fff"; // posebi za stolpce
    cnt.shadowColor = 'rgba(128,128,128, 0.3)'; //shadow
    cnt.shadowOffsetX = 4;
    cnt.shadowOffsetY = 1;
    cnt.translate(0,canvas.height - margin);
    cnt.scale(xScale,-1 * yScale);

    for(i = 0; i < sections; i++) {
        cnt.fillRect(i+1, 0, 0.5, itemVal[i]);
    }

}