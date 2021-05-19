FROM fedora:33

#RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf
RUN yum install -y \
  cobbler \
  cobbler-web \
  dhcp\
  supervisor \
  net-tools 
RUN yum install -y pykickstart debmirror 
RUN yum install -y openssl

#httpd doesn't run without this
RUN /usr/libexec/httpd-ssl-gencerts

#COPY /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/pxelinux.0
COPY supervisord/supervisord.conf /etc/supervisord.conf
COPY supervisord/cobblerd.ini /etc/supervisord.d/cobblerd.ini
COPY supervisord/tftpd.ini /etc/supervisord.d/tftpd.ini
COPY supervisord/httpd.ini /etc/supervisord.d/httpd.ini
COPY dhcpd.conf  /etc/dhcp/dhcpd.conf 

EXPOSE 69 80 443 25151

#ENTRYPOINT /usr/bin/supervisord -c /etc/supervisord.conf
COPY first-sync.sh /usr/local/bin/first-sync.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh /usr/local/bin/first-sync.sh

ENTRYPOINT /entrypoint.sh