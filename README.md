# SG - IAAS

## Installation (not UTM)

    git clone https://github.com/sophos-iaas/sg-iaas.git ~/.sg-iaas
    echo "export PATH=\$PATH:~/.sg-iaas/bin" >> ~/.bashrc

### Requirements

#### Linux (ubuntu, debian)

    apt install awscli jq git

#### Linux (fedora, redhat)

    yum install awscli jq git

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

    sg-iaas ogw-routes <vpc-id>

#### Check subnet compatibility

    sg-iaas ogw-compat <vpc-id>

#### Create IAM role for CloudWatch

Allow CloudWatch to restart OGW instances in case of failure. This role might be
missing on older installations and can be created with the following command

    sg-iaas ogw-create-cw-role
