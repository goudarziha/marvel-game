class Character
	def initialize(data_obj = {})
	   @id = data_obj["id"]
	   @name = data_obj["name"]
	   @description =  data_obj["description"]
	end

	def name
		return @name
	end

	def id
		return @id
	end

	def description
		return @description
	end

 end