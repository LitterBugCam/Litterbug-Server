defmodule Streaming.Manager do
  @moduledoc """
  The Manager context.
  """

  import Ecto.Query, warn: false
  alias Streaming.Repo
import Torch.Helpers, only: [sort: 1, paginate: 4]
import Filtrex.Type.Config

alias Streaming.Manager.Device

@pagination [page_size: 15]
@pagination_distance 5

@doc """
Paginate the list of devices using filtrex
filters.

## Examples

    iex> list_devices(%{})
    %{devices: [%Device{}], ...}
"""
@spec paginate_devices(map) :: {:ok, map} | {:error, any}
def paginate_devices(params \\ %{}) do
  params =
    params
    |> Map.put_new("sort_direction", "desc")
    |> Map.put_new("sort_field", "inserted_at")

  {:ok, sort_direction} = Map.fetch(params, "sort_direction")
  {:ok, sort_field} = Map.fetch(params, "sort_field")

  with {:ok, filter} <- Filtrex.parse_params(filter_config(:devices), params["device"] || %{}),
       %Scrivener.Page{} = page <- do_paginate_devices(filter, params) do
    {:ok,
      %{
        devices: page.entries,
        page_number: page.page_number,
        page_size: page.page_size,
        total_pages: page.total_pages,
        total_entries: page.total_entries,
        distance: @pagination_distance,
        sort_field: sort_field,
        sort_direction: sort_direction
      }
    }
  else
    {:error, error} -> {:error, error}
    error -> {:error, error}
  end
end

defp do_paginate_devices(filter, params) do
  Device
  |> Filtrex.query(filter)
  |> order_by(^sort(params))
  |> paginate(Repo, params, @pagination)
end

@doc """
Returns the list of devices.

## Examples

    iex> list_devices()
    [%Device{}, ...]

"""
def list_devices do
  Repo.all(Device)
end

@doc """
Gets a single device.

Raises `Ecto.NoResultsError` if the Device does not exist.

## Examples

    iex> get_device!(123)
    %Device{}

    iex> get_device!(456)
    ** (Ecto.NoResultsError)

"""
def get_device!(id), do: Repo.get!(Device, id)

@doc """
Creates a device.

## Examples

    iex> create_device(%{field: value})
    {:ok, %Device{}}

    iex> create_device(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def create_device(attrs \\ %{}) do
  %Device{}
  |> Device.changeset(attrs)
  |> Repo.insert()
end

@doc """
Updates a device.

## Examples

    iex> update_device(device, %{field: new_value})
    {:ok, %Device{}}

    iex> update_device(device, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def update_device(%Device{} = device, attrs) do
  device
  |> Device.changeset(attrs)
  |> Repo.update()
end

@doc """
Deletes a Device.

## Examples

    iex> delete_device(device)
    {:ok, %Device{}}

    iex> delete_device(device)
    {:error, %Ecto.Changeset{}}

"""
def delete_device(%Device{} = device) do
  Repo.delete(device)
end

@doc """
Returns an `%Ecto.Changeset{}` for tracking device changes.

## Examples

    iex> change_device(device)
    %Ecto.Changeset{source: %Device{}}

"""
def change_device(%Device{} = device) do
  Device.changeset(device, %{})
end

defp filter_config(:devices) do
  defconfig do
    text :title
      date :published_at
      text :mac_addr
      
  end
end
end
