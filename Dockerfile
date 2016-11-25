FROM java:8

ENV PORT=8080 \
    GRADLE_HOME=/usr/bin/gradle-2.9 \
    PATH=$PATH:/usr/bin/gradle-2.9/bin:/meta/.cli

EXPOSE 8080

ADD . /meta

WORKDIR /usr/bin

RUN wget -q https://services.gradle.org/distributions/gradle-2.9-bin.zip -O gradle.zip \
    && unzip -q gradle.zip \
    && rm gradle.zip \
    && wget https://nodejs.org/dist/v6.2.1/node-v6.2.1-linux-x64.tar.gz \
    && tar -xzf "node-v6.2.1-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
    && rm "node-v6.2.1-linux-x64.tar.gz" \
    && node -v \
    && npm -v \
    && curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/unlimited_jce_policy.zip "http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip" \
    && unzip -jo -d ${JAVA_HOME}/jre/lib/security /tmp/unlimited_jce_policy.zip \
    && cd /meta \
    && gradle build \
    && gradle test \
    && npm install -g gulp \
    && npm install -g newman \
    && npm install -g karma \
    && npm install -g karma-coverage \
    && npm install -g jasmine \
    && npm install -g istanbul \
    && npm install -g node-sass \
    && npm install -g git \
    && git config --global user.name CI-BuildBot \
    && git config --global user.email svc_DMSBUILD \
    && tar -xzf cf-cli*.tgz -C /usr/bin/ \
    && cd spring_1_3_0_sample \
    && gradle build \
    && gradle test \
    && cd ../spring_1_3_3_sample \
    && gradle build \
    && gradle test
