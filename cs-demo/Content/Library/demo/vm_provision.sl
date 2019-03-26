########################################################################################################################
#!!
#! @description: Generated flow description.
#!
#! @input input_1: Generated description.
#! @input input_2: Generated description.
#!
#! @output output_1: Generated description.
#!
#! @result SUCCESS: Flow completed successfully.
#! @result FAILURE: Failure occurred during execution.
#!!#
########################################################################################################################

namespace: cs_demo.content.library.demo
flow:
  name: vm_provision
  inputs:
    - input_1: ''
    - input_2: ''
  workflow:
    - clone_vm:
        do:
          io.cloudslang.vmware.vcenter.vm.clone_vm: []
        navigate:
          - SUCCESS: set_vmcpu_count
          - FAILURE: FAILURE
    - power_on_vm:
        do:
          io.cloudslang.vmware.vcenter.power_on_vm: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
    - set_vmcpu_count:
        do:
          io.cloudslang.vmware.vcenter.vm.conf.set_vmcpu_count: []
        navigate:
          - SUCCESS: set_vm_memory_size
          - FAILURE: FAILURE
    - set_vm_memory_size:
        do:
          io.cloudslang.vmware.vcenter.vm.conf.set_vm_memory_size: []
        navigate:
          - SUCCESS: add_nic_to_vm
          - FAILURE: FAILURE
    - add_nic_to_vm:
        do:
          io.cloudslang.vmware.vcenter.vm.conf.add_nic_to_vm: []
        navigate:
          - SUCCESS: power_on_vm
          - FAILURE: FAILURE
  outputs:
    - output_1: '${step_output_1}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      clone_vm:
        x: 40
        y: 78
        navigate:
          62c4c4e1-0054-3ee8-6568-40a8bf46043a:
            targetId: eea709db-fbd1-0928-b9d1-7cd46e641103
            port: FAILURE
      power_on_vm:
        x: 492
        y: 267
        navigate:
          da35d653-946b-17d2-9977-ad826f26e8df:
            targetId: 29e06341-9db2-29f7-fe7e-429d66eaadfd
            port: SUCCESS
          2b3212af-4322-e35d-b78f-e93e0886c33f:
            targetId: eea709db-fbd1-0928-b9d1-7cd46e641103
            port: FAILURE
      add_nic_to_vm:
        x: 453
        y: 81
        navigate:
          95a093b3-b251-7b07-4177-e651ed089657:
            targetId: eea709db-fbd1-0928-b9d1-7cd46e641103
            port: FAILURE
      set_vm_memory_size:
        x: 326
        y: 79
        navigate:
          d5483a68-d79d-e4fd-ea3a-9255d62255b4:
            targetId: eea709db-fbd1-0928-b9d1-7cd46e641103
            port: FAILURE
      set_vmcpu_count:
        x: 187
        y: 77
        navigate:
          b5eea936-7a42-2c77-6e6e-b48eaee2454e:
            targetId: eea709db-fbd1-0928-b9d1-7cd46e641103
            port: FAILURE
    results:
      SUCCESS:
        29e06341-9db2-29f7-fe7e-429d66eaadfd:
          x: 687
          y: 75
      FAILURE:
        eea709db-fbd1-0928-b9d1-7cd46e641103:
          x: 242
          y: 254
