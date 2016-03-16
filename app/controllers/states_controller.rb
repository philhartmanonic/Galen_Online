class StatesController < ApplicationController
  before_action :set_state, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :except => [:show, :calendar]
  # GET /states
  # GET /states.json
  def index
    @states = State.all
  end

  def import
    State.import(params[:file])
    redirect_to states_path, notice: "State Data imported!"
  end

  def calendar
    @states = State.all
  end

  # GET /states/1
  # GET /states/1.json
  def show
    @states = State.all
    @state = State.find(params[:id])
    @elections = Election.all
    @grouped_elections = @elections.order("percent desc").group_by { |i| [i.state_id, i.party_id] }
  end

  # GET /states/new
  def new
    @states = State.all
    @state = State.new
  end

  # GET /states/1/edit
  def edit
    @states = State.all
  end

  def calendar
    @states = State.all
    dem_states = State.includes(:elections).where("elections.party_id = 2").references(:elections)
    gop_states = State.includes(:elections).where("elections.party_id = 1").references(:elections)
    @calendar_states = []
    dem_winners = {}
    gop_winners = {}
    dem_states.each do |s|
      if s.dem_date.nil? == false and s.dem_date <= Date.today and s.elections.empty? == false
        a = s.elections.first
        dem_winners[s.id] = "#{a.candidate.last_name}: #{a.percent}%, #{a.regs} delegates"
      elsif s.dem_polls.first.kind_of?(Hash)
        a = s.dem_polls.first[:Results].first
        dem_winners[s.id] = "(Poll) #{a[0]}: #{a[1]}"
      else
        dem_winners[s.id] = "No data"
      end
    end
    gop_states.each do |s|
      if s.gop_date.nil? == false and s.gop_date <= Date.today and s.elections.empty? == false
        a = s.elections.first
        gop_winners[s.id] = "#{a.candidate.last_name}: #{a.percent}%, #{a.regs} delegates"
      elsif s.gop_polls.first.kind_of?(Hash)
        a = s.gop_polls.first[:Results].first
        gop_winners[s.id] = "(Poll) #{a[0]}: #{a[1]}"
      else
        gop_winners[s.id] = "No data"
      end
    end 
    @states.each do |s|
      if s.gop_own == true
        @calendar_states << {state: s, name: s.name, date: s.gop_date, type: s.p_or_c, gop: gop_winners[s.id], dem: dem_winners[s.id], party: 'Republican'}
      end
      if s.dem_own == true
        @calendar_states << {state: s, name: s.name, date: s.dem_date, type: s.p_or_c, gop: gop_winners[s.id], dem: dem_winners[s.id], party: 'Democratic'}
      end
      if s.both == true
        @calendar_states << {state: s, name: s.name, date: s.gop_date, type: s.p_or_c, gop: gop_winners[s.id], dem: dem_winners[s.id], party: 'Both'}
      end
    end
    @cs = @calendar_states.sort_by { |k| k[:date] }.group_by {|k| k[:date].strftime('%B')}
  end

  # POST /states
  # POST /states.json
  def create
    @state = State.new(state_params)

    respond_to do |format|
      if @state.save
        format.html { redirect_to @state, notice: 'State was successfully created.' }
        format.json { render :show, status: :created, location: @state }
      else
        format.html { render :new }
        format.json { render json: @state.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /states/1
  # PATCH/PUT /states/1.json
  def update
    respond_to do |format|
      if @state.update(state_params)
        format.html { redirect_to @state, notice: 'State was successfully updated.' }
        format.json { render :show, status: :ok, location: @state }
      else
        format.html { render :edit }
        format.json { render json: @state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /states/1
  # DELETE /states/1.json
  def destroy
    @state.destroy
    respond_to do |format|
      format.html { redirect_to states_url, notice: 'State was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_state
      @state = State.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def state_params
      params.require(:state).permit(:name, :p_or_c, :gop_date, :dem_date, :map)
    end
end
