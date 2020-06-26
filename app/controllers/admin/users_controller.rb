class Admin::UsersController < AdminController
  before_action :find_user, only: [:show, :edit, :update, :enable, :disable]

  def index
    @users = User.all.page(params[:page])

  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    # set a random password; user will change this
    temp_pass = SecureRandom.base64(32)
    @user.password = temp_pass
    @user.password_confirmation = temp_pass

    # set user as already confirmed, since they cannot change their password otherwise
    @user.confirmed_at = Time.current

    if @user.save
      @user.send_reset_password_instructions
      flash[:notice] = 'User created successfully.'
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def enable
    @user.active = true
    flash[:notice] = 'User enabled successfully.' if @user.save
    redirect_to admin_user_path(@user)
  end

  def disable
    @user.active = false
    flash[:notice] = 'User disabled successfully.' if @user.save
    redirect_to admin_user_path(@user)
  end

  private

  def find_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'That user does not exist.'
    redirect_back(fallback_path: admin_users_path)
    return
  end

  def user_params
    params.require(:user).permit(:email, :name, :about_me)
  end
end
