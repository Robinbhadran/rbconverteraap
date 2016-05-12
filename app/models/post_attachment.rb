class PostAttachment < ActiveRecord::Base
   mount_uploader :avatar, AvatarUploader
   belongs_to :post
   belongs_to :user

   def self.converter(file)
    book_name = ""
    b_chp = ""
    b_chp_ver_t = ""

    if File.extname(file.avatar.url) == ".usfm"
      text =  File.open(file.avatar.path).read
      directory_name = "output_folder"
      Dir.mkdir("#{Rails.public_path}/" + directory_name + "/#{file.id.to_s}") unless File.directory?("#{Rails.public_path}/" + directory_name + "/#{file.id.to_s}")
      output_name = "#{Rails.public_path}/#{directory_name}/#{file.id.to_s}/#{File.basename(file.avatar.url, '.*')}.txt"
      output = File.open(output_name, 'w')

      text.each_line do |line|
        line.split("\r").each_with_index do |l, i|
          if l.include? ("\\id ") 
            book_name = l.partition(" ").last.gsub("\n", "").partition(" ").first
          end
          if l.include? ("\\c")
            chapter = l.gsub!(/\\c\s+/, "\t").gsub("\n", "")
            b_chp = book_name + chapter
          end
          if l.include? ("\\v")
            n = l
            v = l
            ver_number = n.gsub!(/\\v\s+/, "\t").partition(" ").first
            ver_text = v.sub(/\s*[\w']+\s+/, " ").insert(0, "\t")
            b_chp_ver_t = b_chp + ver_number + ver_text
          end
          output << b_chp_ver_t
        end
      end
      output.close
    end
   end

def self.text_to_usfm(file)
  chap = []
  vers = []
  hash = {}
  h = Hash.new { |hash, key| hash[key] = [] }
  flag = false
  flag1 = false
  l2 = ""
  count = 0
  book_name = ""
  file_name = file

  else File.extname(file.avatar.url) == ".txt"
  text =  File.open(file.avatar.path).read

  directory_name = "output_folder"
  Dir.mkdir("#{Rails.public_path}/" + directory_name + "/#{file.id.to_s}") unless File.directory?("#{Rails.public_path}/" + directory_name + "/#{file.id.to_s}")
  output_name = "#{Rails.public_path}/#{directory_name}/#{file.id.to_s}/#{File.basename(file.avatar.url, '.*')}.txt"
  
  output = File.open("#{output_name}", 'w:utf-8')
  if File.extname(file.avatar.url) == ".usfm"

  text = File.open(file.avatar.path, "r:utf-8").read
  text.gsub!(/\r\n?/, "\n")

  book_name = "#{text.partition(" ").first}"

  text.each_line do |line|
    line.split("\r").each_with_index do |l, i|
      if l.include? "अध्याय"
        flag = true
        l2 = l.partition(" ").last
        count = 0
        vers = []
      end
      if flag and !(l.include? "अध्याय")
        count = 1
        if count != 0
          vers  << l
          h.store(l2, vers.delete_if{|x| x == "\n" })
        end
      end
      chap = []
    end
  end
  hash.store(book_name, h)

  hash.each do|k, v|
    output << "\\id #{k}\n"
    v.each do |k, v|
      output << "\\c #{k}"
      v.each do |k, v|
        output << "\\v #{k}"
      end
    end
  end
  output.close
end

end

 end
