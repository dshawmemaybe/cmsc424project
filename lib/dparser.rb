require 'nokogiri'
def parseHTML(html)
	components = []
	f = File.open("parsertest.html")
	doc = Nokogiri::HTML(f)
	# href is an array of all the imgs with their attributes
	imgs = doc.css('img')
	imgs.each { |img| 
		# attributes is hash of all the attributes in the img
		attributes = img.attributes
		# work your magic here
	}

	# do similar stuff for doc.css('a') and iframe, etc

end
