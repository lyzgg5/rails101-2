class GroupsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy]
  before_action :find_group_and_check_permission, only:[:edit, :update, :destroy]
  def index
    @groups = Group.all
  end

  def show
    @group =Group.find(params[:id])
@posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 5)
  end

  def edit
  end

  def new
    @group =Group.new
  end

  def create
    @group =Group.new(group_params)
    @group.user = current_user
    #判斷不得為空白
    if @group.save
      current_user.join!(@group)#建立新的討論時同時加員為此討論成員
      redirect_to groups_path
    else
      render :new
    end
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path, notice: "Update Success更新成功"
    else
      render :edit
    end
  end

  def destroy

    @group.destroy
    redirect_to groups_path, alert: "Group deleted 討論已刪除"
  end

def join
  @group = Group.find(params[:id])

  if !current_user.is_member_of?(@grouop)
    current_user.join!(@group)
    flash[:notice] = "加入本討論成功!"
  else
    flash[:warning] = "你已經是本討論版成員!"
  end
  redirect_to group_path(@group)
end

def quit
  @group = Group.find(params[:id])
  if current_user.is_member_of?(@group)
    current_user.quit!(@group)
    flash[:alert] = "已退出本討論!"
  else
    flash[:warning] = "你不是本討論版成員，怎麼退"
  end
  redirect_to group_path(@group)
end

private#私自定義
  def group_params
    params.require(:group).permit(:title, :description)
  end

  def find_group_and_check_permission
    @group =Group.find(params[:id])

    if current_user != @group.user
      redirect_to root_path, alert: "You have no permission"
    end
  end

end
