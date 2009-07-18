require 'rubygems'
require 'mechanize'
require 'log4r'
require 'fileutils'
require 'nkf'
require 'kconv'

require File.join(File.dirname(__FILE__), "image_collector", "version")

module ImageCollector
  class Collector
    def collect(opts)
      @index = 0
      @imglist = []
      if opts[:put_version]
        put_version
      elsif opts[:url] && opts[:dir]
        init_dir(opts[:dir])
        collect_contents(opts[:url])
      elsif opts[:file]
        dir = nil
        File.open(opts[:file]) do |f|
          f.each_line do |line|
            line.chomp!
            if line =~ /^https?:\/\//
              unless dir
                dir = "image"
                init_dir(dir)
              end
              collect_contents(line)
              sleep(0.5)
            else
              unless line.empty?
                # dir = Kconv.kconv(line, Kconv::SJIS).unpack('a*')[0].chomp
                dir = Kconv.kconv(line, Kconv::SJIS)
                init_dir(dir)
              end
            end
          end
        end
      else
        usage
      end
    end

    def usage
      puts <<EOS
imgcol
  -d out dir
  -u url
  -f list file
  -v puts version
EOS
    end

    private
    def put_version
      puts "ImageCollector version #{ImageCollector::VERSION::STRING}"
    end

    def init_dir(dir)
      @index = 0
      @imglist.clear

      set_uniq_dir_name(dir)
      FileUtils.mkdir_p(@dir)

      @logger = Log4r::Logger.new("ImageCollector")
      formatter = Log4r::PatternFormatter.new(
                                              :pattern => "%d %C[%l]: %M",
                                              :date_format => "%Y/%m/%d %H:%M:%S")

      logfile = File.join(@dir, "request-#{Time.now.strftime('%Y%m%d%H%M%S')}.log")
      @logger.outputters =
        Log4r::FileOutputter.new(
                                 "file",
                                 :filename => logfile,
                                 :trunc => false,
                                 :formatter => formatter
                                 )
      # @logger.outputters = Log4r::StdoutOutputter.new('console',
      #                                                 :formatter => formatter,
      #                                                :level=>Log4r::DEBUG)
    end

    def collect_contents(url)
      begin
        collect_data(url)
      rescue Exception => e
        @logger.error(e.to_s +
                      "\n  " + e.backtrace.join("\n  "))
      end
    end

    def collect_data(url, search_image = true)
      begin
        @agent = WWW::Mechanize.new
        @agent.user_agent_alias = 'Windows IE 7'

        @logger.info("get start: #{url}")
        page = @agent.get(url)
        # @logger.debug("=====================")
        # @logger.debug(page.body)
        # @logger.debug("=====================")

        if search_image && page.is_a?(WWW::Mechanize::Page)
          @logger.info("collect page start: #{url}")

          image_list(url, page).each do |image_url|
            sleep(0.5)
            begin
              @logger.info("get image:#{image_url}")
              collect_data(image_url, false)
            rescue Exception => e
              @logger.error("image get error:" + e.to_s +
                            "\n  " + e.backtrace.join("\n  "))
            end
          end

          @logger.info("collect page end: #{url}")
        else
          @logger.info("save file")
          save_file(page, url)
          @index += 1
        end

        @logger.info("get end: #{url}")
      rescue Exception => e
        @logger.error(e.to_s +
                      "\n  " + e.backtrace.join("\n  "))
      end
    end

    def image_list(url, page)
      img_list = []
      page_uri = URI.parse(url)
      page.root.search('img').each do |image|
        begin
          img_list << get_image_url(page_uri, image['src'])
        rescue Exception => e
          @logger.error("image get error:" + e.to_s +
                        "\n  " + e.backtrace.join("\n  "))
        end
      end

      img_list.uniq
    end

    def get_image_url(page_uri, image_src)
      if /^https?:\/\// =~ image_src
        return image_src;
      end

      # @logger.debug("page_uri:#{page_uri}")
      # @logger.debug("image_src:#{image_src}")
      if /^\// =~ image_src
        image_uri = URI.parse(image_src)
        image_uri.scheme ||= page_uri.scheme
        image_uri.host ||= page_uri.host
        image_uri.port ||= page_uri.port
        image_url = image_uri.to_s
      else
        image_url = File.dirname(page_uri.to_s)
        image_url += "/"
        image_url += image_src
      end

      image_url
    end

    def save_file(file, url)
      file_name = sprintf("%05d_%s", @index, File.basename(url, '.*'))

      ext = File.extname(url).downcase
      if ext.nil? || ext.empty?
        ext = '.jpg'
      end
      if ext =~ /(.*)\?(.*)/
        ext = $1
      end

      file_name += ext
      @logger.info("save as:#{file_name}")
      file.save(File.join(@dir, file_name))
    end

    def set_uniq_dir_name(dir)
      if File.exist? dir
        1000.times do |i|
          name = sprintf("%s_%05d", dir, i)
          unless File.exist?(name)
            @dir = name
            return
          end
        end
        raise "dir is not uniq"
      else
        @dir = dir
      end
    end
  end
end
