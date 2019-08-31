#!/bin/bash
set -x
DOCKERFILEFOLDER=1.07.Dockerfile
if [[ ! -e $DOCKERFILEFOLDER/Dockerfile ]]; then
	mkdir -p $DOCKERFILEFOLDER
	touch $DOCKERFILEFOLDER/Dockerfile
fi

cat > $DOCKERFILEFOLDER/Dockerfile << 'EOF'
FROM ubuntu
RUN apt-get -qq update && apt-get -qq install curl
CMD echo "Input website:"; read website; echo "Searching.."; sleep 1; curl http://$website;
EOF

docker build --quiet --tag curler $DOCKERFILEFOLDER 
echo helsinki.fi | docker run --interactive curler
source dockercontainerprune.sh
