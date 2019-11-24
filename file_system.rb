require 'digest'
require 'fileutils'
require 'digest/sha1'

module FileSystem
	def init()
	  	if Dir.exist?('./.dvcs')
	  		raise 'cannot create directory .dvcs: directory exists!' 
		else
			Dir.mkdir './.dvcs'
			out_file = File.new(File.join("./.dvcs", "revision_history_file"), "w")
			out_file.close
		end
	end

	def clone(pth)
		if Dir.entries("#{pth}").select {|entry| File.directory? entry}.include? '.dvcs'
			FileUtils.cp_r "#{pth}", './'
		else
			raise 'source dir is not a dvcs project!' 
		end
	end

	def store_rh(l_strings)
		open(File.join("./.dvcs", "revision_history_file"), "a") { |f|
  			l_strings.each { |element| f.puts(element) }
		}
	end

	def get_rh()
		text = []
		File.foreach(File.join("./.dvcs", "revision_history_file")) do |line|
		  text << line
		end

		text
	end

	def diff(file1, file2)
		a = open(file1, "r").read.split("\n")
		b = open(file2, "r").read.split("\n")
		if a.length != b.length
			(a.length > b.length)? (0...(a.length-b.length)).to_a.each {|_| b << nil} : (0...(b.length-a.length)).to_a.each {|_| a << nil}
		end
		diff_list = []

		a.each_with_index {|val,index| diff_list << [index, a[index], b[index]] if val != b[index]}
		diff_list
	end

	def read(path)
		File.open(path)
	end

	def write(path, string)
		if File.file?(path)
			0
		else
			open(path, 'w') { |f|
	  			f.puts string
			}
			1
		end
	end

	def cpy(path1, path2)
		if File.directory?(path1)
			FileUtils.cp_r "#{path1}", "#{path2}"
			1
		elsif File.file?(path1)
			FileUtils.cp "#{path1}", "#{path2}"
			1
		else
			0
		end
	end

	def getHash(pth)
		Digest::SHA1.hexdigest "#{pth}"
	end

	def delete(pth)
		if File.directory?(pth)
			FileUtils.remove_dir(pth)
			1
		elsif File.file?(pth)
			File.delete(pth)
			1
		else
			0
		end
	end
end

class DVCS
	include FileSystem
end

dvcs_file = DVCS.new
# dvcs_file.init()
# dvcs_file.clone('/u/zkou2/Code/453/p2')
# dvcs_file.store_rh(['a', 'b', 'c'])
# p dvcs_file.diff('file1', 'file2')
# p dvcs_file.write('file1','123')
# p dvcs_file.cpy('file1','file3')
# p dvcs_file.getHash('/u/zkou2/Code/DVCS/file1')
p dvcs_file.delete('us')