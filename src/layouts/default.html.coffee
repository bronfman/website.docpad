# -----------------------------
# Prepare

# Get our formatted site title as defined by out docpad.cson file
siteTitle = @getSiteTitle()

# Merge our site keywords with our documents keywords and stringify
siteKeywords = @site.keywords.concat(@document.keywords or []).join(', ')


# -----------------------------
# Document

doctype 5
html lang: 'en', ->

	# -----------------------------
	# Document Header

	head ->
		# -----------------------------
		# Meta Information

		# Set our charset to UFT8 (oldshool method)
		meta charset:'utf-16'

		# Set our charset to UFT8 (newschool method)
		meta 'http-equiv':'content-type', content:'text/html; charset=utf-8'

		# Always use the latest rendering engine
		meta 'http-equiv':'X-UA-Compatible', content:'IE=edge,chrome=1'

		# Set our defualt viewport (window size and scaling) for mobile devices
		meta name:'viewport', content:'width=device-width, initial-scale=1'

		# SEO: Set our page title that will show up in search engine results
		meta name:'title', content:h(siteTitle)

		# SEO: Set the name of the author who wrote this page
		meta name:'author', content:h(@document.author or @site.author)

		# SEO: Set the email of the author who wrote this page
		meta name:'email', content:h(@document.email or @site.email)

		# SEO: Set the description of this page
		meta name:'description', content:h(@document.description or @site.description)

		# SEO: Set the keywords of this page
		meta name:'keywords', content:h(siteKeywords)

		# Output meta data set by DocPad and it's plugins
		text @blocks.meta.toHTML()

		# Page title as shown in the browser tab and window
		title @getSiteTitle()


		# -----------------------------
		# (RSS/ATOM) Feeds

		# Feed
		@site.feeds.forEach (feed) ->
			link
				href: h(feed.href)
				title: h(feed.title)
				type: h(feed.type or 'application/atom+xml')
				rel: 'alternate'


		# -----------------------------
		# Stylesheets

		text @blocks.styles.add([
			'/vendor/fancybox/jquery.fancybox.css'
			"/themes/#{@theme}/style.css"
			"/style.css"
		]).toHTML()



	# -----------------------------
	# Document Body

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
				@collections.pages.toJSON().forEach (page) =>
					linkClass = if @document.url.indexOf(page.url) is 0 then 'active' else 'inactive'
					linkTitle = h(page.linkTitle or '')
					linkUrl = h(page.url)
					li 'class':linkClass, ->
						a href:linkUrl, title:linkTitle, ->
							page.name

		# Document
		article '.page',
			'typeof': 'sioc:page'
			about: h @document.url
			datetime: h @document.date.toISODateString()
			-> @content

		# Footing
		footer '.footing', ->
			p '.footnote', -> @site.footnote
			p '.copyright', -> @site.copyright

		###
		# Sidebar
		aside '.sidebar', ->
			# Render all the social sections
			@site.social.forEach (social,socialKey) ->
				@partial "feed-#{socialKey}", {
					config: social
					feed: @feedr.feeds[socialKey] or null
				}
		###

		# Include our scripts
		text @blocks.scripts.add([
			'/vendor/log.js'
			'/vendor/jquery.js'
			'/vendor/modernizr.js'
			'/vendor/underscore.js'
			'/vendor/backbone.js'
			'/vendor/fancybox/jquery.fancybox.js'
			"/themes/#{@theme}/script.js"
			"/script.js"
		]).toHTML()

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
