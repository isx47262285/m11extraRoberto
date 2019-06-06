#! /bin/bash
useradd pere
useradd marta
echo "pere" | passwd --stdin pere
echo "marta" | passwd --stdin marta

cp /opt/docker/marta /var/spool/mail/marta
chown marta.mail /var/spool/mail/marta
cp /opt/docker/pere /var/spool/mail/pere
chown pere.mail /var/spool/mail/pere
cp /opt/docker/xinetd.d/* /etc/xinetd.d/

