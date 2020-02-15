FROM ubuntu:eoan
#docker build . -t normies:t1
#docker run -v $PWD/out:/opt/normies/build/out -t normies:t1

ARG DEV

WORKDIR /opt

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
		apt install --yes vim; \
	fi

COPY . normies/

RUN mkdir normies/build

WORKDIR /opt/normies/build

CMD cmake -DINSTALL_BUILD_TIME_DEP=TRUE .. \
	&& make deploy

#RUN git clone https://github.com/conformism/normies \
#	&& mkdir normies/build \
#	&& cd normies/build \
#	&& cmake -DINSTALL_BUILD_TIME_DEP=TRUE .. \
#	&& make deploy

#CMD bash
#CMD supervisord -c /etc/supervisord.conf

