FROM vm-griffin-104.asl.lab.emc.com:5000/ubuntu:xenial

MAINTAINER Henry Leong

RUN apt-get update && apt-get -y --no-install-recommends install \
    sudo \
    ca-certificates \
    curl

ENV GOSU_VERSION 1.9

RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
    && chmod +x /usr/local/bin/gosu

COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

RUN echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /home/user

CMD /bin/bash --login

#################################################

RUN apt-get update && apt-get -y --no-install-recommends install \
    wget \
    tar \
    rpm \
    nano \
    vim-gtk \
    emacs \
    git \
    ssh

ENV INSTALL_HOME=/opt/emc
RUN mkdir -p $INSTALL_HOME

##########################################
##  add dependencies
##########################################

RUN apt-get update && apt-get -y --no-install-recommends install \
    libgtk2.0-0 \
    libxtst6 \
    libnotify4 \
    libgconf-2-4 \
    libasound2 \
    libxss1 \
    dnsutils \
    bzip2 \
    python \
    build-essential \
    libkrb5-dev \
    xz-utils

##########################################
##  java and mvn
##########################################

RUN mkdir -p $INSTALL_HOME/apps/java \
    && export jdkfile="jdk-8u91-linux-x64.tar.gz" \
    && export jdkurl="http://vm-griffin-104.asl.lab.emc.com/docker/apps/$jdkfile" \
    && curl -SL $jdkurl | tar xvz --directory $INSTALL_HOME/apps/java


ENV JAVA_HOME=$INSTALL_HOME/apps/java/jdk1.8.0_91
ENV PATH=$INSTALL_HOME/bin:$JAVA_HOME/bin:$PATH

ENV MVN_HOME=$INSTALL_HOME/apps/maven-toolchain-3.3
RUN mkdir $MVN_HOME \
    && export mvnurl="https://ap-ir.lss.emc.com/artifactory/public/com/emc/brs/maven/maven-toolchain/3.3/maven-toolchain-3.3.tar.gz" \
    && curl --insecure -SL $mvnurl | tar xvz --directory $MVN_HOME \
    && sed -i -e 's/ap-sc/ap-ir/g' $MVN_HOME/tools/maven/apache-maven-3.3.9/conf/settings.xml

ENV PATH=$MVN_HOME/tools/bin:$PATH

RUN mvn mdev:prepare-environment
RUN mvn mdev:install-eclipse -Dtodir=$INSTALL_HOME/apps/eclipse 
    
RUN mkdir $INSTALL_HOME/bin \
    && ln -s $INSTALL_HOME/apps/eclipse/*/eclipse/eclipse $INSTALL_HOME/bin/eclipse

ENV JNAERATOR_INCLUDE_PATH=/usr/include:/usr/include/x86_64-linux-gnu:/usr/lib/gcc/x86_64-linux-gnu/5/include

##########################################
##  git
##########################################

RUN mkdir $INSTALL_HOME/git-certs \
    && curl http://ap.lss.emc.com/bootstrap/pki/certs/EMC_Root_CA.pem > $INSTALL_HOME/git-certs/EMC_CA.pem \
    && curl http://ap.lss.emc.com/bootstrap/pki/certs/EMC_SSL_CA_b60fcefc.pem >> $INSTALL_HOME/git-certs/EMC_CA.pem

COPY scripts/setup-git.sh $INSTALL_HOME/bin
COPY scripts/git-prompt.sh /etc/profile.d

##########################################
##  node.js v6.9.1
##########################################

RUN mkdir -p $INSTALL_HOME/apps/nodejs \
    && export nodefile="node-v6.9.1-linux-x64.tar.xz" \
    && export nodeurl="http://vm-griffin-104.asl.lab.emc.com/docker/apps/$nodefile" \
    && curl -SL $nodeurl | tar xvJ --directory $INSTALL_HOME/apps/nodejs

ENV PATH=$INSTALL_HOME/apps/nodejs/node-v6.9.1-linux-x64/bin:$PATH

RUN npm install -g \
    bower \
    gulp

##########################################
##  mongodb 3.2.11
##########################################

RUN mkdir -p $INSTALL_HOME/apps/mongodb \
    && export mongofile="mongodb-linux-x86_64-ubuntu1604-3.2.11.tgz" \
    && export mongourl="http://vm-griffin-104.asl.lab.emc.com/docker/apps/$mongofile" \
    && curl -SL $mongourl | tar xvz --directory $INSTALL_HOME/apps/mongodb

ENV PATH=$INSTALL_HOME/apps/mongodb/mongodb-linux-x86_64-ubuntu1604-3.2.11/bin:$PATH

COPY scripts/start-mongodb.sh $INSTALL_HOME/bin


##########################################
##  golang
##########################################

ENV GOROOT=$INSTALL_HOME/apps/golang/go

RUN mkdir -p $INSTALL_HOME/apps/golang \
    && export gofile="go1.7.3.linux-amd64.tar.gz" \
    && export gourl="http://vm-griffin-104.asl.lab.emc.com/docker/apps/$gofile" \
    && curl -SL $gourl | tar xvz --directory $INSTALL_HOME/apps/golang \
    && ln -s $GOROOT/bin/go $INSTALL_HOME/bin/go \
    && ln -s $GOROOT/bin/godoc $INSTALL_HOME/bin/godoc \
    && ln -s $GOROOT/bin/gofmt $INSTALL_HOME/bin/gofmt


##########################################
##  vscode
##########################################

RUN mkdir -p $INSTALL_HOME/apps/vscode \
    && export vscodefile="code-stable-code_1.7.2-1479766213_amd64.tar.gz" \
    && export vscodeurl="http://vm-griffin-104.asl.lab.emc.com/docker/apps/$vscodefile" \
    && curl -SL $vscodeurl | tar xvz --directory $INSTALL_HOME/apps/vscode \
    && ln -s $INSTALL_HOME/apps/vscode/*/bin/code $INSTALL_HOME/bin/code


##########################################
##  profile.d scripts for login
##########################################
COPY scripts/motd.sh /etc/profile.d
COPY scripts/startup-user.sh /etc/profile.d

