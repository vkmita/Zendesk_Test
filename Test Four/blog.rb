class Blog

  # not sure about how to really initialize the best way. Hashes instead of strings?
  def initialize(header, footer, posts)
    @header = header
    @footer = footer
    @posts = posts.sort{|a,b| a[:created_at].to_i <=> b[:created_at].to_i }
  end

  def render
    output = render_header
    for post in @posts
      output += render_post(post) + render_comments(post) if !post[:title].nil? # a post without a title and only comments makes no sense
    end
    return output += render_footer
  end

  # a generalized renderer might be helpful
  def render_header
    return content_tag("div",(content_tag("h1",@header)))
  end

  def render_footer
    return content_tag("div",@footer)
  end

  def render_post(post)
    return content_tag("div",(content_tag("p",(post[:title].upcase))))
  end

  def render_comments(post)
    comments = ""
    for comment in post[:comments]
       comments += content_tag("div",comment) if !comment.nil?
    end
    return comments
  end

  def content_tag(tag,content)
    return "<" + tag +">" + content + "</" + tag +">"
  end
end

require 'date'
posts = [
    { :title => "I like Zendesk", :comments => "Dogs are awesome", :created_at => Time.now },
    { :title => "I like Bananas", :comments => "Typos are awesome", :created_at => Time.now },
    { :title => nil, :comments => ["wibbles are wobble", "yay"], :created_at => Time.now }
]

blog = Blog.new("my blog", "Copyright Wobble (2012)", posts)

puts blog.render