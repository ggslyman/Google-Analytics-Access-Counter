<?php
require_once('gapi.class.php');
require_once('ga.conf');
set_time_limit(0);
// PV�𒲂ׂ����y�[�W�̃p�X

// gapi�N���X�̃C���X�^���X���쐬
// ��1����: Google Analytics�̃��O�C�����[���A�h���X
// ��2����: Google Analytics�̃p�X���[�h
$ga = new gapi(GOOGLE_ANALYTICS_MAIL, GOOGLE_ANALYTICS_PASS);
$date_today = mktime (0, 0, 0, date("m"), date("d"),  date("y"));
$date_yesterday = $date_today - (86400*3);
// ���|�[�g�f�[�^�̎擾
$ga->requestReportData(
    GOOGLE_ANALYTICS_BLOG_ID,      // ���|�[�gID�BAnalytics�Ń��|�[�g��\�������ۂ�URL��id�Ŏw�肳��Ă���l
    array('date'),                 // �f�B�����V����
    array('pageviews','visits'),   // ���v���
    '-date',                          // �\�[�g�L�[
    null,                          // �t�B���^
    date('Y-m-d', $date_yesterday),// ���|�[�g�J�n��
    date('Y-m-d')                  // ���|�[�g�I����
);
// ���ʂ̎擾
$results = $ga->getResults();

// ���|�[�g�f�[�^�̎擾
$ga->requestReportData(
    GOOGLE_ANALYTICS_BLOG_ID,      // ���|�[�gID�BAnalytics�Ń��|�[�g��\�������ۂ�URL��id�Ŏw�肳��Ă���l
    array('visitorType'),                          // �f�B�����V����
    array('pageviews'),   // ���v���
    null,                          // �\�[�g�L�[
    null,                          // �t�B���^
    '2008-01-01',                  // ���|�[�g�J�n��
    date('Y-m-d')                  // ���|�[�g�I����
);
//// ���ʂ̎擾
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