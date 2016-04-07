FROM debian:jessie
Maintainer Peter

RUN apt-get update && apt-get -y upgrade && apt-get -y install abcde && apt-get autoclean

RUN cat /bin/autorip.sh << EOF \
#/bin/bash
PATH=$PATH:/bin/abcde:/bin/autorip.sh \
/bin/abcde -NVP | \
tee /var/log/autorip.log & \
exit
EOF && chmod 750 /bin/autorip.sh
RUN cat /etc/udev/rules.d/99-autorip.rules << EOF \
SUBSYSTEM=="block", KERNEL=="sr0", ENV{ID_CDROM_MEDIA_CD}=="1", RUN+="/bin/autorip.sh"
EOF
ADD abcde.conf /etc/abcde.conf
