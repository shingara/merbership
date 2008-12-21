class Members < Application
  # provides :xml, :yaml, :js
  
  before :ensure_authenticated, :exclude => [:show, :index]
  before :admin_authenticated, :only => [:new, :create, :destroy]
  before :edit_own, :only => [:edit, :update]
  before :need_setting

  def index
    @members = Member.all
    display @members
  end

  def show(id)
    @member = Member.get(id)
    raise NotFound unless @member
    display @member
  end

  def new
    only_provides :html
    @member = Member.new
    display @member
  end

  def edit(id)
    only_provides :html
    @member = Member.get(id)
    raise NotFound unless @member
    display @member
  end

  def create(member)
    @member = Member.new(member)
    if @member.save
      redirect resource(@member), :message => {:notice => "Member was successfully created"}
    else
      message[:error] = "Member failed to be created"
      render :new
    end
  end

  def update(id, member)
    @member = Member.get(id)
    raise NotFound unless @member
    if @member.update_attributes(member_filtered(member))
       redirect resource(@member)
    else
      display @member, :edit
    end
  end

  def delete(id)
    @member = Member.get(id)
    raise NotFound unless @member
    display @member
  end

  def destroy(id)
    @member = Member.get(id)
    raise NotFound unless @member
    if @member.destroy
      redirect resource(:members)
    else
      raise InternalServerError
    end
  end

private

  # only if user is admin or he want edit himself
  def edit_own
    if session.user
      unless session.user.admin? || session.user.id == params[:id].to_i
        message[:error] = 'You need to be an admin'
        raise Unauthenticated
      end
    else
      message[:error] = 'You need to be an admin'
      raise Unauthenticated
    end
  end

  def need_setting
    @setting = Setting.first
    unless @setting.completed?
      redirect url(:controller => 'settings')
    end
  end

  def member_filtered(member)
    member_param = member
    if session.user.admin?
      member_param.each do |key, value|
        unless @setting.field_edit[key] || 
          key == 'subscription_on' ||
          key == 'function_id' ||
          key == 'password_confirmation' ||
          key == 'password' 
          member_param.delete(key)
        end
      end
    end
    member_param
  end

end # Members
