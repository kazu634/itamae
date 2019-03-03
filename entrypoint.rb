# [Chef\-soloからItamaeに完全移行した話 \- Qiita](https://qiita.com/toritori0318/items/00ea2a75c8321aaf9ef6)
node["recipes"] = node["recipes"] || []

# レシピを順番にinclude_recipeするだけ
node["recipes"].each do |recipe|
  include_recipe recipe
end
