# Smpl prjkt for chtmll 🥴

## Usage

```shell script
git clone https://github.com/a0s/chtmll.git
cd chtmll

bundle install
bundle exec rake db:create
bundle exec rake db:migrate

# Then extract your dataset into ./dataset like
# ./dataset/categories.json
# ./dataset/reviews.json
# ./dataset/themes.json
# and import it with:
bundle exec rake import_dataset
# or 
bundle exec rake import_dataset path=PATH_TO_DATASET

bundle exec rails s # start server
```

## API Endpoints

`GET /reviews` - filter reviews by theme_ids/category_ids/comments.
Example:
```bash
curl -s "localhost:3000/reviews?comments[]=find&theme_ids[]=6345&theme_ids[]=6374&category_ids[]=1223&limit=5" | jq
[
  {
    "id": 58925314,
    "comment": "... SKIPPED ...",
    "themes": [
      {
        "sentiment": 1,
        "theme_id": 6345
      },
      {
        "sentiment": 1,
        "theme_id": 6344
      },
      {
        "sentiment": 1,
        "theme_id": 6374
      }
    ]
  },

... SKIPPED ...

]
```

`GET /reviews/avg_by_theme` - average sentiment for reviews filtered by theme_ids/category_ids/comments and 
splitted by theme_id. Example:
```bash
curl -s "localhost:3000/reviews/avg_by_theme?comments[]=find&category_ids[]=1223" | jq
[
  {
    "theme_id": 6344,
    "avg_sentiment": 1
  },
  {
    "theme_id": 6345,
    "avg_sentiment": 1
  },
  {
    "theme_id": 6349,
    "avg_sentiment": -1
  }
]
```

`GET /reviews/avg_by_category` - average sentiment for reviews filtered by theme_ids/category_ids/comments and 
splitted by theme id. Example:
```bash
curl -s "localhost:3000/reviews/avg_by_category?comments[]=find&category_ids[]=1223" | jq
[
  {
    "category_id": 1223,
    "avg_sentiment": 0.8666666666666667
  }
]
```

`POST /review` - create new review for existing theme_id
```bash
curl -s -X POST --data '{"comment":"ololo", "themes":[{"theme_id":6345,"sentiment":1}]}' -H 'Content-Type: application/json' localhost:3000/review | jq
{
  "id": 59460021,
  "comment": "ololo",
  "themes": [
    {
      "sentiment": 1,
      "theme_id": 6345
    }
  ]
}
```
   
## Tests

```bash
> rspec -f p                                                                                                                                                  (ruby-2.6.3@chtmll) 
................................................

Finished in 2.3 seconds (files took 2.11 seconds to load)
48 examples, 0 failures
```

## TODO

* mass async insert over rabbitmq
* better specs
* endpoints for creation themes and categories

## Known issues

1) Local development and pg gem on MacOS 

```bash
brew install postgresql@9.6
gem install pg -v '1.1.4' -- --with-pg-config=/usr/local/Cellar/postgresql@9.6/9.6.16/bin/pg_config
```
 
2) Source dataset included data duplication, lets skip it during import

```json
{
    "comment": "... SKIPPED ...", 
    "themes": [
        {
            "theme_id": 6374,
            "sentiment": -1
        }, 
        {
            "theme_id": 6374,
            "sentiment": 1
        }, 
        {
            "theme_id": 6350,
            "sentiment": -1
        }, 
        {
            "theme_id": 6363,
            "sentiment": -1
        }
    ], 
    "created_at": "2019-06-18T12:22:40.000Z", 
    "id": 59421588
}
``` 
