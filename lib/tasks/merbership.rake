namespace :merbership do

  desc 'Generate the first admin function and non admin function and first user like admin'
  task :bootstrap => :merb_env do
    require 'spec/fixtures.rb'
    Setting.gen
    Member.gen(:login => 'admin',
               :password => 'merbership',
               :password_confirmation => 'merbership',
               :function => Function.first(:admin => true))
  end

  desc 'check all member and send mail if need noticed'
  task :notify => :merb_env do
    Member.all.each do |user|
      user.notify_subscription_if_needed
    end
  end

end
