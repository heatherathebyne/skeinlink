# SkeinLink

Free and open web application software for tracking fiber arts projects and supplies. Track
knitting, crocheting, weaving, and spinning projects, and catalog stash, for an entire fiber arts
community.

If you just want to use SkeinLink for your projects, come join the [FiberKind community](https://www.fiberkind.com)!

If you want to run your own SkeinLink or contribute code, read on.

## How to run locally

You will need Docker and Docker Compose installed.

1. Clone this repo.
2. Configure a local MySQL or MariaDB database connection by copying `config/database.yml.example` to `config/database.yml`. You shouldn't need to make any changes to it for Docker use.
3. Set site-specific SkeinLink configuration in `config/skeinlink.yml`. Start with copying `config/skeinlink.yml.example`.
4. Set site-specific Devise authentication configuration in `config/initializers/devise_custom.yml`. This file overrides the defaults in `config/initializers/devise.yml`.
5. Run `docker-compose up`.
6. Set up the database with `docker-compose exec web bundle exec rake db:create db:schema:load db:seed`.
7. Open `http://localhost:3000` in your browser. You should see SkeinLink loaded.
8. Register as a new user. (As of now, you will need to edit `app/models/user.rb` to enable `:registerable`.)
9. Unless you really want to set up Mailcatcher or a local mail server, manually confirm your new user. Open the Rails console with `bundle exec rails c` and run `User.update_all confirmed_at: DateTime.now`, then `exit`.
10. Log in!

## Contributing

Bug reports welcome! If you've discovered a bug, help me out by opening an issue.

Pull requests with bugfixes or other code contributions are _very_ welcome! Fork this repo, make
your changes there, and open a pull request. I ask that you implement basic spec coverage for any
non-view code changes you make; if you'd like help with that, let me know and I can provide
guidance.

Bug reports and pull requests are an opportunity for us to collaborate to make SkeinLink better than
we could by ourselves. I strive to treat every contribution and contributor with the respect of a
colleague and friend, and request that you do too.

Thank you for reading and contributing :)
