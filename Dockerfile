# ====================================================================== #
# Android SDK Docker Image
# ====================================================================== #

# Base image
# ---------------------------------------------------------------------- #
FROM alpine:3.11.5

# Author
# ---------------------------------------------------------------------- #
LABEL maintainer "john@kerryhouse.net"

# update ca certs
RUN apk update \
    apk add ca-certificates \
    update-ca-certificates

# install basic dependencies
RUN apk update \
    apk upgrade \
    apk add tar

# download sensuctl
RUN wget https://s3-us-west-2.amazonaws.com/sensu.io/sensu-go/5.19.1/sensu-go_5.19.1_linux_amd64.tar.gz -O /tmp/sensu-go.tar.gz

RUN tar xvf /tmp/sensu-go.tar.gz --directory /usr/bin && \
    rm /tmp/sensu-go.tar.gz

RUN wget https://get.helm.sh/helm-v3.2.0-rc.1-linux-amd64.tar.gz -O /tmp/helm.tar.gz

RUN tar xvf /tmp/helm.tar.gz --directory /tmp && \
    mv /tmp/linux-amd64/helm /usr/bin/. && \
    rm /tmp/helm.tar.gz && \
    rm -rf /tmp/linux-amd64

CMD tail -f /dev/null

# # download and install Gradle
# # https://services.gradle.org/distributions/
# ARG GRADLE_VERSION=6.1.1
# ARG GRADLE_DIST=bin
# RUN cd /opt && \
#     wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-${GRADLE_DIST}.zip && \
#     unzip gradle*.zip && \
#     ls -d */ | sed 's/\/*$//g' | xargs -I{} mv {} gradle && \
#     rm gradle*.zip

# # download and install Kotlin compiler
# # https://github.com/JetBrains/kotlin/releases/latest
# ARG KOTLIN_VERSION=1.3.61
# RUN cd /opt && \
#     wget -q https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip && \
#     unzip *kotlin*.zip && \
#     rm *kotlin*.zip

# # download and install Android SDK
# # https://developer.android.com/studio/#downloads
# ARG ANDROID_SDK_VERSION=4333796
# ENV ANDROID_HOME /opt/android-sdk
# RUN mkdir -p ${ANDROID_HOME} && cd ${ANDROID_HOME} && \
#     wget -q https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip && \
#     unzip *tools*linux*.zip && \
#     rm *tools*linux*.zip

# # download and install nodejs
# RUN apt-get install -yq nodejs build-essential

# # download and install yarn
# RUN apt install yarn

# # set the environment variables
# ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
# ENV GRADLE_HOME /opt/gradle
# ENV KOTLIN_HOME /opt/kotlinc
# ENV PATH ${PATH}:${GRADLE_HOME}/bin:${KOTLIN_HOME}/bin:${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools/bin
# ENV _JAVA_OPTIONS -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap
# # WORKAROUND: for issue https://issuetracker.google.com/issues/37137213
# ENV LD_LIBRARY_PATH ${ANDROID_HOME}/emulator/lib64:${ANDROID_HOME}/emulator/lib64/qt/lib

# # accept the license agreements of the SDK components
# ADD license_accepter.sh /opt/
# RUN chmod +x /opt/license_accepter.sh && /opt/license_accepter.sh $ANDROID_HOME

# # setup adb server
# EXPOSE 5037

# # install and configure SSH server
# EXPOSE 22
# ADD sshd-banner /etc/ssh/
# ADD authorized_keys /tmp/
# RUN apt-get update -y && \
#     apt-get install -y --no-install-recommends openssh-server supervisor locales && \
#     mkdir -p /var/run/sshd /var/log/supervisord && \
#     locale-gen en en_US en_US.UTF-8 && \
#     apt-get remove -y locales && apt-get autoremove -y && \
#     FILE_SSHD_CONFIG="/etc/ssh/sshd_config" && \
#     echo "\nBanner /etc/ssh/sshd-banner" >> $FILE_SSHD_CONFIG && \
#     echo "\nPermitUserEnvironment=yes" >> $FILE_SSHD_CONFIG && \
#     ssh-keygen -q -N "" -f /root/.ssh/id_rsa && \
#     FILE_SSH_ENV="/root/.ssh/environment" && \
#     touch $FILE_SSH_ENV && chmod 600 $FILE_SSH_ENV && \
#     printenv | grep "JAVA_HOME\|GRADLE_HOME\|KOTLIN_HOME\|ANDROID_HOME\|LD_LIBRARY_PATH\|PATH" >> $FILE_SSH_ENV && \
#     FILE_AUTH_KEYS="/root/.ssh/authorized_keys" && \
#     touch $FILE_AUTH_KEYS && chmod 600 $FILE_AUTH_KEYS && \
#     for file in /tmp/*.pub; \
#     do if [ -f "$file" ]; then echo "\n" >> $FILE_AUTH_KEYS && cat $file >> $FILE_AUTH_KEYS && echo "\n" >> $FILE_AUTH_KEYS; fi; \
#     done && \
#     (rm /tmp/*.pub 2> /dev/null || true)

# ADD supervisord.conf /etc/supervisor/conf.d/
# CMD ["/usr/bin/supervisord"]