<?php
require_once('gapi.class.php');
require_once('ga.conf');
set_time_limit(0);
// PVを調べたいページのパス

// gapiクラスのインスタンスを作成
// 第1引数: Google Analyticsのログインメールアドレス
// 第2引数: Google Analyticsのパスワード
$ga = new gapi(GOOGLE_ANALYTICS_MAIL, GOOGLE_ANALYTICS_PASS);
$date_today = mktime (0, 0, 0, date("m"), date("d"),  date("y"));
$date_yesterday = $date_today - (86400*3);
// レポートデータの取得
$ga->requestReportData(
    GOOGLE_ANALYTICS_BLOG_ID,      // レポートID。Analyticsでレポートを表示した際にURLのidで指定されている値
    array('date'),                 // ディメンション
    array('pageviews','visits'),   // 統計情報
    '-date',                          // ソートキー
    null,                          // フィルタ
    date('Y-m-d', $date_yesterday),// レポート開始日
    date('Y-m-d')                  // レポート終了日
);
// 結果の取得
$results = $ga->getResults();

// レポートデータの取得
$ga->requestReportData(
    GOOGLE_ANALYTICS_BLOG_ID,      // レポートID。Analyticsでレポートを表示した際にURLのidで指定されている値
    array('visitorType'),                          // ディメンション
    array('pageviews'),   // 統計情報
    null,                          // ソートキー
    null,                          // フィルタ
    '2008-01-01',                  // レポート開始日
    date('Y-m-d')                  // レポート終了日
);
//// 結果の取得
$result_totals = $ga->getResults();
$total_pvs_count = 0;
foreach($result_totals as $result_total){
	$metrics = $result_total->getMetrics();
	$total_pvs_count += $metrics['pageviews'];
}
//Creates XML string and XML document using the DOM 
$dom = new DomDocument('1.0', 'iso-8859-1'); 
//add root - <accesses> 
$accesses = $dom->appendChild($dom->createElement('accesses')); 
$total_pvs = $accesses->appendChild($dom->createElement('total_pvs')); 
$total_pvs->appendChild($dom->createTextNode($total_pvs_count)); 

//add <title> text node element to <title> 
foreach($results as $result){
	//add <access> element to <accesses> 
	$access = $accesses->appendChild($dom->createElement('access')); 
	//add <access_date> element to <access> 
	$access_date = $access->appendChild($dom->createElement('access_date')); 
	//add <pageviews> element to <access> 
	$pageviews = $access->appendChild($dom->createElement('pageviews')); 
	$visits = $access->appendChild($dom->createElement('visits')); 
	$metrics = $result->getMetrics();
	$dimiensions = $result->getDimesions();
	$pageviews->appendChild($dom->createTextNode($metrics['pageviews'])); 
	$visits->appendChild($dom->createTextNode($metrics['visits'])); 
	$access_date->appendChild($dom->createTextNode($dimiensions['date'])); 
}
//generate xml 
$dom->formatOutput = true; // set the formatOutput attribute of 
                        // domDocument to true 
// save XML as string or file 
$test1 = $dom->saveXML(); // put string in test1 
echo $test1;
?>