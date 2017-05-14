#!/usr/bin/php
<?
include('debut.php');

// listes des news traitées pareillement

$LISTSOURCE[1]['source']='Yahoo';
$LISTSOURCE[1]['subsource']='Technologies';
$LISTSOURCE[1]['cat']=MULTIMEDIA;
#$LISTSOURCE[1]['URL']='http://fr.news.yahoo.com/rss/technologies.xml';
$LISTSOURCE[1]['URL']='https://fr.news.yahoo.com/rss/technologies';
/*
$LISTSOURCE[2]['source']='Yahoo';
$LISTSOURCE[2]['subsource']='Economie';
$LISTSOURCE[2]['cat']=ECONOMIE;
$LISTSOURCE[2]['URL']='http://fr.news.yahoo.com/rss/economie.xml';
*/
$LISTSOURCE[3]['source']='Yahoo';
$LISTSOURCE[3]['subsource']='Science';
$LISTSOURCE[3]['cat']=SCIENCE;
#$LISTSOURCE[3]['URL']='http://fr.news.yahoo.com/rss/sciences.xml';
$LISTSOURCE[3]['URL']='https://fr.news.yahoo.com/rss/sciences';
/*
$LISTSOURCE[4]['source']='Yahoo';
$LISTSOURCE[4]['subsource']='Culture';
$LISTSOURCE[4]['cat']=CULTURE;
$LISTSOURCE[4]['URL']='http://fr.news.yahoo.com/rss/culture.xml';
*/
#$LISTSOURCE[5]['source']='Yahoo';
#$LISTSOURCE[5]['subsource']='Insolite';
#$LISTSOURCE[5]['cat']=INSOLITE;
#$LISTSOURCE[5]['URL']='http://fr.news.yahoo.com/rss/insolite.xml';

$LISTSOURCE[6]['source']='Yahoo';
$LISTSOURCE[6]['subsource']='Santé';
$LISTSOURCE[6]['cat']=SANTE;
#$LISTSOURCE[6]['URL']='http://fr.news.yahoo.com/rss/sante.xml';
$LISTSOURCE[6]['URL']='https://fr.news.yahoo.com/rss/sante';

/*
$LISTSOURCE[]['source']='Yahoo';
$LISTSOURCE[]['subsource']='';
$LISTSOURCE[]['cat']=;
$LISTSOURCE[]['URL']='';
*/


include('fin.php');

