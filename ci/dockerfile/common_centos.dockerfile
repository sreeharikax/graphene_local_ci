ARG BUILD_OS

FROM quay.io/centos/centos:$BUILD_OS

RUN echo 'proxy=http://proxy-dmz.intel.com:911' >> /etc/yum.conf

RUN dnf distro-sync -y && dnf install 'dnf-command(config-manager)' -y

RUN if [[ $BUILD_OS = "stream8" ]]; then \
        dnf config-manager --set-enabled -y powertools \
    else \
        dnf config-manager --set-enabled -y crb; \
    fi

RUN yum install -y yum-utils epel-release

RUN yum-config-manager --add-repo https://packages.gramineproject.io/rpm/gramine.repo

# Add steps here to set up dependencies
RUN yum update -y && yum install -y \
    gcc\
    git \
    make \
    python3-pip \
    python3-pytest \
    sudo \
    wget

RUN if [[ $BUILD_OS = "stream8" ]]; then \
        yum install -y curl; \
    fi

RUN wget https://rpmfind.net/linux/centos/8-stream/AppStream/x86_64/os/Packages/sshpass-1.09-4.el8.x86_64.rpm

RUN sudo dnf install ./sshpass-1.09-4.el8.x86_64.rpm -y

RUN python3 -m pip install -U 'meson>=0.56,<0.57'

# Add the user UID:1000, GID:1000, home at /intel
RUN groupadd -r intel -g 1000 && useradd -u 1000 -r -g intel -G wheel -m -d /intel -c "intel Jenkins" intel && \
    chmod 777 /intel

# Make sure /intel can be written by intel
RUN chown 1000 /intel

RUN echo 'intel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN echo 'http_proxy="http://proxy-dmz.intel.com:911/"\nhttps_proxy="http://proxy-dmz.intel.com:912/"' >> /etc/environment

# Blow away any random state
RUN rm -f /intel/.rnd

# Make a directory for the intel driver
RUN mkdir -p /opt/intel && chown 1000 /opt/intel

# Make a directory for the Gramine installation
RUN mkdir -p /home/intel/gramine_install && chown 1000 /home/intel/gramine_install

# Set the working directory to intel home directory
WORKDIR /intel

# Specify the user to execute all commands below
USER intel

# Set environment variables.
ENV HOME /intel

# Define default command.
CMD ["bash"]
