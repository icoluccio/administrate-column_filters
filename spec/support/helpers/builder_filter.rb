module BuilderFilter
  def filter(column, typed)
    described_class.new(column).to_proc.call(Article.all, typed)
  end
end
