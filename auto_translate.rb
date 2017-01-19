require 'json'
require 'net/http'
require 'fileutils'

$directory = ''
$outputPath = ''
$rootOutputPath = File.join(Dir.pwd, 'output')
$queue = []
$translated = {}
$linesInFile = 0
$currentLineNumber = 0
$noSpoilers = false
$cachedSinceDump = 0
$debug = false
$sleepOnTranslate = 3
$cacheWritesPerDump = 5
$extractedDataDir = ''
$dataDir = ''
$extractedJsonDir = ''
$extractedJsonDir = ''
$logFile = ''
$logBuffer = ''
$dataExtension = ''
$translatorTool = ''
$lastTranslateTime = Time.now
$totalProcessedLines = 0
$totalLines = 0
$linesPerUpdate = 10000
$deleteExisting = true
$logCacheHits = false
$logTranslations = true
$totalTranslations = 0
$totalCacheHits = 0
$totalFailures = 0
$breakBlocksOnKatakana = true
$translateScripts = false
$translateLinesWithVars = false
$preserveExistingData = true
$lastLogged = Time.now
$filter = {}
$outputLanguage = 'en'
$overrideCharacters = /ー,/

def translateBlock(block)
	if block.strip.length == 0
		return nil
	end

	cached = $translated[block]
	if(cached)		
		if $logCacheHits
			if $noSpoilers
				log "[#{$currentLineNumber}/#{$linesInFile}] cache hit! [#{block}]"
			else
				log "[#{$currentLineNumber}/#{$linesInFile}] cache hit! [#{block}] => [#{cached}]"
			end
		end
		$totalCacheHits += 1
		return cached
	end
	
	if $cacheOnly 
		return nil
	end
	
	trans = nil
	
	tries = 1
	loop do 
		timeDelta = Time.now - $lastTranslateTime		
		if timeDelta < $sleepOnTranslate
			log "Sleeping for [#{timeDelta}s] to throttle API usage", true
			sleep timeDelta
		end
	
		$lastTranslateTime = Time.now			
		uri = URI("http://transltr.org/api/translate")
		begin			
			Net::HTTP.start(uri.host) do |http|
			
			  req = Net::HTTP::Post.new(uri)
			  req['Content-Type'] = 'application/json'
			  req['Accept'] = 'application/json'
			  req.set_form_data(:text => block, 'from' => 'ja', 'to' => $outputLanguage)
			  response = http.request req # Net::HTTPResponse object
			  trans = JSON.parse(response.body)["translationText"]
			  if trans == nil 
				trans = ''
			  end
  			  trans = trans.gsub('"', '“')
			  trans = trans.gsub("\u0000", "")
			  $translated.merge!({ block => trans })
			  $totalTranslations += 1
			  $cachedSinceDump += 1
			  
			  if $logTranslations
				if $noSpoilers
					log "[#{$currentLineNumber}/#{$linesInFile}] translated [#{block}]"
				else
					log "[#{$currentLineNumber}/#{$linesInFile}] translated [#{block}] => [#{trans}]"
				end	
			  end			  
			  
			  if $cachedSinceDump > $cacheWritesPerDump	
				dumpCache
				$cachedSinceDump = 0
			  end
			end					
			break
		rescue Exception => e  
			log "Translation API failed for [#{block}] with message: #{e.message}"
		end	
		if tries >= 5
			$totalFailures += 1
			break
		end
		tries += 1 
		sleep $sleepOnTranslate
	end

	trans
end

def getBlock(line, currentIndex, terminatingChar)
	log "getBlock: line [#{line}] currentIndex [#{currentIndex}] terminatingChar [#{terminatingChar}]", true 
	log "getBlock: #{line.slice(currentIndex..-1).index(terminatingChar)}", true
	line[currentIndex..currentIndex + line.slice(currentIndex..-1).index(terminatingChar)]
end

def isKatakana(char)
	char.match(/[アイウエオカキクケコガギグゲゴサシスセソザジズゼゾタチツテトダヂヅデドナニヌネノハヒフヘホバビブベボパピプペポマミムメモヤユヨラリルレロワヰヱヲン]/)		
end

def isTerminatingCharacter(char)
	!char.match($overrideCharacters) and (char.match(/[ '♥“”１２３４５６９０▲●←↑→↓（）▽★・、～」▼■＠「.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()-_\[\]\"<>\n|:…！?…。♪『？―”“~\/]/) == true or !(char =~ /\p{Han}|\p{Katakana}|\p{Hiragana}/))
end

def log(line, debug = false, forceWrite = false)
		
	if !debug || $debug
		puts line
		$logBuffer += line + "\n"
		bufferLength = $logBuffer.length
		if (bufferLength > 1000 || forceWrite || Time.now - $lastLogged > 2) and File.exists?($logFile)
		
		  # the GUI can lock up the file causing this to bomb, nbd just get it the next time
		  begin
			open($logFile, 'a') { |f|
				f.puts $logBuffer
			}		
			$logBuffer = ''
			$lastLogged = Time.now
		  rescue Exception => e
		  	puts "Failed to open log file for writing"
		  end
		end
	end
end

def translationFileName
	return "translation_#{$outputLanguage}.json"
end

def dumpCache()
	if !$cacheOnly and $lastCacheWriteNumValues != nil and $lastCacheWriteNumValues != $translated.length and $translated.length > 0
		log "Writing #{$translated.length} cached translations to disk at: #{translationFileName}"
		File.open(translationFileName, 'w:UTF-8') do |file|
			file.write("#{JSON.pretty_generate($translated)}")
		end
		$lastCacheWriteNumValues = $translated.length
	end	
end

def scriptVariable(lineToEnd)
	# ex: <フェロモン値[180]>\r\n<MAXMP +100>\r\n<消費MP％減:50>
	match = lineToEnd.match(/^<.+?:.+?>/)
	if match
		return "#{match}"
	end 
	# ex: $gamevar[123] =
	match = lineToEnd.match(/^\$.+?\[[0-9]+?\].?=/)
	if match
		return "#{match}"
	end 	
	# ex: \\c[5]
	match = lineToEnd.match(/^\\\\.+?\[.+?\]/)
	if match
		return "#{match}"
	end 				
	# ex: _tv[\"移動場所設定\"]
	match = lineToEnd.match(/^[^\s\\]+?\[\\".+?"\]/)			
	if match
		return "#{match}"	
	end 		
	# ex: set_npm(8, "test4", 0,0, 150)
	match = lineToEnd.match(/^[^\s\\]+?\(.*?".*?".*?\)/)
	if match
		return "#{match}"
	end 	
	return nil
end 

def translateLine(line, isArray = false)
	if !line.include? '"' || !line
		return nil
	end
	log "processing line: " + line, true
	currentIndex = 0
	blockStartIndex = -1
	katakanaStartIndex = -1
	output = ""

	# TODO: DRY this out
	while currentIndex < line.length
	
		# check for script variables
		lineToEnd = line.slice(currentIndex..-1)
		scriptVar = scriptVariable(lineToEnd)
					
		# Current char is start of script variable or function
		if scriptVar
			# Bail on the entire line
			if !$translateLinesWithVars
				if isArray
					return line
				else 
					return nil
				end
			else
				# Translate any in progress blocks
				if(blockStartIndex != -1 or katakanaStartIndex != -1)
					startIndex = blockStartIndex
					if startIndex == -1 
						startIndex = katakanaStartIndex
					end 
					block = line.slice(startIndex..currentIndex - 1)
					
					log "[#{$currentLineNumber}/#{$linesInFile}] Terminated block [#{block}] with script var: [#{scriptVar}] for line [#{line.strip}]"
					translatedBlock = translateBlock(block)
					if translatedBlock != nil
						output += translatedBlock					
					else 
						output += block
					end
					blockStartIndex = -1
					katakanaStartIndex = -1
				end			
			
				output += scriptVar
				currentIndex += scriptVar.length
				next					
			end
		end				
		
		currentChar = line[currentIndex]
		
		# Check if current character is not Japanese
		if isTerminatingCharacter(currentChar)
			# No block is in progress
			if(blockStartIndex == -1 and katakanaStartIndex == -1)
				output += currentChar
			# A block was in progress so translate it
			else
				startIndex = blockStartIndex
				if startIndex == -1 
					startIndex = katakanaStartIndex
				end 
				log "Terminating character: [#{currentChar}]", true
				translatedBlock = translateBlock(line.slice(startIndex..currentIndex - 1))
				if translatedBlock != nil
					output += translatedBlock					
				else 
					output += line.slice(startIndex..currentIndex - 1)
				end
				blockStartIndex = -1
				katakanaStartIndex = -1
				output += currentChar
			end
			currentIndex += 1		
		# Check if current char is Katakana
		elsif $breakBlocksOnKatakana and isKatakana(currentChar)
			if blockStartIndex != -1
				translatedBlock = translateBlock(line.slice(blockStartIndex..currentIndex - 1))
				log "katakana #{currentChar} broke block: #{line.slice(blockStartIndex..currentIndex - 1)}", true
				if translatedBlock != nil
					output += translatedBlock					
				else 
					output += line.slice(blockStartIndex..currentIndex - 1)
				end
				blockStartIndex = -1
			end						
			if katakanaStartIndex == -1 
				katakanaStartIndex = currentIndex
			end 
			currentIndex += 1
		# Current character is Japanese
		else
			# Already in a translation block
			if katakanaStartIndex != -1 
				log "Broke katakana block #{line.slice(katakanaStartIndex..currentIndex - 1)} on character: [#{currentChar}]", true
				translatedBlock = translateBlock(line.slice(katakanaStartIndex..currentIndex - 1))
				if translatedBlock != nil
					output += translatedBlock					
				else 
					output += line.slice(katakanaStartIndex..currentIndex - 1)
				end
				blockStartIndex = currentIndex
				katakanaStartIndex = -1	
			end				
			
			# Start new translation block
			if blockStartIndex == -1
				log "starting translate block on character: " + currentChar, true
				blockStartIndex = currentIndex
			end			
			currentIndex += 1
		end
	end 	
	
	if !isArray and output.sub('",', '"').strip == line.sub('",', '"').strip
		return nil
	end
	
	output
end

def getFilterName(fileName)
	fileNameNoExt = File.basename(fileName, File.extname(fileName))
	filter = $filter[fileNameNoExt]
	if filter == nil
		filter = $filter["Other"]
	end
	if fileNameNoExt.include? "Map"
		filter = $filter["Map"]
	end
	filter
end

def translateFile(fileName)
	log "\nTranslating: " + fileName
	translateArrayMode = false
	writeMode = false
	output = ""
	
	$linesInFile = getLinesInFile(fileName)
	if $linesInFile == 0
		return
	end	
	$currentLineNumber = 0
	
	filter = getFilterName fileName
	singleOnly = false
	if filter != nil and filter == 'Skip'
		fileNameNoExt = File.basename(fileName, File.extname(fileName))
		source = File.join($extractedDataDir, fileNameNoExt + $dataExtension)
		dest = File.join($dataDir, fileNameNoExt + $dataExtension)
		log "Skipping file based on filter... Copying [#{source}] to [#{dest}]"
		if !Dir.exists? $dataDir
			Dir.mkdir $dataDir
		end
		FileUtils.cp_r source, dest, :remove_destination => true
		return
	elsif filter != nil and filter == 'Translate Single Lines'
		singleOnly = true
		log "Skipping multiline translations for this file based on filter"
	end
		
	file_content = File.open(fileName, "r:UTF-8", &:read)
	file_content.each_line {|line|
		if $currentLineNumber % $linesPerUpdate == 0
			log "#{Time.now} Progress: Total [#{$totalProcessedLines}/#{$totalLines}] #{File.basename($outputPath) + "/" + File.basename(fileName)} [#{$currentLineNumber}/#{$linesInFile}] Cache hits [#{$totalCacheHits}] Translations [#{$totalTranslations}] Failures [#{$totalFailures}]"
		end
		log "Input: #{line}", true
		$currentLineNumber += 1
		$totalProcessedLines += 1
	
		if(translateArrayMode)
			if(line.strip == '],')
				translateArrayMode = false
			else
				transLine = translateLine(line, true)
				if(transLine == nil)
					translateArrayMode = false								
				else 
					$queue.push(transLine)
				end
			end			
			output += line
		elsif(line.match(/"original.*?".*?:/))	
			log "original found: " + line, true
			$lastOriginalLine = line			
			stripped = line.strip
			# check last character to see if this is a single line string or an array
			if(stripped[stripped.length - 1] == '[')	
				if !singleOnly
					log "TRANSLATE ARRAY MODE ON", true
					translateArrayMode = true
				end
			else
				log "single line to translate: " + line, true		
				translatedLine = translateLine(line)
				if translatedLine != nil
					translatedLine.sub! '",\n"', '"\n'
					translatedLine = translatedLine.slice(0..translatedLine.length - 1)
					$queue.push(translatedLine)
				end
			end	
			output += line
		elsif(line.include? '"translation"')
			stripped = line.strip
			if(stripped[stripped.length - 1] == '[')	
				if !singleOnly
					log "WRITE MODE ON", true
					writeMode = true						
					log "Output: #{line}", true			
				end
				output += line	
			elsif $queue.length > 0						
				translated = $queue.shift
				translatedLine = "#{translated}".sub '"original   "', '"translation"'			
				lastCharOriginal = line.split(',')
				lastCharTranslated = translatedLine.split(',')
				# strip comma if not there in original line
				if lastCharOriginal.length != lastCharTranslated.length
					split = translatedLine.split(',')
					index = 0
					strippedLine = ""
					split.each do |part|
						if index < split.length
							strippedLine += part
						else	
							strippedLine += "\n"
						end
					end
					translatedLine = strippedLine
				end
				output += translatedLine
				log "Output: #{translatedLine}", true
			else 
				output += line
			end
		elsif(writeMode)			
			if($queue.length > 0)
				log "WRITE MODE: length [#{$queue.length}] [#{$queue[0]}]", true
				output += $queue.shift
			else
				output += line
				log "WRITE MODE OFF", true
				writeMode = false
			end
		else
			output += line
		end
	}
	
	# write translated JSON to the extractedDataDir for ease of importing later
	name = File.basename(fileName)
	File.open(File.join($extractedDataDir, name), 'wb:UTF-8') do |fo|
		fo.write(output)
	end
end

def getLinesInFile(fileName)
	begin 
		return File.read(fileName).each_line.count
	rescue Exception => e 
		return 0
	end
end

def translateScriptFile(fileName)
	log "\nTranslating Script: " + fileName
	output = ""
	$linesInFile = getLinesInFile(fileName)
	if $linesInFile == 0 
		return
	end
	$currentLineNumber = 0

	file_content = File.open(fileName, "r:UTF-8", &:read)
	file_content.each_line {|line|
		if $currentLineNumber % $linesPerUpdate == 0
			totalPercentage = 0
			if $totalLines > 0 
				totalPercentage = $totalProcessedLines/$totalLines
			end
			filePercentage = 0
			if $linesInFile > 0
				filePercentage = $currentLineNumber/$linesInFile
			end
			log "#{Time.now} Progress: Total [#{$totalProcessedLines}/#{$totalLines}] (#{totalPercentage}%) #{File.basename($outputPath) + "/" + File.basename(fileName)} [#{$currentLineNumber}/#{$linesInFile}] (#{filePercentage}%) Cache hits [#{$totalCacheHits}] Translations [#{$totalTranslations}] Failures [#{$totalFailures}]"
		end
	
		#lineToTrans = line.match(/((.*?)([^ ]+?) +=( *?)".+")?/)
		lineToTrans = line.match(/([^ ]+?) *= *".+?"/)
		if lineToTrans 
			log "Translating #{lineToTrans}"
			original = "#{lineToTrans}"
			original = original.match(/".+?"/)
			original = "#{original}"
			original = original.match(/".+?"/)			
			original = "#{original}"
			log "Turned out to be #{original}"
			# insert apostrophes after string tokens for の and remove double spaces
			trans = translateLine(original.gsub("%sの", "%s's ").gsub(/(%s)(?=[^(%s)])(?=[^'])/, '%s ').gsub(/[ ]{2,}/, ' '))
			if trans != nil
				output += line.sub(original, trans)
			else 
				output += line
			end	
		else 
			output += line 
		end
		$currentLineNumber += 1
	}
	
	output = output.gsub("\n", "\r\n")
	
	outputFileName = fileName.slice(0.. fileName.rindex(File.extname(fileName)) - 1)
	outputFileName += "_tran.rb"
	log "Writing translated script to #{outputFileName}"
	File.open(outputFileName, 'wb:UTF-8') do |fo|
		fo.write(output)
	end
end

def decryptData
	# find the game data file
	$gameDataFileName = nil
	if File.exists? File.join($outputPath, 'Game.rgssad')
		$gameDataFileName = File.join($outputPath, 'Game.rgssad')
	elsif File.exists? File.join($outputPath, 'Game.rgss2a')
		$gameDataFileName = File.join($outputPath, 'Game.rgss2a')
	elsif File.exists? File.join($outputPath, 'Game.rgss3a')
		$gameDataFileName = File.join($outputPath, 'Game.rgss3a')	
	else 
		log "Failed to find game data file!"
	end
	
	if $gameDataFileName
		log "Found game data file: #{$gameDataFileName}"
	end
	
	dataDirExisted = Dir.exists? $dataDir
	# Back up the originals only once
	backup = File.join($outputPath, 'DataOriginal')
	if $preserveExistingData and dataDirExisted and !Dir.exists? backup		
		Dir.mkdir backup
		FileUtils.cp_r File.join($dataDir, '.'), backup
	end

	if ($gameDataFileName != nil and !$skipDataExtract)
		command = "\"#{File.join(Dir.pwd, "3rdParty/RgssDecrypter/RgssDecrypter")}\" -p \"#{$gameDataFileName}\""
		log "Running command #{command}"
		begin
			log `#{command}`		
		rescue Exception => e  
			log "Error: RgssDecrypter crashed with message: #{e}", false, true
			abort
		end	
	end
	
	if $skipDataExtract 
		log "Skipping data extract, keeping #{$extractedDataDir} and #{$extractedJsonDir}"
	elsif !Dir.exists?($extractedDataDir)
		log "Moving Data from [#{backup}] to [#{$extractedDataDir}]"
		#Dir.mkdir $extractedDataDir
		FileUtils.mv $dataDir, $extractedDataDir, :force => true 
	end	
	
	if Dir.exists? $dataDir
		FileUtils.rm_rf $dataDir
	end
	
	if $preserveExistingData and Dir.exists? backup
		log "Moving backed up original data files into #{$extractedDataDir}"
		FileUtils.cp_r File.join(backup, '.'), $extractedDataDir, :remove_destination => true
	end
	
	if !Dir.exists? $extractedDataDir
		log "MP"
		abort()
	end
	
	# get the file extension
	$dataExtension = nil
	Dir.foreach($extractedDataDir) do |item|
		log "Evaluating extension of file: #{item}"
		$dataExtension = File.extname(item)
		next unless $dataExtension.include?(".r")
		break
	end
	
	# set the correct data dump/import script
	$translatorTool = nil
	if $dataExtension == ".rxdata"
		$translatorTool = 'rmxp_translator.rb'	
	elsif $dataExtension == ".rvdata"
		$translatorTool = 'rmvx_translator.rb'		
	elsif $dataExtension == ".rvdata2"
		$translatorTool = 'rmvxace_translator.rb'
	end	
	
	# couldn't find it from data files, read ini
	if($translatorTool == nil or $dataExtension == nil)
		buffer = ''
		File.open(File.join($outputPath, 'Game.ini'), 'r:UTF-8') do |file|
			buffer = file.read
		end
		if buffer.include? "RGSS1"
			$translatorTool = 'rmxp_translator.rb'
			$dataExtension = '.rxdata'
		elsif buffer.include? "RGSS2"
			$translatorTool = 'rmvx_translator.rb'
			$dataExtension = '.rvdata'		
		elsif buffer.include? "RGSS3"
			$translatorTool = 'rmvxace_translator.rb'
			$dataExtension = '.rvdata2'	
		end			
	end
	
	log "Found data extension [#{$dataExtension}]. Using [#{$translatorTool}] to unpack"
	
	Dir.foreach($extractedDataDir) do |item|
		next if item == '.' or item == '..' 
		if (item[0] != item[0].capitalize and (File.extname item).include? ".rvdata") or item =="ExVersionID.rvdata2"
			log "Non-standard data file found [#{item}]. Potentially TES script. Cannot translate without integrating TES_Patcher link: https://mega.nz/#!tBUUhK4I!fei5CNO40sScPX3nqG1rJkldhbf9xJcICInmzt2x0CA"
			FileUtils.mv File.join($extractedDataDir, item), File.join($dataDir, item)
		end
	end
end

def dumpJson
	if $skipJsonDump 
		log "Skipping json dump"
		return
	end	
	
	FileUtils.rm_rf $extractedJsonDir
	Dir.mkdir $extractedJsonDir
	
	command = "ruby \"#{File.join(Dir.pwd, "3rdParty/rmxp_translator/#{$translatorTool}")}\" --dump=\"#{File.join($extractedDataDir, "*#{$dataExtension}")}\" --dest=\"#{$extractedJsonDir}\""
	log "Running command: #{command}", false, true
	log `#{command}`, false, true

	FileUtils.cp_r File.join($extractedJsonDir, "scripts"), File.join($extractedDataDir, "scripts")
end

def packageDataFileFromJson
	if !Dir.exists? $extractedDataDir
		log "Extracted data directory doesn't exist, nothing to do", false, true	
		return
	end
	if !Dir.exists? $dataDir
		Dir.mkdir $dataDir
	end
	command = "ruby \"#{File.join(Dir.pwd, "3rdParty/rmxp_translator/#{$translatorTool}")}\" --translate=\"#{File.join($extractedDataDir, "*#{$dataExtension}")}\" --dest=\"#{$dataDir}\""
	log "Running command: #{command}", false, true
	log `#{command}`, false, true
	
	if $gameDataFileName and File.exists? $gameDataFileName
		log "Moving data file [#{$gameDataFileName}] to backup [#{$gameDataFileName + ".backup"}]"
		FileUtils.mv $gameDataFileName, $gameDataFileName + ".backup", :force => true
	end
end

def computeTotalLines
	Dir.foreach($extractedJsonDir) do |item|
	  next if item == '.' or item == '..' or  File.extname(item) != '.json'
	  filter = getFilterName item	
	  if filter != nil and filter != 'Skip'
		$totalLines += File.foreach(File.join($extractedJsonDir, item)).count	  
	  end
	end	
end

def loadSettings	
	if File.exists? 'settings.json'
		File.open('settings.json', 'rb') do |file|
			cache = file.read
			hash = JSON.parse cache
			log "Settings file exists: #{JSON.pretty_generate(hash)}", false, true
			
			if hash.key?("output") and hash["output"].strip != ""		
				$rootOutputPath = hash["output"]
			end
			if hash.key?("showTranslation")
				$noSpoilers = hash["showTranslation"].zero?
			end
			if hash.key?("cacheOnly")
				$cacheOnly = !hash["cacheOnly"].zero?
			end
			if hash.key?("deleteExisting")
				$deleteExisting = !hash["deleteExisting"].zero?
			end
			if hash.key?("skipDataExtract")
				$skipDataExtract = !hash["skipDataExtract"].zero?
			end
			if hash.key?("skipJsonDump")
				$skipJsonDump = !hash["skipJsonDump"].zero?
			end
			if hash.key?("skipTranslate")
				$skipTranslate = !hash["skipTranslate"].zero?
			end
			if hash.key?("logCacheHits")
				$logCacheHits = !hash["logCacheHits"].zero?
			end
			if hash.key?("logTranslations")
				$logTranslations = !hash["logTranslations"].zero?
			end			
			if hash.key?("breakBlocksOnKatakana")
				$breakBlocksOnKatakana = !hash["breakBlocksOnKatakana"].zero?
			end			
			if hash.key?("translateScripts")
				$translateScripts = !hash["translateScripts"].zero?
			end									
			if hash.key?("translateLinesWithVars")
				$translateLinesWithVars = !hash["translateLinesWithVars"].zero?
			end				
			if hash.key?("overrideCharacters")
				overrideChars = hash["overrideCharacters"]
				$overrideCharacters = Regexp.quote("[#{overrideChars}]")
			end				
			
			if hash.key?("outputLanguage")
				$outputLanguage = hash["outputLanguage"]
			end					
									
			if hash.key?("Actors")
				$filter["Actors"] = hash["Actors"]
			end
			if hash.key?("Animators")
				$filter["Animators"] = hash["Animators"]
			end
			if hash.key?("Armors")
				$filter["Armors"] = hash["Armors"]
			end
			if hash.key?("Classes")
				$filter["Classes"] = hash["Classes"]
			end
			if hash.key?("CommonEvents")
				$filter["CommonEvents"] = hash["CommonEvents"]
			end
			if hash.key?("Enemies")
				$filter["Enemies"] = hash["Enemies"]
			end
			if hash.key?("Items")
				$filter["Items"] = hash["Items"]
			end
			if hash.key?("Map")
				$filter["Map"] = hash["Map"]
			end
			if hash.key?("Scripts")
				$filter["Scripts"] = hash["Scripts"]
			end
			if hash.key?("Skills")
				$filter["Skills"] = hash["Skills"]
			end
			if hash.key?("States")
				$filter["States"] = hash["States"]
			end
			if hash.key?("System")
				$filter["System"] = hash["System"]
			end
			if hash.key?("Tilesets")
				$filter["Tilesets"] = hash["Tilesets"]
			end
			if hash.key?("Troops")
				$filter["Troops"] = hash["Troops"]
			end
			if hash.key?("Weapons")
				$filter["Weapons"] = hash["Weapons"]
			end
			if hash.key?("Other")
				$filter["Other"] = hash["Other"]
			end
		end
	end
end

def loadCache
	if File.exists? translationFileName
		log "Cache file exists, loading...", false, true
		File.open(translationFileName, 'r:UTF-8') do |file|
			cache = file.read
			hash = JSON.parse cache
			$translated.merge!(hash)	
		end
		log "#{$translated.length} cached values"
		$lastCacheWriteNumValues = $translated.length
	else
		$lastCacheWriteNumValues = 0
	end
end

def translateDirectory
	if $translateScripts or !$skipTranslate
		loadCache
	end
	
	if $translateScripts
		$scriptDir = File.join($extractedDataDir, "scripts")
		log "Processing script directory [#{$scriptDir}]"
		Dir.foreach($scriptDir) do |item|
		  next if item == '.' or item == '..' or item.include? '_tran.rb'	  
		  processed = true
		  if !$skipTranslate 
			translateScriptFile(File.join($scriptDir, item))
			dumpCache
		  else
			break	  
		  end
		end	
	end	

	if $skipTranslate 
		log "Skipping translation step"
		return
	else
		computeTotalLines	
	end
	
	processed = false	
	
	
	Dir.foreach($extractedJsonDir) do |item|
	  next if item == '.' or item == '..' or  File.extname(item) != '.json'	  
	  processed = true
	  if !$skipTranslate 
		translateFile(File.join($extractedJsonDir, item))
		dumpCache
	  else
		break	  
	  end
	end	
	
	if processed && !$skipTranslate 
		dumpCache
	end
end

def setupLog
	$logFile = File.join($outputPath, "RPG Maker Auto Translate - #{$outputLanguage}.log")
	File.write($logFile, '')	
end

def copyGameDirectoryToOutput	
	$outputPath = File.join($rootOutputPath, File.basename($directory).gsub('[', '(').gsub(']', ')'))
	log "Output path: [#{$outputPath}]"
	
	log "Setting up directories"
	$extractedDataDir = File.join($outputPath, 'DataExtracted') 
	$dataDir = File.join($outputPath, 'Data')
	$extractedJsonDir = File.join($outputPath, 'JsonExtracted')	

	if Dir.exists?($outputPath)		
		if !$deleteExisting
			log "Skipping directory copy since no delete flag is on and directory already exists"
			setupLog
			return
		else 
			FileUtils.rm_rf $outputPath
			while Dir.exists? $outputPath
				sleep 1
			end
		end
	end	
	
	if !Dir.exists? $rootOutputPath
		log "Creating output root directory: #{$rootOutputPath}"
		Dir.mkdir $rootOutputPath
	end
	
	log "Creating output directory: #{$outputPath}"
	Dir.mkdir $outputPath
	setupLog
	log "Copying [#{$directory}] to [#{$outputPath}]"	
	begin
		FileUtils.cp_r File.join($directory, '.'), $outputPath
	rescue Exception => e  
		log "Error: Failed to copy source to output directory with message: #{e.message}"
		abort
	end
end

# main
if __FILE__ == $0
	startTime = Time.now
	if ARGV[0] == nil
		abort("Error: You must pass in the source directory:\nruby auto_translate.rb \"C:\SomeDirectoryContainingGame\"")
	end
	$directory = ARGV[0]	
	$directory = $directory.gsub('\\', '/')
	if !Dir.exists?($directory)
		abort("Error: Source directory does not exist")
	end

	loadSettings
	copyGameDirectoryToOutput
	decryptData	
	dumpJson	
	translateDirectory
	packageDataFileFromJson
		
	log "Processed #{$totalLines} lines in #{Time.now - startTime} seconds", false, true
end