%w(
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
  .env
  .env.production
  .env.development
).each { |path| Spring.watch(path) }
