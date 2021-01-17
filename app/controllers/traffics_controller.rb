class TrafficsController < ApplicationController
  before_action :set_traffic, only: [:show, :edit, :update, :destroy]


  def index      
    sql = "SELECT distinct(company_url) as company_url from traffics"
    @traffics = Traffic.connection.execute(sql)    
  end

  def get_details
    @traffics = Traffic.where(:company_url => params[:company_url])
  end

  def groups
    company_url = params[:company_url]
    sql = "SELECT
      to_char(record_date, 'YYYY month') as traffic_month,
      SUM(page_views_per_million) as total_traffic
      FROM traffics
      WHERE company_url='#{company_url}'
      GROUP BY traffic_month;"
    @traffics = Traffic.connection.execute(sql)    
  end

  # GET /traffics/1
  # GET /traffics/1.json
  def show
  end

  # GET /traffics/new
  def new
    @traffic = Traffic.new
  end

  # GET /traffics/1/edit
  def edit
  end

  # POST /traffics
  # POST /traffics.json
  def create
    @traffic = Traffic.new(traffic_params)

    respond_to do |format|
      if @traffic.save
        format.html { redirect_to @traffic, notice: 'Traffic was successfully created.' }
        format.json { render :show, status: :created, location: @traffic }
      else
        format.html { render :new }
        format.json { render json: @traffic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /traffics/1
  # PATCH/PUT /traffics/1.json
  def update
    respond_to do |format|
      if @traffic.update(traffic_params)
        format.html { redirect_to @traffic, notice: 'Traffic was successfully updated.' }
        format.json { render :show, status: :ok, location: @traffic }
      else
        format.html { render :edit }
        format.json { render json: @traffic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /traffics/1
  # DELETE /traffics/1.json
  def destroy
    @traffic.destroy
    respond_to do |format|
      format.html { redirect_to traffics_url, notice: 'Traffic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_traffic
      @traffic = Traffic.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def traffic_params
      params.require(:traffic).permit(:record_date, :page_views_per_million, :page_views_per_user, :rank, :reach_per_million)
    end
end
