class AcademicsController < ApplicationController
  def index

    # TODO create way to record each variaion searched

    if params[:api_request] == "on"

      # Getting an array of 3 letter variations
      # total variations = 17576
      @start = 16600
      @stop = 17576
      @search_count = @start
      @variations = alphabet_variations(@start, @stop)
      @entries_this_run = 0
      @created = 0
      @not_created = 0

      # Running each variation through the ldap search
      @variations.each do |variation|
        @entries_this_variation = 0
        ldap_search_and_create(variation + "*")

        # pause so we don't get blocked
        sleep_time = rand(3)
        puts "\n---------------- Variation \'#{variation.upcase}\'. #{@entries_this_variation} entries found. -----------\n"
        puts "\n---------------- Search #{@search_count} of #{@stop} -----------\n"
        puts "\n++++++++++++++++ #{@entries_this_run} total records found this run. +++++++++++++++++++++\n"
        puts "\n>>>>>>>>>>>>>>>> #{@created} total records created this run. <<<<<<<<<<<<<<<<<<<\n"
        puts "\n<<<<<<<<<<<<<<<< #{@not_created} records skipped this run.  >>>>>>>>>>>>>>>>>\n"
        puts "\n//////////////// Sleeping for #{sleep_time} seconds. ///////////////////////////\n"

        CheckedVariation.create_or_update(letters: variation, position: @search_count, entries: @entries_this_variation)

        sleep sleep_time
        @search_count += 1
      end
    end

    @academics = Academic.all
    @checked_variations = CheckedVariation.all
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
      @entries_this_variation += 1
      @entries_this_run += 1

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
