require 'xcodeproj'
project_path = 'DoctorLive.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.first

# Helper to find or create group
def find_or_create_group(parent_group, path_components)
  return parent_group if path_components.empty?
  first = path_components.shift
  group = parent_group.groups.find { |g| g.display_name == first || g.path == first }
  group ||= parent_group.new_group(first)
  find_or_create_group(group, path_components)
end

# Files to add
files = [
  "DoctorLive/Controller/Recorder Screen/RecorderVC.swift",
  "DoctorLive/Controller/Recorder Screen/RecorderVC+Extension.swift",
  "DoctorLive/Controller/Chat Screen/ChatLeftAudioCell.swift",
  "DoctorLive/Controller/Chat Screen/ChatLeftAudioCell.xib",
  "DoctorLive/Controller/Chat Screen/ChatRightAudioCell.swift",
  "DoctorLive/Controller/Chat Screen/ChatRightAudioCell.xib"
]

files.each do |file_path|
  components = file_path.split('/')[0...-1]
  group = find_or_create_group(project.main_group, components)
  
  filename = File.basename(file_path)
  
  # Check if file already exists in group
  existing_ref = group.files.find { |f| f.path == filename }
  if existing_ref
    puts "File #{filename} already in group"
    next
  end
  
  file_ref = group.new_file(filename)
  target.add_file_references([file_ref])
  puts "Added #{file_path}"
end

project.save
