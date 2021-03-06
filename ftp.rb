
require 'net/ftp'
require 'fileutils'
require 'zip.rb'

def download_remote_dir(ftp,dir_name)
 
 FileUtils.mkdir dir_name #create local directory
 FileUtils.cd dir_name    #change dir to local directory
 ftp.chdir(dir_name)      #change ftp to remote directory
 
  listing = ftp.ls('-l')
   listing.each do |remote_file| 
     if remote_file =~ /^d/ and remote_file.split.last != ".." and remote_file.split.last != "." #if dir and not . or ..
     then  download_remote_dir(ftp, remote_file.split.last) #recuresively download remote directory
     else
	if remote_file.split.last != ".." and remote_file.split.last != "." 
	then
	 ftp.getbinaryfile(remote_file.split.last,remote_file.split.last) #download remote file
	end
     end
   end
 
  ftp.chdir("..")	 #go to remote parent directory
  FileUtils.cd ".."      # go to local parent directory
end


puts "Enter ftp host to connect with"
ftp_host_name = gets().chomp

puts "Please enter ftp user name"
ftp_user_name = gets().chomp

puts "Please enter ftp password"
ftp_pass = gets().chomp


 begin

	ftp = Net::FTP.new(ftp_host_name)
	
	  ftp.login(ftp_user_name,ftp_pass)

	  listing = ftp.ls('-l') #list remote directory
		
	  

	   puts "Following are the dictionaries ..."
	  # prints directories
		listing.each do |directory| 
		  if directory =~ /^d/ and directory.split.last != ".." and directory.split.last != "."
		   then  puts directory.split.last
		  end
		 end
		  
		
	   puts 'Enter directory name to download'
	   dir_name = gets().chomp()
	   download_remote_dir(ftp,dir_name)

	   puts 'wants to zip directory y/n'
	   if(gets.chomp == 'y')
	   then
		   zf=ZipFileGenerator.new(dir_name,dir_name+'.zip')	#create instance of zip file generator
		   zf.write()		#create zip file
		   FileUtils.remove_dir(dir_name)
	   end			
rescue Net::FTPPermError => e
 puts 'wrong username/passowrd'

rescue Exception => e
puts e.class
puts e

ensure
 ftp.close
end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 