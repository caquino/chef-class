#
# Cookbook Name:: lab_haproxy_cookbook
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "haproxy" do
	action :upgrade
end

pool_members = search("node", "role:lab_web_role")
config = data_bag_item("lab_environment_secrets", "haproxy")
Chef::Log.debug("Databag : #{config}")
Chef::Log.debug("Item: #{config['admin']}")

cookbook_file "haproxy-default" do
      path "/etc/default/haproxy"
      owner "root"
      group "root"
      mode 0644
      notifies :restart, "service[haproxy]", :delayed
end

template "/etc/haproxy/haproxy.cfg" do
	source "haproxy.cfg.erb"
	owner "root"
	group "root"
	mode "0644"
	variables ({
			:pool_members => pool_members.uniq,
			:admin => config['admin']
		  })
	notifies :restart, "service[haproxy]", :delayed
end

service "haproxy" do
	action [:enable, :start]
	supports :reload => true
end

