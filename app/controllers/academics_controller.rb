class AcademicsController < ApplicationController
  def index

    # results = ldap_search("Adam*")

  end


  private

  def ldap_search(query)

    ldap = Net::LDAP.new :host => "directory.utexas.edu",
     :port => 389,
     :auth => {
           :method => :anonymous,
     }

    filter = Net::LDAP::Filter.eq("cn", query)
    treebase = "dc=directory,dc=utexas,dc=edu"

    results = []
    ldap.search(:base => treebase, :filter => filter) do |entry|
      results << entry
      puts "DN: #{entry.dn}"
      entry.each do |attribute, values|
        puts "   #{attribute}:"
        values.each do |value|
          puts "      --->#{value}"
        end
      end
    end

    binding.pry
    return results
  end
end
