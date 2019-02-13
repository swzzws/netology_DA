/*
скопировали файл и создали бд movie с коллекцией tags

/usr/bin/mongoimport --host $APP_MONGO_HOST --port $APP_MONGO_PORT --db movies --collection tags --file /usr/local/share/netology/raw_data/simple_tags.json
*/

/*
     общее число тегов
*/
print(db.tags.count());
/*
      считаем только количество тегов woman
*/
print(db.tags.count({name:"woman"}));

/*
      top-3 самых популярных
*/
printjson(db.tags.aggregate(
[
{$group: {_id:"$name", numName: {$sum: 1}}},
{$sort:{numName: -1}}, 
{$limit: 3}
]
)
); 


/*
запуск agg.js из ubuntu

/usr/bin/mongo $APP_MONGO_HOST:$APP_MONGO_PORT/movies /vagrant/agg.js

не понимаю как в запуске из командной строки сделать вывод не по алфавиту, а по количеству тэгов?
*/



