Name:             iaas
Version:          1.0.0
Release:          %{_gitrelease}
Provides:         %{_gitprovides}
Summary:          SG IaaS tools
Group:            System
License:          MIT
URL:              https://github.com/sophos-iaas/sg-iaas
Source:           %{name}.git.tar.gz
Source99:	      	gitinfo
BuildRoot:        %{_tmppath}/%{name}-%{version}-build
Requires:    			bash jq python python-pip curl ruby

%description
SG IaaS support and customer tooling.

%prep
%setup -n %{name}

%build

%install
mkdir -p %{buildroot}/usr/bin
mkdir -p %{buildroot}/usr/lib/sg-iaas
install -D -m 755 bin/sg-iaas %{buildroot}/usr/bin/sg-iaas
cp -r lib/* %{buildroot}/usr/lib/sg-iaas

%check

%files
%defattr(-,root,root)
/usr/bin/sg-iaas
/usr/lib/sg-iaas/

%changelog
