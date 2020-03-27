class Value < ApplicationRecord

 # 空文字以外, 10文字以内, 数値のみ(文字列数字を数値に変換) 
 validates :input, presence: true, length: {maximum: 10}, numericality: {only_integer: true} 
 
end
