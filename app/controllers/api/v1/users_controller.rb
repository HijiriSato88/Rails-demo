module Api
    module V1
        class UsersController < ApplicationController
            before_action :set_user, only: [:details, :update, :delete]

            def index
                users = User.all
                render json: users
            end

            def details
                render json: @user
            end

            def register
                user = User.new(user_params)
                if user.save
                    render json: user, status: :created
                else
                    render json: user.errors, status: :unprocessable_entity
                end
            end

            def update
                if @user.update(user_params)
                render json: { status: 'SUCCESS', message: 'Updated the post', data: @user }
                else
                render json: { status: 'SUCCESS', message: 'Not updated', data: @user.errors }
                end
            end

            def delete
                @user.destroy
                render json: { status: 'SUCCESS', message: 'Deleted the post', data: @user }
            end

            private

            def set_user
                @user = User.find(params[:id])
            end
            
            def user_params
                params.permit(:name, :age, :email)
            end

        end
    end
end

