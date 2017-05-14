#!/usr/bin/php
<?
include('includes/dbnews-2.php');
include('includes/lastRSS.php');
require_once('includes/newscat.php');

// table dans laquelle les news sont insérées
$newstable='newsv2';
$uniquetable='uniquenewsv2';

// listes des news traitées pareillement
$LISTSOURCE[0]['source']='Liberation';
$LISTSOURCE[0]['subsource']='Une';
$LISTSOURCE[0]['cat']=UNE;
$LISTSOURCE[0]['URL']='http://www.liberation.fr/interactif/rss/actualites/';

$LISTSOURCE[1]['source']='Liberation';
$LISTSOURCE[1]['subsource']='Monde';
$LISTSOURCE[1]['cat']=MONDE;
$LISTSOURCE[1]['URL']='http://www.liberation.fr/interactif/rss/actualites/monde/';
/*
$LISTSOURCE[2]['source']='Liberation';
$LISTSOURCE[2]['subsource']='Economie';
$LISTSOURCE[2]['cat']=ECONOMIE;
$LISTSOURCE[2]['URL']='http://www.liberation.fr/interactif/rss/actualites/economie/';

$LISTSOURCE[3]['source']='Liberation';
$LISTSOURCE[3]['subsource']='Médias';
$LISTSOURCE[3]['cat']=MEDIA;
$LISTSOURCE[3]['URL']='http://www.liberation.fr/interactif/rss/actualites/medias/';

$LISTSOURCE[4]['source']='Liberation';
$LISTSOURCE[4]['subsource']='Science';
$LISTSOURCE[4]['cat']=SCIENCE;
$LISTSOURCE[4]['URL']='http://www.liberation.fr/interactif/rss/actualites/sciences/';

$LISTSOURCE[5]['source']='Liberation';
$LISTSOURCE[5]['subsource']='Société';
$LISTSOURCE[5]['cat']=SOCIETE;
$LISTSOURCE[5]['URL']='http://www.liberation.fr/interactif/rss/actualites/societe/';

$LISTSOURCE[6]['source']='Liberation';
$LISTSOURCE[6]['subsource']='Politique';
$LISTSOURCE[6]['cat']=FRANCE;
$LISTSOURCE[6]['URL']='http://www.liberation.fr/interactif/rss/actualites/politique/';

$LISTSOURCE[7]['source']='Liberation';
$LISTSOURCE[7]['subsource']='Culture';
$LISTSOURCE[7]['cat']=CULTURE;
$LISTSOURCE[7]['URL']='http://www.liberation.fr/interactif/rss/culturerss/';
*/
$LISTSOURCE[8]['source']='Liberation';
$LISTSOURCE[8]['subsource']='Multimédia';
$LISTSOURCE[8]['cat']=MULTIMEDIA;
$LISTSOURCE[8]['URL']='http://www.liberation.fr/interactif/rss/multimediarss/';

/*
$LISTSOURCE[]['source']='Liberation';
$LISTSOURCE[]['subsource']='';
$LISTSOURCE[]['cat']=;
$LISTSOURCE[]['URL']='';
*/

// a partir d'ici normalement on ne touche plus
$rss=new lastRSS;

$dbnew= new dbnews($newstable,$uniquetable);



reset($LISTSOURCE);

while(list(,$feed) = each($LISTSOURCE)) {

	if ($rs = $rss->get($feed['URL'])) {
		foreach ($rs['items'] as $item) {
			$url=$item['link'];
			$titre=$item['title'];
			$description=$item['description'];
			$date=$item['pubDate'];
			$extra='';

			// petit pipo sur l'url pour virer des saloperies
			$url=str_replace('?rss=true', '', $url);
			if (strpos($url,'?xtor') !== false) $url=substr($url,0,strpos($url,'?xtor'));


			//echo "$url - $titre - $date - $description\n";

			$dbnew->addnews($feed['source'], $feed['subsource'], $titre, $url, $feed['cat'], $date, $extra, $description);

		} 


	}


}


