# https://victorafanasev.info/tech/capistrano-automatically-check-if-remote-origin-updated-before-deploy
namespace :deploy do
  desc 'Check if origin master synced with local repository before deploy'
  task :git_uptodate_check do
    if !`git status --short`.empty?
      raise 'Please commit your changes first'
    elsif `git remote`.empty?
      raise 'Please add remote origin repository to your repo first'
    elsif !`git rev-list master...origin/master`.empty?
      raise 'Please push your commits to the remote origin repo first'
    end
  end
end

before 'deploy', 'deploy:git_uptodate_check'
