FROM opensuse/leap:15.4
LABEL maintainer "Michał Gryniak <mgryniak@gmail.com>"
ENV TZ UTC
#=================================================
# Clean packages
RUN zypper clean -a 
#-------------------------------------------------
# Base packages
RUN zypper refresh 
RUN zypper install -y --no-recommends \
        zip unzip tar gzip wget mc htop jq supervisor openssh-server go
#-------------------------------------------------
# Set locale
ENV LANG en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
#-------------------------------------------------
# Configure supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
#-------------------------------------------------
# Configure ssh
RUN mkdir -p /run/sshd
RUN sed -i "s/#PasswordAuthentication/PasswordAuthentication/g" /etc/ssh/sshd_config
RUN ssh-keygen -A
#-------------------------------------------------
# Configure users
RUN useradd -m -d /home/dev -s /bin/bash dev
RUN echo "dev:devDev1234;" | chpasswd
#-------------------------------------------------
# Clean image
RUN zypper clean -a 
#=================================================
EXPOSE 22
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
