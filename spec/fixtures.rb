Function.fixture(:president) {{
  :name => 'president',
  :admin => true
}}

Function.fixture(:member) {{
  :name => 'member',
  :admin => false
}}

president = Function.gen(:president)
member = Function.gen(:member)

Member.fixture {{
  :login => /\w+/.gen,
  :firstname => /\w+/.gen,
  :lastname => /\w+/.gen,
  :email => "#{/\w+/.gen}.#{/\w+/.gen}@gmail.com",
  :birthdate => Date::today,
  :password => 'tintinpouet',
  :password_confirmation => 'tintinpouet',
  :occupation => 'developper',
  :address => '200 rue ok',
  :city => /\w+/.gen,
  :phone_number => '0123456789',
  :website => 'http://pictrails.rubyforge.org',
  :subscription_on => Date::today,
  :function => member
}}

Setting.fixture {{
  :month_subscription => 12,
  :month_notification => 10,
  :field_show => '1,2,3,4',
  :field_edit => '1,2,3,4,5',
  :name => 'rubyfrance',
  :email_admin => 'cyril.mougel@gmail.com',
}}
