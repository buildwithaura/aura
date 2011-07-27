class Page < Sequel::Model
  def self.seed(type=nil, &blk)
    super

    return  unless type == :sample

    blk.call :info, "Creating sample pages..."

    require "ffaker"
    lorem = lambda { Faker::Lorem.paragraphs(3).map { |s| "<p>#{s}</p>" }.join("\n\n") }

    p1 = self.create :title => "Home",
                      :slug => "home",
                      :body => lorem.call

    p1 = self.create :title => "About us",
                      :slug => "about-us",
                      :body => lorem.call

    p1 = self.create :title => "Products",
                      :slug => "products",
                      :body => lorem.call

    [ "Sony iPhone", "Blackberry iXUS",
      "Canon Vostro", "Nokia Curve"
    ].each do |product|
      p2 = self.create :title => product,
                        :parent_id => p1.id,
                        :body => lorem.call
      [ "8GB Black", "8GB White", "16GB 3G", "16GB Wifi" ].each do |type|
        p3 = self.create :title => type,
                          :parent_id => p2.id,
                          :body => lorem.call
      end
    end

    p1 = self.create :title => "Employees",
                      :slug => "employees",
                      :body => lorem.call

    8.times {
      p2 = self.create :title => Faker::Name.name,
                        :parent_id => p1.id,
                        :body => lorem.call
    }
  end
end
