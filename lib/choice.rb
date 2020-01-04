class Choice
    @@array = Array.new
    attr_accessor :key, :name, :value
    
    def self.all_instances
        @@array
    end

    def initialize(id, key, name, value)
        @id = id
        @key = key
        @name = name
        @value = value
        @@array << self
    end

    def name
        return @name
    end

    def return_arr
        return {'key': @key.to_s, 'name': @name, 'value': :value}
    end
end