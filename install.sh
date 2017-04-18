#!/bin/bash
# https://vestacp.com/pub/vst-install.sh
# https://vestacp.com/pub/vst-install-rhel.sh

#----------------------------------------------------------#
#                  Variables&Functions                     #
#                       变量&功能                            #
#----------------------------------------------------------#

CHOST='c.vestacp.com'
VERSION='rhel'
release=$(grep -o "[0-9]" /etc/redhat-release |head -n1)
vestacp="http://$CHOST/$VERSION/$release"
# http://c.vestacp.com/rhel/6


#----------------------------------------------------------#
#                      Configure Exim                      #
#----------------------------------------------------------#

gpasswd -a exim mail
wget $vestacp/exim/exim.conf -O /etc/exim/exim.conf
wget $vestacp/exim/dnsbl.conf -O /etc/exim/dnsbl.conf
wget $vestacp/exim/spam-blocks.conf -O /etc/exim/spam-blocks.conf
touch /etc/exim/white-blocks.conf

# if [ "$spamd" = 'yes' ]; then
#     sed -i "s/#SPAM/SPAM/g" /etc/exim/exim.conf
# fi
# if [ "$clamd" = 'yes' ]; then
#     sed -i "s/#CLAMD/CLAMD/g" /etc/exim/exim.conf
# fi

chmod 640 /etc/exim/exim.conf
rm -rf /etc/exim/domains
mkdir -p /etc/exim/domains

rm -f /etc/alternatives/mta
ln -s /usr/sbin/sendmail.exim /etc/alternatives/mta
chkconfig sendmail off 2>/dev/null
service sendmail stop 2>/dev/null
chkconfig postfix off 2>/dev/null
service postfix stop 2>/dev/null

chkconfig exim on
service exim start
# check_result $? "exim start failed"

#----------------------------------------------------------#
#                     Configure Dovecot                    #
#----------------------------------------------------------#

gpasswd -a dovecot mail
wget $vestacp/dovecot.tar.gz -O /etc/dovecot.tar.gz
wget $vestacp/logrotate/dovecot -O /etc/logrotate.d/dovecot
cd /etc
rm -rf dovecot dovecot.conf
tar -xzf dovecot.tar.gz
rm -f dovecot.tar.gz
chown -R root:root /etc/dovecot*
chkconfig dovecot on
service dovecot start
# check_result $? "dovecot start failed"





