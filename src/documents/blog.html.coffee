---
name: 'Blog'
linkTitle: 'View articles'
layout: 'page'
pageOrder: 2
---

# Post Listing
text @partial 'document-list.html.coffee', {
	documents: @collections.posts.toJSON()
}