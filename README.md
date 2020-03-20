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
$ rails new FizzBuzz
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
- db name: values
- db data: input, output

## controller

- FizzBuzzes controller 作成
- new, show, index アクション追加

```
$ rails g controller values new show index
```

http://127.0.0.1:3000/values/new
http://127.0.0.1:3000/values/show
http://127.0.0.1:3000/values/index
