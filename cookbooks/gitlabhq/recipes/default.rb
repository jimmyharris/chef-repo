#
# Cookbook Name:: gitlabhq
# Recipe:: default
#
# Copyright 2011, TFM
#
# All rights reserved - Do Not Redistribute
#

# --- Install packages we need ---
package 'gitosis' do
  action :install
end

package 'libcurl4-openssl-dev' do
  action :install
end 

include_recipe %w(sqlite3 libsqlite3-dev git-core python-setuptools)

# --- Set host name ---
# Note how this is plain Ruby code, so we can define variables to
# DRY up our code:
hostname = 'gitlabhq.local'
 
file '/etc/hostname' do
  content "#{hostname}\n"
end
 
service 'hostname' do
  action :restart
end
 
file '/etc/hosts' do
  content "127.0.0.1 localhost #{hostname}\n"
end
 

bash "install gitlab" do
  code <<-EOH
    sudo easy_install pygments
    sudo echo 'export RAILS_ENV=production' >> /etc/profile
    sudo adduser --system --shell /bin/sh --gecos 'git version control' --group --disabled-password --home /home/git git
    ssh-keygen -t rsa
    sudo -H -u git gitosis-init < ~/.ssh/id_rsa.pub
    sudo chmod 755 /home/git/repositories/gitosis-admin.git/hooks/post-update
    echo "gem: --no-rdoc --no-ri" > ~/.gemrc
    rvmsudo gem install passenger
    rvmsudo passenger-install-nginx-module
  EOH
end
# --- Deploy a configuration file ---
# For longer files, when using 'content "..."' becomes too
# cumbersome, we can resort to deploying separate files:
# cookbook_file '/etc/apache2/apache2.conf'
# This will copy cookbooks/op/files/default/apache2.conf (which
# you'll have to create yourself) into place. Whenever you edit
# that file, simply run "./deploy.sh" to copy it to the server.
 
# service 'apache2' do
#   action :restart
# end