# FizzBuzz

フォームから値を送信 > FizzBuzz 結果を表示

## purpose

- form_with の使い方の理解
- 独自のアクションを追加できるようになる

## environment

- mac OS catarina 10.16.3
- ruby 2.6.5
- ruby on rails 6.0.2.1

## setup

git 設定, サーバ起動確認

```
$ rails new fizzbuzz
$ git add .
$ git commit -m "first commit"
$ git remote add origin https://github.com/karlley/FizzBuzz.git
$ git push -u origin master
$ rails s
```

http://127.0.0.1:3000 で表示確認

## name

- model: value 
- controller: values
- view: new, show, index
- db_name: values
- column_name: input, output

## controller

- FizzBuzzes controller 作成
- new, show, index アクション追加

```
$ rails g controller values new show index
```

- http://127.0.0.1:3000/values/new
- http://127.0.0.1:3000/values/show
- http://127.0.0.1:3000/values/index

## model, DB

```
$ rails db:create
$ rails g model value input:integer output:string
$ rails db:migrate
```

コンソールで確認

```
$ rails c --sandbox
>> value = Value.new(input: 3, output: "Fizz")
>> value.valid?
>> value.save
>> value
>> Value.all
>> Value.count
```

## routes

view でpath を記述するので先にroute を作成する

config/routes.rb

```
Rails.application.routes.draw do
  get '/values/new', to: 'values#new'
  get '/values/show', to: 'values#show'
  get '/values/index', to: 'values#index'
  post '/values', to: 'values#create'
end
```

- http://127.0.0.1:3000/values/new
- http://127.0.0.1:3000/values/show
- http://127.0.0.1:3000/values/index

view で使用するroute の確認

```
$ rails routes
Prefix         Verb    URI Pattern                Controller#Action
values_new     GET     /values/new(.:format)      values#new
values_show    GET     /values/show(.:format)     values#show
values_index   GET     /values/index(.:format)    values#index
values         POST    /values(.:format)          values#create
```

## new, create

### view for new, create

new.html.erb

```
<h1>Values#new</h1>
<p>Find me in app/views/values/new.html.erb</p>

<%= form_with model: @value do |f| %>
  <%= f.label :input, "Enter a Number!", value: "Enter a Number!" %>
  <%= f.text_field :input %>
  <%= f.submit "FizzBuzz!" %>
<% end %>
```

### view for debug data

application.html.erb

```
<!DOCTYPE html>
<html>
  <head>
    <title>FizzBuzz</title>
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
  </head>

  <body>
    <%= yield %>
    <p>=========================================</p>
    <p> debug data</p>
    <%= debug(params) if Rails.env.development? %>
    <p>=========================================</p>
  </body>
</html>
```

### controller for new, create

- create にpost > DB 保存 & index.html.erb にリダイレクト
- リダイレクト先は最終的にshow に変更する
- create アクションのvalid? == false は機能していない

app/controller/values_controllers/values_controller.rb

```
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
```

## show

### route for show

```
Rails.application.routes.draw do
  get '/values/new', to: 'values#new'
  get '/values/show', to: 'values#show'
  get '/values/index', to: 'values#index'
  post '/values', to: 'values#create'
  # /values/id_number でアクセス可能になる
  resources :values
end
```

追加されたroutes を確認

```
$ rails routes
Prefix         Verb    URI Pattern                 Controller#Action
values_new     GET     /values/new(.:format)       values#new
values_show    GET     /values/show(.:format)      values#show
values_index   GET     /values/index(.:format)     values#index
values         POST    /values(.:format)           values#create
# resources で追加されたroutes
               GET     /values(.:format)           values#index
               POST    /values(.:format)           values#create
new_value      GET     /values/new(.:format)       values#new
edit_value     GET     /values/:id/edit(.:format)  values#edit
value          GET     /values/:id(.:format)       values#show
               PATCH   /values/:id(.:format)       values#update
               PUT     /values/:id(.:format)       values#update
               DELETE  /values/:id(.:format)       values#destroy
```

### view for show

show.html.erb

```
<h1>Values#show</h1>
<p>Find me in app/views/values/show.html.erb</p>

  <p>id: <%= @value.id %></p>
  <p>input: <%= @value.input %></p>
  <p>output: <%= @value.output %></p>
```

### controller for show

```
class ValuesController < ApplicationController
  def new
    @value = Value.new
  end

  def show
    @value = Value.find(params[:id])
  end

  def index
  end

  def create
     @value = Value.new(value_params)
     if @value.valid?
       @value.save
       # redirect_to action: "show"
       # /values/id で表示させるためのインスタンス変数
       redirect_to @value
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

```

## index

### view for index

index.html.erb

```
<h1>Values#index</h1>
<p>Find me in app/views/values/index.html.erb</p>

<h2><%= @values_count %> times FizzBuzz !!</h2>

<% @values.each do |value| %>
  <div>
    <p>---------------------------</p>
    <p>id: <%= value.id %></p>
    <p>input: <%= value.input %></p>
    <p>output: <%= value.output %></p>
  </div>
<% end %>

```

### controller for index

values_controller.rb

```
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
     @value = Value.new(value_params)
     if @value.valid?
       @value.save
       # redirect_to action: "show"
       redirect_to @value
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
```

## fizzbuzz

- input で入力された値をoutput でFizzBuzz 表示する
- 数値以外が入力 > flashメッセージ & new ページ再表示 <= 未実装

### model for fizzbuzz

バリデーションを設定

- 空文字以外
- 10文字以内
- 数値のみ

value.rb

```
class Value < ApplicationRecord

 # 空文字以外, 10文字以内, 数値のみ(文字列数字を数値に変換) 
 validates :input, presence: true, length: {maximum: 10}, numericality: {only_integer: true} 
 
end
```

コンソールで確認

```
$ rails c
# 空文字を弾く
>> value = Value.new(input: "")
=> #<Value id: nil, input: nil, output: nil, created_at: nil, updated_at: nil>
>> value.valid?
=> false
>> value.errors.full_messages
=> ["Input can't be blank"]
>> value.save
=> false

# 10文字以内
>> value = Value.new(input: "012345678912345")
=> #<Value id: nil, input: "012345678912345", output: nil, created_at: nil, updated_at: nil>
>> value.valid?
=> false

# 文字列の数字を数値に変換
>> value = Value.new(input: "1234")
=> #<Value id: nil, input: 1234, output: nil, created_at: nil, updated_at: nil>
>> value.valid?
=> true

# 数値以外は弾く
>> value = Value.new(input: "aiueo")
=> #<Value id: nil, input: 0, output: nil, created_at: nil, updated_at: nil>
>> value.valid?
=> false
```
### controller for fizzbuzz 

index.html.erb で入力されたinput をfizzbuzz してoutput に保存する

values_controller.rb

```
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

  private

    def value_params
      params.require(:value).permit(:input, :output)
    end
end
```