class ValuesController < ApplicationController
  def new
    @value = Value.new
  end

  def show
    @value = Value.find(params[:id])
  end

  def index
    @values = Value.all
    @values_count = Value.count
  end

  def create
    @input = params.require(:value)[:input].to_i

    if @input % 15 == 0
      @output = "FizzBuzz!"
    elsif @input % 3 == 0
      @output = "Fizz!"
    elsif @input % 5 == 0
      @output = "Buzz!"
    else
      @output = "Invalid Number!"
    end

    params.require(:value)[:output] = @output
    @value = Value.new(value_params)
    if @value.valid?
      @value.save
      redirect_to @value
    else
      # 動いてない
      flash.now[:danger] = 'Number Only!!'
      render action: "new"
    end
  end

  # model にメソッドを移すときのサンプル
  # def fizzbuzz
  #   if self.input % 15 == 0
  #     @output = "FizzBuzz!"
  #   elsif self.input % 3 == 0
  #     @output = "Fizz!"
  #   elsif self.input % 5 == 0
  #     @output = "Buzz!"
  #   else
  #     @output = "Invalid Number!"
  #   end
  # end

  private

    def value_params
      params.require(:value).permit(:input, :output)
    end
end
