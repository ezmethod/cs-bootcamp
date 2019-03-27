#   (c) Copyright 2017 EntIT Software LLC, a Micro Focus company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: Executes a '/v1/secret/${secret}' GET call against a Vault Server to retrieve a particular secret.
#!
#! @input hostname: Vault's FQDN.
#! @input port: Vault's Port.
#! @input protocol: Vault's Protocol.
#!                  Default: 'https'
#!                  Possible values: 'https' and 'http'.
#! @input x_vault_token: Vault's X-VAULT-Token.
#! @input secret: The Secret to be retrieved from the vault server
#! @input proxy_host: Proxy server used to access the web site.
#!                    Optional
#! @input proxy_port: Proxy server port.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: User name used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
#! @input keystore: The pathname of the Java KeyStore file.
#!                  You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trust_all_roots is 'true'
#!                  this input is ignored.
#!                  Format: Java KeyStore (JKS)
#!                  Optional
#! @input keystore_password: The password associated with the KeyStore file. If trust_all_roots is false and
#!                           keystore is empty, keystore_password default will be supplied.
#!                           Optional
#! @input connect_timeout: Time in seconds to wait for a connection to be established.
#!                         Default: '0' (infinite)
#!                         Optional
#! @input socket_timeout: Time in seconds to wait for data to be retrieved.
#!                        Default: '0' (infinite)
#!                        Optional
#!
#! @output secret_value: The value stored in Vault for the requested secret.
#! @output return_result: The response of the operation in case of success or the error message otherwise.
#! @output error_message: return_result if status_code different than '200'.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output status_code: Status code of the HTTP call.
#! @output response_headers: Response headers string from the HTTP Client REST call.
#!
#! @result SUCCESS: Everything completed successfully and the available secret have been retrieved from Vault.
#! @result FAILURE: Something went wrong. Most likely Vault's return_result was not as expected.
#!!#
########################################################################################################################

namespace: io.cloudslang.hashicorp.vault.secrets

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: read_secret

  inputs:
    - protocol:
        default: 'https'
    - hostname
    - port
    - secret
    - x_vault_token:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
    - keystore:
        required: false
    - keystore_password:
        required: false
        sensitive: true
    - connect_timeout:
        default: '0'
        required: false
    - socket_timeout:
        default: '0'
        required: false

  workflow:
    - read_vault_secret:
        do:
          http.http_client_get:
            - url: "${protocol + '://' + hostname + ':' + port + '/v1/secret/' + secret}"
            - headers: "${'X-VAULT-Token: ' + x_vault_token}"
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - connect_timeout
            - socket_timeout
            - content_type: 'application/json'
        publish:
          - return_result
          - return_code
          - error_message
          - status_code
          - response_headers
        navigate:
          - SUCCESS: get_secret
          - FAILURE: on_failure

    - get_secret:
        do:
          json.json_path_query:
            - json_object: '${return_result}'
            - json_path: .value
        publish:
          - secret_value: "${''.join( c for c in return_result if  c not in '[]' )}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure

  outputs:
    - secret_value
    - return_result
    - return_code
    - status_code
    - error_message
    - response_headers

  results:
    - SUCCESS
    - FAILURE