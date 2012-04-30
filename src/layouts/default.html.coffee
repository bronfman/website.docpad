# Site & Document Data
site = @site
documentTitle = if @document.title then "#{@document.title} | #{@site.title}" else @site.title

# HTML
doctype 5
html lang: 'en', ->
	head ->
		# Standard
		meta charset: 'utf-8'
		meta 'http-equiv': 'X-UA-Compatible', content: 'IE=edge,chrome=1'
		meta 'http-equiv': 'content-type', content: 'text/html; charset=utf-8'
		meta name: 'viewport', content: 'width=device-width, initial-scale=1'
		text @meta.toHTML()

		# Feed
		@site.feeds.forEach (feed) ->
			link
				href: feed.href
				title: feed.title
				type: (feed.type or 'application/atom+xml')
				rel: 'alternate'

		# SEO
		title documentTitle
		meta name: 'title', content: documentTitle
		meta name: 'author', content: (@document.author or site.author)
		meta name: 'email', content: (@document.email or site.email)
		meta name: 'description', content: (@document.description or site.description)
		meta name: 'keywords', content: site.keywords.concat(@document.keywords or []).join(', ')

		# Include our Styles
		text @scripts.add([
			'vendor/fancybox/jquery.fancybox.css'
			"themes/#{@theme}/style.css"
			"style.css"
		).toHTML()
	body ->
		# Heading
		header '.heading', ->
			a href:'/', title:'Return home', ->
				h1 -> @site.heading
				span '.heading-avatar', ->
			h2 ->
				text @site.subheading

		# Pages
		nav '.pages', ->
			ul ->
				@collections.pages.toJSON().forEach (page) ->
					cssname = if @document.url.indexOf(page.url) is 0 then 'active' else 'inactive'
					li 'class':cssname, ->
						a href:page.url, title:page.linkTitle ->
							page.name

		# Document
		article '.page',
			'typeof': 'sioc:page'
			about: @document.url
			datetime: @document.date.toISODateString()
			-> @content

		# Footing
		footer '.footing', ->
			p '.footnote', -> @site.footnote
			p '.copyright', -> @site.copyright

		# Sidebar
		aside '.sidebar', ->
			# Render all the social sections
			@site.social.forEach (social,socialKey) ->
				@partial "feed-#{socialKey}", {
					config: social
					feed: @feedr.feeds[socialKey] or null
				}

		# Include our scripts
		text @scripts.add([
			'vendor/log.js'
			'vendor/jquery.js'
			'vendor/modernizr.js'
			'vendor/underscore.js'
			'vendor/backbone.js'
			'vendor/fancybox/jquery.fancybox.js'
			"themes/#{@theme}/script.js"
			"script.js"
		).toHTML()

		# Analytics
		analytics = @site.analytics or {}
		if analytics.reinvigorate?
			script src:'http://include.reinvigorate.net/re_.js'
			script """
				reinvigorate.track("#{analytics.reinvigorate}");
				"""
		if analytics.google?
			script """
				var _gaq = _gaq || [];
				_gaq.push(['_setAccount', '#{analytics.google}']);
				_gaq.push(['_trackPageview']);
				(function() {
					var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
					ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
					var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
				})();
				"""
