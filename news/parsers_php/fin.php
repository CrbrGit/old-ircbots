<?
include('includes/simplepie.inc');

// a partir d'ici normalement on ne touche plus
$rss=new lastRSS;

$dbnew= new dbnews($newstable,$uniquetable);


reset($LISTSOURCE);

while(list(,$feed) = each($LISTSOURCE)) {

  if ($feed['TYPE']=='atom') {
    $atom = new SimplePie();
    $atom->set_feed_url($feed['URL']);
    $atom->enable_cache(false);
    $atom->set_output_encoding('ISO-8859-1');

    if ($atom->init()) {
      foreach ($atom->get_items() as $item) {
        $url=$item->get_permalink();
        $titre=$item->get_title();
        $description=$item->get_description();
        $date=$item->get_date('Y-m-d H:i:s');
        // petit pipo sur l'url pour virer des saloperies
        $url=str_replace('?rss=true', '', $url);
        if (strpos($url,'?xtor') !== false) $url=substr($url,0,strpos($url,'?xtor'));
        //if (strpos($url,'#xtor') !== false) $url=substr($url,0,strpos($url,'#xtor'));
        if (strpos($url,'#') !== false) $url=substr($url,0,strpos($url,'#'));

        $titre=str_replace(' (Reuters)', '', $titre);

        // les caractères a la con
        $titre=str_replace('&#039;', '\'', $titre);
        $titre=str_replace('&#339;', 'oe', $titre);
        $titre=str_replace('&#8230', '...', $titre);
        $titre=html_entity_decode($titre,ENT_QUOTES);
        $titre=str_replace('"', '\'', $titre);
        $dbnew->addnews($feed['source'], $feed['subsource'], $titre, $url, $feed['cat'], $date, html_entity_decode($extra,ENT_QUOTES), html_entity_decode($description,ENT_QUOTES));
      }
    }
  } else {

    if ($rs = $rss->get($feed['URL'])) {
      foreach ($rs['items'] as $item) {
        $url=$item['link'];
        $titre=$item['title'];
        $description=$item['description'];
        $date=$item['pubDate'];
        $extra='';

        // petite saloperie pour le monde et ses URL a la noix
        // connerie
        //if (strpos($url,'rss.feedsportal.com') !== false)  {
        //  $hand=fopen($urli, "r");
        //  while ($ligne=fgets($handle)) {
        //    if (strpos($ligne,'Location: ') !== false) {
        //      str_replace('Location: ', '', $ligne);
        //      break;
        //    }
        //  }
        //}

        // petit pipo sur l'url pour virer des saloperies
        $url=str_replace('?rss=true', '', $url);
        if (strpos($url,'?xtor') !== false) $url=substr($url,0,strpos($url,'?xtor'));
        //if (strpos($url,'#xtor') !== false) $url=substr($url,0,strpos($url,'#xtor'));
        if (strpos($url,'#') !== false) $url=substr($url,0,strpos($url,'#'));

        $titre=str_replace(' (Reuters)', '', $titre);

        // les caractères a la con
        $titre=str_replace('&#039;', '\'', $titre);
        $titre=str_replace('&#339;', 'oe', $titre);
        $titre=str_replace('&#8230', '...', $titre);
        $titre=html_entity_decode($titre,ENT_QUOTES);
        $titre=str_replace('"', '\'', $titre);


#echo "$url - $titre - $date - $description\n";

        $dbnew->addnews($feed['source'], $feed['subsource'], $titre, $url, $feed['cat'], $date, html_entity_decode($extra,ENT_QUOTES), html_entity_decode($description,ENT_QUOTES));

      } 
    }
  }

}

