class Api::V1::ProfilesController < Api::BaseController
  before_action :set_user

  def show
    render partial: 'api/v1/models/user.json.jbuilder', locals: { resource: @user }
  end

  def update
    @user.update!(profile_params)
  end

  def destroy
    if params['email']&.downcase == @user.email.downcase

      sign_out
      if @user.destroy
        Current.reset

        # TODO: Return 404 response
        return head :ok
      end
    end

    head :unprocessable_entity
  end

  private

  def set_user
    @user = current_user
  end

  def profile_params
    params.require(:profile).permit(
      :email,
      :name,
      :display_name,
      :password,
      :password_confirmation,
      :avatar,
      :availability,
      ui_settings: {}
    )
  end
end
