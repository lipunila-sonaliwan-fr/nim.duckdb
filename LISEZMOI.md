``
   _._
 o|- -|o This file is licensed under CC BY-NC-SA 4.0 international license.
  ( l )  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/
    =    Author: jean-marc "jihem" quere 2016
``

## duQuack
> Lab'Oratoire / Projet magenta - Laboratoire de Psycholinguistique Cognitive et Sociale \
> https://lipunila.sonaliwan.fr - metalab(at)sonaliwan.fr

Le package duQuack comporte une librairie allégée qui permet de faire l'essentiel avec DuckDB : **sonaliwan/duckdb**.
Il propose également le serveur **duQuack** qui permet la connexion de plusieurs cliente DuckDB en utilisant le protocole Quack.

Le fichier duquack.txt comporte, sur la première ligne, le nom de la resource accédée (et mise à disposition) par le serveur. Il peut s'agir un espace vierge en mémoire (:memory:), d'un fichier sur disque (CSV, Excel, Parquet,...) ou d'une base de données (DuckDB, SQLite, MySQL, PosgreSQL ou toute autre accessible en ODBC). La seconde ligne définit le token devant être présenté par les clients pour accéder au serveur.

Après chargement du package (via `nimble install duquack`), il est possible de...
- Lancer les tests avec `nimble test`
- Construire le projet (et la bibliothèque) par `nimble build`
- Démarrer le serveur duQuack : `nimble run`.

Le résultat, à l'écran se présente de la façon suivante :

```
jihem@sonaliwan-mac01 nim.duckdb % nimble run
      Info: using /opt/homebrew/Cellar/nim/2.2.10/nim/bin/nim for compilation
   Building duquack/duquack using c backend
     _         ____                  _
  __| |_   _  /___ \_   _  __ _  ___| | __
 / _` | | | |//  / / | | |/ _` |/ __| |/ /
| (_| | |_| / \_/ /| |_| | (_| | (__|   <
 \__,_|\__,_\___,_\ \__,_|\__,_|\___|_|\_\
                                     1.0.0
 Press [Ctrl]-[C] twice to stop.

  - 00:18:08.955918 <== uptime du serveur (tel que renvoyé par "FROM whoami()") 
```

Les réglages par défaut (fichier duquack.txt non modifié ou absent) sont indiqués ci-dessous.
- Ressource mise à disposition : base vierge en mémoire (**:memory:**)
- Token : 'secret'.

Les dossier xxxOS comportent les bibliothèques dynamiques et l'interface console de DuckDB (en v1.5.5) pour Linux, macOS et Windows. Le serveur et les applications Nim développées peuvent être déployés sur l'ensemble de ces systèmes d'exploitation (et sont interopérables). 

Une fois le serveur activé, vous pouvez utiliser la console DuckDB, installée par vos soins ou l'une de celles proposées pour accéder au serveur duquack.

```
jihem@sonaliwan-lin01 nim.duckdb % **duckdb**
DuckDB v1.5.5 (Variegata)
Enter ".help" for usage hints.
memory D **LOAD 'QUACK';**
memory D **create secret(type quack, token 'secret');**
┌─────────┐
│ Success │
│ boolean │
├─────────┤
│ true    │
└─────────┘
memory D **attach 'quack:<adresse IP du serveur ou 127.0.0.1 si utilisé en local>:9494' as server (disable_ssl true);**
memory D **select * from server.query("from whoami()");**
┌─────────┬──────────┬──────────┬─────────┬────────────────┬───────────────────────────────┬──────────────────────────────────┐
│  name   │ provider │ hostname │ region  │     uptime     │            ts_now             │               meta               │
│ varchar │ varchar  │ varchar  │ varchar │    interval    │   timestamp with time zone    │               json               │
├─────────┼──────────┼──────────┼─────────┼────────────────┼───────────────────────────────┼──────────────────────────────────┤
│ NULL    │ NULL     │ NULL     │ NULL    │ 00:25:00.68998 │ 2026-09-04 18:26:57.535303+02 │ {                                │
│         │          │          │         │                │                               │   "duckdb_version": "v1.5.5",    │
│         │          │          │         │                │                               │   "platform": "osx_arm64"        │
│         │          │          │         │                │                               │ }                                │
└─────────┴──────────┴──────────┴─────────┴────────────────┴───────────────────────────────┴──────────────────────────────────┘
memory D
```

Les commandes en **gras** peuvent également être intégrées à un programme Nim pour réaliser un client et oeuvrer en mode Client / Serveur. DuckDB peut être utilisé indépendemment de tout serveur par vos applications. Voir le dossier *tests* pour quelques exemples.

IMPORTANT : pour conserver les données du serveur de façon rémanante, remplacer **:memory:** dans le fichier duquack.txt (présent dans le dossier de l'exécutable compilé) par une resource disponible : fichiers, bases de données, etc. 

Exemple (duquack.txt)
**sona.duckdb**
secret

Si le fichier ququack.txt est absent du dossier, copier le à partir du dossier src ou créer le, puis relancer le serveur : arrêter le en pressant 2 fois sur \[CTrl\]-\[C\], puis entrer à nouveau `nimble run`.

La suite est à effectuer dans une nouvelle session DuckDB (`.exit` permet de quitter la précédente): 

```
memory D **create secret(type quack, token 'secret');** 
┌─────────┐
│ Success │
│ boolean │
├─────────┤
│ true    │
└─────────┘
memory D **attach 'quack:<adresse IP du serveur ou 127.0.0.1 si utilisé en local>:9494' as server (disable_ssl true);**
memory D **create table server.demo (nom varchar, age int);**
memory D **insert into server.demo values ('Paul', 35);**
memory D **select * from server.demo;**
┌─────────┬───────┐
│   nom   │  age  │
│ varchar │ int32 │
├─────────┼───────┤
│ Paul    │    35 │
└─────────┴───────┘
memory D
```

Il alors possible d'arrêter une nouvelle fois le serveur. Un nouveau fichier est présent dans le répertoire : **sona.duckdb**.
Il s'agit de la base de données, contenant la table créée avec la ligne ajoutée. 

En relançant le serveur (`nimble run`) et en se reconnectant à partir d'une nouvelle console Duckdb (*create secret..., attach...*), une nouvelle exécution de la requête **select * from server.demo;** affiche les données précédemment saisies : elles ont bien été sauvegardées. 

Les possibilités de DuckDB sont quasiment infinies et nous venons juste d'effleurer le sujet (en Nim !). Vous êtes vivement invité à consulter le site officiel de DuckDB (https://duckdb.org) qui comporte une documentationn accessible et abondante (dont une description de Quack : https://duckdb.org/quack). Beaucoup de tutos, très bien réalisés sont également disponibles en ligne.

IMPORTANT : si pour une raison ou une autre vous rencontrer des difficultés pour charger des extensions DuckDB (dont Quack), il est possible de provoquer leur installation (une bonne fois pour toutes) sur la session utilisées à l'aide de la console DuckDB : **INSTALL '<extension>'**. Les extensions sont stockées dans le dossier **.duckdb** à la racine du compte utilisateur de la session :/home/<nom> sous Linux, /Users/<nom> sous macOS et dans /Utilisateurs/<nom> sous Windows. Le dossier **.duckdb/extensions/<version de DuckDB>/<version du système d'exploitaton>** les contient toutes. Il est alors possible de copier le contenu de ce répertoire vers un système à installer (doté de la même version de DuckDB et du système d'exploitation).

À titre exceptionnel, ce dépôt comporte les binaires requis pour Linux, macOS et Windows en v1.5.5 des consoles de DuckDB et des bibliothèques nécessaires pour Nim (identifiée et mise en oeuvre automatiquement par la bibliothèque **sonaliwan/duckdb**).

Veuillez trouver ci-dessous un rappel de la licence associée à ceux-ci:

Copyright 2018-2026 Stichting DuckDB Foundation

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

### Encore une chose !
Un p'tit geste qui peut - grandement - nous aider... \[La caféïne c'est important pour une équipe de neuro-atypiques : TSA, TDAH, TAG, HPI et/ou THPI (membres de **mensa.fr** et de **triplenine.org**).\]

[![Buy Me a Coffee](buymeacoffe-fre.png)](https://buymeacoffee.com/sonaliwan.fr)
