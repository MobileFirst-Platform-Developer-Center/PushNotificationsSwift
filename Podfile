use_frameworks!

target "PushNotificationsSwift" do
    pod 'IBMMobileFirstPlatformFoundation'
    pod 'IBMMobileFirstPlatformFoundationPush'
end

post_install do |installer|
    workDir = Dir.pwd

    installer.pods_project.targets.each do |target|
        debugXcconfigFilename = "#{workDir}/Pods/Target Support Files/#{target}/#{target}.debug.xcconfig"
        xcconfig = File.read(debugXcconfigFilename)
        newXcconfig = xcconfig.gsub(/HEADER_SEARCH_PATHS = .*/, "HEADER_SEARCH_PATHS = ")
        File.open(debugXcconfigFilename, "w") { |file| file << newXcconfig }

        releaseXcconfigFilename = "#{workDir}/Pods/Target Support Files/#{target}/#{target}.release.xcconfig"
        xcconfig = File.read(releaseXcconfigFilename)
        newXcconfig = xcconfig.gsub(/HEADER_SEARCH_PATHS = .*/, "HEADER_SEARCH_PATHS = ")
        File.open(releaseXcconfigFilename, "w") { |file| file << newXcconfig }
    end
end 
