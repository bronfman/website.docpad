# Document List
nav '.list-documents', 'typeof':'dc:collection', ->
	@documents.forEach (document) ->
		li '.list-documents-document', 'typeof':'soic:post', about:document.url, ->
			# Display a header link
			h3 ->
				a '.list-documents-link', href:document.url, ->
					strong '.list-documents-title', property:'dc:title', ->
						document.title
					small '.list-documents-date', property:'dc:date', ->
						document.date.toShortDateString()

			# Display the description if it exists
			if document.description
				p '.list-documents-description', property:'dc:description', ->
					document.description
