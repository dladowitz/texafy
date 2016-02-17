class AcademicsController < ApplicationController
  def index

    # TODO create way to record each variaion searched

    if params[:api_request] == "on"

      # Getting an array of 3 letter variations
      # total variations = 17576
      @start = 2000
      @stop = 2028
      @search_count = @start
      @variations = alphabet_variations(@start, @stop)
      @entries = 0
      @created = 0
      @not_created = 0

      # Running each variation through the ldap search
      @variations.each do |variation|
        ldap_search_and_create(variation + "*")

        # pause so we don't get blocked
        sleep_time = rand(10)
        puts "\n---------------- Variation #{variation}. Search #{@search_count} of #{@stop} -----------\n"
        puts "\n++++++++++++++++ #{@entries} records found so far +++++++++++++++++++++\n"
        puts "\n>>>>>>>>>>>>>>>> #{@created} records created so far <<<<<<<<<<<<<<<<<<<\n"
        puts "\n<<<<<<<<<<<<<<<< #{@not_created} records NOT created  >>>>>>>>>>>>>>>>>\n"
        puts "\n//////////////// Sleeping for #{sleep_time} ///////////////////////////\n"
        sleep sleep_time
        @search_count += 1
      end
    end

    @academics = Academic.all
  end


  private

  def ldap_search_and_create(query)

    ldap = Net::LDAP.new :host => "directory.utexas.edu",
     :port => 389,
     :auth => {
           :method => :anonymous,
     }

    filter = Net::LDAP::Filter.eq("uid", query)
    treebase = "dc=directory,dc=utexas,dc=edu"

    ldap.search(:base => treebase, :filter => filter) do |entry|
      @entries += 1

      puts "DN: #{entry.dn}"
      entry.each do |attribute, values|
        puts "   #{attribute}:"
        values.each do |value|
          puts "      --->#{value}"
        end
      end

    #  TODO abstract this out to academic.rb
      academic = Academic.new( uta_id: entry[:uid].first,
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

      if academic.save
        @created += 1
        puts "\n+++++++++++++++ Academic Created Successfully: #{academic.first_name} #{academic.last_name} ++++++++++++++++++++\n"
      else
        @not_created += 1
        puts "\n<<<<<<<<<<< Academic NOT Created: #{academic.first_name} #{academic.last_name} - Error: #{academic.errors.full_messages} >>>>>>>>>>>>>>>>>>\n"
      end
    end
  end


  def alphabet_variations(start, stop)
    count = 17576
    variations = ('aaa'..'zzz').to_a.uniq

    return variations[start..stop]

  end

end
