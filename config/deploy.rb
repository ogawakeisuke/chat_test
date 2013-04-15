#まだ完璧じゃない

set :application, "piston"
set :scm, :git 
set :repository, "git@github.com:ogawakeisuke/chat_test.git"
# set :repository,  "#{Dir::pwd}/.git"
# set :local_repository, "#{Dir::pwd}/.git"

set :branch, "master"
role :web, "54.249.233.250"                          # Your HTTP server, Apache/etc
role :app, "54.249.233.250"                          # This may be the same as your `Web` server

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"
# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts
# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

set :use_sudo, false
set :deploy_to, "/home/piston/#{application}"
set :deploy_via, :copy
# set :copy_strategy, :export
set :copy_compression, :zip
set :node_env, 'production'
#set :node_port, 443
#set :node_port, 8888
set :user, "piston"
set :group, "piston"


#current_app_path = "#{current_path}/server"
#ここで起動スクリプトをかく。
namespace :deploy do
  task :start, :roles => :app do
    run "cd #{current_path} && NODE_ENV=#{node_env} forever start app.js"
  end
  
  task :stop, :roles => :app do
    run "cd #{current_path} && forever stop app.js"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && NODE_ENV=#{node_env} forever restart app.js"
  end
  
  task :npm_install, :roles => :app, :except => { :no_release => true } do
    #puts "current_path: #{current_path}"
    run "cd #{current_path} && npm install"
  end

end

after 'deploy:create_symlink', 'deploy:npm_install'

after "deploy:create_symlink", :roles => :app do
  run "ln -svf #{shared_path}/node_modules #{current_path}/node_modules"
  run "cd #{current_path} && npm i"
end

after "deploy:setup", :roles => :app do
  run "mkdir -p #{shared_path}/node_modules"
end