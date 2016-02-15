class AcademicsController < ApplicationController
  def index
    if params[:api_request] == "on"
      results = ldap_search("ssp22*")
    end

    @academics = Academic.all
  end


  private

  def ldap_search(query)

    ldap = Net::LDAP.new :host => "directory.utexas.edu",
     :port => 389,
     :auth => {
           :method => :anonymous,
     }

    filter = Net::LDAP::Filter.eq("uid", query)
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


        binding.pry
        Academic.create( uta_id: entry[:uid].first,
                          first_name: entry[:givenname].first,
                          last_name: entry[:sn].first,
                          email: entry[:mail].first,
                          role: entry[:utexasedupersonprimarypubaffiliation].first,
                          employee_title: entry[:title].first,
                          student_level: entry[:utexasedupersonclassification].first,
                          college: entry[:utexasedupersonschool].first ? entry[:utexasedupersonschool].first : entry[:utexasedupersonprimaryorgunitname].first,
                          major: entry[:utexasedupersonmajor].first,
                          phone: entry[:homephone].first ? entry[:homephone].first : entry[:telephonenumber]
                        )
      end
    end

    return results
  end
end
