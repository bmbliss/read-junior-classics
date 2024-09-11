class ChildrenController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_child, only: [:show, :edit, :update, :destroy]

  def index
    @children = @user.children
  end

  def show
  end

  def new
    @child = @user.children.build
  end

  def create
    @child = @user.children.build(child_params)
    if @child.save
      redirect_to user_child_path(@user, @child), notice: 'Child was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @child.update(child_params)
      redirect_to user_child_path(@user, @child), notice: 'Child was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @child.destroy
    redirect_to user_children_path(@user), notice: 'Child was successfully deleted.'
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_child
    @child = @user.children.find(params[:id])
  end

  def child_params
    params.require(:child).permit(:name, :grade_level)
  end
end
