load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'

@test "/usr/bin/entrypoint.sh returns 0" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"pwd && whoami\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "dojo init finished"
  assert_line --partial "/dojo/work"
  assert_line --partial "k8s-aws-dojo"
  refute_output --partial "root"
  assert_equal "$status" 0
}
@test "correct kubectl version is installed" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"kubectl version --client\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "1.16.8"
  assert_equal "$status" 0
}
@test "correct Helm version is installed" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"timeout 1 helm version\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "3.2.0"
  # do not assert exit status, this command hangs and will be time-outed, because
  # we use fake tls certificates
}
@test "Helm was correctly initialized" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"ls -la /home/dojo/.cache\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "helm"
  assert_equal "$status" 0
}
@test "ssh client is installed" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"ssh\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "usage: ssh"
  assert_equal "$status" 255
}
@test "correct eksctl version is installed" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"eksctl version\""
  # this is printed on test failure
  echo "output: $output"
  assert_output --partial "0.18.0"
  assert_equal "$status" 0
}
@test "correct aws cli version is installed" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"aws --version\""
  # this is printed on test failure
  echo "output: $output"
  assert_output --partial "2.0.10"
  assert_equal "$status" 0
}
