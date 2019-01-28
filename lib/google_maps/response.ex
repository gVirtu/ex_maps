defmodule GoogleMaps.Response do
  @moduledoc false

  @type t :: {:ok, map()} | {:error, error()} | {:error, error(), String.t()}

  @type status :: String.t

  @type error :: HTTPoison.Error.t | status()

  def wrap({:error, error}, _resource), do: {:error, error}
  def wrap({:ok, %{body: body} = response}, "json") when is_binary(body) do
    wrap({:ok, %{response | body: Jason.decode!(body)}}, "json")
  end

  def wrap({:ok, %{body: %{"status" => "OK"} = body}}, "json"), do: {:ok, body}
  def wrap({:ok, %{body: %{"status" => status, "error_message" => error_message}}}, "json"), do: {:error, status, error_message}
  def wrap({:ok, %{body: %{"status" => status}}}, "json"), do: {:error, status}

  def wrap({:ok, %{body: body, status_code: 200}}, "photo") when is_binary(body), do: {:ok, body}
  def wrap({:ok, %{status_code: status}}, "photo"), do: {:error, status}
end
