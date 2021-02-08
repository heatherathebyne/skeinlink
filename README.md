# SkeinLink

Free and open web application software for tracking fiber arts projects and supplies. Track
knitting, crocheting, weaving, and spinning projects, and catalog stash, for an entire fiber arts
community.

If you just want to use SkeinLink for your projects, come join the [FiberKind community](https://www.fiberkind.com)!

If you want to run your own SkeinLink or contribute code, read on.

## What this software is made of

* MRI Ruby 2.6.6
* Rails 6.0

## Additional requirements

* ImageMagick
* MariaDB 10.4+

## How to run locally

1. Ensure you have Ruby 2.6.6 with Bundler installed. I like [rbenv](https://github.com/rbenv/rbenv).
2. Clone this repo.
3. `cd` to the cloned repo and `bundle`.
4. Configure a local MySQL or MariaDB database connection by copying `config/database.yml.example` to `config/database.yml`.
5. Set site-specific SkeinLink configuration in `config/skeinlink.yml`. Start with copying `config/skeinlink.yml.example`.
6. Set site-specific Devise authentication configuration in `config/initializers/devise_custom.yml`. This file overrides the defaults in `config/initializers/devise.yml`.
7. Set up the database with `bundle exec rake db:create db:schema:load db:seed`.
8. Run `bundle exec rails s` and open the URL it displays.
9. Register as a new user. (As of now, you will need to edit `app/models/user.rb` to enable `:registerable`.)
10. Unless you really want to set up Mailcatcher or a local mail server, manually confirm your new user. Open the Rails console with `bundle exec rails c` and run `User.update_all confirmed_at: DateTime.now`, then `exit`.
11. Log in!

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
