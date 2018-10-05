defmodule Streaming.DeviceView do
  use Streaming.Web, :view

  import Torch.TableView
  import Torch.FilterView

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
        access_key: Application.get_env(:ex_aws, :access_key_id),
        secret: Application.get_env(:ex_aws, :secret_access_key)
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

end
