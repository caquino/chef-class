user = ENV['USER'] || 'YOUR USERNAME'
node_name user
client_key "#{ENV['HOME']}/.chef/#{user}.pem"
validation_client_name "zenlab-validator"
validation_key "#{ENV['HOME']}/.chef/chef-validator.pem"
chef_server_url "https://chefs.local/organizations/zenlab"
syntax_check_cache_path "#{ENV['HOME']}/.chef/syntax_check_cache"
cookbook_path [ "#{ENV['HOME']}/chef/cookbooks" ]
knife[:editor]="/usr/bin/vim"
