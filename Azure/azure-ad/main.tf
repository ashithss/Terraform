# Retrieve domain information.Use this data source to access information about existing Domains within Azure Active Directory.
data "azuread_domains" "example" {
  only_initial = true #(Optional) Set to true to only return the initial domain, which is your primary Azure Active Directory tenant domain. Defaults to false.
}

# Create an application. Manages an application registration within Azure Active Directory.
resource "azuread_application" "example" {
  display_name = "ExampleApp"
    app_role {
    allowed_member_types = ["Application"] #Required) Specifies whether this app role definition can be assigned to users and groups by setting to User, or to other applications (that are accessing this application in a standalone scenario) by setting to Application, or to both.
    description          = "Apps can query the database" #(Required) Description of the app role that appears when the role is being assigned and, if the role functions as an application permissions, during the consent experiences.
    display_name         = "Query" #(Required) Display name for the app role that appears during app role assignment and in consent experiences.
    enabled              = var.enable # (Optional) Determines if the app role is enabled. Defaults to true.
    id                   = "00000000-0000-0000-0000-111111111111" #(Required) The unique identifier of the app role. Must be a valid UUID.
    value                = "Query.All" #(Optional) The value that is used for the roles claim in ID tokens and OAuth 2.0 access tokens that are authenticating an assigned service or user principal.
  }
}
#Manages a rotating time resource, which keeps a rotating UTC timestamp stored in the Terraform state and proposes resource recreation when the locally sourced current time is beyond the rotation time. 
resource "time_rotating" "example" {
  rotation_days = var.num #(Number) Number of days to add to the base timestamp to configure the rotation timestamp. When the current time has passed the rotation timestamp, the resource will trigger recreation. At least one of the 'rotation_' arguments must be configured.
}
#Manages a password credential associated with an application within Azure Active Directory. These are also referred to as client secrets during authentication.
resource "azuread_application_password" "example" {
  application_object_id = azuread_application.example.object_id #(Required) The object ID of the application for which this password should be created. Changing this field forces a new resource to be created.
  rotate_when_changed = { # (Optional) A map of arbitrary key/value pairs that will force recreation of the password when they change, enabling password rotation based on external conditions such as a rotating timestamp. Changing this forces a new resource to be created.
    rotation = time_rotating.example.id
  }
}
# Create a service principal
resource "azuread_service_principal" "internal" {
  application_id = azuread_application.example.application_id #(Required) The application ID (client ID) of the application for which to create a service principal.
}


#Manages an app role assignment for a group, user or service principal. Can be used to grant admin consent for application permissions.
resource "azuread_app_role_assignment" "example" {
  app_role_id         = azuread_service_principal.internal.app_role_ids["Query.All"] #(Required) The ID of the app role to be assigned, or the default role ID 00000000-0000-0000-0000-000000000000. Changing this forces a new resource to be created.
  resource_object_id  = azuread_service_principal.internal.object_id #(Required) The object ID of the service principal representing the resource. Changing this forces a new resource to be created.
  principal_object_id = azuread_group.example.object_id # (Required) The object ID of the user, group or service principal to be assigned this app role. Supported object types are Users, Groups or Service Principals. Changing this forces a new resource to be created.
}
#Use this data source to access the configuration of the AzureAD provider.
data "azuread_client_config" "current" {}

# Create a user
resource "azuread_user" "example" {
  user_principal_name = "ExampleUser@${data.azuread_domains.example.domains.0.domain_name}" #- (Required) The user principal name (UPN) of the user.
  display_name        = "Example User"
  password            = "Helloworld123@"
}
# Create a group
resource "azuread_group" "example" {
  display_name     = "example"
  owners           = [data.azuread_client_config.current.object_id] #(Optional) A set of object IDs of principals that will be granted ownership of the group. Supported object types are users or service principals. By default, the principal being used to execute Terraform is assigned as the sole owner. Groups cannot be created with no owners or have all their owners removed.
  security_enabled = var.enable # (Optional) Whether the group is a security group for controlling access to in-app resources. At least one of security_enabled or mail_enabled must be specified. A Microsoft 365 group can be security enabled and mail enabled (see the types property).
  members = [
    azuread_user.example.object_id,
    /* more users */
  ]
}
#Manages an invitation of a guest user within Azure Active Directory.
resource "azuread_invitation" "example" {
  user_display_name  = "Bob Bobson"
  user_email_address = "arti.jain@happiestminds.com" #(Required) The email address of the user being invited.
  redirect_url       = "https://portal.azure.com" #(Required) The URL that the user should be redirected to once the invitation is redeemed.

  message {
    additional_recipients = ["arti.jain@happiestminds.com"] # (Optional) Email addresses of additional recipients the invitation message should be sent to. Only 1 additional recipient is currently supported by Azure.
    body                  = "Hello there! You are invited to join my Azure tenant!" #(Optional) Customized message body you want to send if you don't want to send the default message. Cannot be specified with language.
  }
}



