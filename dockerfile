from ubuntu:latest
ARG wise_home=/elba


#Move Elba Directory
COPY WISETutorial /elba
WORKDIR /elba

RUN  apt-get update -y

# Set up Python 3 environment.
#Python dependencies
RUN apt-get install -y virtualenv && \
    virtualenv -p `which python3` $wise_home/.env
RUN /bin/bash -c "source $wise_home/.env/bin/activate && \
    pip install click && \
    pip install psycopg2-binary && \
    pip install thrift"

RUN apt install git gnupg curl -y

# Install Postgresql cli V10
RUN set -x; \
		echo "deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
		&& curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
		&& apt-get update \
		&& apt-get install -y postgresql-client-10
        

RUN apt-get install libboost-dev libboost-test-dev libboost-program-options-dev libboost-filesystem-dev libboost-thread-dev libevent-dev automake libtool flex bison pkg-config g++ libssl-dev -y && \
 git clone https://git-wip-us.apache.org/repos/asf/thrift.git thrift && \
 cd thrift && \
 ./bootstrap.sh && \
 ./configure && \
  make && \
  make install

RUN  cd $wise_home/WISEServices/auth/src && \
    rm -rf py/gen_auth && \
    mkdir py/gen_auth && \
    thrift -r --gen py -out py/gen_auth spec.thrift


 CMD $wise_home/WISEServices/auth/scripts/start_server.sh py 0.0.0.0 $AUTH_PORT $AUTH_THREADPOOLSIZE $POSTGRESQL_HOST