FROM debian:buster-20200514

ENV GOLANGVER=1.14.3
ENV NODEJSVER=12.17.0-1nodesource1

RUN apt-get -yq update
RUN apt-get -yq upgrade
RUN apt-get -yq autoremove
RUN apt-get -yq install python3-pip gnupg curl apt-transport-https fakeroot \
		dh-autoreconf make gcc g++ rsync ruby ruby-dev git sudo

# nodejs, postgres 10
RUN curl --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key | \
		apt-key add -
RUN echo "deb https://deb.nodesource.com/node_12.x buster main" | \
		tee /etc/apt/sources.list.d/nodesource.list
RUN curl --silent https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
		apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" | \
		tee /etc/apt/sources.list.d/pgdg.list
RUN apt-get -yq update
RUN apt-get -yq install nodejs=${NODEJSVER} postgresql-10

# terser, less, sass, typescript
RUN /usr/bin/npm install -g terser sass less clean-css less-plugin-clean-css \
		typescript

# go
RUN curl -o /tmp/go.tar.gz https://dl.google.com/go/go${GOLANGVER}.linux-amd64.tar.gz
RUN tar xvf /tmp/go.tar.gz -C /usr/local
RUN rm /tmp/go.tar.gz
RUN echo 'PATH=$PATH:/usr/local/go/bin' > /etc/profile.d/golang.sh
RUN chmod 644 /etc/profile.d/golang.sh

# goimports
RUN GOPATH=/root/go /usr/local/go/bin/go get golang.org/x/tools/cmd/goimports
RUN cp /root/go/bin/goimports /usr/bin

# jekyll and friends
RUN gem install pygments.rb rouge bundler jekyll

# pygments
RUN pip3 install Pygments

CMD ["/bin/bash"]

