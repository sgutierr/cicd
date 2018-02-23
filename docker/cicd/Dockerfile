# sshd
#
# VERSION               0.0.1

FROM centos:7
ENV container docker

#
# Delete a number of unit files which might cause issues. From here, you are ready to build your base image.
#

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]


#
# MW tool installations 
#

RUN yum install -y \
    openssl-devel \
    wget \
    curl \
    git \
    dtach \
    vim \
    bzip2 \
    tar \
    gcc \
    g++ \ 
    make \ 
    automake \ 
    autoconf \ 
    readline-devel \
    curl-devel \
    openssl-devel \ 
    zlib-devel \ 
    httpd-devel \
    apr-devel \
    apr-util-devel \
    sqlite-devel \
    libffi-devel \
    libxslt-devel \
    rubygems \
    python \
    ruby \
    &&  yum groupinstall "Development Tools" -y \
&&  yum clean all

# node.js LTS install
RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash - \
    && yum -y install nodejs \
    && npm -g up


# dockerize install
ENV DOCKERIZE_VERSION v0.6.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
&&  tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
&&  rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz


#
# 3Scale CLI tools
#

RUN git clone git://github.com/rbenv/rbenv.git /usr/local/rbenv \
&&  git clone git://github.com/rbenv/ruby-build.git /usr/local/rbenv/plugins/ruby-build \
&&  git clone git://github.com/jf/rbenv-gemset.git /usr/local/rbenv/plugins/rbenv-gemset \
&&  git clone git://github.com/3scale/3scale_toolbox.git \
&&  git clone git://github.com/3scale/3scale-cli \
&&  git clone git://github.com/sgutierr/cicd.git \
&&  /usr/local/rbenv/plugins/ruby-build/install.sh
ENV PATH /usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv

RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh \
&&  echo 'export PATH=/usr/local/rbenv/bin:$PATH' >> /etc/profile.d/rbenv.sh \
&&  echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh

RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /root/.bashrc \
&&  echo 'export PATH=/usr/local/rbenv/bin:$PATH' >> /root/.bashrc \
&&  echo 'eval "$(rbenv init -)"' >> /root/.bashrc

ENV CONFIGURE_OPTS --disable-install-doc
ENV PATH /usr/local/rbenv/bin:/usr/local/rbenv/shims:$PATH

RUN eval "$(rbenv init -)"; rbenv install 2.4.3 \
&&  eval "$(rbenv init -)"; rbenv global 2.4.3 \
&&  eval "$(rbenv init -)"; gem update --system \
&& eval "$(rbenv init -)"; gem install bundler -f

# Install 3Scale toolbox
RUN gem install 3scale_toolbox

ENV NODE_TLS_REJECT_UNAUTHORIZED=0 

# Install 3Scale-cli
RUN npm install -g node-3scale-cli
# Create credentials.json
RUN cd $HOME; mkdir .3scale

# Install CMS tool
RUN cd /cicd/cms; gem install 3scale-cms-0.1.1.gem

# Setup execution permisssions on scripts
RUN chmod 711 /cicd/scripts/*

# Patch for 3Scale-api 
RUN cp -f /cicd/3scale-api-ruby/*.rb /usr/local/rbenv/versions/2.4.3/lib/ruby/gems/2.4.0/gems/3scale-api-0.1.5/lib/3scale/api

# swagger installation
RUN npm install -g swagger; cd /cicd/nodejs/3scale-cicd-api; swagger project start

