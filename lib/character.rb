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

	def get_word_from_seed(seed)
		if has_description
			arr = @description.split(" ")
			return arr[seed-1]
		else
			return false
		end
	end

	def has_description
		if @description.nil? || @description.empty?
			return false
		end
		return true
	end

	def create_choice_arr(i)
		return {@name => i}
	end
 end