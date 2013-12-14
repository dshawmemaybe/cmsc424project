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
	hrefs = doc.css('a')
	hrefs.each { |href| 
		# attributes is hash of all the attributes in the img
		attributes = href.attributes
		# work your magic here
	}
	iframes = doc.css('iframe')
	iframes.each { |iframe| 
		# attributes is hash of all the attributes in the img
		attributes = iframes.attributes
		# work your magic here
	}
	components.push(imgs,href,iframes)
end
