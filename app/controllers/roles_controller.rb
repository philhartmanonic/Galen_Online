class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  # GET /states
  # GET /states.json
  def index
    @roles = Role.all
  end

  # GET /states/1
  # GET /states/1.json
  def show
    @roles = Role.all
  end

  # GET /states/new
  def new
    @roles = Role.all
    @role = Role.new
  end

  # GET /states/1/edit
  def edit
    @roles = Role.all
  end

  # POST /states
  # POST /states.json
  def create
    @role = Role.new(state_params)

    respond_to do |format|
      if @role.save
        format.html { redirect_to @role, notice: 'State was successfully created.' }
        format.json { render :show, status: :created, location: @role }
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /states/1
  # PATCH/PUT /states/1.json
  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to @role, notice: 'Role was successfully updated.' }
        format.json { render :show, status: :ok, location: @role }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /states/1
  # DELETE /states/1.json
  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_url, notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
      params.require(:role).permit(:name, :description)
    end
end
