namespace :active_storage do
  desc 'Ensures all files are mirrored'
  task mirror_all: [:environment] do
    # Iterate through each blob
    ActiveStorage::Blob.all.each do |blob|

      # We assume the primary storage is local
      local_file = ActiveStorage::Blob.service.primary.path_for(blob.key)

      # Iterate through each mirror
      blob.service.mirrors.each do |mirror|
        # If the file doesn't exist on the mirror, upload it
        mirror.upload(blob.key, File.open(local_file), checksum: blob.checksum) unless mirror.exist? blob.key
      end
    end
  end
end
