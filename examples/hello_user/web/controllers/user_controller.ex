defmodule HelloUser.UserController do
  use HelloUser.Web, :controller

  import HelloUser.Controllers.ControllerHelper

  alias HelloUser.User

  def swaggerdoc_index, do: %{
    description: "Retrieve all Users",
    response_schema: %{"title" => "Users", "type": "array", "items": %{"$ref": "#/definitions/HelloUser.User"}},
    parameters: []
  }    
  @spec index(Plug.Conn.t, [any]) :: Plug.Conn.t 
  def index(conn, _params) do
    json conn, to_sendable(Repo.all(User))
  end

  def swaggerdoc_show, do: %{
    description: "Retrieve a specific User",
    response_schema: %{"$ref": "#/definitions/HelloUser.User"},
    parameters: [%{
      "name" => "id",
      "in" => "path",
      "description" => "User identifier",
      "required" => true,
      "type" => "integer"
    }]
  }    
  @spec show(Plug.Conn.t, [any]) :: Plug.Conn.t 
  def show(conn, %{"id" => id}) do
    json conn, to_sendable(Repo.get!(User, id))
  end

  def swaggerdoc_create, do: %{
    description: "Create a User" ,
    parameters: [%{
      "name" => "type",
      "in" => "body",
      "description" => "The new User",
      "required" => true,
      "schema": %{"$ref": "#/definitions/HelloUser.User"}
    }]
  }
  @spec create(Plug.Conn.t, [any]) :: Plug.Conn.t 
  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, _user} -> resp(conn, :created, "")
      {:error, changeset} -> 
        conn
        |> put_status(:bad_request)
        |> json inspect(changeset.errors)     
    end
  end

  def swaggerdoc_update, do: %{
    description: "Update a User" ,
    parameters: [%{
      "name" => "id",
      "in" => "path",
      "description" => "User identifier",
      "required" => true,
      "type" => "integer"
    },
    %{
      "name" => "type",
      "in" => "body",
      "description" => "The updated User",
      "required" => true,
      "schema": %{"$ref": "#/definitions/HelloUser.User"}
    }]
  }  
  @spec update(Plug.Conn.t, [any]) :: Plug.Conn.t 
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, _user} -> resp(conn, :no_content, "")
      {:error, changeset} -> 
        conn
        |> put_status(:bad_request)
        |> json inspect(changeset.errors)        
    end
  end

  def swaggerdoc_delete, do: %{
    description: "Delete a User" ,
    parameters: [%{
      "name" => "id",
      "in" => "path",
      "description" => "User identifier",
      "required" => true,
      "type" => "integer"
    }]
  }  
  @spec delete(Plug.Conn.t, [any]) :: Plug.Conn.t
  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)
    resp(conn, :no_content, "")
  end


  def swaggerdoc_sync_user, do: %{
    description: "Synchronize a User to a 3rd-party system" ,
    parameters: [%{
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
  }  
  @spec sync_user(Plug.Conn.t, [any]) :: Plug.Conn.t
  def sync_user(conn, %{"id" => _id}) do
    #Take some sort of customized action, based on the params
    resp(conn, :no_content, "")
  end

  def swaggerdoc_get_custom_fields, do: %{
    description: "Retrieve all get_custom_fields associated with a User",
    response_schema: %{"title" => "User.CustomFields", "type": "array", "items": %{
      "title" => "User.CustomField", 
      "description" => "A Custom Field",
      "type" => "object",
      "required" => ["key","value"],
      "properties" => %{
        "key" => %{"type" => "string", "description" => "The key for the custom field"},
        "value" => %{"type" => "string", "description" => "The value for the custom field"},
      }
    }},
    parameters: [%{
      "name" => "id",
      "in" => "path",
      "description" => "Workflow identifier",
      "required" => true,
      "type" => "integer"
    }]
  }
  @spec get_custom_fields(Plug.Conn.t, [any]) :: Plug.Conn.t 
  def get_custom_fields(conn, %{"id" => _id}) do
    custom_fields = [%{key: "test1", value: "value1"}, %{key: "test2", value: "value2"}]

    json conn, custom_fields
  end
end
