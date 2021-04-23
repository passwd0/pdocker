#!/bin/bash


is_set_path_manually=false

## init parameter
_path=$(pwd)
if [[ -n $1 ]]; then
#	is_set_path_manually=true
	_path=$(pwd)${1}
fi
path_shared=$_path
#if [[ $(pwd) =~ .*/Hack/ctf/.* ]]; then
#	is_inside_ctf_path=true
#	_path=$(pwd);
#else
#	is_inside_ctf_path=false
#	_path=$(pwd);
#fi

## set name and path_shared
#if $is_inside_ctf_path; then
#	path_shared=$(cut -d/ -f-6 <<< ${_path})
#	name=$(basename $path_shared)
#else
#	path_shared=/tmp
	name=chronos
#fi
#if $is_set_path_manually; then # is correct keep it separate because should overwrite path_shared
#	path_shared=$_path
#fi

echo "instance name: $name"
echo "instance path: $path_shared"

## run docker
if [[ $(docker ps -f "name=${name}" | wc -l | xargs) == 1 ]]; then
	echo "creating new instance"
	docker run --privileged -dit \
		-h ${name} \
		--name ${name} \
		-v ${path_shared}:/home \
		--cap-add=SYS_PTRACE \
		--security-opt seccomp=unconfined \
		-p 3002:3002 \
		pdocker/ctf:1.4
fi

echo "starting instance"
echo "press a key..."
read
docker exec -it ${name} /bin/bash -c tmux
