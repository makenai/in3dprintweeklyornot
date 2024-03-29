require "bundler/capistrano"
load 'deploy/assets'

set :application, "in3dprintweeklyornot"
set :repository,  "git@github.com:makenai/in3dprintweeklyornot.git"
set :user, "release"
set :use_sudo, false

# ssh_options[:keys] = "~/.ssh/makenai.pem"
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "ooo.makenai.net"                   # Your HTTP server, Apache/etc
role :app, "ooo.makenai.net"                   # This may be the same as your `Web` server
role :db,  "ooo.makenai.net", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end