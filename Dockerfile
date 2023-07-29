FROM node:18.10-alpine3.16

# install zsh
RUN apk update && \
    apk add zsh git make vim zsh-autosuggestions zsh-syntax-highlighting bind-tools curl && \
    rm -rf /var/cache/apk/*

# install oh-my-zsh
RUN sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

ENV PATH="$PATH:./node_modules/.bin"

WORKDIR /kb
ENTRYPOINT [ "/bin/zsh" ]