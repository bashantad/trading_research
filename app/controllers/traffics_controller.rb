class TrafficsController < ApplicationController
  before_action :set_traffic, only: [:show, :edit, :update, :destroy]

  def index      
    sql = "SELECT distinct(company_url) as company_url from traffics"
    @traffics = Traffic.connection.execute(sql)    
  end

  def get_details
    @traffics = Traffic.where(:company_url => params[:company_url]).order("record_date DESC")
  end

  def groups
    company_url = params[:company_url]
    ranking_divider = 10000
    sql = "SELECT
      to_char(record_date, 'YYYY-MM') as traffic_month,
      CAST(SUM(page_views_per_million) as INT) as total_traffic,
      CAST(avg(rank)/#{ranking_divider} as INT) as average_rank
      FROM traffics
      WHERE company_url='#{company_url}'
      GROUP BY traffic_month
      ORDER BY traffic_month;"
    @traffics = Traffic.connection.execute(sql)
    @traffics = accumulate_data(@traffics)
    @data = @traffics.to_a.collect{ |data| data.values }
  end

  def get_default_row(row)
    {
      "traffic_month" => row["traffic_month"],
      "total_traffic" => 0,
      "average_rank" => 0
    }
  end

  def accumulate_data(data)
    no_of_month_avg = 3
    result = []
    index = 0
    current_row = get_default_row(data.first)    
    data.to_a.each do |row|
      if(index%no_of_month_avg == 0)
        if(index != 0)
          result << current_row
        end
        index = 0        
        current_row = get_default_row(row)
      end
      current_row["total_traffic"] += row["total_traffic"].to_i
      current_row["average_rank"] += row["average_rank"].to_i
      index = index + 1
    end
    if current_row["total_traffic"] > 0
      result << current_row
    end
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
