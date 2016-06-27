# SG - IAAS

## Installation

    git clone https://github.com/sophos-iaas/sg-iaas.git ~/.sg-iaas
    echo "export PATH=\$PATH:~/.sg-iaas/bin" >> ~/.bashrc

### Requirements

#### Linux (ubuntu, debian)

    apt install awscli jq git

#### Linux (fedora, redhat)

    **** install ????

#### macOS

    brew install awscli jq git

#### FreeBSD

    pkg install awscli jq git

### Verify installation

    sg-iaas verify

### Update

    sg-iaas update

## Help

    sg-iaas help

### OGW (Outbound Gateway)

#### Verify routing

    sg-iaas ogw-routes vpc-6045f307
