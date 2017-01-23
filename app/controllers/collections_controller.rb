class CollectionsController < ApplicationController
  def new
    @bill = Bill.find(params[:bill_id])
    @collection = @bill.collections.new
  end

  def create
  	@collection = Collection.new(collection_params)
    respond_to do |format|
      if @collection.save
        format.html { redirect_to bills_path, notice: 'collection was successfully created.' }
        format.json { render :show, status: :created, location: @collection }
      else
        @bill = Bill.find(params[:bill_id])
        format.html { render :new }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end



  private

  def collection_params
    params.require(:collection).permit(:reference, :bill_id, :amount, :collection_date)
  end
  def json_params
    params.permit(:attachment)
  end
end
