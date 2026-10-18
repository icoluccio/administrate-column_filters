module AdministrateSearch
  def search(term)
    Administrate::Search.new(Article.all, ArticleDashboard.new, term).run
  end
end
