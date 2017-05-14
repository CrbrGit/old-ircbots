<?
// categories des news (pas encore en place, mais ce serait coooool :)
define('FRANCE',10);
define('MONDE',20);
define('SANTE',30);
define('MULTIMEDIA',40);
define('SCIENCE',50);
define('CULTURE',60);
define('PEOPLE',70);
define('MEDIA',80);
define('ECONOMIE',90);
define('INSOLITE',100);
define('SPORT',110);
define('UNE',120);



define('UNE',99999);



/*
catstable:
- id
- idnews
- source
- subsource
- url (si autre URL pour même
- categorie


--------
autre facon de faire, sacrement plus propre :
toute nouvelle news est inserée dans newsv2 (a l'exception de  celles qu'on a deja : meme url, meme source, meme subsource)
on rajoute un champ categorie a la table news et un champ id_unique (index)

une table newsunique contenant (sert juste a generer automatiquement un auto increment);
- id_unique par news unique


####inutile#une table group_news qui fait le lien entre les 2
####inutile#- id_unique (de newsunique)
####inutile#- id_news (de news)


ensuite, les selects depuis le TCL  se font sur newsoriginal. on decouvre les nouvelles news et
####inutile#SELECT DISTINCT id_unique, n.*, count(n.id) as nbsites
####inutile#FROM group_news as gn, news as n
####inutile#WHERE gn.id_news = new.id
####inutile#AND gn.id_unique > $ID_LAST
####inutile#GROUP BY gn.id_unique
####inutile#ORDER by n.date ASC
####inutile#(le count sert a rien, juste faire un aggregat des lignes et n'en avoir qu'une seule)


SELECT DISTINCT id_unique,count(id) as nbsites
FROM news
WHERE id_unique > $ID_LAST
GROUP BY id_unique
ORDER by date ASC
(le count sert a rien, juste faire un aggregat des lignes et n'en avoir qu'une seule)




*/
