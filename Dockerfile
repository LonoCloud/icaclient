# Start with:
# docker run --rm --name icaclient -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY="$DISPLAY" icaclient
# then open about:addons in firefox and set ica-client to "allways activate"
FROM ubuntu:latest
MAINTAINER Marc Wäckerlin

WORKDIR /tmp/install
ADD icaclient_*.deb icaclient.deb
RUN dpkg --add-architecture i386
RUN apt-get -y update
RUN apt-get -y install firefox openssh-server
RUN dpkg -i icaclient.deb || apt-get -y -f install
RUN ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/
RUN c_rehash /opt/Citrix/ICAClient/keystore/cacerts/
RUN rm -f /usr/lib/mozilla/plugins/npwrapper.npica.so \
          /usr/lib/firefox/plugins/npwrapper.npica.so \
          /usr/lib/mozilla/plugins/npica.so
RUN ln -s /opt/Citrix/ICAClient/npica.so /usr/lib/firefox-addons/plugins/npica.so

RUN useradd -m browser
USER browser
WORKDIR /home/browser

RUN mkdir .ICAClient
ADD wfclient.ini .ICAClient/wfclient.ini

USER browser
CMD firefox --new-instance
