class Post < ActiveRecord::Base
	belongs_to :user
	has_many :comments
	has_many :votes, as: :takes_votes, dependent: :destroy
	accepts_nested_attributes_for :comments
	accepts_nested_attributes_for :votes
	accepts_nested_attributes_for :user

	def score
		return self.votes.where(up: true).count - self.votes.where(up: false).count
	end

	def has_comments?
		self.comments.load
		return self.comments.any?
	end

	def formatted_created_time
		self.created_at.strftime(" on %B %d, %Y at %I:%M %P")
	end

	private
	
	def to_html
    Jekyll::Converters::Markdown::RedcarpetParser.new({
      'highlighter' => 'rouge',
      'redcarpet' => {
        'extensions' => [
          "no_intra_emphasis", "fenced_code_blocks", "autolink",
          "strikethrough", "lax_spacing",  "superscript", "with_toc_data"
        ]
      }
    }).convert(markdown)
  end
end
