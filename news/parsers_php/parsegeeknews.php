#!/usr/bin/php
<?
include('debut.php');

// listes des news traitées pareillement
$LISTSOURCE[1]['source']='PC INpact';
$LISTSOURCE[1]['subsource']='';
$LISTSOURCE[1]['cat']=MULTIMEDIA;
$LISTSOURCE[1]['URL']='http://www.pcinpact.com/include/news.xml';

$LISTSOURCE[2]['source']='Clubic';
$LISTSOURCE[2]['subsource']='';
$LISTSOURCE[2]['cat']=MULTIMEDIA;
$LISTSOURCE[2]['URL']='http://www.clubic.com/c/xml.php?type=news';

$LISTSOURCE[3]['source']='Presence PC';
$LISTSOURCE[3]['subsource']='';
$LISTSOURCE[3]['cat']=MULTIMEDIA;
$LISTSOURCE[3]['URL']='http://www.presence-pc.com/ppcrss.xml';

/*
$LISTSOURCE[4]['source']='LinuxFR';
$LISTSOURCE[4]['subsource']='';
$LISTSOURCE[4]['cat']=MULTIMEDIA;
//$LISTSOURCE[4]['URL']='http://linuxfr.org/backend/news/rss20.rss';
$LISTSOURCE[4]['URL']='http://linuxfr.org/news.atom';
$LISTSOURCE[4]['TYPE']='atom';
*/

$LISTSOURCE[5]['source']='ZDNet';
$LISTSOURCE[5]['subsource']='';
$LISTSOURCE[5]['cat']=MULTIMEDIA;
$LISTSOURCE[5]['URL']='http://www.zdnet.fr/feeds/rss/actualites/';

/*
$LISTSOURCE[]['source']='';
$LISTSOURCE[]['subsource']='';
$LISTSOURCE[]['cat']=MULTIMEDIA;
$LISTSOURCE[]['URL']='';
*/

include('fin.php');


