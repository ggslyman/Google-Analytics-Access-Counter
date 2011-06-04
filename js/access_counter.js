var dispflag;
$(document).ready(function () {
	$.ajax({
		type: "GET",
		url: "http://www.hogehoge.com/ga.php",
		dataType: "xml",
		error: function(XMLHttpRequest, textStatus, errorThrown){
		},
		success: function (data, status, xhr) {
			xmlParser(data);
		}
	});
});
function xmlParser(xml) {
	var html_blocks = '<div id="counter-box">'
	$('#load').fadeOut();
	$('#load').css("display:none");
	$(xml).find("total_pvs").each(function () {
		var total_pvs = $(this).text()
		html_blocks = html_blocks + '<div id="pvs"><a><span id="access-counter-header">Total Access:</span><span id="access-count">'+total_pvs+'</span></a></div><div id="counter"><div id="counter-close"><a>×</a></div>'
	});
	$(xml).find("access").each(function () {
		var dispDate = $(this).find("access_date").text().replace(/([0-9]{4})([0-9]{2})([0-9]{2})/g,'$1\/$2\/$3')
		var CurrentYear =  $(this).find("access_date").text().replace(/([0-9]{4})([0-9]{2})([0-9]{2})/g,'$1')
		var CurrentMonth =  $(this).find("access_date").text().replace(/([0-9]{4})([0-9]{2})([0-9]{2})/g,'$2')
		var CurrentDay = $(this).find("access_date").text().replace(/([0-9]{4})([0-9]{2})([0-9]{2})/g,'$3')
		var weekname = mySet(CurrentYear,CurrentMonth,CurrentDay)
		html_blocks = html_blocks +'<div class="access_date">' + dispDate + '(' + weekname + ')' + '</div>'
		html_blocks = html_blocks +'<div class="pageviews">ページビュー :' + $(this).find("pageviews").text() + '</div>'
		html_blocks = html_blocks +'<div class="visits">訪問者数: ' + $(this).find("visits").text() + '</div>'
	});
	html_blocks = html_blocks + '</div>'
	$("div#access-counter").append(html_blocks);
}
$('div#pvs a').live("click", function(){
	$('div#counter').css("display","block");
});
$('div#counter-close a').live("click", function(){
	$('div#counter').css("display","none");
});
this.trim = function(str, del)
{
	return str.replace( new RegExp(!del ? "^[ 　]+|[ 　]+$"
: "^" + del + "+|" + del + "+$", "g"), "");
}
function mySet($year,$month,$day){
   myWeekTbl = new Array( "日","月","火","水","木","金","土" );
   myDate = new Date( $year ,
                      $month - 1 ,
                      $day );
   myWeek = myDate.getDay();
   return myWeekTbl[myWeek];
}
