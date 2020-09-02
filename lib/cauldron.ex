defmodule Cauldron do
  use GenServer
  @short 200
  @long  400

  def toil_and_trouble(server) do
    short_wait
    toil(server)
    IO.puts("MQ: message_queue_length: #{message_queue_length(server)}")
    toil_and_trouble(server)
  end

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def init(intial_value) do
    {:ok, intial_value}
  end

  def toil(server) do
    GenServer.cast(server, :toil)
  end

  def handle_cast(:toil, state) do
    long_wait
    {:noreply, state+1}
  end

  defp message_queue_length(pid) do
    pid
    |> Process.info(:message_queue_len)
    |> elem(1)
  end

  defp short_wait, do: wait(@short)

  defp long_wait, do: wait(@long)

  def wait(time) do
    time
    |> :random.uniform
    |> Process.sleep
  end

end
