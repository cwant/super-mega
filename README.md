# Super-Mega Search

A Ruby-on-Rails website to aggregate knowledge search for an organization.

## What? How?

It runs search API functions on several platforms and aggregates the results in a tabbed display.

The supported platforms are: Slack, Mediawiki, OTRS, and Wordpress.

You need to create `config/super-mega.yml`, `config/credentials.yml.enc` and
`config/locales/super-mega.en.yml` (or whatever non-English language you want
to support). See example files in the codebase with similar names.
