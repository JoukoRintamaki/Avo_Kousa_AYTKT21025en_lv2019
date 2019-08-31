#!/bin/bash
set -x
DOCKERFILEFOLDER=1.06.Dockerfile
if [[ ! -e $DOCKERFILEFOLDER/Dockerfile ]]; then
	mkdir -p $DOCKERFILEFOLDER
	touch $DOCKERFILEFOLDER/Dockerfile
fi

cat > $DOCKERFILEFOLDER/Dockerfile << EOF
FROM devopsdockeruh/overwrite_cmd_exercise
ENTRYPOINT ["timeout","5s","./start.sh"]
CMD ["--clock 0"]
EOF

docker build --quiet --tag docker-clock $DOCKERFILEFOLDER 
docker run docker-clock
source dockercontainerprune.sh
