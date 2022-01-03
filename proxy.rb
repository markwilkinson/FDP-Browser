#require 'rdf/raptor'
require 'linkeddata'
require 'sparql'
require 'sinatra'
require 'rest-client'
require 'json'
require 'erb'
require 'rdf/vocab'

get '/' do
  erb :index, { :locals => params, :layout => :layout, :content_type => :html }
  
end

get '/proxy' do
  getit()
  erb :renderme, {:layout => false, :content_type => :xml}
end


def getit()
  xslts = get_xslts
  url = params[:url]
  url.gsub!(/\.\w\w\w$/, "")
  url.gsub!(/\/$/, "")
  ttl = url + "/?format=ttl"
  $stderr.puts "\n\nTHE URL IS " + ttl + "\n\n"
  content = RestClient.get(ttl)
  rdf = content.body
  
  io = StringIO.new(rdf)

  reader = RDF::Reader.for(:turtle).new(io)

  queryable = RDF::Repository.new
  reader.each_statement {|s| queryable << s}
  
  query = %(
    PREFIX dcterms: <http://purl.org/dc/terms/>
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX ldp: <http://www.w3.org/ns/ldp#>
    SELECT ?member ?type
    WHERE {
      ?s ldp:membershipResource ?member .
      ?member a ?type
    }
    )
  
#  $stderr.puts "\n\nXSLTs:  #{xslts}\n\n"
  query = SPARQL.parse(query)
  type = "Unknown"
  queryable.query(query) do |result|
    thistype = result[:type].to_s
#    $stderr.puts "Type Found #{thistype}"
    next unless xslts.keys.include?(thistype)
    type=thistype
#    $stderr.puts "Type Set #{type}"
  end
#  $stderr.puts "Type Final #{type}"
  xslt = xslts[type]
#  $stderr.puts "XSLT Final #{xslt}"


  @xmldata = RDF::Writer.for(:rdfxml).buffer do |w|
   w.prefix(:foaf, RDF::URI.new("http://xmlns.com/foaf/0.1/"))
   w.prefix(:dc, RDF::URI.new("http://purl.org/dc/terms/"))
   w.prefix(:spar, RDF::URI.new("http://purl.org/spar/datacite/"))
   w.prefix(:sio, RDF::URI.new("http://semanticscience.org/resource/"))
   w.prefix(:dcat, RDF::URI.new("http://www.w3.org/ns/dcat#"))
   w.prefix(:re, RDF::URI.new("http://www.re3data.org/schema/3-0#"))
   w.prefix(:fdp, RDF::URI.new("http://rdf.biosemantics.org/ontologies/fdp-o#"))
   w.prefix(:ldp, RDF::URI.new("http://www.w3.org/ns/ldp#"))
   w.prefix(:rdf, RDF::URI.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#"))
   w.prefix(:rdfs, RDF::URI.new("http://www.w3.org/2000/01/rdf-schema#"))

    #queryable.each_statement {|s| w << s}
   w << queryable
end

  @xmldata.gsub!(/^(\<\?xml[^>]+\>)/, '\1
<?xml-stylesheet type="text/xsl" href="|||PUT_XSLT_HERE|||" ?>


')
  @xmldata.gsub!(/\|\|\|PUT_XSLT_HERE\|\|\|/, xslt)
  
  #$stderr.puts @xmldata

  
    
end

def get_xslts
  res = RestClient.get("http://localhost:4567/index.txt")
  list = res.body
  members = list.split("\n")
  typehash = Hash.new
  $stderr.puts members
  members.each {|m| type, xsl = m.split(","); $stderr.puts "type #{type} xsl #{xsl}"; type.strip!; xsl.strip!; typehash[type] = xsl}
  return typehash
end