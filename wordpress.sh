#!/bin/bash
#SUJET DU TP:

#/!\ ATTENTION: JE NE VEUX PAS DE HOSTS (trop de problèmes à cause de ça), DONC MERCI
#DE RESTER SUR "192.168.33.10", QUI EST LA VALEUR PAR DEFAUT DE VOTRE VAGRANT FILE /!\

#/!\ ATTENTION: VEUILLEZ TELECHARGER mysql-server AVANT, AFIN DE METTRE LE 0000,
#MAIS NE SURTOUT TELECHARGER AUCUN AUTRES PAQUETS
#ET VEUILLEZ CREER UNE BASE DE DONNEES AU PREALABLE QUI S'APPELLERA "wordpress" /!\

#A faire à deux !

#Début du script

#saut de ligne
blue='\033[34m'
green='\x1B[0;32m'
cyan='\x1B[1;36m'
bold='\033[1m'
normal='\033[0m'

function ligne {
  echo " "
}
#Un script en Bash, qui va permettre de faire plusieurs choses:

#1. Installation d'Apache2, de PHP avec la version adéquate, ainsi que
#les autres paquets que j'ai mis dans certains tutos
#sudo apt-get install apache2 php7.0 php7.0-mysql libapache2-mod-php7.0 -y
#2. Installation en CLI de Wordpress, avec toutes les étapes,
#sauf que vous donnez le choix à votre utilisateur, comme:
#    	2.a. Le nom du site
ligne
echo -e "${blue}${bold}Quel est le nom du site ?${normal}"
read siteName
#      2.b. Son nom d'utilisateur admin (pour se connecter à son Wordpress)
ligne
echo -e "${blue}${bold}Quel est le nom du d'utilisateur admin ?${normal}"
read adminName
#      2.c. Son mot de passe admin (pour se connecter à son Wordpress)
ligne
echo -e "${blue}${bold}Quel est le mot de passe admin ?${normal}"
read adminPass

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod 777 wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

ligne
wp --info
ligne
echo -e "${green}${bold}installation wordpress réussie !${normal}"
ligne

sleep 1
ligne
echo -e "${cyan}${bold}téléchargement de wordpress${normal}"
ligne
wp core download

ligne
echo -e "${cyan}${bold}configuration de wordpress${normal}"
ligne
wp config create --dbname=wordpress --dbuser=root --dbpass=0000 --dbhost=localhost --allow-root

ligne
echo -e "${cyan}${bold}installation du site $siteName${normal}"
ligne
wp core install --url=192.168.33.10 --title='$siteName' --admin_user='$adminName' --admin_password='$adminPass' --admin_email='admin@admin.fr' --skip-email

sudo service apache2 restart
ligne
echo -e "${green}${bold}installation du site $siteName réussie !${normal}"
ligne


#Une fois le Wordpress fonctionnel et mis en place
#(donc BIEN s'assurer que tout fonctionne avant de passer à cette étape):

#3. Interaction avec les thèmes:
#		3.a. Ajout de thèmes
#    3.b. Suppression de thèmes
#    3.c. Activation du thème
#    3.d. Lui permettre la possibilité de CHERCHER un thème, qui lui
#retournera un tableau avec le slug lui permettant d'installer ce dit-thème

ligne
echo -e "${blue}${bold}Voulez vous installer un thème ?${normal}"
ligne
choiceTheme="";
select choix in "oui" "non";
do
  case $choix in
    oui ) choiceTheme="1";break;;
    non ) choiceTheme="2";break;;
  esac
done

if [ "$choiceTheme" == "1" ]
then
  ligne
  echo -e "${blue}${bold}Quel thème choisissez vous ?${normal}"
  read theme
  ligne
  echo -e "${blue}${bold}Thèmes disponibles :${normal}"
  wp theme search --fields=name,slug $theme
  ligne
  echo -e "${blue}${bold}Entrez le slug correspondant :${normal}"
  read installTheme
  wp theme install $installTheme
  ligne
  echo -e "${green}${bold}Votre thème à été installé avec succès !${normal}"


  #4. Interaction avec les plugins:
  #		4.a. Exactement les 4 intitulés que pour les thèmes
  #    4.b. Désactivation d'un plugin choisi

  ligne
  echo -e "${blue}${bold}Voulez vous installer un plugin ?${normal}"
  ligne
  choicePlugin="";
  select choix in "oui" "non";
  do
    case $choix in
      oui ) choicePlugin="1";break;;
      non ) choicePlugin="2";break;;
    esac
  done

  if [ "$choicePlugin" == "1" ]
  then
    ligne
    echo -e "${blue}${bold}Quel plugin choisissez vous ?${normal}"
    read plugin
    ligne
    echo -e "${blue}${bold}Plugin disponibles :${normal}"
    wp plugin search --fields=name,slug $plugin
    ligne
    echo -e "${blue}${bold}Entrez le slug correspondant :${normal}"
    read installPlugin
    wp plugin install $installPlugin
    ligne
    echo -e "${green}${bold}Votre plugin à été installé avec succès !${normal}"


  fi

fi
ligne
  echo -e "votre configuration graphique est terminée"



#Le script est à mettre sur un Github (pour vous refaire bosser un peu Github),
#et c'est un travail à faire à DEUX
#Bon chance :)
