#!/usr/bin/php
<?
include('debut.php');

// listes des news traitées pareillement
#$LISTSOURCE[0]['source']='Yahoo';
#$LISTSOURCE[0]['subsource']='Une';
#$LISTSOURCE[0]['cat']=UNE;
#$LISTSOURCE[0]['URL']='http://fr.news.yahoo.com/rss/a-la-une.xml';

$LISTSOURCE[1]['source']='Yahoo';
$LISTSOURCE[1]['subsource']='Monde';
$LISTSOURCE[1]['cat']=MONDE;
#$LISTSOURCE[1]['URL']='http://fr.news.yahoo.com/rss/monde.xml';
$LISTSOURCE[1]['URL']='https://fr.news.yahoo.com/rss/world';

$LISTSOURCE[2]['source']='Yahoo';
$LISTSOURCE[2]['subsource']='France';
$LISTSOURCE[2]['cat']=FRANCE;
#$LISTSOURCE[2]['URL']='http://fr.news.yahoo.com/rss/france.xml';
$LISTSOURCE[2]['URL']='https://fr.news.yahoo.com/rss/france';

/*
$LISTSOURCE[]['source']='Yahoo';
$LISTSOURCE[]['subsource']='';
$LISTSOURCE[]['cat']=;
$LISTSOURCE[]['URL']='';
*/

include('fin.php');

