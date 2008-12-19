require "rubygems"

# Add the local gems dir if found within the app root; any dependencies loaded
# hereafter will try to load from the local gems before loading system gems.
if (local_gem_dir = File.join(File.dirname(__FILE__), '..', 'gems')) && $BUNDLE.nil?
  $BUNDLE = true; Gem.clear_paths; Gem.path.unshift(local_gem_dir)
end

require "merb-core"
require "spec" # Satisfies Autotest and anyone else not using the Rake tasks

# this loads all plugins required in your init file so don't add them
# here again, Merb will do it for you
Merb.start_environment(:testing => true, :adapter => 'runner', :environment => ENV['MERB_ENV'] || 'test')

Spec::Runner.configure do |config|
  config.include(Merb::Test::ViewHelper)
  config.include(Merb::Test::RouteHelper)
  config.include(Merb::Test::ControllerHelper)
end
require File.dirname(__FILE__) + '/fixtures.rb'

Merb::Test.add_helpers do
 
  def create_default_admin
    m = Member.first(:login => 'shingara')
    unless m
      unless Function.first(:admin => true)
        Function.gen(:president)
      end
      Member.gen( :login => 'shingara',
                  :password => 'tintinpouet',
                  :password_confirmation => 'tintinpouet',
                  :function => Function.first(:admin => true)) or raise "can't create user"
    else
      unless m.function && m.function.admin?
        f = Function.first(:admin => true)
        unless f
          f = Function.gen(:president)
        end
        m.function = f
        m.save
      end
    end
    delete_all_user_without_function
  end

  def delete_all_user_without_function
    Member.all(:function_id => nil).destroy!
  end

  def create_default_member
    unless Member.first(:login => 'oupsnow')
      Member.gen( :login => 'oupsnow',
                  :password => 'tintinpouet',
                  :password_confirmation => 'tintinpouet') or raise "can't create user"
    end
  end
 
  def login_admin
    create_default_admin
    request('/login', {:method => 'PUT',
            :params => { :login => 'shingara',
              :password => 'tintinpouet' }})
  end

  def login_member
    create_default_member
    request('/login', {:method => 'PUT',
            :params => { :login => 'oupsnow',
              :password => 'tintinpouet' }})
  end
end
