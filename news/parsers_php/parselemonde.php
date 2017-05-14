#!/usr/bin/php
<?
include('debut.php');

// listes des news traitées pareillement


$LISTSOURCE[0]['source']='Le Monde';
$LISTSOURCE[0]['subsource']='Une';
$LISTSOURCE[0]['cat']=UNE;
$LISTSOURCE[0]['URL']='http://www.lemonde.fr/rss/sequence/0,2-3208,1-0,0.xml';

$LISTSOURCE[1]['source']='Le Monde';
$LISTSOURCE[1]['subsource']='International';
$LISTSOURCE[1]['cat']=MONDE;
$LISTSOURCE[1]['URL']='http://www.lemonde.fr/rss/sequence/0,2-3210,1-0,0.xml';

$LISTSOURCE[2]['source']='Le Monde';
$LISTSOURCE[2]['subsource']='Europe';
$LISTSOURCE[2]['cat']=MONDE;
$LISTSOURCE[2]['URL']='http://www.lemonde.fr/rss/sequence/0,2-3214,1-0,0.xml';

$LISTSOURCE[3]['source']='Le Monde';
$LISTSOURCE[3]['subsource']='France';
$LISTSOURCE[3]['cat']=FRANCE;
$LISTSOURCE[3]['URL']='http://www.lemonde.fr/rss/sequence/0,2-3224,1-0,0.xml';

$LISTSOURCE[4]['source']='Le Monde';
$LISTSOURCE[4]['subsource']='Société';
$LISTSOURCE[4]['cat']=FRANCE;
$LISTSOURCE[4]['URL']='http://www.lemonde.fr/rss/sequence/0,2-3226,1-0,0.xml';
/*
$LISTSOURCE[5]['source']='Le Monde';
$LISTSOURCE[5]['subsource']='Régions';
$LISTSOURCE[5]['cat']=FRANCE;
$LISTSOURCE[5]['URL']='http://www.lemonde.fr/rss/sequence/0,2-3228,1-0,0.xml';
*/
$LISTSOURCE[6]['source']='Le Monde';
$LISTSOURCE[6]['subsource']='Entreprise';
$LISTSOURCE[6]['cat']=ECONOMIE;
$LISTSOURCE[6]['URL']='http://www.lemonde.fr/rss/sequence/0,2-3234,1-0,0.xml';

$LISTSOURCE[7]['source']='Le Monde';
$LISTSOURCE[7]['subsource']='Médias';
$LISTSOURCE[7]['cat']=MEDIA;
$LISTSOURCE[7]['URL']='http://www.lemonde.fr/rss/sequence/0,2-3236,1-0,0.xml';
/*
$LISTSOURCE[8]['source']='Le Monde';
$LISTSOURCE[8]['subsource']='Aujourd\'hui';
$LISTSOURCE[8]['cat']=CULTURE;
$LISTSOURCE[8]['URL']='http://www.lemonde.fr/rss/sequence/0,2-3238,1-0,0.xml';

$LISTSOURCE[9]['source']='Le Monde';
$LISTSOURCE[9]['subsource']='Sports';
$LISTSOURCE[9]['cat']=SPORT;
$LISTSOURCE[9]['URL']='http://www.lemonde.fr/rss/sequence/0,2-3242,1-0,0.xml';
*/
$LISTSOURCE[10]['source']='Le Monde';
$LISTSOURCE[10]['subsource']='Sciences';
$LISTSOURCE[10]['cat']=SCIENCE;
$LISTSOURCE[10]['URL']='http://www.lemonde.fr/rss/sequence/0,2-3244,1-0,0.xml';
/*
$LISTSOURCE[11]['source']='Le Monde';
$LISTSOURCE[11]['subsource']='Culture';
$LISTSOURCE[11]['cat']=CULTURE;
$LISTSOURCE[11]['URL']='http://www.lemonde.fr/rss/sequence/0,2-3246,1-0,0.xml';
*/


include('fin.php');

