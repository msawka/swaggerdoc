# SwaggerDoc

The SwaggerDoc module provides a convenience task for generating [Swagger](http://swagger.io/) API documentation for Phoenix and Ecto-based projects.  This task has been created for Phoenix and Ecto 1.0 and greater.

[![Build Status](https://semaphoreci.com/api/v1/projects/4b7a4024-763d-4585-9e9a-d5a02545bacf/534603/badge.svg)](https://semaphoreci.com/perceptive/swaggerdoc)

## Getting Started

To use swaggerdoc with your projects, edit your mix.exs file and add it as a dependency:

```elixir
defp deps do
  [{:swaggerdoc, "~> 0.0.1"}]
end
```

To execute the Mix task, simply type `mix swagger`:

```elixir
hello_user$ mix swagger
Generating Swagger documentation...
Adding Ecto definitions...
Adding Phoenix Routes...
Writing JSON to file...
Finished generating Swagger documentation!
```

To view the generated Swagger in [swagger-ui](https://github.com/swagger-api/swagger-ui):

* In a temp folder, execute a git clone of https://github.com/swagger-api/swagger-ui.git
* In the browser of your choice, open the file *temp folder*/swagger-ui/dist/index.html
* In the JSON API input box at the top of the page, paste in the link to the JSON
* Hit the 'Explore' button

For a complete example, please see the [examples](https://github.com/OpenAperture/swaggerdoc/tree/master/examples) section.

## Config

SwaggerDoc's version and project information is configured in your config.exs files.  The options are specified under the :swaggerdoc application.

```iex
config :swaggerdoc,
  swagger_version: "2.0"
```

### Task Config
The following task-specific options are available:

* :output_path
  * Description:  Specifies the file path where the JSON file will be created.
  * Type:  string
  * Default Value:  System.cwd!() <> "/swagger"
* :output_file
  * Description:  Specifies the file name (within the output_path) of the Swagger JSON
  * Type:  string
  * Default Value:  "api.json"

### Swagger Config
The following Swagger-specific options are available:

* :swagger_version
  * Description:  Specifies the Swagger Specification version being used. It can be used by the Swagger UI and other clients to interpret the API listing. The value MUST be "2.0".
  * Swagger Location:  [Swagger Object](http://swagger.io/specification/#swaggerObject), "swagger"
  * Type:  string
  * Default Value:  "2.0"
* :host
  * Description:  The host (name or ip) serving the API. This MUST be the host only and does not include the scheme nor sub-paths. It MAY include a port. If the host is not included, the host serving the documentation is to be used (including the port). The host does not support path templating.
  * Swagger Location:  [Swagger Object](http://swagger.io/specification/#swaggerObject), "host"
  * Type:  string
  * Default Value:  ""  
* :base_path
  * Description:  The base path on which the API is served, which is relative to the host. If it is not included, the API is served directly under the host. The value MUST start with a leading slash (/). The basePath does not support path templating.
  * Swagger Location:  [Swagger Object](http://swagger.io/specification/#swaggerObject), "basePath"
  * Type:  string
  * Default Value:  ""    
* :schemes
  * Description:  The transfer protocol of the API. Values MUST be from the list: "http", "https", "ws", "wss". If the schemes is not included, the default scheme to be used is the one used to access the Swagger definition itself.
  * Swagger Location:  [Swagger Object](http://swagger.io/specification/#swaggerObject), "schemes"
  * Type:  [string]
  * Default Value:  ["http"]
* :consumes
  * Description:  A list of MIME types the APIs can consume. This is global to all APIs but can be overridden on specific API calls. Value MUST be as described under Mime Types.
  * Swagger Location:  [Swagger Object](http://swagger.io/specification/#swaggerObject), "consumes"  
  * Type:  [string]
  * Default Value:  []
* :produces
  * Description:  A list of MIME types the APIs can produce. This is global to all APIs but can be overridden on specific API calls. Value MUST be as described under Mime Types.
  * Swagger Location:  [Swagger Object](http://swagger.io/specification/#swaggerObject), "produces"  
  * Type:  [string]
  * Default Value:  []  
* :project_version
  * Description:  Provides the version of the application API (not to be confused with the specification version).
  * Swagger Location:  [Info Object](http://swagger.io/specification/#infoObject), "version"
  * Type:  string
  * Default Value:  ""
* :project_name
  * Description:  The title of the application.
  * Swagger Location:  [Info Object](http://swagger.io/specification/#infoObject), "title"
  * Type:  string
  * Default Value:  ""
* :project_desc
  * Description:  A short description of the application. GFM syntax can be used for rich text representation.
  * Swagger Location:  [Info Object](http://swagger.io/specification/#infoObject), "description"
  * Type:  string
  * Default Value:  ""
* :project_terms
  * Description:  The Terms of Service for the API.
  * Swagger Location:  [Info Object](http://swagger.io/specification/#infoObject), "termsOfService"
  * Type:  string
  * Default Value:  ""
* :project_contact_name
  * Description:  The identifying name of the contact person/organization.
  * Swagger Location:  [Contact Object](http://swagger.io/specification/#contactObject), "name"
  * Type:  string
  * Default Value:  ""
* :project_contact_email
  * Description:  The email address of the contact person/organization. MUST be in the format of an email address.
  * Swagger Location:  [Contact Object](http://swagger.io/specification/#contactObject), "email"
  * Type:  string
  * Default Value:  ""
* :project_contact_url
  * Description:  The URL pointing to the contact information. MUST be in the format of a URL.
  * Swagger Location:  [Contact Object](http://swagger.io/specification/#contactObject), "url"
  * Type:  string
  * Default Value:  ""
* :project_license_name
  * Description:  The license name used for the API.
  * Swagger Location:  [License Object](http://swagger.io/specification/#licenseObject), "url"
  * Type:  string
  * Default Value:  ""
* :project_license_url
  * Description:  A URL to the license used for the API. MUST be in the format of a URL.
  * Swagger Location:  [License Object](http://swagger.io/specification/#licenseObject), "url"
  * Type:  string
  * Default Value:  ""

Here's an example from the sample [HelloUser's config.exs](https://github.com/OpenAperture/swaggerdoc/blob/master/examples/hello_user/config/config.exs):
```iex
config :swaggerdoc,
  swagger_version: "2.0",
  project_version: "1.0.0",
  project_name: "Hello User",
  project_desc: "The REST API for the Hello User",
  project_terms: "https://www.mozilla.org/en-US/MPL/2.0/",
  project_contact_name: "OpenAperture",
  project_contact_email: "openaperture@lexmark.com",
  project_contact_url: "http://openaperture.io",
  project_license_name: "Mozilla Public License, v. 2.0",
  project_license_url: "https://www.mozilla.org/en-US/MPL/2.0/",
  host: "openaperture.io",
  base_path: "/",
  schemes: ["https"],
  consumes: ["application/json"],
  produces: ["application/json"]  
```

## Default Behavior
The mix task is designed to scan for Ecto-specific Models and Phoenix-specific routes to attempt to generate an accurrate Swagger API object.  

### Converting Ecto Models into Swagger Definitions
Each [Ecto Model](https://github.com/elixir-lang/ecto/blob/v1.0.0/lib/ecto/model.ex) that is identified (prescence of the [__schema__ method](https://github.com/elixir-lang/ecto/blob/v1.0.0/lib/ecto/schema.ex#L229-L230)) is converted into a [Definitions Object](http://swagger.io/specification/#definitionsObject).  

The conversion uses schema fields and updates them into schemas unde the [Definitions Object](http://swagger.io/specification/#definitionsObject).  The following values are used to convert an [Ecto schema type](https://github.com/elixir-lang/ecto/blob/v1.0.0/lib/ecto/schema.ex#L107-L145) into a [Swagger property type](http://swagger.io/specification/#dataTypeType):

* :id -> %{"type" => "integer", "format" => "int64"}
* :binary_id -> %{"type" => "string", "format" => "binary"}
* :integer -> %{"type" => "integer", "format" => "int64"}
* :float -> %{"type" => "number", "format" => "float"}
* :boolean -> %{"type" => "boolean"}
* :string -> %{"type" => "string"}
* :binary -> %{"type" => "string", "format" => "binary"}
* :Ecto.DateTime -> %{"type" => "string", "format" => "date-time"}
* :Ecto.Date -> %{"type" => "string", "format" => "date"}
* :Ecto.Time -> %{"type" => "string", "format" => "date-time"}
* :uuid -> %{"type" => "string"}
* _ -> %{"type" => "string"}

Looking at the [HelloUser.User model](https://github.com/OpenAperture/swaggerdoc/blob/master/examples/hello_user/web/models/user.ex#L4-L11):

```elixir
  schema "users" do
    field :name, :string
    field :email, :string
    field :bio, :string
    field :number_of_pets, :integer

    timestamps
  end
```

The JSON output will look like:

```javascript
	"definitions": {
	  "HelloUser.User": {
	    "properties": {
	      "updated_at": {
	        "type": "string",
	        "format": "date-time"
	      },
	      "number_of_pets": {
	        "type": "integer",
	        "format": "int64"
	      },
	      "name": {
	        "type": "string"
	      },
	      "inserted_at": {
	        "type": "string",
	        "format": "date-time"
	      },
	      "id": {
	        "type": "integer",
	        "format": "int64"
	      },
	      "email": {
	        "type": "string"
	      },
	      "bio": {
	        "type": "string"
	      }
	    }
	  }
	}
```

### Converting Phoenix Routes into Swagger Paths
The [Phoenix Routes](https://github.com/phoenixframework/phoenix/blob/v1.0.0/lib/phoenix/router/route.ex) that is found via the [Phoenix Router](https://github.com/phoenixframework/phoenix/blob/v1.0.0/lib/phoenix/router.ex) are converted into a [Swagger Paths Object](http://swagger.io/specification/#pathsObject), each route becoming a [Path Item](http://swagger.io/specification/#pathItemObject).  The Phoenix template paths are converted into [Swagger path templates](http://swagger.io/specification/#pathTemplating) and each templated variable is converted into a [Path paramter](http://swagger.io/specification/#parametersDefinitionsObject).  All path parameters are assumed to be required and are of type string (except for parameters named `id`, which are assumed to be integers).

[Response Definitions](http://swagger.io/specification/#responsesDefinitionsObject) are generated, based on the HTTP verb associated with the operation:

* All Verbs
  * "404" => %{"description" => "Resource not found"}, 
  * "401" => %{"description" => "Request is not authorized"}, 
  * "500" => %{"description" => "Internal Server Error"}
* GET
  * "200" => %{"description" => "Resource Content"}
* DELETE
  * "204" => %{"description" => "No Content"}
* POST
  * "201" => %{"description" => "Resource created"
  * "400" => %{"description" => "Request contains bad values"}
* PUT
  * "204" => %{"description" => "No Content"
  * "400" => %{"description" => "Request contains bad values"}

## Customized Behavior
The default behavior of the task may be improved by adding action-specific functions that provide the task more detail.  As the task scans for [Phoenix Routes](https://github.com/phoenixframework/phoenix/blob/v1.0.0/lib/phoenix/router/route.ex), it will check for the prescense of a function named "swaggerdoc_#{route.controller.method}".  If that function is present, the Map returned will be used in place of the default Swagger implementation.  The map may consist of the following elements:

* :description
  * Short description of the API endpoint.
* :response_schema
  * For API endpoints that are returning a value (i.e. a GET), you may want to return a specific [Schema Object](http://swagger.io/specification/#schemaObject) that represents the return value.
  * To specify a specific Ecto Model, add as a [$ref](https://github.com/OpenAperture/swaggerdoc/blob/master/examples/hello_user/web/controllers/user_controller.ex#L41):  `"schema": %{"$ref": "#/definitions/HelloUser.User"}`.  Make sure to use the fully-qualified module name.
  * To specify an array of Ecto Models, add as an [array of items](https://github.com/OpenAperture/swaggerdoc/blob/master/examples/hello_user/web/controllers/user_controller.ex#L10):  `%{"title" => "Users", "type": "array", "items": %{"$ref": "#/definitions/HelloUser.User"}}`
  * To specify a custom object that doesn't have a corresponding model, [build the schema](https://github.com/OpenAperture/swaggerdoc/blob/master/examples/hello_user/web/controllers/user_controller.ex#L149-L158) directly:  
```elixir
	%{
		"title" => "User.CustomFields", "type": "array", "items": %{
		  "title" => "User.CustomField", 
		  "description" => "A Custom Field",
		  "type" => "object",
		  "required" => ["key","value"],
		  "properties" => %{
		    "key" => %{"type" => "string", "description" => "The key for the custom field"},
		    "value" => %{"type" => "string", "description" => "The value for the custom field"},
		  }
	  }
	}
```  
* :parameters
  * An array of [Parameter Definition objects](http://swagger.io/specification/#parametersDefinitionsObject).  These values may represent a combination of query, body, formdata, etc...  For an example, please see the [sync_user](https://github.com/OpenAperture/swaggerdoc/blob/master/examples/hello_user/web/controllers/user_controller.ex#L109-L140):
```elixir
	[%{
	  "name" => "id",
	  "in" => "path",
	  "description" => "Workflow identifier",
	  "required" => true,
	  "type" => "integer"
	},
	%{
	  "name" => "force_sync",
	  "in" => "body",
	  "description" => "Force a synchronization of the user",
	  "required" => false,
	  "schema": %{
	    "title" => "force_sync", 
	    "description" => "Force a synchronization of the user",
	    "type" => "boolean"
	  }
	},
	%{
	  "name" => "foreign_system_id",
	  "in" => "body",
	  "description" => "Foreign User system identifier",
	  "required" => true,
	  "schema": %{
	    "title" => "foreign_system_id", 
	    "description" => "Foreign User system identifier",
	    "type" => "string"
	  }      
	}]
```
  * Note that `body` parameters are required to define a `schema`.

## Contributing

To contribute to OpenAperture development, view our [contributing guide](http://openaperture.io/dev_resources/contributing.html)
