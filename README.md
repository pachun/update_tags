# Update Tags

`update_tags` is a command line app which automatically creates and updates your Jekyll blog post's tag's index pages so that they'll work with GitHub pages.

### The Problem

Tagging posts in jekyll is straightforward if you can use [plugins like this one][1]. However, [GitHub Pages only supports a set of whitelisted plugins][2] and I don't see any blog-post-tagging related helpers in that list. To make tags work with GitHub Pages, you need to create an index page for each of your tags, which is painful. [Read more][3]

### The Solution

Create a file named `_includes/tag_index_page.md`, like this one:

```
---
layout: default
---

<h1>{{ tag }} Posts</h1>

{% for post in tagged_posts %}
  {{ post.title }}
{% endfor %}
```

This file defines how your tag index pages will look. You get access to two special variables; `tag` and `tagged_posts`.

Then, [install update_tags](#Install) and run `update_tags continuously` while you work on your jekyll blog. Let's say you create a blog post with the following tags in your front matter:

```
---
tags: ["Test Driven Development", "Ruby"]
---
```

Two pages will be automatically created by `update_tags` using the template defined in `_includes/tag_index_page.md` for each of the two tags. You will see them in the browser at `tag/test-driven-development` and `tag/ruby`.

### Example

If the quick and dirty explanation in [The Solution](#The-Solution) section above doesn't make sense yet, try the following to see `update_tags` in action from beginning to end.

Create a new blank jekyll blog:

```sh
jekyll new MyBlog --blank
cd MyBlog
```

Create a file named `_includes/tag_index_page.md` with the following contents:

```
---
layout: default
---

<h1>{{ tag }} Posts</h1>

{% for post in tagged_posts %}
  {{ post.title }}
{% endfor %}
```

Run update_tags and jekyll serve (with live reloading):

```
update_tags continuously # leave it running
jekyll s -l              # leave it running
```

Create a blog post; here's an example you can dump into `_posts/2022-10-01-hello-world.md`:

```
---
layout: default
tags: ["React Native", "Ruby on Rails"]
---

I like making things with Ruby on Rails and React Native.
```

Now, open your browser to `localhost:4000/tag/ruby-on-rails` or `localhost:4000/tag/react-native`. You'll see the tag index pages listing all posts with the respective tag. As you write new posts with existing tags, the tag index pages will be kept in sync. When you create new tags, new tag index pages will be automatically created.

### Install

```sh
gem install update_tags
```

### Usage

Leave this running while editing your blog locally:

```
update_tags continuously
```

Or run this once before committing and pushing your edited blog back up to the GitHub pages repository:

```
update_tags now
```

You can also specify a different tag output directory:

```
update_tags continuously --at taglets
```

Or specify a different tag index page template with:

```
update_tags continuously --template _includes/my_tag_index_page_template.md
```

[1]: https://github.com/pattex/jekyll-tagging
[2]: https://pages.github.com/versions/
[3]: https://pachulski.me/jekyll-blog-post-tags-and-github-pages
