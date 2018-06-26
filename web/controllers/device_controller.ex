defmodule Streaming.DeviceController do
  use Streaming.Web, :controller
  alias Streaming.Auth
  alias Streaming.Auth.User
  alias Streaming.Auth.Guardian
  alias Streaming.Manager
  alias Streaming.Manager.Device
  alias Aws.Iot.ThingShadow
  alias Streaming.Manager.Event

  plug(:put_layout, {Streaming.LayoutView, "app.html"})



 def device_state(thing) do
   url = "https://a1oa9tg9lcso0.iot.eu-west-1.amazonaws.com/things/#{thing}/shadow"
   #url = "https://a1oa9tg9lcso0.iot.eu-west-1.amazonaws.com/topics/topic"

   headers = %{
     "Content-Type" => "application/json"
   }

   body = '{
    "state": {
        "desired": {
            "live": "wtffff"

        }

    }

}'



   {:ok, %{} = sig_data, _} =
     Sigaws.sign_req(url, region: "eu-west-1", service: "iotdata",
       access_key: "AKIAJGN4PBBBTWUGGBHQ",
       secret:    "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",
      # body: "#{body}",
       #method: "POST"
        )
       IO.inspect (Map.merge(headers, sig_data))
       header=Map.merge(headers, sig_data)
       {:ok, resp} = HTTPoison.get(url, Map.merge(headers, sig_data),[])
#       {:ok, resp} = HTTPoison.post(url,body, Map.merge(headers, sig_data),[])


  #     IO.inspect(resp)
req = Poison.decode!(resp.body)
%{"state"=>%{"desired"=>%{"live"=> date}}}=req

date=date




 end

  def index(conn, params) do
 date1=DateTime.utc_now()
 date1=DateTime.truncate(date1, :second)
IO.inspect (date1)
  date=  device_state("Litterbug")
  IO.inspect(date)

    changeset = Auth.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user != nil do
      %{devices:  devices}=  Repo.get(User, maybe_user.id) |> Repo.preload(:devices)
      #  IO.inspect (devices)
            render(conn, "index.html",date: date, maybe_user: maybe_user,changeset: changeset,devices: devices)

       conn
       |> render("index.html",changeset: changeset, action: device_path(conn, :login_global), maybe_user: maybe_user, devices: devices)
      else


        conn
        |> render("index.html" ,changeset: changeset, action: device_path(conn, :login_global), maybe_user: maybe_user)

   end


  end

  def new(conn, _params) do
    changeset = Manager.change_device(%Device{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"device" => device}) do
    changeset=Device.changeset(%Device{}, device)
    user = Guardian.Plug.current_resource(conn)

    device_with_user = Ecto.Changeset.put_assoc(changeset, :user, user)
  #  case Manager.create_device(device_with_user) do

    case Repo.insert(device_with_user) do
      {:ok, device} ->
        conn
        |> put_flash(:info, "Device created successfully.")
        |> redirect(to: device_path(conn, :show, device))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

def   get_url(folder) do


  end

  def show(conn, %{"id" => id}) do

  device = Manager.get_device!(id)
  IO.puts "url2"

  records = from(d in Event, limit: 5, where: d.device_id == ^id, order_by: [desc: d.id]) |> Repo.all
  #%{detection: detection}=Enum.at(records,3)

#cut=String.replace("#{Enum.at(records,3).detection}", "litter","")
#cut=String.replace("#{cut}", ".jpg","")
#date=String.replace("#{cut}", "device-#{device.mac_addr}/","")

#IO.inspect (date)

  url2=ExAws.S3.list_objects("littercam",max_keys: 5, prefix: "device-#{device.mac_addr}/") |> ExAws.request!
#    IO.inspect(url2.body.contents)
url1=url2.body.contents
 #url1=ExAws.S3.list_objects("littercam",max_keys: 10, prefix: "device-#{device.mac_addr}/") |> ExAws.stream!|> Enum.to_list
  url="https://s3-us-west-2.amazonaws.com/littercam/device-#{device.mac_addr}/litter.jpg"

    render(conn, "show.html", device: device, url: url,listurl: records)
  end

  def edit(conn, %{"id" => id}) do
    device = Manager.get_device!(id)
    changeset = Manager.change_device(device)
    render(conn, "edit.html", device: device, changeset: changeset)
  end

  def update(conn, %{"id" => id, "device" => device_params}) do
    device = Manager.get_device!(id)

    case Manager.update_device(device, device_params) do
      {:ok, device} ->
        conn
        |> put_flash(:info, "Device updated successfully.")
        |> redirect(to: device_path(conn, :show, device))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", device: device, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    device = Manager.get_device!(id)
    {:ok, _device} = Manager.delete_device(device)

    conn
    |> put_flash(:info, "Device deleted successfully.")
    |> redirect(to: device_path(conn, :index))
  end

def myaccount(conn, _params) do
  render(conn, "myaccount.html")

end





  def login_global(conn, %{"user" =>user,  "action" => action}) do
    case action do
       "userlogin" -> login(conn, user, "false")
       "newuser" -> create_user(conn, user)
       "admin" -> login(conn, user, "true")
    end
  end
  def register(conn,_params) do
    changeset = Auth.change_user(%User{})
    conn
    |> render("signup.html", changeset: changeset, action: device_path(conn, :login_global))

    redirect(conn,to: "/")
  end

def create_user(conn, %{"email"=>email, "password"=>password}) do

  user_changeset=User.changeset(%User{}, %{"email"=>email, "password"=>password})

 case Repo.insert(user_changeset)   do
  {:ok, _changeset} ->
    conn
    |> put_flash(:info, "Your account was created")
    |> login( %{"email"=>email, "password"=>password},"false")

  {:error, changeset} ->
    IO.puts "eeeee"
    IO.inspect (changeset.errors[:email])
    {email_error, _list}=changeset.errors[:email]
    conn
    |> put_flash(:info, "Unable to create account. Email #{email_error}")
    |> redirect(to: "/")
end



 case Auth.create_user(%{"email"=>email, "password"=>password}) do
   {:ok, _user} ->
login(conn, %{"email"=>email, "password"=>password},"false")

 end
end

  def login(conn,%{"email"=>email, "password"=>password},admin) do

    case admin do
      "true" ->
        Auth.authenticate_admin(email, password)
        |> login_reply(conn,"true")
        "false" ->
           Auth.authenticate_user(email, password)
           |> login_reply(conn,"false")
    end

   end


   defp login_reply({:error, error}, conn,admin) do
     case admin  do
       "false" ->
           conn
           |> put_flash(:error, error)
           |> redirect(to: "/")
             "true" ->
               conn
               |> put_flash(:error, error)
               |> redirect(to: "/admin")
end
   end


   defp login_reply({:ok, user}, conn, admin) do
     case admin  do
       "false" ->
         conn
         |> put_flash(:success, "Welcome back!")
         |> Guardian.Plug.sign_in(user)
         |> redirect(to: "/")
        "true" ->
          conn
          |> put_flash(:success, "Welcome Admin!")
          |> Guardian.Plug.sign_in(user)
          |> redirect( to: device_path(conn, :index_admin ))

     end

   end


   def logout(conn, _) do
     conn
     |> Guardian.Plug.sign_out()
     |> redirect(to: "/")
   end

   def wiki(conn, _) do
     conn
     |> render("wiki.html")

   end





   def upload(conn, %{"upload" => %{"file" => file},"id" => id}) do
     # Get the file's extension
     file_extension = Path.extname(file.filename)
     device = Manager.get_device!(id)

     # Generate the UUID
     file_uuid = UUID.uuid4(:hex)

     # Set the S3 filename
     s3_filename =  "device-#{device.mac_addr}/parameters.txt2"

     # The S3 bucket to upload to
     s3_bucket = "littercam"

     # Load the file into memory
     {:ok, file_binary} = File.read(file.path)
     IO.puts file_binary
     # Upload the file to S3
     url="https://s3-us-west-2.amazonaws.com/littercam/device-#{device.mac_addr}/litter.jpg"

     {:ok, _} =ExAws.S3.put_object(s3_bucket, s3_filename, file_binary)   |> ExAws.request()
     IO.puts s3_filename
     conn |>
     put_flash(:success, "File uploaded successfully!")
     |> render("show.html",device: device, url: url)
   end












end
