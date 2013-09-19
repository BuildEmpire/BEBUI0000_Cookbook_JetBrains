#
# Cookbook Name:: cookbook_jetbrains
# Recipe:: teamcity
#

archive_directory = Chef::Config[:file_cache_path]

# Install TeamCity Server
server_archive_name = "TeamCity-#{node["cookbook_jetbrains"]["teamcity"]["version"]}.tar.gz"
server_archive_path = "#{archive_directory}/#{server_archive_name}"
server_directory = "/opt/teamcity/#{node["cookbook_jetbrains"]["teamcity"]["version"]}"
remote_file server_archive_path do
  backup false
  source "http://download.jetbrains.com/teamcity/#{server_archive_name}"
  action :create_if_missing
  notifies :run, "bash[install-teamcity]", :immediately
end
bash "install-teamcity" do
  code <<-EOH
    mkdir -p #{server_directory}
    cd #{server_directory}
    tar -xvf #{server_archive_path}
  EOH
  action :nothing
end

# Configure TeamCity Server
config_directory = "#{server_directory}/TeamCity/conf"
template "#{config_directory}/server.xml" do
  source "server.xml.erb"
  variables(
    :address => node["cookbook_jetbrains"]["teamcity"]["address"],
    :port => node["cookbook_jetbrains"]["teamcity"]["port"]
  )
end
link "/opt/teamcity/current" do
  to server_directory
end

# Download the postgres java driver
data_directory = "/root/.BuildServer"
jdbc_driver_filename = "postgresql-#{node["cookbook_jetbrains"]["teamcity"]["postgresql-driver-version"]}.jdbc4.jar"
jdbc_driver_directory = "#{data_directory}/lib/jdbc"
directory jdbc_driver_directory do
  recursive true
  action :create
end
remote_file "#{jdbc_driver_directory}/#{jdbc_driver_filename}" do
  backup false
  mode 00644
  source "http://jdbc.postgresql.org/download/#{jdbc_driver_filename}"
  action :create_if_missing
end

# Setup the database properties file for TeamCity
data_config_directory = "#{data_directory}/config"
directory data_config_directory do
  recursive true
  action :create
end
template "#{data_config_directory}/database.properties" do
  source "database.properties.erb"
  action :create_if_missing
  variables(
    :port => node["postgresql"]["config"]["port"],
    :database_name => node["cookbook_jetbrains"]["teamcity"]["database_name"],
    :user => node["cookbook_jetbrains"]["teamcity"]["username"],
    :password => node["cookbook_jetbrains"]["teamcity"]["password"]
  )
end

# Create TeamCity Service
cookbook_file "/etc/init/teamcity-server.conf" do
  backup false
  source "teamcity-server.conf"
  action :create_if_missing
  notifies :start, "service[teamcity-server]", :immediately
end

# Start TeamCity Service
service "teamcity-server" do
  provider Chef::Provider::Service::Upstart
  action :restart
end