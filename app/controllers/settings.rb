class Settings < Application

  before :ensure_authenticated
  before :admin_authenticated

  def index
    if request.post?
      @setting = Setting.get(params[:setting][:id])
      @setting.update_attributes(params[:setting])
      @setting.field_show = {} unless params[:setting][:field_show]
      @setting.field_edit = {} unless params[:setting][:field_edit]
      @setting.save
    else
      @setting = Setting.first
      unless @setting
        @setting = Setting.create
      end
    end
    display @setting
  end
  
end
