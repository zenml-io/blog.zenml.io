 ## Contributing

To contribute, simply create a feature branch in the format `<your name>/<feature you're working on>`. As an example, if `Bart` works on a feature to add "El Barto" to the imprint, he would be committing his changes to `bart/el-barto-imprint`.

Please check your work locally for the following

- [ ] `bundle exec jekyll serve` works and displays your changes correctly
- [ ] Your changes look as intended in an up-to-date version of Chrome in all viewport sizes
- [ ] If you committed images, make sure they are a reasonable small size. Use `.svg` where possible.
- [ ] Only linked and necessary resources are committed.

After you're happy with your work, you can push and create merge requests. Please provide relevant information about your merge request in the description.

## Setup and Usage

Jekyll is just a fancy way of automating the copy-pasting of HTML blocks to form a static website. It offers a scriptable syntax called [Liquid](https://shopify.github.io/liquid/), made by our friends at Shopify.
It features conditional logic, loops and other fancy stuff, but can be clunky at times.

### Prerequisites

- `ruby` version **2.5** or higher (check with `ruby -v`)
  - As a note: I recommend to set up `rbenv` while you're at it (see: [https://github.com/rbenv/rbenv](https://github.com/rbenv/rbenv))
- RubyGems (check with `gem -v`)
- Bundler (`gem install bundler`)

### Installing

Given you have all prerequisites, to install jekyll and all dependencies simply run `bundle install` within this repo.

### Working with Jekyll

Working with Jekyll is simple, one main command is required for you to do developer-things: `bundle exec jekyll serve`. This will spawn a self-updating webserver with IOwatch on the current working directory.

Note: Pass the `--livereload` option to serve to automatically refresh the page with each change you make to the source files: `bundle exec jekyll serve --livereload`

**IMPORTANT NOTE:** changes to the `_config.yml` require a restart of `bundle exec jekyll serve`.

### Syntax and structure

I recommend familiarizing yourself with Jekyll before doing major changes in this repo, starting here: [jekyllrb.com/docs/step-by-step/02-liquid/](https://jekyllrb.com/docs/step-by-step/02-liquid/).

As a brief primer on structure:

- `/` contains all folders, the site-wide `_config.yaml` (keys are accessible on pages via `{{ site.<key> }}`) and main "pages" (e.g. `index.html`). [Read more](https://jekyllrb.com/docs/pages/).
- `_includes/` contains re-usable elements, e.g. `nav.html` or `head.html`, which are used across layouts. [Read more](https://jekyllrb.com/docs/includes/).
- `_layouts/` contain unique layouts. They usually build the structure of a page, and then include the content of a page via `{{ content }}`. [Read more](https://jekyllrb.com/docs/layouts/).
- For blogs, `_posts` has a special function. [Please read the official documentation for more info](https://jekyllrb.com/docs/posts/).
- `_data/` is a great place to store site-wide referenced information in `.yaml`-notation.

### Pushing Blog to Production

Any time a new blogpost is added, you must run the `python scripts/tag_generator.py` manually once all blogposts are added to the `_posts` directory, and all tags have been listed in the metadata at the top of each post.

(We are working on a fix for this to run automatically, but for now, make sure )