#
# Cookbook Name:: mysql
# Recipe:: client
#
# Copyright 2008-2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

::Chef::Resource::Package.send(:include, Opscode::Mysql::Helpers)

package "mysql-client" do
  package_name value_for_platform(
    [ "centos", "redhat", "suse", "fedora"] => { "default" => "mysql" },
    "default" => "mysql-client"
  )
  action :install
end

package "mysql-devel" do
  package_name begin
    if platform?(%w{ centos redhat suse fedora })
      "mysql-devel"
    elsif debian_before_squeeze? || ubuntu_before_lucid?
      "libmysqlclient15-dev"
    else
      "libmysqlclient-dev"
    end
  end
  action :install
end

if platform?(%w{ debian redhat centos fedora suse })

  package "mysql-ruby" do
    package_name value_for_platform(
      [ "centos", "redhat", "suse", "fedora"] => { "default" => "ruby-mysql" },
      ["debian", "ubuntu"] => { "default" => 'libmysql-ruby' },
      "default" => 'libmysql-ruby'
    )
    action :install
  end

else
  Chef::Log.info("Going to install mysql gem")
  gem_package "mysql" do
    action :install
  end
end
# r = gem_package "mysql" do
#     action :nothing
#   end
# 
#   r.run_action(:install)
# end

# == Install MySQL client gem
# Also installs in compile phase

# r = execute "install mysql gem" do
#   command "/gem install mysql --no-rdoc --no-ri -v 2.7 -- --build-flags --with-mysql-config"
# end
# r.run_action(:run)
# 
# Gem.clear_paths
# log "Gem reload forced with Gem.clear_paths"
