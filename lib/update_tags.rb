require "front_matter_parser"
require "fileutils"

class UpdateTags
  def self.update(tag_directory:, path_to_tag_index_page_template:)
    new(tag_directory, path_to_tag_index_page_template).update
  end

  attr_reader :tag_directory, :path_to_tag_index_page_template

  def initialize(tag_directory, path_to_tag_index_page_template)
    @tag_directory = tag_directory
    @path_to_tag_index_page_template = path_to_tag_index_page_template
  end

  def update
    print "Updating tags..."
    delete_tag_pages
    create_tag_pages
    print " Done.\n"
  end

  private

  def delete_tag_pages
    FileUtils.rm_rf(tag_directory)
  end

  def create_tag_pages
    FileUtils.mkdir(tag_directory)

    tags.each do |tag|
      File.write(
        tag_index_page_path(tag),
        tag_index_page_source(tag),
      )
    end
  end

  def blog_post_filenames
    @blog_post_filenames ||= Dir.entries("./_posts") - [".", ".."]
  end

  def tags
    @tags ||= blog_post_filenames.inject([]) do |tags, blog_post_filename|
      new_tags = (FrontMatterParser::Parser
        .parse_file(blog_post_file(blog_post_filename))
        .front_matter["tags"])
      if new_tags.is_a? String then
        new_tags = new_tags.split(/[[:space:]]+/)
      elsif not new_tags.is_a? Array then
        new_tags = []
      end
      tags += new_tags
    end.uniq
  end

  def blog_post_file(blog_post_filename)
    "./_posts/#{blog_post_filename}"
  end

  def tag_index_page_path(tag)
    "#{tag_directory}/#{url_friendly_tag(tag)}.md"
  end

  def url_friendly_tag(tag)
    tag.downcase.split(" ").join("-")
  end

  def tag_index_page_front_matter_parser
    @tag_index_page_front_matter_parser ||= FrontMatterParser::Parser
      .parse_file(path_to_tag_index_page_template)
  end

  def tag_index_page_front_matter
    @tag_index_page_front_matter ||= \
      tag_index_page_front_matter_parser.front_matter.map do |key, value|
        "#{key}: #{value}"
      end.join("\n")
  end

  def tag_index_page_content
    @tag_index_page_content ||= tag_index_page_front_matter_parser.content
  end

  def injected_liquid_for_tag_index_page(tag)
    <<~INJECTED_LIQUID
      {% assign tag = "#{tag}" %}
      {% assign tagged_posts = "" | split: "" %}
      {% for post in site.posts %}
        {% if post.tags contains tag %}
          {% assign tagged_posts = tagged_posts | push: post %}
        {% endif %}
      {% endfor %}
    INJECTED_LIQUID
  end

  def tag_index_page_source(tag)
    <<~TAG_INDEX_PAGE
      ---
      #{tag_index_page_front_matter}
      ---

      #{injected_liquid_for_tag_index_page(tag)}

      #{tag_index_page_content}
    TAG_INDEX_PAGE
  end
end
