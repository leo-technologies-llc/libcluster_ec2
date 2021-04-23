defmodule ClusterEC2 do
  @moduledoc File.read!("#{__DIR__}/../README.md")
  @tesla_adapter Application.get_env(:tesla, :adapter)
  @base_url "http://169.254.169.254/latest/meta-data"

  @doc """
    Queries the local EC2 instance metadata API to determine the instance ID of the current instance.
  """
  @spec local_instance_id() :: binary()
  def local_instance_id do
    case Tesla.get(http(), "/instance-id/") do
      {:ok, %{status: 200, body: body}} -> body
      _ -> ""
    end
  end

  @doc """
    Queries the local EC2 instance metadata API to determine the aws resource region of the current instance.
  """
  @spec instance_region() :: binary()
  def instance_region do
    case Tesla.get(http(), "/placement/availability-zone/") do
      {:ok, %{status: 200, body: body}} -> String.slice(body, 0..-2)
      _ -> ""
    end
  end

  defp http() do
    adapter = {@tesla_adapter, [recv_timeout: 120_000]}
    options = [{Tesla.Middleware.BaseUrl, @base_url}]
    Tesla.client(options, adapter)
  end
end
