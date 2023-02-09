control 'nginx-version' do
  impact 1.0
  title 'NGINX version'
  desc 'The required version of NGINX should be installed.'
  describe nginx.version do
    it { should cmp >= input('nginx_version') }
  end
end

control 'nginx-modules' do
  impact 1.0
  title 'NGINX modules'
  desc 'The required NGINX modules should be installed.'
  modules = input('nginx_modules')
  describe nginx do
    modules.each do |current_module|
      # puts current_module
      its('modules') { should include current_module }
    end
  end
end

control 'nginx-conf-file' do
  impact 1.0
  title 'NGINX configuration file'
  desc 'The NGINX config file should exist.'
  # describe file('/etc/nginx/nginx.conf') do
  #   it { should be_file }
  # end

  describe 'test file' do
    subject { file('/etc/nginx/nginx.conf') }
    it 'should be a file' do
      expect(subject).to(be_file)
    end
  end
end

control 'nginx-conf-perms' do
  impact 1.0
  title 'NGINX configuration'
  desc 'The NGINX config file should owned by root, be writable only by owner, and not writeable or and readable by others.'
  describe file('/etc/nginx/nginx.conf') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should_not be_readable.by('others') }
    it { should_not be_writable.by('others') }
    it { should_not be_executable.by('others') }
  end
end

control 'nginx-shell-access' do
  impact 1.0
  title 'NGINX shell access'
  desc 'The NGINX shell access should be restricted to admin users.'
  # describe users.shells(/bash/).usernames do
  #   it { should be_in input('admin_users')}
  # end

  non_admin_users = users.shells(/bash/).usernames
  
  describe "Bash access for non-admin users" do
    it "should be removed." do
      failure_message = "These non-admin should not have bash access: #{non_admin_users.join(", ")}"
      expect(non_admin_users).to eq(input('admin_users')), failure_message
    end
  end

end