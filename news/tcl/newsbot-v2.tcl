# news.tcl
# 
# Script qui display des news depuis une base de données, juste les nouvelles news
#
#
#
#
#
## infos de connexion a la base
set mysqlnewsv2(host)	"127.0.0.1"
set mysqlnewsv2(user)	"BDD-USER"
set mysqlnewsv2(pass)	"BDD-PASS"
set mysqlnewsv2(db)	"news"
set mysqlnewsv2(table)	"newsv2"


## chan ou on fait le bordel
#set mysqlnewsv2(channel) "#newsfr-test"
set mysqlnewsv2(channel) "#newsfr"

package require mysqltcl 


bind time - "* * * * *" newsv2:display

proc newsv2:display { min hour day month year } { 

  global mysqlnewsv2

  if  { $mysqlnewsv2(lock) == 1 } {
    # il y a deja une procedure en cours de traitement, on ne se rajoute pas dessus
    return 0
  }
  
  if  {[catch {mysqluse $mysqlnewsv2(connec) $mysqlnewsv2(db)}]} {
    # can't use database, try to reconnect to the database
    #mysqlclose $mysqlnewsv2(connec)
    catch {set mysqlnewsv2(connec) [mysqlconnect -user $mysqlnewsv2(user) -password $mysqlnewsv2(pass) -host $mysqlnewsv2(host)]}
   
    # if still can't, then we do exit
    if  {[catch {mysqluse $mysqlnewsv2(connec) $mysqlnewsv2(db)}]} {
      #mysqlclose $mysqlnewsv2(connec)
      return 0
    }
  }

  # on met un lock pour etre sur que cet proc sera finie avant le lancement de la suivante
  set mysqlnewsv2(lock) 1

  # cherche les differences a afficher depuis la derniere fois
  set sql "SELECT id_unique, source, subsource, titre, url, date, count(id) as nbsites FROM $mysqlnewsv2(table) WHERE id_unique > $mysqlnewsv2(lastsaid) GROUP BY id_unique ORDER by date ASC"
  set result [mysqlquery $mysqlnewsv2(connec) $sql]
  while {[set row [mysqlnext $result]] != ""} {
    set mysaidv2		[lindex $row 0]
    set newssource		[lindex $row 1]
    set newssubsource		[lindex $row 2]
    set newstext		[lindex $row 3]
    set newsurl			[lindex $row 4]
    set newsdate		[lindex $row 5]

    if { $mysqlnewsv2(lastsaid) < $mysaidv2 } {
      set mysqlnewsv2(lastsaid) $mysaidv2
    }

    if { "$newssubsource" != "" } {
      set newssource		"$newssource - $newssubsource"
    }

    putquick "PRIVMSG $mysqlnewsv2(channel) :\[$newssource\] $newstext ($newsdate) \[ $newsurl \]"
  }
  mysqlendquery $result

  # a la fin, on enleve le lock
  set mysqlnewsv2(lock) 0
}

# connexion a la base
catch {mysqlclose $mysqlnewsv2(connec)}
if {[catch {set mysqlnewsv2(connec) [mysqlconnect -user $mysqlnewsv2(user) -password $mysqlnewsv2(pass) -host $mysqlnewsv2(host)]}]} {
    putlog "can't connect to mysql server!"; return 0
}

# on crée le lock pour la proc
set mysqlnewsv2(lock) 0

# derniere fois (il faudra mettre le dernier enregistrement actuel de la base pour les rehash precedents)
#set mysqlnewsv2(lastsaid) 0
if { [catch { mysqluse $mysqlnewsv2(connec) $mysqlnewsv2(db)}]} {
  set mysqlnewsv2(lastsaid) 0
} else  {
  set result [mysqlquery $mysqlnewsv2(connec) "SELECT MAX(id_unique) FROM $mysqlnewsv2(table)"]
  set row [mysqlnext $result]
  set mysqlnewsv2(lastsaid) [lindex $row 0]
  mysqlendquery $result

}
