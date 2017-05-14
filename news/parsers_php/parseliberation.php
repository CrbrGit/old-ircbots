#!/usr/bin/php
<?
include('includes/dbnews.php');
include('includes/lastRSS.php');
require_once('includes/newscat.php');

// table dans laquelle les news sont insérées
$newstable='testnews';
$catstable='testcats';

// listes des news traitées pareillement
$LISTSOURCE[0]['source']="Liberation";
$LISTSOURCE[0]['subsource']="Une";
$LISTSOURCE[0]['cat']=UNE;
$LISTSOURCE[0]['URL']="http://www.liberation.fr/interactif/rss/actualites/";

// a partir d'ici normalement on ne touche plus
$rss=new lastRSS;

$dbnew= new dbnews($newstable,$catstable);



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


			echo "$url - $titre - $date - $description\n";

			$dbnew->addnews($feed['source'], $feed['subsource'], $titre, $url, $date, $extra, $description);

		} 


	}


}






