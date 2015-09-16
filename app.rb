require 'json'
require 'rubygems'
require 'bundler'
Bundler.require(:default)

class Api
  def self.endpoint
    "https://meduza.io/api/v3/"
  end
  def self.get(path)
    res = RestClient.get("#{endpoint}#{path}")
    OpenStruct.new(JSON.parse(res))
  end
end

Cuba.define do
  on get do
    on root do
      data = Api.get("search?chrono=all&page=0&per_page=50&locale=ru")
      respond = Tilt.new("views/layout.html.erb").render do
        Tilt.new("views/root.html.erb").render(data)
      end
      res.write respond
    end

    on "image/attachments/images/:f/:s/:t/:type/:img" do |f, s, t, type, img|
      res.redirect ["https://meduza.io", "image/attachments/images", f, s, t, type, img].join("/")
    end

    on ":document_type/:yyyy/:mm/:dd/:key" do |document_type, yyyy, mm, dd, key|

      data = Api.get([document_type, yyyy, mm, dd, key].join("/"))

      respond = Tilt.new("views/layout.html.erb").render do
        Tilt.new("views/#{document_type}.html.erb").render(data)
      end

      res.write respond
    end

  end
end
