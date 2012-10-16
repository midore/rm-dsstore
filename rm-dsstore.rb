# coding: utf-8
# rm-dsstore.rb

#---------------------------------------------------------------------
# Search files named .DS_Store in ENV['HOME']
# usage
# % ruby rm-dsstore.rb
# % ruby rm-dsstore.rb 'rmf'
# Other directory
# % ruby rm-dsstore.rb /Volumes/dir
# % ruby19 rm-dsstore.rb /Volumes/dir 'rmf'
#---------------------------------------------------------------------
#
# Mac OS X 10.8.2
# ruby 1.9.3p286 (2012-10-12 revision 37165) [x86_64-darwin12.2.0]
# ruby 1.9.3p125 (2012-02-16 revision 34643) [x86_64-darwin12.2.0]
# ruby 1.8.7 (2012-02-08 patchlevel 358) [universal-darwin12.0]
#
# Mac OS X 10.7.2
# ruby 1.9.3p0 (2011-10-30 revision 33570) [x86_64-darwin11.2.0]
# ruby 1.8.7 (2010-01-10 patchlevel 249) [universal-darwin11.0]

require 'find'

class DSStore
  def initialize(path, option)
    @path = path
    @option = option
    @checkdir = FileTest.directory?(path)
    @checkpath = File.exist?(path)
    @list = Array.new
  end

  def ls_or_rm
    return print "not found directory\n" unless @checkpath
    return print "It is not directory\n" unless @checkdir
    return print "not found .DS_Store file\n" if list.empty?
    @list.each{|f|
      file = f =~ /\s/ ? f.gsub(/\s/, "\ " ) : f
      @option == 'rmf' ? sys_rm(file) : sys_ls(file)
    }
  end

  private
  def list
    Find.find(@path){|path|
     next unless File.readable?(path)
     next if File.directory?(path)
     x = File.basename(path)
     @list << path if x == ".DS_Store"
    }
    return @list
  end

  def sys_ls(f)
    system("ls \'#{f}\'")
  end

  def sys_rm(f)
    system("rm \'#{f}\'")
    print "Removed: #{f}\n"
  end
end

t = Time.now
dir, opt = ENV['HOME'], nil if ARGV.nil?
if ARGV[1].nil?
  case ARGV[0]
  when /\//
    dir, opt = ARGV[0], nil
  else
    dir, opt = ENV['HOME'], ARGV[0]
  end
end
dir, opt = ARGV[0], ARGV[1] unless ARGV[1].nil?
print "TargetDir: #{dir}\nOption: #{opt}\n"
print "------------------------------\n"
DSStore.new(dir, opt).ls_or_rm
t2 = Time.now - t
print "\n=>Time: #{t2.to_s}\n"

