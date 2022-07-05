title "Bastillion Integration Test"

describe processes("dockerize") do
  it { should exist }
  its('users') { should eq ['bastillion'] }
  its('pids') { should cmp "1"}
end
describe processes("/bin/bash /opt/bastillion/startBastillion.sh") do
  it { should exist }
  its('users') { should eq ['bastillion'] }
end
describe processes("java -Xms1024m -Xmx1024m -jar start.jar") do
  it { should exist }
  its('users') { should eq ['bastillion'] }
end
describe port(8443) do
  its('protocols') { should include 'tcp' }
  its('addresses') { should include '0.0.0.0' }
end
