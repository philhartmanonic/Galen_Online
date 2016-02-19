module ApplicationHelper

  require 'redcarpet'
  require 'rouge'
  require 'rouge/plugins/redcarpet'

  class HTML < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
    def block_code(code, language)
      Rouge.highlight(code, language || 'text', 'html')
    end
  end

  class HTMLWithPants < Redcarpet::Render::HTML
    include Redcarpet::Render::SmartyPants
  end

  def markdown(content)
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, {
      autolink:            true,
      fenced_code_blocks:  true,
      superscript:         true,
      underline:           true,
      highlight:           true,
      footnotes:           true,
      quote:               true,
      tables:              true,
      no_intra_emphasis: true,
      disable_indented_code_blocks: true,
      lax_spacing: true,
      escape_html: true,
      hard_wrap: true,
      prettify: true
    })
    @markdown.render(content).html_safe
  end
end