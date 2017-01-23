class BillsController < ApplicationController
  before_action :set_bill, only: [:show, :edit, :update, :destroy]

  # GET /bills
  # GET /bills.json
  def index
    if filter_params.present? && filter_params[:filter] == "pending"
      @bills = Bill.joins(:collections).having("(bills.amount-SUM(collections.amount)) = 0").group("bills.id")
    elsif filter_params.present? && filter_params[:filter] == "collected"
      @bills = Bill.joins(:collections).having("(bills.amount-SUM(collections.amount)) != 0").group("bills.id")
    else
      @bills = Bill.all
    end
  end
  # GET /bills/1
  # GET /bills/1.json
  def show
  end

  # GET /bills/new
  def new
    @bill = Bill.new
  end

  # GET /bills/1/edit
  def edit
  end

  def load_json
  end

  def save_json
    @json = JSON.parse(json_params[:attachment].read)
    failed_objects_array = []
    @json.each do |json|
      b = Bill.create(json)
      unless b.persisted?
       failed_objects_array << b.errors.full_messages
      end
    end
    redirect_to bills_path, notice: failed_objects_array.join(",")
  end

  def load_collection_json
  end

  def save_collection_json
    @json = JSON.parse(json_params[:attachment].read)
    failed_objects_array = []
    @json.each do |json|
      b = Bill.where(reference: json["reference"])
      unless b.empty?
        c = b[0].collections.create(json)
        unless c.persisted?
         failed_objects_array << c.errors.full_messages
        end
      else
        failed_objects_array << "There is no bill with reference #{json["reference"]}"
      end
    end
    redirect_to bills_path, notice: failed_objects_array.join(",")
  end
  # POST /bills
  # POST /bills.json
  def create
    @bill = Bill.new(bill_params)

    respond_to do |format|
      if @bill.save
        format.html { redirect_to bills_path, notice: 'Bill was successfully created.' }
        format.json { render :show, status: :created, location: @bill }
      else
        format.html { render :new }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bills/1
  # PATCH/PUT /bills/1.json
  def update
    respond_to do |format|
      if @bill.update(bill_params)
        format.html { redirect_to @bill, notice: 'Bill was successfully updated.' }
        format.json { render :show, status: :ok, location: @bill }
      else
        format.html { render :edit }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1
  # DELETE /bills/1.json
  def destroy
    @bill.destroy
    respond_to do |format|
      format.html { redirect_to bills_url, notice: 'Bill was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bill
      @bill = Bill.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bill_params
      params.require(:bill).permit(:invoice_date, :customer_name, :brand_manager, :narration, :amount, :reference)
    end

    def filter_params
      params.permit(:filter)
    end

    def json_params
      params.permit(:attachment)
    end
end
