FROM ubuntu
RUN apt-get -qq update && apt-get -qq install curl
CMD echo "Input website:"; read website; echo "Searching.."; sleep 1; curl http://$website;
