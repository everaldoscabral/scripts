#!/bin/bash
# ESCRITO POR SANSAO

if [ `whoami` != "zabbix" ] ; then
        echo ""
        echo "voce deve estar logado com o user zabbix para continuar."
        echo "Se nunca logou com ele, execute o comando em seguida logue"
        echo ""
        echo "sudo usermod -s /bin/bash zabbix ; sudo passwd zabbix"
        echo ""
		exit
fi

SCRIPTS=/usr/lib/zabbix/alertscripts/
DISTRO=/etc/redhat-release
PROJETO=Telegram-Graph-authenticated_Python
URLGIT=https://github.com/sansaoipb/$PROJETO


if [ ! -e $PROJETO ]
then
  git clone $URLGIT
fi

cd $PROJETO ; sudo unzip telegram.zip ; sudo rm -rf README.md ; cd telegram ; sudo chmod +x telegram-cli* ; cd /tmp/

if [ -e $DISTRO ]
then
  cd $PROJETO/telegram ; sudo mv telegram-cli.CentOS telegram-cli ; sudo yum install -y python-requests.noarch openssl098e.x86_64 python34-libs libconfig-devel readline-devel libevent-devel lua-devel python-devel unzip git make ; sudo ln -s /usr/lib64/liblua-5.1.so /usr/lib64/liblua5.2.so.0 ; sudo ln -s /usr/lib64/libcrypto.so.0.9.8e /usr/lib64/libcrypto.so.1.0.0
else
  cd $PROJETO/telegram ; sudo rm -rf telegram-cli.CentOS ; sudo apt-get install -y python-requests libreadline-dev libconfig-dev libssl-dev libevent-dev libjansson-dev libpython-dev libpython3-all-dev liblua5.2-0 git unzip make ; pip install requests
fi

if [ -e $SCRIPTS ]
then
  PATHSCRIPTS=/usr/lib/zabbix/alertscripts
else
  PATHSCRIPTS=/usr/local/share/zabbix/alertscripts
fi

cd .. ; sudo cp -R telegram* $PATHSCRIPTS ; cd $PATHSCRIPTS ; sudo chmod +x $PATHSCRIPTS/*.py ; cd .. ; sudo chown -R zabbix. *

replace 'config_directory = "/etc/zabbix/scripts/telegram/";' 'config_directory = '$PATHSCRIPTS'/telegram/;' -- $PATHSCRIPTS/telegram/telegram.config
echo ""
echo "Acesse"
echo ""
echo "cd $PATHSCRIPTS/telegram"
echo ""
echo "para começar a configuração"
echo ""
