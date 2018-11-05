class Client < User

  def self.all
    super.where(role: 2)
    # puts "MASUK CLIENT"
  end
end
