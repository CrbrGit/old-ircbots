Repository to store old unmaintained code that was used in the good old days (90ies and the beginning of the millenium). Use at your own risks


it contains 2 things : 

- news : 
  * Some badly written PHP scripts that parse rss and put the content into a mysql database (requires PHP 5.X or less. Will not work with PHP7 and later).
  * a TCL script for eggdrop that read this database and posts it to an IRC channel.

- "AI". A good old (very old) talking bot, in french. written in TCL too.



It should all still work but be advised :

- There is at least one remotely exploitable flaw on the "ai" script that could allow an attacker to launch code on the bot executing this script (somewhere in one of the response triggered by nickname changing)

- the News script requires a tcl module to access mysql database (debian package "mysqltcl")


Copyright : 
- I don't care what you do with that but :
- the php parsers for the feeds uses 2 open source projets :
   * lastRSS (http://lastrss.oslab.net) which is under GPL licence. used to read rss feeds
   * simplepie (http://simplepie.org) which is under the BSD licence. used to read atom feeds

