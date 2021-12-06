ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN \
    ALPINE_MIN_VERSION="$(cat /etc/alpine-release | cut -d'.' -f1,2)" && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

# Install requirements for add-on
RUN apk add --no-cache --update-cache cups cups-libs cups-client cups-filters cups-pdf hplip

# Change the config file
RUN sed -i 's/<Location \/>/<Location \/>\n  Allow All/' /etc/cups/cupsd.conf && \
	  sed -i 's/<Location \/admin>/<Location \/admin>\n  Allow All\n  Require user @SYSTEM/' /etc/cups/cupsd.conf && \
	  sed -i 's/<Location \/admin\/conf>/<Location \/admin\/conf>\n  Allow All/' /etc/cups/cupsd.conf && \
    echo -e "ServerAlias *\nDefaultEncryption Never\nDirtyCleanInterval 5" >> /etc/cups/cupsd.conf && \
    echo -e "AccessLog stdout\nPageLog stdout\nErrorLog stderr" >> /etc/cups/cupsd.conf

# Copy data for add-on
COPY start-cups.sh /
RUN chmod a+x /start-cups.sh

EXPOSE 631
CMD ["/start-cups.sh"]