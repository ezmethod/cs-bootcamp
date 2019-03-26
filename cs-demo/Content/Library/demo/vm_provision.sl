########################################################################################################################
#!!
#! @description: <pre>Clones a virtual machine. The virtual machine may be a template vm. The source virtual machine is specified via vmIdentifierType and virtualMachine (optionally vmDatacenter) while the clone is defined by vmName,vmFolder,vmResourcePool,dataStore,hostSystem, and clusterName.
#!               
#!               Note: cannot work across virtual datacenters
#!               
#!               Inputs:
#!                   host -  VMware vCenter, ESX or ESXi host hostname or IP.
#!                   user - VMware username.
#!                   password - VMware user's password.
#!                   port - Port to connect on.
#!               Examples: 443, 80
#!                   protocol - Connection protocol.
#!               Valid values: "https", "http"
#!                   closeSession - Close the internally kept VMware Infrastructure API session at completion of operation.
#!               Valid values: "true", "false"
#!                   async - Asynchronously perform the task.
#!               Valid values: "true", "false"
#!                   taskTimeOut - Time to wait before the operation is considered to have failed (seconds).
#!               Default value: 800
#!                   vmIdentifierType - Virtual machine identifier type.
#!               Valid values: "inventorypath", "name", "ip", "hostname", "uuid", "vmid"
#!                   virtualMachine - Primary Virtual Machine identifier of the virtual machine to clone from. Inventorypath (Datacenter/vm/Folder/MyVM), Name of VM, IP (IPv4 or IPv6 depending upon ESX version), hostname (full), UUID, or the VM id (vm-123,123).
#!                   vmDatacenter - Virtual machine's datacenter. If host is ESX(i) use "ha-datacenter".
#!                   vmName - Name of new virtual machine being created.
#!                   vmFolder - Virtual machine's inventory folder. Folder names are delimited by a forward slash "/".  This input is case sensitive.  Only supported when host is a vCenter.  For root folder, use "/".
#!               Example: /Hewlett Packard Enterprise/Operations Orchestration/Templates and VMs/
#!                   vmResourcePool - Resource pool for new virtual machine. Resource pool names are delimited by a forward slash "/".  For the root resource pool, specify "Resources" or a single "/".
#!                   dataStore - Name of datastore or datastore cluster to store new virtual machine (eg. host:dsname, mydatastore).  If not specified the same datastore of the source virtual machine will be used.
#!                   hostSystem - Name of destination host system (ESX or ESXi) for new virtual machine as seen in the vCenter UI.  Only supported when host is a vCenter.  If not specified the same host system of the source virtual machine will be used.
#!                   clusterName - Name of the VMWare HA or DRS cluster.  Can be specified instead of hostSystem if the desired destination ESX(i) host is in a DRS or HA cluster.
#!                   description - Description / annotation. To be able to clone the machine, even when no description input is given, the user needs to have the following permission to the virtual machine: Virtual machine -> Configuration -> Set annotation.
#!                   markAsTemplate - Mark the virtual machine as a template? If true virtual machine will be marked as a template.  Mark as regular virtual machine otherwise.
#!               Valid values: "true", "false".
#!                   thinProvision - Specify whether to perform thin provisioning of the virtual disk. If empty, the disk format will be set as same format as source. If true, the disk format will be set as thin provisioned format. If false, the disk format will be set as thick format.
#!               Valid values: "true", "false"
#!                   customizationTemplateName - Name of the customization specification to apply while creating this clone. The customization specification should already exist in the vCenter customization specifications manager. If  both 'customizationTemplateName' and 'customizationSpecXml' have values, the operation will fail with an error message.
#!                   customizationSpecXml - The Xml string of the customization spec.
#!                   connectionTimeout -  The time to wait for a connection to be established, in seconds. A "connectionTimeout" value of '0' represents an infinite timeout.
#!               Default value: 0
#!               Format: an integer representing seconds
#!               Examples: 10, 20
#!                   socketTimeout -  The time to wait for data (a maximum period of inactivity between two consecutive data packets), in seconds. A "socketTimeout" value of '0' represents an infinite timeout.
#!               Default value: 0
#!               Format: an integer representing seconds
#!               Examples: 10, 20
#!                   diskConfig - An optional list that allows specifying the datastore location for each virtual disk. Specify each disk config as a pair <diskId>, <datastoreName> delimited by colon(:), and each pair separated by comma(,). Format: <diskId1>:<datastoreName>,<diskId2>:<datastoreName2>. The <diskId> can be the deviceNumber or the deviceName as seen in the datastore View
#!               Example: myvm.vmdk:myDatastore,1:myDatastore2 
#!               
#!               Results:
#!                   returnResult - Task result or operation result.
#!               
#!               Responses:
#!                   success - The operation completed successfully.
#!                   failure - Something went wrong.
#!               
#!               Notes:
#!               1) Inventory Path Formatting: If host is an ESX server inventory path will be: ha-datacenter/vm/<name of vm> .  If host is a vCenter the inventory path will be: <name of datacenter>/vm/<folders>/<name of vm> . The <folders>/<name of vm> part of the path is based on the "Virtual Machines & Templates" view in the vCenter client. The inventory path is case sensitive.
#!               
#!               2) This operation can also be used to deploy a virtual machine from template, clone virtual machine to template and clone a template to template. 
#!               
#!               3) The result of the VMware/VMware Virtual Infrastructure and vSphere/Guest/Export Guest Customization Spec operation can be used to get the customizationSpecXml input value.
#!               
#!               4) The privilege required on the source virtual machine depends on the source and destination types:
#!               
#!                   - source is virtual machine, destination is virtual machine - VirtualMachine.Provisioning.Clone
#!                   - source is virtual machine, destination is template - VirtualMachine.Provisioning.CreateTemplateFromVM
#!                   - source is template, destination is virtual machine - VirtualMachine.Provisioning.DeployTemplate
#!                   - source is template, destination is template - VirtualMachine.Provisioning.CloneTemplate
#!               
#!               5) Note that "socketTimeout" and "connectionTimeout" inputs do not represent the time to wait for the operation to complete. They are used when communicating with the service, to make sure that the service is up and responds to client's requests. They can be used for service diagnosis purpose.
#!               
#!               6) The "taskTimeOut" input is only used when the task is performed in a synchronous manner ("async" is set to "false").
#!               </pre>
#!
#! @input input_1: Generated description.
#! @input input_2: Generated description.
#!
#! @output output_1: Generated description.
#!
#! @result SUCCESS: Flow completed successfully.
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
          io.cloudslang.vmware.vcenter.vm.clone_vm:
            - host: "${get_sp('vcenter_host')}"
            - user: "${get_sp('vcenter_user')}"
            - password:
                value: "${get_sp('vcenter_password')}"
                sensitive: true
            - vm_source_identifier: linux
            - vm_source: vmlinux
            - datacenter: "${get_sp('datacenter')}"
            - vm_name: vmlinux
            - vm_folder: datastore1
            - mark_as_template: no
        navigate:
          - SUCCESS: set_vmcpu_count
          - FAILURE: FAILURE
    - power_on_vm:
        do:
          io.cloudslang.vmware.vcenter.power_on_vm:
            - host: "${get_sp('vcenter_host')}"
            - user: "${get_sp('vcenter_user')}"
            - password:
                value: "${get_sp('vcenter_password')}"
                sensitive: true
            - vm_identifier: name
            - vm_name: name
            - datacenter: "${get_sp('datacenter')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
    - set_vmcpu_count:
        do:
          io.cloudslang.vmware.vcenter.vm.conf.set_vmcpu_count:
            - host: "${get_sp('vcenter_host')}"
            - user: "${get_sp('vcenter_user')}"
            - password:
                value: "${get_sp('vcenter_password')}"
                sensitive: true
            - vm_identifier: name
            - vm_name: vmlinux
            - datacenter: "${get_sp('datacenter')}"
            - vm_cpu_count: '4'
        navigate:
          - SUCCESS: set_vm_memory_size
          - FAILURE: FAILURE
    - set_vm_memory_size:
        do:
          io.cloudslang.vmware.vcenter.vm.conf.set_vm_memory_size:
            - host: "${get_sp('vcenter_host')}"
            - user: "${get_sp('vcenter_user')}"
            - password:
                value: "${get_sp('vcenter_password')}"
                sensitive: true
            - vm_identifier: name
            - vm_name: "${get_sp('vcenter_password')}"
            - vm_memory_size: '32'
        navigate:
          - SUCCESS: add_nic_to_vm
          - FAILURE: FAILURE
    - add_nic_to_vm:
        do:
          io.cloudslang.vmware.vcenter.vm.conf.add_nic_to_vm:
            - host: "${get_sp('vcenter_host')}"
            - user: "${get_sp('vcenter_user')}"
            - password:
                value: "${get_sp('vcenter_password')}"
                sensitive: true
            - vm_identifier: name
            - vm_name: name
            - datacenter: null
            - net_port_group: "${get_sp('datacenter')}"
            - net_nic_type: e1000
            - net_mac_generation: second
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
          2bc7c564-8246-a0ed-9148-7ab4e8218eaa:
            targetId: 32b1eba8-b234-b36a-15b0-5697b1f71660
            port: FAILURE
      power_on_vm:
        x: 563
        y: 299
        navigate:
          da35d653-946b-17d2-9977-ad826f26e8df:
            targetId: 29e06341-9db2-29f7-fe7e-429d66eaadfd
            port: SUCCESS
          4d04c045-8ee8-7540-593b-1f27b9b0803c:
            targetId: 32b1eba8-b234-b36a-15b0-5697b1f71660
            port: FAILURE
      set_vmcpu_count:
        x: 221
        y: 78
        navigate:
          16f8e3c9-8e31-c1a5-7a8a-78084570701c:
            targetId: 32b1eba8-b234-b36a-15b0-5697b1f71660
            port: FAILURE
      set_vm_memory_size:
        x: 379
        y: 76
        navigate:
          0ea4f68a-be34-2433-d88a-aa4249532cb7:
            targetId: 32b1eba8-b234-b36a-15b0-5697b1f71660
            port: FAILURE
      add_nic_to_vm:
        x: 573
        y: 79
        navigate:
          23dbf708-baac-7192-942b-d04d1dc09fd7:
            targetId: 32b1eba8-b234-b36a-15b0-5697b1f71660
            port: FAILURE
    results:
      SUCCESS:
        29e06341-9db2-29f7-fe7e-429d66eaadfd:
          x: 859
          y: 302
      FAILURE:
        32b1eba8-b234-b36a-15b0-5697b1f71660:
          x: 296
          y: 304
