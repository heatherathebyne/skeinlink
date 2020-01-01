# SkeinLink

Free and open web application software for tracking fiber arts projects and supplies. Track knitting, crocheting, weaving, and spinning projects, and catalog stash, for 1-10,000+ users. (I pulled that number out of a hat, but it isn't unrealistic.)

## Important information

**Personal project warning!** I'm writing this for myself first, and features are implemented in
roughly the order in which they are most important to me. Code quality may be all over the place.
Specs will happen when I feel like writing them. I ❤️ pull requests!

**This is not desktop software!** If you are here looking for a personal download-and-install project
tracker, this isn't it. This is a web application designed to be hosted on a web server. You can, of
course, run it locally on your own system, but there are extra steps involved.

**This is nowhere near feature complete!** Or even feature adequate.

**This is currently not safe to put on the public internet!** No authorization system, no file type
restrictions, ... the list goes on. It's not that the app is *inherently* unsafe, just that I
haven't yet put in mitigations for certain common methods of abuse.

## What this software is made of

* MRI Ruby 2.6.5
* Rails 6.0.1

## Additional requirements

* ImageMagick
* MariaDB 10.4

## How to run locally

1. Ensure you have Ruby 2.6.5 with Bundler installed. I like [rbenv](https://github.com/rbenv/rbenv).
2. Clone this repo.
3. `cd` to the cloned repo and `bundle`.
4. Configure a local SQLite database connection by copying `config/database.yml.example` to `config/database.yml`.
5. Set up the database with `bundle exec rake db:create db:schema:load db:seed`.
6. Run `bundle exec rails s` and open the URL it displays.
7. Register as a new user.
8. Unless you really want to set up Mailcatcher or a local mail server, manually confirm your new user. Open the Rails console with `bundle exec rails c` and run `User.update_all confirmed_at: DateTime.now`, then `exit`.
9. Log in!

## Contributing

Fork this repo, make your changes there, and send me a pull request.
