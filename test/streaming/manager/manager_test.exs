defmodule Streaming.ManagerTest do
  use Streaming.DataCase

  alias Streaming.Manager

  describe "devices" do
    alias Streaming.Manager.Device

    @valid_attrs %{mac_addr: "some mac_addr", published_at: ~N[2010-04-17 14:00:00.000000], title: "some title"}
    @update_attrs %{mac_addr: "some updated mac_addr", published_at: ~N[2011-05-18 15:01:01.000000], title: "some updated title"}
    @invalid_attrs %{mac_addr: nil, published_at: nil, title: nil}

    def device_fixture(attrs \\ %{}) do
      {:ok, device} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Manager.create_device()

      device
    end

    test "paginate_devices/1 returns paginated list of devices" do
      for _ <- 1..20 do
        device_fixture()
      end

      {:ok, %{devices: devices} = page} = Manager.paginate_devices(%{})

      assert length(devices) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_devices/0 returns all devices" do
      device = device_fixture()
      assert Manager.list_devices() == [device]
    end

    test "get_device!/1 returns the device with given id" do
      device = device_fixture()
      assert Manager.get_device!(device.id) == device
    end

    test "create_device/1 with valid data creates a device" do
      assert {:ok, %Device{} = device} = Manager.create_device(@valid_attrs)
      assert device.mac_addr == "some mac_addr"
      assert device.published_at == ~N[2010-04-17 14:00:00.000000]
      assert device.title == "some title"
    end

    test "create_device/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Manager.create_device(@invalid_attrs)
    end

    test "update_device/2 with valid data updates the device" do
      device = device_fixture()
      assert {:ok, device} = Manager.update_device(device, @update_attrs)
      assert %Device{} = device
      assert device.mac_addr == "some updated mac_addr"
      assert device.published_at == ~N[2011-05-18 15:01:01.000000]
      assert device.title == "some updated title"
    end

    test "update_device/2 with invalid data returns error changeset" do
      device = device_fixture()
      assert {:error, %Ecto.Changeset{}} = Manager.update_device(device, @invalid_attrs)
      assert device == Manager.get_device!(device.id)
    end

    test "delete_device/1 deletes the device" do
      device = device_fixture()
      assert {:ok, %Device{}} = Manager.delete_device(device)
      assert_raise Ecto.NoResultsError, fn -> Manager.get_device!(device.id) end
    end

    test "change_device/1 returns a device changeset" do
      device = device_fixture()
      assert %Ecto.Changeset{} = Manager.change_device(device)
    end
  end
end
