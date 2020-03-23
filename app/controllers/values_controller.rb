class ValuesController < ApplicationController
  def new
    @value = Value.new
  end

  def show
  end

  def index
  end

  def create
     @value = Value.new(value_params)
     if @value.valid?
       @value.save
       redirect_to action: "index"
     else
       # 機能していない
       render action: "new"
     end
  end

  private

    def value_params
      params.require(:value).permit(:input, :output)
    end
end
