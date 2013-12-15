require 'nokogiri'
	def parseHTML(html)
		components = []
		f = File.open(html)
		doc = Nokogiri::HTML(f)
		# href is an array of all the imgs with their attributes
		imgs = doc.css('img')
		imgshash = []
		imgs.each { |img| 
			# attributes is hash of all the attributes in the img
			imgshash.push(img.attributes)
			# work your magic here 
		}
		hrefs = doc.css('a')
		hrefshash = []
		hrefs.each { |href| 
			# attributes is hash of all the attributes in the img
			hrefshash.push(href.attributes)
			# work your magic here
		}
		iframes = doc.css('iframe')
		iframeshash = []
		iframes.each { |iframe| 
			# attributes is hash of all the attributes in the img
			iframeshash.push(iframe.attributes)
			# work your magic here
		}
		videos = doc.css('video')
		videoshash = []
		videos.each { |video| 
			# attributes is hash of all the attributes in the img
			videoshash.push(video.attributes)
			# work your magic here
		}
		audios = doc.css('audio')
		audioshash = []
		audios.each { |audio| 
			# attributes is hash of all the attributes in the img
			audioshash.push(audio.attributes)
			# work your magic here
		}

		components.push(imgshash,hrefshash,iframeshash,videoshash, audioshash)

		return components
	end