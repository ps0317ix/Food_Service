class UsersController < ApplicationController

  before_action :authenticate_user, {only:[:index, :show, :edit, :update]}
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
  before_action :ensure_correct_user, {only: [:edit, :update]}

  # ユーザーホーム
  def index
    @users = User.all.order(created_at: :desc)
  end

  # ユーザー一覧
  def show
    @users = User.find_by(id: params[:id])
  end

  # ユーザー新規登録ページ
  def new
    @user = User.new
  end

  # ユーザー新規作成実行
  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      img: "default_image.jpg",
      password: params[:password]
    )
    if @user.save
      flash[:notice] = "ユーザー登録が完了しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/new")
    end
  end

  # ユーザー情報更新ページ
  def edit
    @user = User.find_by(id: params[:id])
  end

  # ユーザー情報更新実行
  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]

    if params[:image]
      @user.img = "#{@user.id}.jpg"
      image = params[:image]
      File.binwrite("public/#{@user.img}",image.read)
    end

    if @user.save
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit")
    end
  end

  # ログイン
  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to("/users")
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end

  # ログアウト
  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end

  # 権限判定
  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end


end
