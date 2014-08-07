#!/bin/bash
#
# -- instant-perlbrew.sh --
#
# Author: Henry Van Styn <vanstyn@cpan.org>
#
# Handy script for the very lazy -- install fresh perlbrew/perl/cpanm/packages
# all at once, and make it the active perl for the current user.
#
# Usage:
#
#   Pass a valid perlbrew perl version (i.e. perl-5.16.3) as the first argument,
#   optionally followed by an additional list of CPAN packages which will be
#   passed to cpanm to install as a final step
#
# Examples:
#
#   ./instant-perlbrew.sh perl-5.20.0
#
#   ./instant-perlbrew.sh perl-5.16.3 RapidApp Dist::Zilla
#
##

if [ -z "$1" ]; then # <-- no args
  echo "Usage: $0 <perlbrew-perl-version> [optional CPAN packages...]"
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
  if [ -n "$1" ]; then  # <-- and additional args are present ...
    cpanm --quiet --skip-satisfied $mods
  fi
fi
