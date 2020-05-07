#!/usr/bin/env bats

# these tests are run inside the tested docker image

@test "kubectl version --client works" {
  run /bin/bash -c "kubectl version --client"
  # this is printed on test failure only
  echo "# output: $output"
  [[ "${output}" =~ "Client Version" ]]
  [[ "${output}" =~ "GoVersion" ]]
  #[ "$output" = "dojo init finished" ]
  [ "$status" -eq 0 ]
}
@test "kubectl version --client fails" {
  run /bin/bash -c "kubectl version --client"
  # this is printed on test failure only
  echo "# output: $output"
  [[ "${output}" =~ "not existing text" ]]
}
