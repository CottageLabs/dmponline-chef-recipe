# Copyright (c) 2012  Cottage Labs
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Cookbook Name:: dmponline
# Recipe:: simple_sword_server

# Install Simple Sword Server



include_recipe "python"
include_recipe "gunicorn"


# install web.py into system
python_pip "web.py" do
  action :install
end

# install lxml into system
python_pip "lxml" do
  action :install
end

#Get the Simple Sword Server software from Github
git "/opt/simple-sword-server" do
  repository "git://github.com/swordapp/Simple-Sword-Server.git"
  reference "master"
  action :sync
end


#Configure Gunicorn to host SSS
gunicorn_config "/opt/simple-sword-server/gunicorn.py" do
  worker_processes 2
  listen "0.0.0.0:8100"
  action :create
end


# Provision service (using bluepill)
include_recipe 'bluepill'
template '/etc/bluepill/simple-sword-server.pill' do
  source 'simple-sword-server.pill.erb'
end
bluepill_service 'simple-sword-server' do
  action [:load, :enable]
end
