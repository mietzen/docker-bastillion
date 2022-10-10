title "Bastillion Integration Test"

describe processes(Regexp.new("dockerize")) do
  it { should exist }
  its('users') { should include 'bastillion' }
  its('pids') { should cmp "1"}
end
describe processes(Regexp.new("startBastillion")) do
  it { should exist }
  its('users') { should include 'bastillion' }
end
describe processes(Regexp.new("java -Xms1024m -Xmx1024m -jar start.jar")) do
  it { should exist }
  its('users') { should include 'bastillion' }
end
describe port(8080) do
  its('protocols') { should include 'tcp' }
  its('addresses') { should include '0.0.0.0' }
end
describe port(8443) do
  its('protocols') { should include 'tcp' }
  its('addresses') { should include '0.0.0.0' }
end