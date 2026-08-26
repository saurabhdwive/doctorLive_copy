require 'xcodeproj'
project_path = 'DoctorLive.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.first

files = [
  "DoctorLive/Controller/Recorder Screen/RecorderVC.swift",
  "DoctorLive/Controller/Recorder Screen/RecorderVC+Extension.swift",
  "DoctorLive/Controller/Chat Screen/ChatLeftAudioCell.swift",
  "DoctorLive/Controller/Chat Screen/ChatLeftAudioCell.xib",
  "DoctorLive/Controller/Chat Screen/ChatRightAudioCell.swift",
  "DoctorLive/Controller/Chat Screen/ChatRightAudioCell.xib"
]

files.each do |file_path|
  # We just add them to the main group, Xcode can handle it
  file_ref = project.main_group.new_reference(file_path)
  target.add_file_references([file_ref])
  puts "Added #{file_path}"
end

project.save
