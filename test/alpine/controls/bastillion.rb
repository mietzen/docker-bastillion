title "Bastillion Integration Test"

describe processes("java -Xms1024m -Xmx1024m -jar start.jar") do
  it { should exist }
  its('users') { should eq ['bastilli'] }
end
describe port(8443) do
  its('protocols') { should include 'tcp' }
  its('addresses') { should include '0.0.0.0' }
end
