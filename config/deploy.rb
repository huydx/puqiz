# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'puqiz'
set :repo_url, 'git@github.com:huydx/puqiz.git'
set :scm, :git

set :rvm_ruby_string, 'ruby-2.0.0-p481'
set :default_env, { rvm_bin_path: '~/.rvm/bin' }
set :user, 'deploy'
set :user_sudo, false
set :current_rev, `git show --format='%H' -s`.chomp
set :branch, "master"
set :unicorn_config,  "config/unicorn.rb"
set :linked_files, %w{config/database.yml}

namespace :deploy do
  task :after_symlink do
    execute "ln -s /home/deploy/config/puqiz/database.yml #{current_path}/config/database.yml"
  end
end
