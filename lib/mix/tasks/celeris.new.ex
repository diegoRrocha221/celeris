defmodule Mix.Tasks.Celeris.New do
  use Mix.Task

  @shortdoc "Creates a new application using the Celeris framework"
  @moduledoc """
  Creates a new Celeris project with a standard Rails-like structure.
  """

  def run([app_name | _args]) do
    app_path = Path.join(File.cwd!(), app_name)

    if File.exists?(app_path) do
      Mix.raise("The directory #{app_path} already exists!")
    else
      File.mkdir_p!(app_path)
      generate_base_structure(app_path, app_name)
      Mix.shell().info("Project #{app_name} created successfully!")
    end
  end

  defp generate_base_structure(app_path, app_name) do
    # Define directories for Rails-like structure
    dirs = [
      "app/controllers",
      "app/models",
      "app/views",
      "app/views/page",
      "config",
      "db/migrate",
      "lib/#{app_name}",
      "public",
      "test"
    ]

    Enum.each(dirs, fn dir -> File.mkdir_p!(Path.join(app_path, dir)) end)
    create_base_files(app_path, app_name)
  end

  defp create_base_files(app_path, app_name) do
    # Generate files like config, initial CRUD, and routes
    # More detailed file content will be added here later
    File.write!(Path.join(app_path, "config/config.exs"), base_config_content(app_name))
    File.write!(Path.join(app_path, "app/controllers/page_controller.ex"), base_controller_content())
    File.write!(Path.join(app_path, "app/views/page/index.html.cel"), base_view_content())
    File.write!(Path.join(app_path, "lib/#{app_name}.ex"), app_module_content(app_name))
  end

  defp base_config_content(app_name) do
    """
    use Mix.Config

    config :#{app_name}, Celeris.Repo,
      database: "#{app_name}_dev",
      username: "postgres",
      password: "postgres",
      hostname: "localhost"
    """
  end

  defp base_controller_content do
    """
    defmodule Celeris.PageController do
      use Celeris.Controller

      def index(conn, _params) do
        render(conn, "index.html.cel", message: "Welcome to Celeris!")
      end
    end
    """
  end

  defp base_view_content do
    """
    <h1><%= message %></h1>
    """
  end

  defp app_module_content(app_name) do
    """
    defmodule #{String.capitalize(app_name)} do
      @moduledoc "Main application module for #{app_name}"
    end
    """
  end
end