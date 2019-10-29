# -------- Node -------------
FROM node:11.14.0-alpine

ENV DEV=developer \
    DEV_HOME=/home/${DEV} \
    uid=1002 gid=1002 \
    PM2_REPO=/home/.pm2

RUN ln -s /usr/bin/nodejs /usr/sbin/node

# CREATE AN COMPLETE USER ACCOUNT
RUN mkdir -p ${DEV_HOME} ${DEV_HOME}/app &&\
    apk update && apk add bash

# ASSIGN CURRENT WORKSPACE
WORKDIR ${DEV_HOME}/app

# INIT NODE APP
COPY package.json .
RUN yarn && ls
COPY . .

RUN adduser -D -u ${uid} -g '${DEV}' ${gid}

# ASSIGN NEW REPO TO DEV USER
# ADD PM2 requirement user access
RUN ls && chmod +x ${DEV_HOME}/app/App.js &&\
    npx pm2 update &&\
    mkdir -p ${DEV_HOME} /home/.cache /home/.yarn &&\
    touch /tmp/.yarn-cache-1002 &&\
    chown -R ${uid}:${gid} /root/.pm2 /home/.cache \
    /tmp/.yarn-cache-1002 /usr/local /home/.yarn ${DEV_HOME}

# PM2 CONFIG
RUN mkdir -p ${PM2_REPO} && chown -R ${uid}:${gid} ${PM2_REPO}

#&&\adduser  -s /dev/null -D -H -g '${DEV}' nobody

EXPOSE 5148
RUN [ "npx", "pm2", "start", "-i", "${uid}", "ecosystem.config.yml" ]

# CONNECT AS DEV USER
USER ${uid}
#RUN su - developer
WORKDIR ${DEV_HOME}/app

EXPOSE 5418:5418
RUN ls
ENTRYPOINT [ "/bin/bash" ]

# -------- NGINX --------

#FROM nginx
#RUN mkdir /app
#COPY --from=0 /home/${DEV}/app /app
#COPY webservice-conf/nginx.conf /etc/nginx/nginx.conf

#WORKDIR /app

#ENTRYPOINT [ "yarn", "prod" ]
