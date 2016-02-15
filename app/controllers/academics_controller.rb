class AcademicsController < ApplicationController
  def index
    if params[:api_request] == "on"

      # Getting an array of 3 letter variations
      @start = 1309
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
        sleep_time = rand(30)
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
    count = 2028
      variations = ["AAA", "AAB", "AAC", "AAD", "AAE", "AAF", "AAG", "AAH", "AAI", "AAJ", "AAK", "AAL", "AAM", "AAN", "AAO", "AAP", "AAQ", "AAR", "AAS", "AAT", "AAU", "AAV", "AAW", "AAX", "AAY", "AAZ", "AAA", "ABA", "ACA", "ADA", "AEA", "AFA", "AGA", "AHA", "AIA", "AJA", "AKA", "ALA", "AMA", "ANA", "AOA", "APA", "AQA", "ARA", "ASA", "ATA", "AUA", "AVA", "AWA", "AXA", "AYA", "AZA", "AAA", "BAA", "CAA", "DAA", "EAA", "FAA", "GAA", "HAA", "IAA", "JAA", "KAA", "LAA", "MAA", "NAA", "OAA", "PAA", "QAA", "RAA", "SAA", "TAA", "UAA", "VAA", "WAA", "XAA", "YAA", "ZAA", "BBA", "BBB", "BBC", "BBD", "BBE", "BBF", "BBG", "BBH", "BBI", "BBJ", "BBK", "BBL", "BBM", "BBN", "BBO", "BBP", "BBQ", "BBR", "BBS", "BBT", "BBU", "BBV", "BBW", "BBX", "BBY", "BBZ", "BAB", "BBB", "BCB", "BDB", "BEB", "BFB", "BGB", "BHB", "BIB", "BJB", "BKB", "BLB", "BMB", "BNB", "BOB", "BPB", "BQB", "BRB", "BSB", "BTB", "BUB", "BVB", "BWB", "BXB", "BYB", "BZB", "ABB", "BBB", "CBB", "DBB", "EBB", "FBB", "GBB", "HBB", "IBB", "JBB", "KBB", "LBB", "MBB", "NBB", "OBB", "PBB", "QBB", "RBB", "SBB", "TBB", "UBB", "VBB", "WBB", "XBB", "YBB", "ZBB", "CCA", "CCB", "CCC", "CCD", "CCE", "CCF", "CCG", "CCH", "CCI", "CCJ", "CCK", "CCL", "CCM", "CCN", "CCO", "CCP", "CCQ", "CCR", "CCS", "CCT", "CCU", "CCV", "CCW", "CCX", "CCY", "CCZ", "CAC", "CBC", "CCC", "CDC", "CEC", "CFC", "CGC", "CHC", "CIC", "CJC", "CKC", "CLC", "CMC", "CNC", "COC", "CPC", "CQC", "CRC", "CSC", "CTC", "CUC", "CVC", "CWC", "CXC", "CYC", "CZC", "ACC", "BCC", "CCC", "DCC", "ECC", "FCC", "GCC", "HCC", "ICC", "JCC", "KCC", "LCC", "MCC", "NCC", "OCC", "PCC", "QCC", "RCC", "SCC", "TCC", "UCC", "VCC", "WCC", "XCC", "YCC", "ZCC", "DDA", "DDB", "DDC", "DDD", "DDE", "DDF", "DDG", "DDH", "DDI", "DDJ", "DDK", "DDL", "DDM", "DDN", "DDO", "DDP", "DDQ", "DDR", "DDS", "DDT", "DDU", "DDV", "DDW", "DDX", "DDY", "DDZ", "DAD", "DBD", "DCD", "DDD", "DED", "DFD", "DGD", "DHD", "DID", "DJD", "DKD", "DLD", "DMD", "DND", "DOD", "DPD", "DQD", "DRD", "DSD", "DTD", "DUD", "DVD", "DWD", "DXD", "DYD", "DZD", "ADD", "BDD", "CDD", "DDD", "EDD", "FDD", "GDD", "HDD", "IDD", "JDD", "KDD", "LDD", "MDD", "NDD", "ODD", "PDD", "QDD", "RDD", "SDD", "TDD", "UDD", "VDD", "WDD", "XDD", "YDD", "ZDD", "EEA", "EEB", "EEC", "EED", "EEE", "EEF", "EEG", "EEH", "EEI", "EEJ", "EEK", "EEL", "EEM", "EEN", "EEO", "EEP", "EEQ", "EER", "EES", "EET", "EEU", "EEV", "EEW", "EEX", "EEY", "EEZ", "EAE", "EBE", "ECE", "EDE", "EEE", "EFE", "EGE", "EHE", "EIE", "EJE", "EKE", "ELE", "EME", "ENE", "EOE", "EPE", "EQE", "ERE", "ESE", "ETE", "EUE", "EVE", "EWE", "EXE", "EYE", "EZE", "AEE", "BEE", "CEE", "DEE", "EEE", "FEE", "GEE", "HEE", "IEE", "JEE", "KEE", "LEE", "MEE", "NEE", "OEE", "PEE", "QEE", "REE", "SEE", "TEE", "UEE", "VEE", "WEE", "XEE", "YEE", "ZEE", "FFA", "FFB", "FFC", "FFD", "FFE", "FFF", "FFG", "FFH", "FFI", "FFJ", "FFK", "FFL", "FFM", "FFN", "FFO", "FFP", "FFQ", "FFR", "FFS", "FFT", "FFU", "FFV", "FFW", "FFX", "FFY", "FFZ", "FAF", "FBF", "FCF", "FDF", "FEF", "FFF", "FGF", "FHF", "FIF", "FJF", "FKF", "FLF", "FMF", "FNF", "FOF", "FPF", "FQF", "FRF", "FSF", "FTF", "FUF", "FVF", "FWF", "FXF", "FYF", "FZF", "AFF", "BFF", "CFF", "DFF", "EFF", "FFF", "GFF", "HFF", "IFF", "JFF", "KFF", "LFF", "MFF", "NFF", "OFF", "PFF", "QFF", "RFF", "SFF", "TFF", "UFF", "VFF", "WFF", "XFF", "YFF", "ZFF", "GGA", "GGB", "GGC", "GGD", "GGE", "GGF", "GGG", "GGH", "GGI", "GGJ", "GGK", "GGL", "GGM", "GGN", "GGO", "GGP", "GGQ", "GGR", "GGS", "GGT", "GGU", "GGV", "GGW", "GGX", "GGY", "GGZ", "GAG", "GBG", "GCG", "GDG", "GEG", "GFG", "GGG", "GHG", "GIG", "GJG", "GKG", "GLG", "GMG", "GNG", "GOG", "GPG", "GQG", "GRG", "GSG", "GTG", "GUG", "GVG", "GWG", "GXG", "GYG", "GZG", "AGG", "BGG", "CGG", "DGG", "EGG", "FGG", "GGG", "HGG", "IGG", "JGG", "KGG", "LGG", "MGG", "NGG", "OGG", "PGG", "QGG", "RGG", "SGG", "TGG", "UGG", "VGG", "WGG", "XGG", "YGG", "ZGG", "HHA", "HHB", "HHC", "HHD", "HHE", "HHF", "HHG", "HHH", "HHI", "HHJ", "HHK", "HHL", "HHM", "HHN", "HHO", "HHP", "HHQ", "HHR", "HHS", "HHT", "HHU", "HHV", "HHW", "HHX", "HHY", "HHZ", "HAH", "HBH", "HCH", "HDH", "HEH", "HFH", "HGH", "HHH", "HIH", "HJH", "HKH", "HLH", "HMH", "HNH", "HOH", "HPH", "HQH", "HRH", "HSH", "HTH", "HUH", "HVH", "HWH", "HXH", "HYH", "HZH", "AHH", "BHH", "CHH", "DHH", "EHH", "FHH", "GHH", "HHH", "IHH", "JHH", "KHH", "LHH", "MHH", "NHH", "OHH", "PHH", "QHH", "RHH", "SHH", "THH", "UHH", "VHH", "WHH", "XHH", "YHH", "ZHH", "IIA", "IIB", "IIC", "IID", "IIE", "IIF", "IIG", "IIH", "III", "IIJ", "IIK", "IIL", "IIM", "IIN", "IIO", "IIP", "IIQ", "IIR", "IIS", "IIT", "IIU", "IIV", "IIW", "IIX", "IIY", "IIZ", "IAI", "IBI", "ICI", "IDI", "IEI", "IFI", "IGI", "IHI", "III", "IJI", "IKI", "ILI", "IMI", "INI", "IOI", "IPI", "IQI", "IRI", "ISI", "ITI", "IUI", "IVI", "IWI", "IXI", "IYI", "IZI", "AII", "BII", "CII", "DII", "EII", "FII", "GII", "HII", "III", "JII", "KII", "LII", "MII", "NII", "OII", "PII", "QII", "RII", "SII", "TII", "UII", "VII", "WII", "XII", "YII", "ZII", "JJA", "JJB", "JJC", "JJD", "JJE", "JJF", "JJG", "JJH", "JJI", "JJJ", "JJK", "JJL", "JJM", "JJN", "JJO", "JJP", "JJQ", "JJR", "JJS", "JJT", "JJU", "JJV", "JJW", "JJX", "JJY", "JJZ", "JAJ", "JBJ", "JCJ", "JDJ", "JEJ", "JFJ", "JGJ", "JHJ", "JIJ", "JJJ", "JKJ", "JLJ", "JMJ", "JNJ", "JOJ", "JPJ", "JQJ", "JRJ", "JSJ", "JTJ", "JUJ", "JVJ", "JWJ", "JXJ", "JYJ", "JZJ", "AJJ", "BJJ", "CJJ", "DJJ", "EJJ", "FJJ", "GJJ", "HJJ", "IJJ", "JJJ", "KJJ", "LJJ", "MJJ", "NJJ", "OJJ", "PJJ", "QJJ", "RJJ", "SJJ", "TJJ", "UJJ", "VJJ", "WJJ", "XJJ", "YJJ", "ZJJ", "KKA", "KKB", "KKC", "KKD", "KKE", "KKF", "KKG", "KKH", "KKI", "KKJ", "KKK", "KKL", "KKM", "KKN", "KKO", "KKP", "KKQ", "KKR", "KKS", "KKT", "KKU", "KKV", "KKW", "KKX", "KKY", "KKZ", "KAK", "KBK", "KCK", "KDK", "KEK", "KFK", "KGK", "KHK", "KIK", "KJK", "KKK", "KLK", "KMK", "KNK", "KOK", "KPK", "KQK", "KRK", "KSK", "KTK", "KUK", "KVK", "KWK", "KXK", "KYK", "KZK", "AKK", "BKK", "CKK", "DKK", "EKK", "FKK", "GKK", "HKK", "IKK", "JKK", "KKK", "LKK", "MKK", "NKK", "OKK", "PKK", "QKK", "RKK", "SKK", "TKK", "UKK", "VKK", "WKK", "XKK", "YKK", "ZKK", "LLA", "LLB", "LLC", "LLD", "LLE", "LLF", "LLG", "LLH", "LLI", "LLJ", "LLK", "LLL", "LLM", "LLN", "LLO", "LLP", "LLQ", "LLR", "LLS", "LLT", "LLU", "LLV", "LLW", "LLX", "LLY", "LLZ", "LAL", "LBL", "LCL", "LDL", "LEL", "LFL", "LGL", "LHL", "LIL", "LJL", "LKL", "LLL", "LML", "LNL", "LOL", "LPL", "LQL", "LRL", "LSL", "LTL", "LUL", "LVL", "LWL", "LXL", "LYL", "LZL", "ALL", "BLL", "CLL", "DLL", "ELL", "FLL", "GLL", "HLL", "ILL", "JLL", "KLL", "LLL", "MLL", "NLL", "OLL", "PLL", "QLL", "RLL", "SLL", "TLL", "ULL", "VLL", "WLL", "XLL", "YLL", "ZLL", "MMA", "MMB", "MMC", "MMD", "MME", "MMF", "MMG", "MMH", "MMI", "MMJ", "MMK", "MML", "MMM", "MMN", "MMO", "MMP", "MMQ", "MMR", "MMS", "MMT", "MMU", "MMV", "MMW", "MMX", "MMY", "MMZ", "MAM", "MBM", "MCM", "MDM", "MEM", "MFM", "MGM", "MHM", "MIM", "MJM", "MKM", "MLM", "MMM", "MNM", "MOM", "MPM", "MQM", "MRM", "MSM", "MTM", "MUM", "MVM", "MWM", "MXM", "MYM", "MZM", "AMM", "BMM", "CMM", "DMM", "EMM", "FMM", "GMM", "HMM", "IMM", "JMM", "KMM", "LMM", "MMM", "NMM", "OMM", "PMM", "QMM", "RMM", "SMM", "TMM", "UMM", "VMM", "WMM", "XMM", "YMM", "ZMM", "NNA", "NNB", "NNC", "NND", "NNE", "NNF", "NNG", "NNH", "NNI", "NNJ", "NNK", "NNL", "NNM", "NNN", "NNO", "NNP", "NNQ", "NNR", "NNS", "NNT", "NNU", "NNV", "NNW", "NNX", "NNY", "NNZ", "NAN", "NBN", "NCN", "NDN", "NEN", "NFN", "NGN", "NHN", "NIN", "NJN", "NKN", "NLN", "NMN", "NNN", "NON", "NPN", "NQN", "NRN", "NSN", "NTN", "NUN", "NVN", "NWN", "NXN", "NYN", "NZN", "ANN", "BNN", "CNN", "DNN", "ENN", "FNN", "GNN", "HNN", "INN", "JNN", "KNN", "LNN", "MNN", "NNN", "ONN", "PNN", "QNN", "RNN", "SNN", "TNN", "UNN", "VNN", "WNN", "XNN", "YNN", "ZNN", "OOA", "OOB", "OOC", "OOD", "OOE", "OOF", "OOG", "OOH", "OOI", "OOJ", "OOK", "OOL", "OOM", "OON", "OOO", "OOP", "OOQ", "OOR", "OOS", "OOT", "OOU", "OOV", "OOW", "OOX", "OOY", "OOZ", "OAO", "OBO", "OCO", "ODO", "OEO", "OFO", "OGO", "OHO", "OIO", "OJO", "OKO", "OLO", "OMO", "ONO", "OOO", "OPO", "OQO", "ORO", "OSO", "OTO", "OUO", "OVO", "OWO", "OXO", "OYO", "OZO", "AOO", "BOO", "COO", "DOO", "EOO", "FOO", "GOO", "HOO", "IOO", "JOO", "KOO", "LOO", "MOO", "NOO", "OOO", "POO", "QOO", "ROO", "SOO", "TOO", "UOO", "VOO", "WOO", "XOO", "YOO", "ZOO", "PPA", "PPB", "PPC", "PPD", "PPE", "PPF", "PPG", "PPH", "PPI", "PPJ", "PPK", "PPL", "PPM", "PPN", "PPO", "PPP", "PPQ", "PPR", "PPS", "PPT", "PPU", "PPV", "PPW", "PPX", "PPY", "PPZ", "PAP", "PBP", "PCP", "PDP", "PEP", "PFP", "PGP", "PHP", "PIP", "PJP", "PKP", "PLP", "PMP", "PNP", "POP", "PPP", "PQP", "PRP", "PSP", "PTP", "PUP", "PVP", "PWP", "PXP", "PYP", "PZP", "APP", "BPP", "CPP", "DPP", "EPP", "FPP", "GPP", "HPP", "IPP", "JPP", "KPP", "LPP", "MPP", "NPP", "OPP", "PPP", "QPP", "RPP", "SPP", "TPP", "UPP", "VPP", "WPP", "XPP", "YPP", "ZPP", "QQA", "QQB", "QQC", "QQD", "QQE", "QQF", "QQG", "QQH", "QQI", "QQJ", "QQK", "QQL", "QQM", "QQN", "QQO", "QQP", "QQQ", "QQR", "QQS", "QQT", "QQU", "QQV", "QQW", "QQX", "QQY", "QQZ", "QAQ", "QBQ", "QCQ", "QDQ", "QEQ", "QFQ", "QGQ", "QHQ", "QIQ", "QJQ", "QKQ", "QLQ", "QMQ", "QNQ", "QOQ", "QPQ", "QQQ", "QRQ", "QSQ", "QTQ", "QUQ", "QVQ", "QWQ", "QXQ", "QYQ", "QZQ", "AQQ", "BQQ", "CQQ", "DQQ", "EQQ", "FQQ", "GQQ", "HQQ", "IQQ", "JQQ", "KQQ", "LQQ", "MQQ", "NQQ", "OQQ", "PQQ", "QQQ", "RQQ", "SQQ", "TQQ", "UQQ", "VQQ", "WQQ", "XQQ", "YQQ", "ZQQ", "RRA", "RRB", "RRC", "RRD", "RRE", "RRF", "RRG", "RRH", "RRI", "RRJ", "RRK", "RRL", "RRM", "RRN", "RRO", "RRP", "RRQ", "RRR", "RRS", "RRT", "RRU", "RRV", "RRW", "RRX", "RRY", "RRZ", "RAR", "RBR", "RCR", "RDR", "RER", "RFR", "RGR", "RHR", "RIR", "RJR", "RKR", "RLR", "RMR", "RNR", "ROR", "RPR", "RQR", "RRR", "RSR", "RTR", "RUR", "RVR", "RWR", "RXR", "RYR", "RZR", "ARR", "BRR", "CRR", "DRR", "ERR", "FRR", "GRR", "HRR", "IRR", "JRR", "KRR", "LRR", "MRR", "NRR", "ORR", "PRR", "QRR", "RRR", "SRR", "TRR", "URR", "VRR", "WRR", "XRR", "YRR", "ZRR", "SSA", "SSB", "SSC", "SSD", "SSE", "SSF", "SSG", "SSH", "SSI", "SSJ", "SSK", "SSL", "SSM", "SSN", "SSO", "SSP", "SSQ", "SSR", "SSS", "SST", "SSU", "SSV", "SSW", "SSX", "SSY", "SSZ", "SAS", "SBS", "SCS", "SDS", "SES", "SFS", "SGS", "SHS", "SIS", "SJS", "SKS", "SLS", "SMS", "SNS", "SOS", "SPS", "SQS", "SRS", "SSS", "STS", "SUS", "SVS", "SWS", "SXS", "SYS", "SZS", "ASS", "BSS", "CSS", "DSS", "ESS", "FSS", "GSS", "HSS", "ISS", "JSS", "KSS", "LSS", "MSS", "NSS", "OSS", "PSS", "QSS", "RSS", "SSS", "TSS", "USS", "VSS", "WSS", "XSS", "YSS", "ZSS", "TTA", "TTB", "TTC", "TTD", "TTE", "TTF", "TTG", "TTH", "TTI", "TTJ", "TTK", "TTL", "TTM", "TTN", "TTO", "TTP", "TTQ", "TTR", "TTS", "TTT", "TTU", "TTV", "TTW", "TTX", "TTY", "TTZ", "TAT", "TBT", "TCT", "TDT", "TET", "TFT", "TGT", "THT", "TIT", "TJT", "TKT", "TLT", "TMT", "TNT", "TOT", "TPT", "TQT", "TRT", "TST", "TTT", "TUT", "TVT", "TWT", "TXT", "TYT", "TZT", "ATT", "BTT", "CTT", "DTT", "ETT", "FTT", "GTT", "HTT", "ITT", "JTT", "KTT", "LTT", "MTT", "NTT", "OTT", "PTT", "QTT", "RTT", "STT", "TTT", "UTT", "VTT", "WTT", "XTT", "YTT", "ZTT", "UUA", "UUB", "UUC", "UUD", "UUE", "UUF", "UUG", "UUH", "UUI", "UUJ", "UUK", "UUL", "UUM", "UUN", "UUO", "UUP", "UUQ", "UUR", "UUS", "UUT", "UUU", "UUV", "UUW", "UUX", "UUY", "UUZ", "UAU", "UBU", "UCU", "UDU", "UEU", "UFU", "UGU", "UHU", "UIU", "UJU", "UKU", "ULU", "UMU", "UNU", "UOU", "UPU", "UQU", "URU", "USU", "UTU", "UUU", "UVU", "UWU", "UXU", "UYU", "UZU", "AUU", "BUU", "CUU", "DUU", "EUU", "FUU", "GUU", "HUU", "IUU", "JUU", "KUU", "LUU", "MUU", "NUU", "OUU", "PUU", "QUU", "RUU", "SUU", "TUU", "UUU", "VUU", "WUU", "XUU", "YUU", "ZUU", "VVA", "VVB", "VVC", "VVD", "VVE", "VVF", "VVG", "VVH", "VVI", "VVJ", "VVK", "VVL", "VVM", "VVN", "VVO", "VVP", "VVQ", "VVR", "VVS", "VVT", "VVU", "VVV", "VVW", "VVX", "VVY", "VVZ", "VAV", "VBV", "VCV", "VDV", "VEV", "VFV", "VGV", "VHV", "VIV", "VJV", "VKV", "VLV", "VMV", "VNV", "VOV", "VPV", "VQV", "VRV", "VSV", "VTV", "VUV", "VVV", "VWV", "VXV", "VYV", "VZV", "AVV", "BVV", "CVV", "DVV", "EVV", "FVV", "GVV", "HVV", "IVV", "JVV", "KVV", "LVV", "MVV", "NVV", "OVV", "PVV", "QVV", "RVV", "SVV", "TVV", "UVV", "VVV", "WVV", "XVV", "YVV", "ZVV", "WWA", "WWB", "WWC", "WWD", "WWE", "WWF", "WWG", "WWH", "WWI", "WWJ", "WWK", "WWL", "WWM", "WWN", "WWO", "WWP", "WWQ", "WWR", "WWS", "WWT", "WWU", "WWV", "WWW", "WWX", "WWY", "WWZ", "WAW", "WBW", "WCW", "WDW", "WEW", "WFW", "WGW", "WHW", "WIW", "WJW", "WKW", "WLW", "WMW", "WNW", "WOW", "WPW", "WQW", "WRW", "WSW", "WTW", "WUW", "WVW", "WWW", "WXW", "WYW", "WZW", "AWW", "BWW", "CWW", "DWW", "EWW", "FWW", "GWW", "HWW", "IWW", "JWW", "KWW", "LWW", "MWW", "NWW", "OWW", "PWW", "QWW", "RWW", "SWW", "TWW", "UWW", "VWW", "WWW", "XWW", "YWW", "ZWW", "XXA", "XXB", "XXC", "XXD", "XXE", "XXF", "XXG", "XXH", "XXI", "XXJ", "XXK", "XXL", "XXM", "XXN", "XXO", "XXP", "XXQ", "XXR", "XXS", "XXT", "XXU", "XXV", "XXW", "XXX", "XXY", "XXZ", "XAX", "XBX", "XCX", "XDX", "XEX", "XFX", "XGX", "XHX", "XIX", "XJX", "XKX", "XLX", "XMX", "XNX", "XOX", "XPX", "XQX", "XRX", "XSX", "XTX", "XUX", "XVX", "XWX", "XXX", "XYX", "XZX", "AXX", "BXX", "CXX", "DXX", "EXX", "FXX", "GXX", "HXX", "IXX", "JXX", "KXX", "LXX", "MXX", "NXX", "OXX", "PXX", "QXX", "RXX", "SXX", "TXX", "UXX", "VXX", "WXX", "XXX", "YXX", "ZXX", "YYA", "YYB", "YYC", "YYD", "YYE", "YYF", "YYG", "YYH", "YYI", "YYJ", "YYK", "YYL", "YYM", "YYN", "YYO", "YYP", "YYQ", "YYR", "YYS", "YYT", "YYU", "YYV", "YYW", "YYX", "YYY", "YYZ", "YAY", "YBY", "YCY", "YDY", "YEY", "YFY", "YGY", "YHY", "YIY", "YJY", "YKY", "YLY", "YMY", "YNY", "YOY", "YPY", "YQY", "YRY", "YSY", "YTY", "YUY", "YVY", "YWY", "YXY", "YYY", "YZY", "AYY", "BYY", "CYY", "DYY", "EYY", "FYY", "GYY", "HYY", "IYY", "JYY", "KYY", "LYY", "MYY", "NYY", "OYY", "PYY", "QYY", "RYY", "SYY", "TYY", "UYY", "VYY", "WYY", "XYY", "YYY", "ZYY", "ZZA", "ZZB", "ZZC", "ZZD", "ZZE", "ZZF", "ZZG", "ZZH", "ZZI", "ZZJ", "ZZK", "ZZL", "ZZM", "ZZN", "ZZO", "ZZP", "ZZQ", "ZZR", "ZZS", "ZZT", "ZZU", "ZZV", "ZZW", "ZZX", "ZZY", "ZZZ", "ZAZ", "ZBZ", "ZCZ", "ZDZ", "ZEZ", "ZFZ", "ZGZ", "ZHZ", "ZIZ", "ZJZ", "ZKZ", "ZLZ", "ZMZ", "ZNZ", "ZOZ", "ZPZ", "ZQZ", "ZRZ", "ZSZ", "ZTZ", "ZUZ", "ZVZ", "ZWZ", "ZXZ", "ZYZ", "ZZZ", "AZZ", "BZZ", "CZZ", "DZZ", "EZZ", "FZZ", "GZZ", "HZZ", "IZZ", "JZZ", "KZZ", "LZZ", "MZZ", "NZZ", "OZZ", "PZZ", "QZZ", "RZZ", "SZZ", "TZZ", "UZZ", "VZZ", "WZZ", "XZZ", "YZZ", "ZZZ"]

    return variations[start..stop]

  end

end
