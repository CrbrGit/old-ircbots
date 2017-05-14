<?
define('DBHOST','127.0.0.1');
define('DBUSER','BDD-USER');
define('DBPASS','BDD-PASS');
define('DB','news');

// on prend les categories de news
require_once('newscat.php');

class dbnews {

	var $dblink = false;
	var $newstable;
	var $uniquenewstable;

	function dbnews($newstable='newsv2', $uniquenewstable='uniquenewsv2') {
		$this->dblink=mysql_connect(DBHOST, DBUSER, DBPASS);
		mysql_select_db(DB);
		$this->newstable=$newstable;
		$this->uniquenewstable=$uniquenewstable;
	}


	function addnews($source='', $subsource='', $titre, $url='', $cat=99999, $date='', $extra='', $description='') {
		if ($source != '' && $url != '' && $titre != '' && is_numeric($cat)) {

			if ($date=='') {
				$date==date('Y-m-d H:i:s');
			}


			$req_verif=mysql_query('
				SELECT count(id) AS ci
				FROM '.$this->newstable.'
				WHERE
					(	url=\''.mysql_real_escape_string($url).'\'
						OR
						(	titre=\''.mysql_real_escape_string($titre).'\'
							AND
							dateinsert > DATE_SUB(NOW(),INTERVAL 2 DAY)
						)
					)
					AND
					source = \''.mysql_real_escape_string($source).'\'
					AND
					subsource = \''.mysql_real_escape_string($subsource).'\'

			') or die('Error VERIF1: '.mysql_error());
			$data_verif=mysql_fetch_object($req_verif);
			$count=$data_verif->ci;
			unset($data_verif);
			mysql_free_result($req_verif);

			if ($count == 0) {
				// on a verifié qu'on n'a pas deja cette news de cette source pour
				// ne pas reinserer des 10aines de fois la même


				// on verifie si on a deja une news du même titre d'une autre source
				// (sont chiants à se reprendre les uns les autres) et le cas echéant
				// on recupere l'ID du groupe
				$req_verif2=mysql_query('
					SELECT id_unique, count(id) AS ci
					FROM '.$this->newstable.'
					WHERE (
                                                titre=\''.mysql_real_escape_string($titre).'\'
                                                )
					AND dateinsert > DATE_SUB(NOW(),INTERVAL 2 DAY)
					GROUP BY id_unique
				') or die('Error VERIF2: '.mysql_error());
				$data_verif2=mysql_fetch_object($req_verif2);
				$count2=$data_verif2->ci;
				$id_unique=$data_verif2->id_unique;
				unset($data_verif2);
				mysql_free_result($req_verif2);

				if ($count2 == 0 || $id_unique == 0 ) {
					// on crée un nouveau groupe si on n'avait pas deja une news
					// en base avec le même titre
					mysql_query('INSERT INTO '.$this->uniquenewstable.' (id_unique) VALUES (\'\')') OR die('Error INSERT ID_UNIQUE: '.mysql_error());
					$id_unique=mysql_insert_id();
				}



				// on insert la news (enfin !)
				mysql_query('INSERT INTO '.$this->newstable.' (source, subsource, titre, categorie, url, date, extra, description, dateinsert, id_unique) VALUES (\''.mysql_real_escape_string($source).'\',\''.mysql_real_escape_string($subsource).'\',\''.mysql_real_escape_string($titre).'\','.$cat.',\''.mysql_real_escape_string($url).'\',\''.mysql_real_escape_string($date).'\',\''.mysql_real_escape_string($extra).'\',\''.mysql_real_escape_string($description).'\',NOW(), '.$id_unique.')') OR die('Error INSERT NEWS: '.mysql_error());


				$id_news_inseree=mysql_insert_id();

				return true;
			}
		}

		return false;
	}


}
