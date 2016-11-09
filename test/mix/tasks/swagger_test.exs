defmodule Mocks.DefaultPlug do
  def swaggerdoc_index do
    %{
      responses: %{}
    }
  end
end

defmodule Mocks.UserModel do
  use Ecto.Schema

  schema "users" do
    field :name, :string
    field :email, :string
    field :bio, :string
    field :number_of_pets, :integer

    timestamps
  end
end

defmodule Mocks.UserRequiredModel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :bio, :string
    field :number_of_pets, :integer

    timestamps
  end

  @required_fields ~w(name email)a
  @optional_fields ~w(bio number_of_pets)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

end

defmodule Mocks.SimpleRouter do
  def __routes__, do: []
end

defmodule Mix.Tasks.Swagger.Tests do
  use ExUnit.Case
  use Plug.Test

  alias Mix.Tasks.Swagger
  alias Phoenix.Router.Route, as: PhoenixRoute

  def reset_swagger_env do
    Application.delete_env(:swaggerdoc, :swagger_version)
    Application.delete_env(:swaggerdoc, :project_version)
    Application.delete_env(:swaggerdoc, :project_name)
    Application.delete_env(:swaggerdoc, :project_desc)
    Application.delete_env(:swaggerdoc, :project_terms)
    Application.delete_env(:swaggerdoc, :project_contact_name)
    Application.delete_env(:swaggerdoc, :project_contact_email)
    Application.delete_env(:swaggerdoc, :project_contact_url)
    Application.delete_env(:swaggerdoc, :project_license_name)
    Application.delete_env(:swaggerdoc, :project_license_url)
    Application.delete_env(:swaggerdoc, :host)
    Application.delete_env(:swaggerdoc, :base_path)
    Application.delete_env(:swaggerdoc, :schemes)
    Application.delete_env(:swaggerdoc, :consumes)
    Application.delete_env(:swaggerdoc, :produces)
    Application.delete_env(:swaggerdoc, :pipe_through)
  end

  setup do
    reset_swagger_env
    :ok
  end

  setup_all do
    on_exit fn ->
      reset_swagger_env
    end
    :ok
  end

  #==============================
  # app_json tests

  test "app_json - default values" do
    default_json = Swagger.app_json
    assert default_json != nil
    assert default_json[:swagger] == "2.0"
    assert default_json[:info][:version] == ""
    assert default_json[:info][:title] == ""
    assert default_json[:info][:description] == ""
    assert default_json[:info][:termsOfService] == ""
    assert default_json[:info][:contact][:name] == ""
    assert default_json[:info][:contact][:email] == ""
    assert default_json[:info][:contact][:url] == ""
    assert default_json[:info][:license][:name] == ""
    assert default_json[:info][:license][:url] == ""
    assert default_json[:host] == ""
    assert default_json[:basePath] == ""
    assert default_json[:schemes] == ["http"]
    assert default_json[:consumes] == []
    assert default_json[:produces] == []
    assert default_json[:definitions] == []
    assert default_json[:paths] == %{}
  end

  test "app_json - override values" do
    Application.put_env(:swaggerdoc, :swagger_version, "3.0")
    Application.put_env(:swaggerdoc, :project_version, "123")
    Application.put_env(:swaggerdoc, :project_name, "test name")
    Application.put_env(:swaggerdoc, :project_desc, "testing")
    Application.put_env(:swaggerdoc, :project_terms, "testing terms")
    Application.put_env(:swaggerdoc, :project_contact_name, "last, first")
    Application.put_env(:swaggerdoc, :project_contact_email, "first.last@somewhere.com")
    Application.put_env(:swaggerdoc, :project_contact_url, "http://somewhere")
    Application.put_env(:swaggerdoc, :project_license_name, "license")
    Application.put_env(:swaggerdoc, :project_license_url, "http://somewhere/license")
    Application.put_env(:swaggerdoc, :host, "hostname")
    Application.put_env(:swaggerdoc, :base_path, "/")
    Application.put_env(:swaggerdoc, :schemes, ["http", "https"])
    Application.put_env(:swaggerdoc, :consumes, ["application/json"])
    Application.put_env(:swaggerdoc, :produces, ["application/json"])

    default_json = Swagger.app_json
    assert default_json != nil
    assert default_json[:swagger] == "3.0"
    assert default_json[:info][:version] == "123"
    assert default_json[:info][:title] == "test name"
    assert default_json[:info][:description] == "testing"
    assert default_json[:info][:termsOfService] == "testing terms"
    assert default_json[:info][:contact][:name] == "last, first"
    assert default_json[:info][:contact][:email] == "first.last@somewhere.com"
    assert default_json[:info][:contact][:url] == "http://somewhere"
    assert default_json[:info][:license][:name] == "license"
    assert default_json[:info][:license][:url] == "http://somewhere/license"
    assert default_json[:host] == "hostname"
    assert default_json[:basePath] == "/"
    assert default_json[:schemes] == ["http", "https"]
    assert default_json[:consumes] == ["application/json"]
    assert default_json[:produces] == ["application/json"]
    assert default_json[:definitions] == []
    assert default_json[:paths] == %{}
  end

  #==============================
  # get_router tests

  test "get_router - nil args" do
    assert Swagger.get_router(nil) == Swaggerdoc.Router
  end

  test "get_router - empty args" do
    assert Swagger.get_router([]) == Swaggerdoc.Router
  end

  #==============================
  # add_routes tests

  test "add_routes - nil routes" do
    assert Swagger.add_routes(nil, %{}) == %{}
  end

  test "add_routes - empty routes" do
    assert Swagger.add_routes([], %{}) == %{}
  end

  test "add_routes - route" do
    route = %PhoenixRoute{
      path: "/test",
      opts: :index,
      verb: "GET"
    }
    assert Swagger.add_routes([route], %{paths: %{}}) == %{
      paths: %{"/test" =>
        %{"get" =>  %{
          description: "",
          operationId: "index",
          parameters: [],
          produces: [],
          responses: %{
            "200" => %{"description" => "Resource Content"},
            "401" => %{"description" => "Request is not authorized"}, "404" => %{"description" => "Resource not found"},
            "500" => %{"description" => "Internal Server Error"}
          }
        }}
      }}
  end

  test "add_routes - route with default template param" do
    route = %PhoenixRoute{
      path: "/testing/:id",
      opts: :index,
      verb: "GET"
    }
    assert Swagger.add_routes([route], %{paths: %{}}) == %{
      paths: %{"/testing/{id}" =>
        %{"get" =>  %{
          description: "",
          operationId: "index",
          parameters: [%{"description" => "", "in" => "path", "name" => "id", "required" => true, "type" => "integer"}],
          produces: [],
          responses: %{
            "200" => %{"description" => "Resource Content"},
            "401" => %{"description" => "Request is not authorized"}, "404" => %{"description" => "Resource not found"},
            "500" => %{"description" => "Internal Server Error"}
          }
        }}
      }}
  end

  test "add_routes - route with select pipe_through" do
    Application.put_env(:swaggerdoc, :pipe_through, [:api])
    route = [%PhoenixRoute{
      path: "/testing/:id",
      opts: :index,
      verb: "GET"
    },%PhoenixRoute{
      path: "/api/v1/testing/:id",
      opts: :index,
      verb: "GET",
      pipe_through: [:api],
    }]
    assert Swagger.add_routes(route, %{paths: %{}}) == %{
      paths: %{"/api/v1/testing/{id}" =>
        %{"get" =>  %{
          description: "",
          operationId: "index",
          parameters: [%{"description" => "", "in" => "path", "name" => "id", "required" => true, "type" => "integer"}],
          produces: [],
          responses: %{
            "200" => %{"description" => "Resource Content"},
            "401" => %{"description" => "Request is not authorized"}, "404" => %{"description" => "Resource not found"},
            "500" => %{"description" => "Internal Server Error"}
          }
        }}
      }}
    Application.delete_env(:swaggerdoc, :pipe_through)
  end

  test "add_routes - route from custom plug" do
    route = %PhoenixRoute{
      path: "/test",
      opts: :index,
      verb: "GET",
      plug: Mocks.DefaultPlug
    }
    assert Swagger.add_routes([route], %{paths: %{}}) == %{
      paths: %{"/test" =>
        %{"get" =>  %{
          description: "",
          operationId: "index",
          produces: [],
          responses: %{}
        }}
      }}
  end

  #==============================
  # path_from_route tests

  test "path_from_route - empty path segments" do
    assert Swagger.path_from_route([], nil) == nil
  end

  test "path_from_route - no templates" do
    assert Swagger.path_from_route(["testing"], nil) == "/testing"
  end

  test "path_from_route - templates" do
    assert Swagger.path_from_route(["testing", ":id"], nil) == "/testing/{id}"
  end

  #==============================
  # parse_default_verb tests

  test "parse_default_verb - no templates" do
    assert Swagger.parse_default_verb("/testing") == %{parameters: []}
  end

  test "parse_default_verb - id segment" do
    assert Swagger.parse_default_verb("/testing/:id") == %{parameters: [%{"description" => "", "in" => "path", "name" => "id", "required" => true, "type" => "integer"}]}
  end

  test "parse_default_verb - name segment" do
    assert Swagger.parse_default_verb("/testing/:name") == %{parameters: [%{"description" => "", "in" => "path", "name" => "name", "required" => true, "type" => "string"}]}
  end

  #==============================
  # default_responses tests

  test "default_responses - unknown verb" do
    assert Swagger.default_responses("junk") == %{
      "404" => %{"description" => "Resource not found"},
      "401" => %{"description" => "Request is not authorized"},
      "500" => %{"description" => "Internal Server Error"}
    }
  end

  test "default_responses - get without schema" do
    assert Swagger.default_responses("get") == %{
      "404" => %{"description" => "Resource not found"},
      "401" => %{"description" => "Request is not authorized"},
      "500" => %{"description" => "Internal Server Error"},
      "200" => %{"description" => "Resource Content"}
    }
  end

  test "default_responses - get with schema" do
    assert Swagger.default_responses("get", %{}) == %{
      "404" => %{"description" => "Resource not found"},
      "401" => %{"description" => "Request is not authorized"},
      "500" => %{"description" => "Internal Server Error"},
      "200" => %{"description" => "Resource Content", "schema" => %{}}
    }
  end

  test "default_responses - delete" do
    assert Swagger.default_responses("delete") == %{
      "404" => %{"description" => "Resource not found"},
      "401" => %{"description" => "Request is not authorized"},
      "500" => %{"description" => "Internal Server Error"},
      "204" => %{"description" => "No Content"}
    }
  end

  test "default_responses - post" do
    assert Swagger.default_responses("post") == %{
      "404" => %{"description" => "Resource not found"},
      "401" => %{"description" => "Request is not authorized"},
      "500" => %{"description" => "Internal Server Error"},
      "201" => %{"description" => "Resource created"},
      "400" => %{"description" => "Request contains bad values"}
    }
  end

  test "default_responses - put" do
    assert Swagger.default_responses("put") == %{
      "404" => %{"description" => "Resource not found"},
      "401" => %{"description" => "Request is not authorized"},
      "500" => %{"description" => "Internal Server Error"},
      "204" => %{"description" => "No Content"},
      "400" => %{"description" => "Request contains bad values"}
    }
  end

  #==============================
  # build_definitions tests

  test "build_definitions - no models" do
    assert Swagger.build_definitions([], %{}) == %{}
  end

  test "build_definitions - modules but no models" do
    assert Swagger.build_definitions([{Mocks.DefaultPlug, ""}], %{}) == %{}
  end

  #==============================
  # required_fields tests

  test "required_fields - parse errors from struct, if errors is empty" do
    assert Swagger.required_fields([]) == []
  end

  test "required_fields - parse errors from struct" do
    assert Swagger.required_fields([name: "can't be blank", email: "can't be blank"]) == ["name", "email"]
  end

  test "build_definitions - model" do
    assert Swagger.build_definitions([{Mocks.UserModel, ""}], %{}) == %{
      "Mocks.UserModel" => %{
        "properties" => %{
          "bio" => %{"type" => "string"},
          "email" => %{"type" => "string"},
          "id" => %{"format" => "int64", "type" => "integer"},
          "inserted_at" => %{"format" => "date-time", "type" => "string"},
          "name" => %{"type" => "string"},
          "number_of_pets" => %{"format" => "int64", "type" => "integer"},
          "updated_at" => %{"format" => "date-time", "type" => "string"}}
        }
    }
  end

  test "build_definitions - model support changeset (required_fields)" do
    assert Swagger.build_definitions([{Mocks.UserRequiredModel, ""}], %{}) == %{
      "Mocks.UserRequiredModel" => %{
        "properties" => %{
          "bio" => %{"type" => "string"},
          "email" => %{"type" => "string"},
          "id" => %{"format" => "int64", "type" => "integer"},
          "inserted_at" => %{"format" => "date-time", "type" => "string"},
          "name" => %{"type" => "string"},
          "number_of_pets" => %{"format" => "int64", "type" => "integer"},
          "updated_at" => %{"format" => "date-time", "type" => "string"}
        },
        "required" => ["name", "email"]
      }
    }
  end

  #==============================
  # convert_property_type tests

  test "convert_property_type - :id" do
    assert Swagger.convert_property_type(:id) == %{"type" => "integer", "format" => "int64"}
  end

  test "convert_property_type - :binary_id" do
    assert Swagger.convert_property_type(:binary_id) == %{"type" => "string", "format" => "binary"}
  end

  test "convert_property_type - :integer" do
    assert Swagger.convert_property_type(:integer) == %{"type" => "integer", "format" => "int64"}
  end

  test "convert_property_type - :float" do
    assert Swagger.convert_property_type(:float) == %{"type" => "number", "format" => "float"}
  end

  test "convert_property_type - :boolean" do
    assert Swagger.convert_property_type(:boolean) == %{"type" => "boolean"}
  end

  test "convert_property_type - :string" do
    assert Swagger.convert_property_type(:string) == %{"type" => "string"}
  end

  test "convert_property_type - :Ecto.DateTime " do
    assert Swagger.convert_property_type(Ecto.DateTime ) == %{"type" => "string", "format" => "date-time"}
  end

  test "convert_property_type - :Ecto.Date" do
    assert Swagger.convert_property_type(Ecto.Date) ==%{"type" => "string", "format" => "date"}
  end

  test "convert_property_type - :Ecto.Time" do
    assert Swagger.convert_property_type(Ecto.Time) == %{"type" => "string", "format" => "date-time"}
  end

  test "convert_property_type - :uuid" do
    assert Swagger.convert_property_type(:uuid) == %{"type" => "string"}
  end

  test "convert_property_type - :unknown" do
    assert Swagger.convert_property_type(:unknown) == %{"type" => "string"}
  end

  #==============================
  # run tests

  test "run" do
    :meck.new(Swagger, [:passthrough])
    :meck.expect(Swagger, :get_router, fn _ -> Mocks.SimpleRouter end)
    :meck.expect(Swagger, :add_routes, fn _,_ -> %{} end)

    assert Swagger.run(nil) == :ok
  after
    :meck.unload
  end

  test "run raise exception" do
    :meck.new(Swagger, [:passthrough])
    :meck.expect(Swagger, :get_router, fn _ -> Mocks.SimpleRouter end)
    :meck.expect(Swagger, :add_routes, fn _,_ -> raise "bad news bears" end)

    assert Swagger.run(nil) == :ok
  after
    :meck.unload
  end
end
