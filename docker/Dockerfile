# sshd
#
# VERSION               0.0.1

FROM     drecom/centos-base:latest

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
RUN 3scale_toolbox/gem build 3scale_toolbox.gemspec \
&& gem build 3scale_toolbox.gemspec 

ENV NODE_TLS_REJECT_UNAUTHORIZED=0 

# Install 3Scale-cli
RUN npm install -g node-3scale-cli
# Create credentials.json
RUN mkdir $HOME\.3scale
RUN echo '{
    "threescale": {
    "id": "3scale",
    "access_token": "XXXXXXXXXXXXXX",
    "wildcard": "5.9.12.13.xip.io"
  }
}' >> $HOME.3scale/credentials.json

# Setup execution permisssions on scripts
RUN chmod 711 /cicd/swaggers/*


