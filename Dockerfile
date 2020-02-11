FROM ubuntu:eoan
#docker build . -t "normies:t1"
#docker run -it "normies:t1" bash

ARG DEV

WORKDIR /usr/local/src/

#EXPOSE 25

ENV DEV=${DEV}

RUN apt update \
	&& apt install --yes \
		sudo \
		build-essential \
		git \
		file \
		cmake \
		extra-cmake-modules \
		software-properties-common \
		libelf-dev\
	&& if [ "$DEV" = true ]; then \
		apt install --yes vim telnet; \
	fi

COPY . normies/

RUN mkdir normies/build \
	&& cd normies/build \
	&& cmake -DINSTALL_BUILD_TIME_DEP=TRUE .. \
	&& make pack

#RUN git clone https://github.com/conformism/normies \
#	&& mkdir normies/build \
#	&& cd normies \
#	&& git apply *.patch \
#	&& echo > pack/normies-dev/dependencies.debian \
#	&& cd build \
###	&& cd normies/build \
#	&& cmake -DINSTALL_BUILD_TIME_DEP=TRUE .. \
#	&& make pack

CMD bash
#CMD supervisord -c /etc/supervisord.conf

