# Image Location
FROM node:11.14.0-alpine

ENV DEV=developer \
    DEV_HOME=/home/${DEV} \
    uid=1000 gid=1000

# CREATE AN COMPLETE USER ACCOUNT
RUN mkdir -p ${DEV_HOME} ${DEV_HOME}/app && \
    echo "${DEV}:x:${uid}:${gid}:${DEV},,,:${DEV_HOME}:/bin/bash" >> /etc/passwd && \
    echo "${DEV}:x:${uid}:" >> /etc/group &&\
    rm -rf /var/cache/apk/*

# ASSIGN CURRENT WORKSPACE
WORKDIR ${DEV_HOME}/app

# INIT NODE APP
COPY package.json .
RUN yarn && ls
COPY . .

# CONNECT AS DEV USER
USER ${DEV}

# ASSIGN NEW REPO TO DEV USER
RUN chmod +x ${DEV_HOME}/app/App.js
ENTRYPOINT [ "yarn", "prod" ]

# -------- NGINX --------

#FROM nginx
#RUN mkdir /app
#COPY --from=0 /home/${DEV}/app /app
#COPY webservice-conf/nginx.conf /etc/nginx/nginx.conf

#WORKDIR /app

#ENTRYPOINT [ "yarn", "prod" ]
