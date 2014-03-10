atom_feed(language: 'ru-RU') do |feed|
  feed.title "Marathon & something else"
  latest_article = @articles.last
  feed.updated(latest_article.updated_at)
  @articles.each do |article|
    feed.entry(article) do |entry|
      entry.title article.title
      entry.content sanitize_full(article.content), type: 'html'
      entry.author link_to 'Vladimir Markovnin', 'https://www.google.com/+VladimirMarkovnin', rel: 'author', type: 'html'
    end
  end
end