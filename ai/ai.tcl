# Ai.tcl

#VERSION 2
#DESCRIPTION Responds to certain words said in the set channels and to certains nick changes.

catch { unset ai }


### variables de config
# emplacement du fichier de configuration
set ai(configfile) "ai/ai.conf"




############### debut du script, ne touchez pas la en dessous, a moins de savoir ce que vous faites


### chargement des variables de configs
source $ai(configfile)


### reactions aux messages sur le chan
bind pubm - * ai:pub
proc ai:pub {nick uhost hand chan arg} {
  global ai botnick owner network
  set chan [string tolower $chan]

  #blindage de $nick [die] & co :)
  set nick [join [lrange [split $nick] 0 0]]
  set hand [join [lrange [split $hand] 0 0]]

  regsub -all {[\]\[\{\}\(\)]} $nick "" nick
  regsub -all {[\]\[\{\}\(\)]} $hand "" hand

  # on se debarasse de tt les accents & ponctuation
  regsub -all {[ÀÁÂÃÄÅàáâãäå]} $arg "a" arg
  regsub -all {[éèêëÈÉÊË]} $arg "e" arg
  regsub -all {[òóôðõöÒÓÔÕÖ]} $arg "o" arg
  regsub -all {[ûüùÛÜÙ]} $arg "u" arg
  regsub -all {[Ýÿý]} $arg "y" arg
  regsub -all {[çÇ]} $arg "c" arg
  regsub -all {[ÌÍÎÏìíîï]} $arg "i" arg
  regsub -all {['-]} $arg " " arg
  regsub -all {[,;\]\[\{\}\(\)!\?\.]} $arg "" arg

  if {(([lsearch -exact [string tolower $ai(chans)] [string tolower $chan]] != -1) || ($ai(chans) == "*")) && (![matchattr $hand b]) && (![matchattr $hand $ai(ignoreflag)]) && ($nick != $botnick)} {
    # si on est bien dans un chan ou l'IA est active, que ce n'est pas un bot ou un garts avec flag +$ai(ignoreflag) (flag ignore) qui parle


    # on choisit un temps de reponse pour le bot
    set lagrep [ai:random [expr $ai(lagmax) + 1 ] ]

    # on lui fait dire sa connerie (avec lag si il faut)
    utimer $lagrep "ai:suitepub $nick $hand $chan {$arg}"

  }
}

#reactions aux /me
#### exactement le meme que le precedent :)
bind ctcp - ACTION ai:action
proc ai:action {nick uhost hand chan keyword arg} {
  ai:pub $nick $uhost $hand $chan $arg
}


# suite de la reaction aux messages publics, suite qui s'execute avec un lag programmé

proc ai:suitepub {nick hand chan arg} {
  global ai botnick owner network

  if { ([string match [string tolower "*$botnick*"] [string tolower $arg]]) || ( $ai(convers[string tolower $chan]) > 0 ) } {
    # si on s'adresse au bot ou bien si on est deja en train de discuter avec lui


    # compteur pour savoir quel type de reponse "intelligente" on va donner (si on en donne une) ( ex : reponse au "merci" => N°6)
    set numtrig 0

    ## parcours de toutes les reponses "intelligente"
    foreach {triggers responses} $ai(intelligentanswers) {

      # derniere reponse donnée
      set lastrep [subst [lindex $ai(lastrepintelans$chan) $numtrig]]

      foreach trigger $triggers {
        # pour chaque "trigger" on verifie s'il correspond a ce qui a été dit

        if {[string match [string tolower $trigger] [string tolower $arg]]} {
          #si ce qui a été dit correspond à un evenement connu


          if { [expr [ai:random [lindex $ai(directreact) 1]] < [lindex $ai(directreact) 0]] } {
            # on fait un tirage au sort, si le chiffre est dans les limite de "reactivité" on envoie la connerie a dire


            # on tire au hasard koi dire parmi les reponses possible pour cet evenement
            set repnum [ai:random [llength $responses]]

            while {$repnum == $lastrep} {
              #on recommence jusqu'a ce que la reponse ne soit pas la mm que la derniere fois
              set repnum [ai:random [llength $responses]]
            }

            # on le dit
            putserv "PRIVMSG $chan :[subst [lindex $responses $repnum ]]"

            # et on sauvegarde la reponse donnée pour ne pas dire la mm chose la prochaine fois
            set ai(lastrepintelans$chan) [lreplace $ai(lastrepintelans$chan) $numtrig $numtrig $repnum]

            # engagement du "mode conversation" pour quelques secondes sur ce chan
            if { $ai(converstime) > 0 } {
              incr ai(convers[string tolower $chan])
              utimer $ai(converstime) "ai:stop_conversation [string tolower $chan]"
            }

          }

          #on sort de la procedure, c'est fini, on a trouvé une reponse
          return
        }
      }

      incr numtrig
    }

    # si on est dans le "monde conversation, on va pas essayer les conneries, sinon, c'est sans fin, c reation a 100% des mots
    if { ![string match [string tolower "*$botnick*"] [string tolower $arg]] } { return }


    ##si parmis les reponses intelligentes on n'a rien trouvé, on sort une connerie


    if { [expr [ai:random [lindex $ai(directreact) 1]] < [lindex $ai(directreact) 0]] } {
      # on fait un tirage au sort, si le chiffre est dans les limite de "reactivité" on envoie la connerie à dire

      # reponse con donnée la dernier fois que le bot a du dire une betise.
      set lastrep $ai(lastrepdumbans$chan)

      #on tire au sort
      set repnum [ai:random [llength $ai(answer)]]
      while {$repnum == $lastrep} {
        # tant qu'a faire, on verifie que la reponse donnée n'es pas la mm que la derniere fois
        set repnum [ai:random [llength $ai(answer)]]
      }

      # on le dit
      putserv "PRIVMSG $chan :[subst [lindex $ai(answer) $repnum]]"

      # on s'en souvient pour ne pas dire la meme chose la prochaine fois
      set ai(lastrepdumbans$chan) $repnum

      # engagement du "mode conversation" pour quelques secondes sur ce chan
      if { $ai(converstime) > 0 } {
        incr ai(convers[string tolower $chan])
        utimer $ai(converstime) "ai:stop_conversation [string tolower $chan]"
      }


    }

  } else  {

    #si on ne s'addressait pas au bot, alors on va voir si ca ne correspond pas a un evenement connu kan meme

    # compteur pour savoir quel type de reponse on va donner (si on en donne une)
    set numtrig 0

    foreach {triggers responses} $ai(indirect) {
      # parcours de tt les reponses possibles

      # derniere reponse donnée par le bot sur ce chan dans ce cas particulier
      set lastrep [subst [lindex $ai(lastrepnpkoi$chan) $numtrig]]

      foreach trigger $triggers {
        # pour chaque "trigger" on verifie s'il correspond a ce qui a été dit

        if {[string match [string tolower $trigger] [string tolower $arg]]} {
          # si c'est le cas, on va selectionner une reponse corrspodnante

          #on tire au sort koi repondre parmis les reponses possibles
          set repnum [ai:random [llength $responses]]

          while {$repnum == $lastrep} {
            #on recommence le tirage au sort si jamais la reponse qu'on allait dire etait la mm que celle qu'on a dit la derniere fois

            set repnum [ai:random [llength $responses]]
          }


          if { [expr [ai:random [lindex $ai(indirectreact) 1]] < [lindex $ai(indirectreact) 0]] } {
            # on fait un tirage au sort, si le chiffre est dans les limite de "reactivité" on envoie la connerie a dire

            # on le dit
            putserv "PRIVMSG $chan :[subst [lindex $responses $repnum]]"

            #on sauvegarde ca comme la derniere chose dite (pour ne pas radotter)
            set ai(lastrepnpkoi$chan) [lreplace $ai(lastrepnpkoi$chan) $numtrig $numtrig $repnum]

            # engagement du "mode conversation" pour quelques secondes sur ce chan
            if { $ai(converstime) > 0 } {
              incr ai(convers[string tolower $chan])
              utimer $ai(converstime) "ai:stop_conversation [string tolower $chan]"
            }

          }


          #on quitte la procedure, on a donné notre reponse.
          return
        }
      }
      incr numtrig
    }
  }
}


#reaction aux changements de nick (tt apreil que au dessus, je refait pas les commentaires)
bind nick - * ai:nick
proc ai:nick {nick uhost hand chan newnick} {
  global ai botnick owner network
  set chan [string tolower $chan]

  # on blinde $nick & $newnick pour eviter les ptit plaisantins [die] & co
  regsub -all {[\]\[\{\}\(\)]} $nick "" nick
  regsub -all {[\]\[\{\}\(\)]} $newnick "" newnick
  regsub -all {[\]\[\{\}\(\)]} $hand "" hand



  if {(([lsearch -exact [string tolower $ai(chans)] [string tolower $chan]] != -1) || ($ai(chans) == "*")) && (![matchattr $hand b]) && (![matchattr $hand $ai(ignoreflag)]) && ($nick != $botnick)} {
    # si on est sur un chan ou le script est activé, et si ce n'est pas un bot ou un gars ignoré qui change de nick :


    # on choisit un temps de reponse pour le bot
    set lagrep [ai:random [expr $ai(lagmax) + 1 ] ]

    # continue (avec lag)
    utimer $lagrep "ai:suitenick $nick $hand $chan $newnick"


  }
}


# suite (avec lag volontaire) de la reaction aux changements de nicks
proc ai:suitenick {nick hand chan newnick}  {
  global ai botnick owner network

  set numtrig 0
  foreach {triggers responses} $ai(newnick) {
    set lastrep [subst [lindex $ai(lastrepnewnickans$chan) $numtrig]]
    foreach trigger $triggers {
      #pour chaque nick possible

      if {[string match [string tolower $trigger] [string tolower $newnick]]} {
        # si c'est un nick qu'on connait

        #on choisit une reponse au hasard (mais pas la meme que la derniere fois
        set repnum [ai:random [llength $responses]]
        while {$repnum == $lastrep} {
          set repnum [ai:random [llength $responses]]
        }

        if { [expr [ai:random [lindex $ai(nickreact) 1]] < [lindex $ai(nickreact) 0]] } {

          # on repond
          putserv "PRIVMSG $chan :[subst [lindex $responses $repnum]]"

          # on se souvient de la reponse pour ne pas radotter
          set ai(lastrepnewnickans$chan) [lreplace $ai(lastrepnewnickans$chan) $numtrig $numtrig $repnum]

          # engagement du "mode conversation" pour quelques secondes sur ce chan
          if { $ai(converstime) > 0 } {
            incr ai(convers[string tolower $chan])
            utimer $ai(converstime) "ai:stop_conversation [string tolower $chan]"
          }

        }

        return
      }
    }
    incr numtrig
  }

  ## si on a pas trouvé de trucs a dire sur le nouvo nick de la personne, on regarde si on a qqchose a dire sur son ancien nick
  set numtrig 0
  foreach {triggers responses} $ai(oldnick) {
    set lastrep [subst [lindex $ai(lastrepoldnickans$chan) $numtrig]]
    foreach trigger $triggers {
      if {[string match [string tolower $trigger] [string tolower $nick]]} {
        set repnum [ai:random [llength $responses]]
        while {$repnum == $lastrep} {
          set repnum [ai:random [llength $responses]]
        }
        if { [expr [ai:random [lindex $ai(nickreact) 1]] < [lindex $ai(nickreact) 0]] } {

          # on dit la betise
          putserv "PRIVMSG $chan :[subst [lindex $responses $repnum]]"

          set ai(lastrepoldnickans$chan) [lreplace $ai(lastrepoldnickans$chan) $numtrig $numtrig $repnum]

          # engagement du "mode conversation" pour quelques secondes sur ce chan
          if { $ai(converstime) > 0 } {
            incr ai(convers[string tolower $chan])
            utimer $ai(converstime) "ai:stop_conversation [string tolower $chan]"
          }

        }

        return
      }
    }
    incr numtrig
  }

}

# conneries kan le chan est inactif

### reset l'"idle" du chan kan qq parle
bind pubm - * ai:blague:pubm
proc ai:blague:pubm { nick uhost hand chan arg } {
  global ai
  if [info exists ai(inact[string tolower $chan])] {
    set ai(inact[string tolower $chan]) [unixtime]
  }
}

### ca casse tout en fait => ca bloque le bind sur le /me du reste
## idem sur /me
#bind ctcp - ACTION ai:blague:action
#proc ai:blague:action {nick uhost hand chan keyword arg} {
#  ai:blague:pubm $nick $uhost $hand $chan $arg
#}


bind pub - $ai(blaguepubtrig) blague:ecritchan

## dire une blangue sur un chan
proc blague:ecritchan { nick uhost hand chan arg } {
  global ai botnick owner
  set arg [string tolower $arg]
  regsub -all \\*|\\? $arg "" arg

  if { ($arg != "") && ( [lsearch -exact [string tolower $ai(blaguebases)] [string tolower $arg]] != -1 ) } {
    set intervalle [expr $ai(blagues-fin$arg)-$ai(blagues-debut$arg)]
    set randindex [expr $ai(blagues-debut$arg)+[ai:random $intervalle]]
    while {$ai(lastblague$chan) == $randindex } {
      set randindex [expr $ai(blagues-debut$arg)+[ai:random $intervalle]]
    }
  } else {
    set randindex [ai:random [llength $ai(blagues)]]
    while {$ai(lastblague$chan) == $randindex } {
      set randindex [ai:random [llength $ai(blagues)]]
    }
  }

  if { $randindex < $ai(blagues-debutnonblagues) } {
    putserv "PRIVMSG $chan :[lindex $ai(blagues) $randindex] ([expr $randindex + 1]/[llength $ai(blagues)])"
  } else {
    putserv "PRIVMSG $chan :[lindex $ai(blagues) $randindex]"
  }

  # engagement du "mode conversation" pour quelques secondes sur ce chan (nota, on reste moins longtemps en eveille dans ce cas la
  if { $ai(converstime) > 0 } {
    incr ai(convers[string tolower $chan])
    utimer [expr $ai(converstime) / 3 + 1] "ai:stop_conversation [string tolower $chan]"
  }

  set ai(inact[string tolower $chan]) [expr [unixtime] - $ai(blagueseuil) + $ai(blagueinterval)]
  set ai(lastblague$chan) $randindex
}

### dit une connerie kan on a depassé le temps mini sans rien sur le chan
bind time - "* * * * *" blague:time
proc blague:time { min hour day month year } {
  global ai owner network botnick

  foreach chan $ai(blaguechans) {
    if [info exists ai(inact[string tolower $chan])] {
      if [expr [unixtime]-$ai(inact[string tolower $chan])]>$ai(blagueseuil) {

        set randindex [ai:random [llength $ai(blagues)]]
        while {$randindex == $ai(lastblague$chan)} {
          set randindex [ai:random [llength $ai(blagues)]]
        }

        if { $randindex < $ai(blagues-debutnonblagues) } {
          putserv "PRIVMSG $chan :[lindex $ai(blagues) $randindex] ([expr $randindex + 1]/[llength $ai(blagues)])"
        } else {
          putserv "PRIVMSG $chan :[lindex $ai(blagues) $randindex]"
        }

        set ai(inact[string tolower $chan]) [expr [unixtime] - $ai(blagueseuil) + $ai(blagueinterval)]
        set ai(lastblague$chan) $randindex

        # engagement du "mode conversation" pour quelques secondes sur ce chan
        if { $ai(converstime) > 0 } {
          incr ai(convers[string tolower $chan])
          utimer [expr $ai(converstime) / 3 + 1] "ai:stop_conversation [string tolower $chan]"
        }

      }
    }
  }
}


#####  lecture/ecriture des données dans les fichiers

### initialisation : lecture des blague dans des fichier => variable
proc ai:lire:blague { } {
 global ai

 set ai(blagues) {}

 set line ""
 foreach file $ai(blaguebases) {
   set myfile "$ai(filedir)/blagues/$file.txt"
   if {[file exists $myfile]} {
      set fid [open $myfile r]
      set ai(blagues-debut$file) [llength $ai(blagues)]
      set entete ""
      gets $fid entete
      for { set compte [llength $ai(blagues)] } { ![eof $fid] } { } {
        gets $fid line
        if {[string length $line] > 2} {
          lappend ai(blagues) "$entete$line"
          incr compte
        }
      }
      set ai(blagues-fin$file) [expr $compte-1]
      close $fid
    }
  }

 #reactions a la con qui ne sont pas des blagues, des trucs du genre "pffff, j'm'ennuie moi"
 set myfile "$ai(filedir)/blagues/nonblagues.txt"
 if {[file exists $myfile]} {
    set fid [open $myfile r]
    set ai(blagues-debutnonblagues) [llength $ai(blagues)]
    for { set compte [llength $ai(blagues)] } { ![eof $fid] } { } {
      gets $fid line
      if {[string length $line] > 1} {
        regsub -all "§1" $line \[ line
        regsub -all "§2" $line \] line
        lappend ai(blagues) "$line"
        incr compte
      }
    }
    set ai(blagues-finnonblagues) [expr $compte-1]
    close $fid
 }

}

# lire les reponses de type "connerie" (c'est a dire kan on s'adresse au bot et qu'il ne comprend pas)
proc ai:lire:conneries { } {
 global ai

 set ai(answer) {}
 set line ""
 set myfile "$ai(filedir)/direct/dumb.txt"
 if {[file exists $myfile]} {
    set fid [open $myfile r]
    for { set compte 0 } { ![eof $fid] } { incr compte } {
      gets $fid line
      if {[string length $line] > 1} {
        regsub -all "§1" $line \[ line
        regsub -all "§2" $line \] line
        lappend ai(answer) "$line"
      }
    }

    close $fid
  }
}

#lire les reponses intelligentes (kan on s'adresse specifiquement au bot)
proc ai:lire:intellians { } {
  global ai botnick

  # raz
  set ai(intelligentanswers) {}

  # remplissage
  foreach i $ai(intelbase) {

    #trigger de declanchement
    set trigger {}
    set fid [open "$ai(filedir)/direct/intelligent/trig[set i].txt" r]
    for { set compte 0 } { ![eof $fid] } { incr compte } {
      gets $fid line
      if {[string length $line] > 1} {
        regsub -all "§botnick" $line "$botnick" line
        lappend trigger "$line"
      }
    }
    close $fid

    #reponse a la con
    set ans {}
    set fid [open "$ai(filedir)/direct/intelligent/ans[set i].txt" r]
    for { set compte 0 } { ![eof $fid] } { incr compte } {
      gets $fid line
      if {[string length $line] > 1} {
        regsub -all "§1" $line \[ line
        regsub -all "§2" $line \] line
        lappend ans "$line"
      }
    }
    close $fid

    # on rajoute tout a la liste
    lappend ai(intelligentanswers) $trigger
    lappend ai(intelligentanswers) $ans

  }
}

#lire les reponses a des evenements indirects
proc ai:lire:indirect { } {
  global ai

  # raz
  set ai(indirect) {}

  # remplissage
  foreach i $ai(indirbase) {

    #trigger de declanchement
    set trigger {}
    set fid [open "$ai(filedir)/indirect/trig[set i].txt" r]
    for { set compte 0 } { ![eof $fid] } { incr compte } {
      gets $fid line
      if {[string length $line] > 2} {
        lappend trigger "$line"
      }
    }
    close $fid

    #reponse a la con
    set ans {}
    set fid [open "$ai(filedir)/indirect/ans[set i].txt" r]
    for { set compte 0 } { ![eof $fid] } { incr compte } {
      gets $fid line
      if {[string length $line] > 2} {
        regsub -all "§1" $line \[ line
        regsub -all "§2" $line \] line
        lappend ans "$line"
      }
    }
    close $fid

    # on rajoute tout a la liste
    lappend ai(indirect) $trigger
    lappend ai(indirect) $ans

  }
}


#lire les reponses a des changements de nick
proc ai:lire:nick { } {
  global ai

  # raz
  set ai(newnick) {}
  set ai(oldnick) {}

  # remplissage
  foreach i $ai(nickbase) {

    #trigger de declanchement
    set trigger {}
    set fid [open "$ai(filedir)/nick/trig[set i].txt" r]
    for { set compte 0 } { ![eof $fid] } { incr compte } {
      gets $fid line
      if {[string length $line] > 2} {
        lappend trigger "$line"
      }
    }
    close $fid

    # reaction au nouvo nick
    if { [file exists "$ai(filedir)/nick/newnick[set i].txt"] }  {

      #reponse a cet evennement
      set ans {}
      set fid [open "$ai(filedir)/nick/newnick[set i].txt" r]
      for { set compte 0 } { ![eof $fid] } { incr compte } {
        gets $fid line
        if {[string length $line] > 2} {
          regsub -all "§1" $line \[ line
          regsub -all "§2" $line \] line
          lappend ans "$line"
        }
      }
      close $fid

      # on rajoute tout a la liste
      lappend ai(newnick) $trigger
      lappend ai(newnick) $ans

    }

    #reaction a l'ancien nick
    if { [file exists "$ai(filedir)/nick/oldnick[set i].txt"] }  {

      #reponse a cet evennement
      set ans {}
      set fid [open "$ai(filedir)/nick/oldnick[set i].txt" r]
      for { set compte 0 } { ![eof $fid] } { incr compte } {
        gets $fid line
        if {[string length $line] > 2} {
          regsub -all "§1" $line \[ line
          regsub -all "§2" $line \] line
          lappend ans "$line"
        }
      }
      close $fid

      # on rajoute tout a la liste
      lappend ai(oldnick) $trigger
      lappend ai(oldnick) $ans

    }

  }

}


# mode conversation, enleve le "mode conversation" d'un chan
proc ai:stop_conversation {lechan} {
  global ai
  set ai(convers$lechan) [ expr $ai(convers$lechan) - 1 ]
}


# tentative d'avoir un random meilleur que celui du TCL (pasque le bot se repete un peu, voire beaucoup)
proc ai:random {args} {
    global _ran

    if {[llength $args] > 1} {
        set _ran [lindex $args 1]
    } else {
        set period 233280
        if {[info exists _ran]} {
            set _ran [expr { ($_ran*9301 + 49297) % $period }]
        } else {
            set _ran [expr { [clock seconds] % $period } ]
        }
        return [expr { int($args*($_ran/double($period))) } ]
    }
}



### initialisation :

# ouverture des fichiers blagues
ai:lire:blague

# ouverture du fichier conneries
ai:lire:conneries

#ouverture des fichiers avec les reponses intelligentes
ai:lire:intellians

#ouverture des fichiers avec les reponses aux evenements indirects
ai:lire:indirect

#ouverture des fichiers avec les reponses au changements de nick
ai:lire:nick

# traitement de la variable "reactivité" afin que avec un lindex on puisse recuperer les 2 valeurs dedant
set ai(indirectreact) [split $ai(indirectreact) :]
set ai(directreact) [split $ai(directreact) :]
set ai(nickreact) [split $ai(nickreact) :]

# raz de tt les variabls qui contiennent les derniers reposnes données pour chaque chan (pour ne pas que le bot se repete)
foreach {chan} $ai(chans) {
  set ai(lastrepintelans$chan) {}
  set ai(lastrepdumbans$chan) "999"
  set ai(lastrepnewnickans$chan) {}
  set ai(lastrepoldnickans$chan) {}
  set ai(lastrepnpkoi$chan) {}
  foreach {triggers responses} $ai(intelligentanswers) {
    lappend ai(lastrepintelans$chan) "999"
  }
  foreach {triggers responses} $ai(newnick) {
    lappend ai(lastrepnewnickans$chan) "999"
  }
  foreach {triggers responses} $ai(oldnick) {
    lappend ai(lastrepoldnickans$chan) "999"
  }
  foreach triggers $ai(indirect) {
    lappend ai(lastrepnpkoi$chan) "999"
  }
}

# kill des timers conversation en cours
foreach t [utimers] {
  if { [string match "*ai:stop_conversation*" [lindex $t 1]] } {
    killutimer [lindex $t 2]
  }
}
# raz de la memoire au sujet des chans ou le bot a engagé la conversation (c a dire ou il reagit meme kan son nick n'est pas dit)
foreach {chan} $ai(chans) {
  set ai(convers$chan) 0
}

# mise a 0 du temps d'idle pour les chans (le temps d'idle sert a determiner kan sortir une blague)
foreach chan $ai(blaguechans) {
  if ![info exists ai(inact[string tolower $chan])] {
    set ai(inact[string tolower $chan]) [unixtime]
  }
  set ai(lastblague$chan) "9999"
}


putlog "*** AI.tcl loaded."
