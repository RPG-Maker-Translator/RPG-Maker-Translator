require 'pathname'

if __FILE__ == $0
	link = ARGV[0]
	target = ARGV[1]
	
	if File.exists?(target)
		sourcePath = Pathname.new(link.gsub("\\", "/"))
		targetPath = Pathname.new(target.gsub("\\", "/"))
				
		command = "cmd.exe /c mklink \"#{sourcePath.realdirpath.to_s.gsub('/', '\\')}\" \"#{targetPath.realdirpath.to_s.gsub('/', '\\')}\""
		puts "Running: #{command}"
		`#{command}`
	end
end