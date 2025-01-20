class UsersController < ApplicationController
    # before_action :authenticate_user!
    def edit
        @user = User.find(params[:id])
    end
    
    def update
        @user = User.find(params[:id])
        if @user.update(user_params)
          redirect_to users_url, notice: "Se han actualizado los datos."
        else
        render :edit, status: :unprocessable_entity
        end
    end
    
    def index
        @users = User.all
        @pagy, @users = pagy(User.all.order(created_at: :desc), items: 15)
    end
    
    def destroy
        @user = User.find(params[:id])

        @user.destroy

        redirect_to users_path
    end

    private
    def user_params
        params.require(:user).permit(:email, :username, :password, {role_ids: []})
    end
end