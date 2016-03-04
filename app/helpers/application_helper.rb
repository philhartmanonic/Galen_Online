module ApplicationHelper

  require 'redcarpet'
  require 'rouge'
  require 'rouge/plugins/redcarpet'

  class HTML < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
    def autolink(link, link_type)
      case link_type
        when :url then url_link(link)
        when :email then email_link(link)
      end
    end
    def url_link(link)
      case link
        when /^https:\/\/www.youtube/ then youtube_link(link)
        when /^https:\/\/youtu.be/ then youtube_link(link)
        else 
          normal_link(link)
      end
    end
    def youtube_link(link)
      if link.include? ("/youtu.be")
        divide = link.split("youtu.be")
        video_id = divide[0]
      elsif link.include? ("www.youtube.com")
        start = link[32..-1]
        divide = start.split("&")
        video_id = divide[0]
      end
      "<iframe class=\"youtube\" width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/#{video_id}\" frameborder=\"0\" allowfullscreen></iframe>"
    end
    def normal_link(link)
      "<a href=\"#{link}\">#{link}</a>"
    end
    def email_link(email)
      "<a href=\"mailto:#{email}\">#{email}</a>"
    end
  end

  def markdown(text)
    render_options = {
      filter_html:     true,
      hard_wrap:       true, 
      link_attributes: { rel: 'nofollow' }      
    }
    renderer = HTML.new(render_options)

    extensions = {
      autolink:           true,
      fenced_code_blocks: true,
      lax_spacing:        true,
      no_intra_emphasis:  true,
      strikethrough:      true,
      superscript:        true
    }

    Redcarpet::Markdown.new(renderer, extensions).render(text).html_safe
  end
end