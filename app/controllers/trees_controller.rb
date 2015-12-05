class TreesController < ApplicationController
  before_action :set_tree, only: [:show, :update, :destroy]
  before_action :authenticate

  def index
    if @current_user.instance_of? User
      @trees = @current_user.trees
      render json: @trees
    end
  end

  def show
    render json: @tree
  end

  def create
    @tree = Tree.new(tree_params)

    if @tree.save
      render json: @tree, status: :created
    else
      render json: @tree.errors, status: :unprocessable_entity
    end
  end

  def update
    if @tree.update(tree_params)
      head :no_content
    else
      render json: @tree.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @tree.destroy

    head :no_content
  end

  private
    def set_tree
      @tree = Tree.find(params[:id])
    end
    def tree_params
      params.require(:tree).permit(:name, :health, :awareness, :level, :user_id)
    end
end
