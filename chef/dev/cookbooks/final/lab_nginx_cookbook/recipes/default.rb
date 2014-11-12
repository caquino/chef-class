#
# Cookbook Name:: lab_nginx_cookbook
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "nginx" do
	action :upgrade
end

file "/usr/share/nginx/www/index.html" do
	content node[:hostname]
end

service "nginx" do
	action [:enable, :start]
	supports :reload => true
end
