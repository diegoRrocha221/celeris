defmodule Mix.Tasks.Celeris.New do
  use Mix.Task

  @shortdoc "Creates a new application using the Celeris framework"
  @moduledoc """
  Creates a new Celeris project with a standard.
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
    # Generate files for config, initial CRUD, and routes
    File.write!(Path.join(app_path, "config/config.exs"), base_config_content(app_name))
    File.write!(Path.join(app_path, "app/controllers/page_controller.ex"), base_controller_content(app_name))
    File.write!(Path.join(app_path, "app/views/page/index.html.cel"), base_view_content())
    File.write!(Path.join(app_path, "lib/#{app_name}.ex"), app_module_content(app_name))
    File.write!(Path.join(app_path, "db/migrate/20220101010101_create_page_table.exs"), migration_content())
  end

  defp base_config_content(app_name) do
    """
    import Config

    config :#{app_name}, #{String.capitalize(app_name)}.Repo,
      adapter: Ecto.Adapters.Postgres,
      database: "#{app_name}_dev",
      username: "postgres",
      password: "postgres",
      hostname: "localhost",
      pool_size: 10
    """
  end

  defp base_controller_content(app_name) do
    """
    defmodule #{String.capitalize(app_name)}.PageController do
      use #{String.capitalize(app_name)}, :controller

      def index(conn, _params) do
        conn
        |> put_resp_content_type("text/html")
        |> render("index.html.cel")
      end
    end
    """
  end

  defp base_view_content do
    """
    <h1>Welcome to Celeris!</h1>
    <p>Your framework is up and running.</p>
    """
  end

  defp app_module_content(app_name) do
    """
    defmodule #{String.capitalize(app_name)} do
      use Application

      def start(_type, _args) do
        children = [
          #{String.capitalize(app_name)}.Repo,
          #{String.capitalize(app_name)}.Router
        ]

        opts = [strategy: :one_for_one, name: #{String.capitalize(app_name)}.Supervisor]
        Supervisor.start_link(children, opts)
      end
    end
    """
  end

  defp migration_content do
    """
    defmodule Repo.Migrations.CreatePageTable do
      use Ecto.Migration

      def change do
        create table(:pages) do
          add :title, :string
          add :content, :text

          timestamps()
        end
      end
    end
    """
  end
end
