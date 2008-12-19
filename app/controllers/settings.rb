class Settings < Application

  before :ensure_authenticated
  before :admin_authenticated

  def index
    if request.post?
      @setting = Setting.get(params[:setting][:id])
      @setting.update_attributes(params[:setting])
    else
      @setting = Setting.first
      unless @setting
        @setting = Setting.create
      end
    end
    display @setting
  end
  
end
