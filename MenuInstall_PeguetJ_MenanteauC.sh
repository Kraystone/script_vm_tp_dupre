#!/bin/bash

#Définition des couleurs, pas utile mais plus lisible
MARRON='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
#La fonction pause, assez utile pour .... mettre en pause
pause (){
    echo -e "${GREEN}Appuyer sur une touche ${NC}"
    read -p "$*"
}
#Test de l'user ID pour Root, si l'user n'est pas en root, le script s'arrete.
if [ "$(id -u)" != "0" ]; then
  echo -e "${RED}Tu n'es pas en root :'(${NC}"
  exit 1
fi
while :
do #Affichage du menu
echo -e "
${GREEN}---Menu du Script---${NC}

${MARRON}1- Update/Upgrade & installation des paquets.
2- Création d'utilisateurs.
3- SSH.
4- Configuration de la BDD.
5- Quitter le script --->[].${NC}
"
read chx_menu
stty echo
if [ $chx_menu = 1 ]; then # test si le numéro 1 est sélectionner.
  echo -e "${MARRON}1- Update/Upgrade & installation des paquets.${NC}" 
  debian=$(grep "Debian" /etc/issue | cut -c1-6)#Stocke la distribution des OS dans la variable debian
  if [[ $debian = Debian ]]; then #si l'OS est debian
    echo -e "${GREEN}Tu as Debian !${NC}"
    echo -e "${GREEN}Programme d'installation de Debian :)${NC}"
    debxport=$(grep "export maccent" /etc/bash.bashrc | cut -c8-14 | head -n 1)
    #stocke le résultat de la première ligne et des caractères 8 à 14 pour la recherche
    #"export maccent" du fichier bash.bashrc dans la variable debxport
    if [[ $debxport = maccent ]]; then #si debxport = maccent
      command > /dev/null 2>&1 #ne rien faire
    else #variable (certaine on servis pour des tests...)
       echo "#~~Variables~~#
export maccent=00:17:A4:4E:7B:7B
export usercent=jules
export ipcent=172.16.60.1
export userdeladebian=$(users | grep -i "leo")
export ipdeladebian=172.16.60.5" >> /etc/bash.bashrc
      source /etc/bash.bashrc #actualiser le fichier bash.bashrc
    fi
    cd /etc
    echo "WEB_Debian" > hostname #changer le nom de la machine
    cd /etc/apt/ #mise a jour des sources
    echo "deb http://deb.debian.org/debian/ stable main contrib non-free
    deb-src http://deb.debian.org/debian/ stable main contrib non-free

    deb http://deb.debian.org/debian/ stable-updates main contrib non-free
    deb-src http://deb.debian.org/debian/ stable-updates main contrib non-free" > sources.list

    echo -e "${GREEN}Les sources ont été modifiées (t'es maintenant sûr de pouvoir installer).${NC}"
    #Update upgrade des sources
    apt-get update -y --force-yes #update/upgrade
    apt-get upgrade -y --force-yes
    echo -e "${GREEN}Update/Upgrade effectués${NC}"
    #installation des paquets du serveur debian
    echo -e "${GREEN}La tu es sur le point d'installer des trucs !${NC}"
    #apt-get install net-tools
    #echo -e "${GREEN}ifconfig installé.${NC}"
    #Installation du paquet SSH
    apt-get install openssh-server -y --force-yes
    echo -e "${GREEN}Paquet SSH installé.${NC}"
    #Installation du paquet FTP
    apt-get install vsftpd -y --force-yes
    echo -e "${GREEN}Paquet FTP installé.${NC}"
    cd /etc
    if [ -d "/etc/vsftpd.conf" ];then
      rm /etc/vsftpd.conf
    fi
      touch /etc/vsftpd.conf #changer le fichier vsftpd
      echo "listen=NO
      listen_ipv6=YES
      anonymous_enable=NO
      local_enable=YES
      write_enable=YES
      local_umask=022
      dirmessage_enable=YES
      use_localtime=YES
      xferlog_enable=YES
      connect_from_port_20=YES
      chroot_local_user=YES
      secure_chroot_dir=/var/run/vsftpd/empty
      pam_service_name=vsftpd
      rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
      rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
      ssl_enable=NO
      allow_writeable_chroot=YES" > /etc/vsftpd.conf
      service restart vsftpd
    #Installation du paquet curl
    apt-get install curl -y --force-yes
    echo -e "${GREEN}Paquet curl installé.${NC}"
    #Installation du paquet Apache
    apt-get install apache2 -y --force-yes
    echo -e "${GREEN}Paquet Apache installé.${NC}"
    #Installation du paquet PHP.
    apt-get install php7.0 -y --force-yes
    echo -e "${GREEN}Paquet PHP7 installé.${NC}"
    apt-get install php -y --force-yes
    echo -e "${GREEN}Paquet PHP installé.${NC}"
    apt-get install php-mysql -y --force-yes
    echo -e "${GREEN}Paquet PHP-MySQL installé.${NC}"
    #apt-get install nmap
    #echo -e "${GREEN}Paquet Nmap installé.${NC}"
    cd /home/$userdeladebian
    if [ -d "/home/$userdeladebian/.ssh/" ];then #si .ssh/ est deja créer, ne rien faire
      command > /dev/null 2>&1
      echo -e "${GREEN}Répertoire .ssh/ déjà crée.${NC}"
    else #si .ssh/ n'est pas créer, le créer
      su -l $userdeladebian -c "mkdir .ssh/"
      echo -e "${GREEN}Répertoire .ssh/ crée.${NC}"
    fi
    cd .ssh/
    if [ -d "/home/$userdeladebian/.ssh/authorized_keys" ];then #si authorized_keys est deja créer, ne rien faire
      command > /dev/null 2>&1
      echo -e "${GREEN}Fichier authorized_keys déjà crée.${NC}"
    else #si authorized_keys n'est pas créer, le créer
      touch authorized_keys
      echo -e "${GREEN}Fichier authorized_keys crée.${NC}"
    fi
    chmod 755 -R /home/$userdeladebian/.ssh/ #ttribution des droits 755 a .ssh/
  else
##################################################################################################################################################################################
    echo -e "${GREEN}Tu as CentOS !${NC}"
    echo -e "${GREEN}Programme d'installation de CentOS :)${NC}"
    centxport=$(grep "export macdeb" /etc/bashrc | cut -c8-13)
    #stocke le résultat de la première ligne et des caractères 8 à 14 pour la recherche
    #"export macdeb" du fichier bashrc dans la variable centxport
    if [[ $centxport = macdeb ]]; then #si centxport = macdeb
      command > /dev/null 2>&1
    else #variable (certaine on servis pour des tests...)
    echo "#~~Variables~~#
export macdeb=00:17:A4:4E:79:A4
export userdeb=cedric
export ipdeb=172.16.60.5
export userdeladecent=$(users | grep -i "leo")
export ipdelacent=172.16.60.1" >> /etc/bashrc
    source /etc/bashrc
    fi
    cd /etc
    echo "BDD" > hostname
    yum -y update
    yum -y upgrade
    echo -e "${GREEN}Update/Upgrade effectués${NC}"
    echo -e "${GREEN}La tu es sur le point d'installer des trucs !${NC}"
    yum -y install net-tools
    #echo -e "${GREEN}ifconfig installé.${NC}"
    yum -y install nano
    echo -e "${GREEN}Nano installé.${NC}"
    #Installation du paquet SSH
    yum -y install openssh-clients
    echo -e "${GREEN}Paquet SSH installé.${NC}"
    #Installation du paquet FTP
    yum -y install vsftpd
    echo -e "${GREEN}Paquet FTP installé.${NC}"
    firewall-cmd --permanent --add-port=21/tcp
    firewall-cmd --permanent --add-service=ftp
    firewall-cmd --reload
    cd /etc
    if [ -d "/etc/vsftpd/vsftpd.conf" ];then
      rm /etc/vsftpd/vsftpd.conf
    fi
      touch /etc/vsftpd/vsftpd.conf
      echo "anonymous_enable=NO
      local_enable=YES
      write_enable=YES
      local_umask=022
      dirmessage_enable=YES
      xferlog_enable=YES
      connect_from_port_20=YES
      xferlog_std_format=YES
      chroot_local_user=YES
      listen=NO
      listen_ipv6=YES
      pam_service_name=vsftpd
      userlist_enable=YES
      tcp_wrappers=YES
      allow_writeable_chroot=YES" > /etc/vsftpd/vsftpd.conf
      systemctl enable vsftpd.service
      setbool -P ftp_home_dir on
      systemctl restart vsftpd
    #Installation du paquet curl
    yum -y install curl
    echo -e "${GREEN}Paquet curl installé.${NC}"
    #Installation du paquet MariaDB
    yum -y install mariadb-server
    echo -e "${GREEN}Paquet MariaDB installé.${NC}"
    #yum -y install nmap
    #echo -e "${GREEN}Paquet Nmap installé.${NC}" 
    cd /home/$userdeladecent
    if [ -d "/home/$userdeladecent/.ssh/" ];then
      command > /dev/null 2>&1
      echo -e "${GREEN}Répertoire .ssh/ déjà crée.${NC}"
    else
      su -l $userdeladecent -c "mkdir .ssh/"
      echo -e "${GREEN}Répertoire .ssh/ crée.${NC}"
    fi
    cd .ssh/
    if [ -d "/home/$userdeladecent/.ssh/authorized_keys" ];then
      command > /dev/null 2>&1
      echo -e "${GREEN}Fichier authorized_keys déjà crée.${NC}"
    else
      touch authorized_keys
      echo -e "${GREEN}Fichier authorized_keys crée.${NC}"
    fi
    chmod 755 -R /home/$userdeladecent/.ssh/
  fi
elif [ $chx_menu = 2 ]; then # test si le numéro 2 est sélectionner.
  echo -e "${MARRON}2- Création d'utilisateurs.${NC}"
  if [[ $debian = Debian ]]; then #si l'OS est debian
    if grep -i "adminweb" /etc/passwd;then #test pour voir si l'user existe deja
      userweb=1
      echo -e "${MARRON}L'utilisateur est déjà présent.${NC}"
    else
      userweb=0
      echo -e "${RED}L'utilisateur n'a pas été créer, vous allez le créer.${NC}"
    fi
    if [ $userweb == 0 ]; then
      adduser adminweb #création de l'utilisateur
      echo -e "${GREEN}Utilisateur adminweb crée.${NC}"
    fi
    unset userweb
  else
    if grep -i "adminbdd" /etc/passwd;then
      userbdd=1
      echo -e "${MARRON}L'utilisateur est déjà présent.${NC}"
    else
      userbdd=0
      echo -e "${RED}L'utilisateur n'a pas été créer, vous allez le créer.${NC}"
    fi
    if [ $userbdd == 0 ]; then
      adduser adminbdd
      passwd adminbdd
      echo -e "${GREEN}Utilisateur adminbdd crée.${NC}"
    fi
    unset userbdd
  fi
elif [ $chx_menu = 3 ]; then # test si le numéro 3 est sélectionner.
  echo -e "${MARRON}3- SSH.${NC}"
  if [[ $debian = Debian ]]; then
    chown -R $userdeladebian /home/$userdeladebian/.ssh/ #Attribution du dossier .ssh/ a l'user
    su -l $userdeladebian -c "ssh-keygen -t rsa" #génération des Clefs
    echo -e "${GREEN}Clefs générées.${NC}"
    ssh-copy-id -i /home/$userdeladebian/.ssh/id_rsa.pub $usercent@$ipcent #copies des clefs
    echo -e "${GREEN}Clefs copiées.${NC}"
  else
    chown -R $userdeladecent /home/$userdeladecent /.ssh/ #Attribution du dossier .ssh/ a l'user
    su -l $userdeladecent -c "ssh-keygen -t rsa" #génération des Clefs
    echo -e "${GREEN}Clefs générées.${NC}"
    ssh-copy-id -i /home/$userdeladecent/.ssh/id_rsa.pub $userdeb@$ipdeb #copies des clefs
    echo -e "${GREEN}Clefs copiées.${NC}"
  fi
elif [ $chx_menu = 4 ]; then # test si le numéro 4 est sélectionner.
  echo -e "${MARRON}4- MariaDB.${NC}"
  if [[ $debian == Debian ]]; then
    command > /dev/null 2>&1
  else #Cette partie n'est pas sensée se lancer sous debian, mais elle passe outre le test précédant
    echo -e "${GREEN}---Configuration de MariaDB---${NC}"
    yum install mariadb-server #Installe MariaDB
    sudo systemctl start mariadb #Lance le système MariaDB
    sudo systemctl enable mariadb #Active MariaDB a chaque démarrage de la machine
    firewall-cmd --add-port=3306/tcp #Ouverture du port 3306
    firewall-cmd --permanent --add-port=3306/tcp #Ouverture permanente du port 3306
    mysql -u root -e "create user adminbdd;" #Creation de l'user 'Adminbdd'
    mysql -u root -e "create database adventofcode;" #Création de la BDD marcachat
    mysql -u root -p adventofcode < adventofcode.sql #Import du script SQl dans la base de données Marcachat
    echo -e "${RED}Avant de CONTINUER !!!!${NC} transferer le fichier 'index.php' et donner la localisation de l'erreur d'accès"
    read location
    mysql -u root -e "GRANT ALL privileges ON marcachat.* TO 'adminbdd'@'$location';" #Ajouts des privilèges de AdminBDD sur la machine distante (serveur Web)
    echo -e "${GREEN}---- Voila MariaDB est configurée ! Félicitations ! A vous la joi des requetes ${RED}SANS CONCATENATION ! "
  fi
elif [ $chx_menu = 5 ]; then # test si le numéro 5 est sélectionner.

  echo -e "${RED}Tu nous quittes :c${NC}"
  reboot
  #exit 1
fi
done
