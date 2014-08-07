#!/bin/bash
#
# -- instant-perlbrew.sh --
#
#   Version  : 1.0
#   License  : perl_5
#   Author   : Henry Van Styn <vanstyn@cpan.org>
#
# Handy script for the very lazy -- install fresh perlbrew/perl/cpanm/packages
# all at once, and make it the permanent, active perl for the current user.
#
# Usage:
#
#   Pass a valid perlbrew perl version (i.e. perl-5.16.3) as the first argument,
#   optionally followed by an additional list of CPAN packages (or any cpanm args) 
#   which will be passed to cpanm to be installed as a final step
#
# Examples:
#
#   ./instant-perlbrew.sh perl-5.20.0
#   ./instant-perlbrew.sh perl-5.16.3 RapidApp Dist::Zilla
#   ./instant-perlbrew.sh perl-5.16.3 --notest RapidApp
#
##

if [ -z "$1" ]; then # <-- no args
  echo "Usage: $0 <perlbrew-perl-version> [opt cpanm args/pkgs ...]"
  exit;
fi;

perl_ver=$1
shift
mods=$(printf " %s" "$@")

wget -O - http://install.perlbrew.pl | bash  && \
source ~/perl5/perlbrew/etc/bashrc && \
perlbrew install $perl_ver && \
perlbrew switch  $perl_ver && \
echo -e "\nsource ~/perl5/perlbrew/etc/bashrc" >> ~/.bash_profile && \
perlbrew install-cpanm

if [ $? -eq 0 ];  then  # <-- the above commands succeeded... 
  echo -e "\n $perl_ver w/ cpanm installed/activated (~/.bash_profile updated)\n"
  if [ -n "$1" ]; then  # <-- and additional args are present ...
    echo -e "\ncpanm --quiet --skip-satisfied $mods"
    cpanm --quiet --skip-satisfied $mods
  fi
fi
