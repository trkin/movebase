# https://github.com/javan/whenever/issues/75#issuecomment-380747
# https://github.com/javan/whenever/wiki/rbenv-and-capistrano-Notes
set :path, '/home/ubuntu/movebase/current'
if @rbenv_root
  # when calling using capistrano than set correct ruby and env
  set :rbenv_exec, "#{rbenv_root}/bin/rbenv exec"
else
  set :rbenv_exec, ''
end

# Make sure that log/cron folder exists: mkdir ~/movebase/current/log/cron

# Example: runner 'MyClass.some_function' (please use only one word, no space,
# brackets...)
job_type :runner, %(cd :path &&
   start=`date` &&
  :rbenv_exec bundle exec rails runner -e :environment :task 2>&1 |
  (echo $start :task started; cat -; echo `date` :task finished)
  >> ':path/log/cron/:task.log' 2>&1
)

job_type :rake, %(cd :path &&
   start=`date` &&
  :rbenv_exec bundle exec rake :task |
  (echo $start :task started; cat -; echo `date` :task finished)
  >> ':path/log/cron/:task.log' 2>&1
)

every :reboot do
  runner 'MyService.new.perform_and_puts'
end

every 1.hour do
  rake 'sitemap:refresh'
end
