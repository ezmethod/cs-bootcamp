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

operation:
  name: vm_provision2

  inputs:
    - host
    - port:
        default: '443'
        required: false
    - protocol:
        default: 'https'
        required: false
    - username
    - password:
        sensitive: true
    - trust_everyone:
        required: false
    - trustEveryone:
        default: ${get("trust_everyone", "true")}
        private: true
    - hostname
    - virtual_machine_name
    - virtualMachineName:
        default: ${get("virtual_machine_name", "")}
        private: true
        required: false
    - delimiter:
        default: ','
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-vmware:0.0.21'
    class_name: io.cloudslang.content.vmware.actions.vm.GetVMDetails
    method_name: getVMDetails

  outputs:
    - return_result: ${get("returnResult", "")}
    - error_message: ${get("exception", returnResult if returnCode != '0' else '')}
    - return_code: ${returnCode}

  results:
    - SUCCESS : ${returnCode == '0'}
    - FAILURE
