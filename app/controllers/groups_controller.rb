class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end

  def new
    @group =Group.new
  end

def create
  @group =Group.new(group_params)
  @group.save

  redirect_to group_path
end


private#私自定義
  def group_params
    params.require(:group).permit(:title, :description)
  end
end
