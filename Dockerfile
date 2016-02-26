# Start with:
# docker run --rm --name icaclient -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY="$DISPLAY" icaclient
# then open about:addons in firefox and set ica-client to "allways activate"
FROM ubuntu:latest
# MAINTAINER Marc Wäckerlin
MAINTAINER Chouser <chouser@lonocloud.com>

WORKDIR /tmp/install
COPY icaclient_*.deb icaclient.deb
RUN dpkg --add-architecture i386

# Need firefox and icaclient.deb for launch and use Citrix
# To provide the required certs, install openssl (to provide c_rehash) and
# ca-certificates.
# Xnest is used to protect the host X server from potential crashes caused by
# whatever wfica sends out, and also to avoid wfica's attempted use of MIT_SHM
# shared memory X protocol, which we don't have working from within the
# container.
# strace required to avoid Xnest crash (see xnest-wfica.sh)
# xclip may help users bridge the X clipboard from host to Xnest.
RUN apt-get -y update && apt-get -y install \
  ca-certificates \
  openssl \
  firefox \
  Xnest \
  x11-xserver-utils \
  xclip \
  && ( dpkg -i icaclient.deb || apt-get -y -f install ) \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN rm /tmp/install/icaclient.deb

RUN ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/
RUN c_rehash /opt/Citrix/ICAClient/keystore/cacerts/
RUN rm -f /usr/lib/mozilla/plugins/npwrapper.npica.so \
          /usr/lib/firefox/plugins/npwrapper.npica.so \
          /usr/lib/mozilla/plugins/npica.so
RUN ln -s /opt/Citrix/ICAClient/npica.so /usr/lib/firefox-addons/plugins/npica.so

# Have icaclient open in a Xnest window
RUN mv /opt/Citrix/ICAClient/wfica /opt/Citrix/ICAClient/wfica.orig
COPY xnest-wfica.sh /opt/Citrix/ICAClient/wfica

# Set browser plugin to "Always Activate"
RUN echo 'pref("plugin.state.npica", 2);' \
    > /usr/lib/firefox/defaults/pref/icaclient.js

RUN useradd -m browser
USER browser
WORKDIR /home/browser

# Add icaclient config
RUN mkdir .ICAClient
COPY wfclient.ini .ICAClient/wfclient.ini

COPY main.sh /home/browser/main.sh
CMD /home/browser/main.sh
