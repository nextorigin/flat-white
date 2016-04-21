# To set the environment variable on heroku use:
# heroku config:add DBURL=mongodb://user:pass@host:port/database

exports =
  db_host: process.env['DB_HOST'] # OR 'mongodb://user:pass@host:port/database'
  db_username: "admin"
  db_password: "PASSWORD"
  address: "127.0.0.1"
  blog_title: 'Sample Title'
  blog_description: 'Sample Blog Description'
  feed_url: 'http://blogurl.com/rss.xml'
  site_url: 'http://blogurl.com'
  site_image_url: 'http://blogurl.com/icon.png'
  site_author: 'Blogs Author Name'

  author_email: 'blog@authorname.com'
  author_facebook_url: 'https://www.facebook.com/author'
  author_twitter_url: 'http://twitter.com/author'
  author_linkedin_url: 'http://www.linkedin.com/pub/author_url'
  author_github_url: 'https://github.com/author'
  author_skype_url: 'callto://skype_author_username'
  author_bio_description: 'Blog owner biography/description'

  crypto_key: 'e981739hdkdfasdfknasdfiu9823oa0sdf9023o4f' #change it in production
  locale: 'pt-br'
  theme: 'default'