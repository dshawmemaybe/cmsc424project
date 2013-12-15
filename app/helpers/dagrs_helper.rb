module DagrsHelper

	def getAuthor(filename)
		return "Administrators"
	end

	def affectedDagrs(dagr)
		mediafiles = Connection.find_by_sql("SELECT child_guid FROM connections WHERE parent_guid='#{dagr.dagr_guid}'")
		returnString = "Affected Dagrs:\n"
		
		mediafiles.each { |child|
			returnString += "#{child.child_guid}\n"
		}
		return returnString
	end	
end