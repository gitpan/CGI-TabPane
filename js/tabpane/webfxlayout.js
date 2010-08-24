/* Do includes */

if (window.pathToRoot == null)
	pathToRoot = "./";

document.write('<link type="text/css" rel="stylesheet" href="/css/tabpane/webfxlayout.css">');

/* end includes */

/* set up browser checks and add a simple emulation for IE4 */

// check browsers
var op = /opera 5|opera\/5/i.test(navigator.userAgent);
var ie = !op && /msie/i.test(navigator.userAgent);	// preventing opera to be identified as ie
var mz = !op && /mozilla\/5/i.test(navigator.userAgent);	// preventing opera to be identified as mz

if (ie && document.getElementById == null) {	// ie4
	document.getElementById = function(sId) {
		return document.all[sId];
	};
}

/* end browser checks */
