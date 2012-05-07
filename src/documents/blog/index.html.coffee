---
name: 'Blog'
linkTitle: 'View articles'
pageOrder: 2
layout: 'page'
---

# Post Listing
text @partial 'list-documents.html.coffee', {
	documents: @collections.posts.toJSON()
}