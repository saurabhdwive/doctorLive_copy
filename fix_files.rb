require 'xcodeproj'
project_path = 'DoctorLive.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.first

files_to_remove = [
  "RecorderVC.swift",
  "RecorderVC+Extension.swift",
  "ChatLeftAudioCell.swift",
  "ChatLeftAudioCell.xib",
  "ChatRightAudioCell.swift",
  "ChatRightAudioCell.xib"
]

# Find and remove bad references
project.files.each do |file|
  if files_to_remove.include?(file.path)
    file.remove_from_project
    puts "Removed bad ref: #{file.path}"
  end
end

project.save
