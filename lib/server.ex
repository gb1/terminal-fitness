defmodule TerminalFitness.Server do

  def listen(port), do: listen(port, &handler/1)
  def listen(port, handler) do
    IO.puts "listen"
    Socket.TCP.listen!(port, packet: :line)
    |> accept(handler)
  end

  def accept(listening_socket, handler) do
    IO.puts "accept"
    socket = Socket.TCP.accept!(listening_socket)
    socket |> Socket.Stream.send!(welcome())
    socket |> Socket.Stream.send!(options())
    spawn (fn -> handle(socket, handler) end)
    accept(listening_socket, handler)
  end

  def handle(socket, handler) do
    IO.puts "handle"
    incoming = Socket.Stream.recv!(socket)
    socket |> Socket.Stream.send!(handler.(incoming))
    handle(socket, handler)
  end

  def handler(line) do

    cond do
      line =~ ~r/help/ -> options
      line =~ ~r/1/ -> pushups
      line =~ ~r/2/ -> squats
      line =~ ~r/3/ -> plank
      true -> "I'm not sure what you mean, type 'help' for options\n\r"
    end

  end

  def welcome do
    TableRex.quick_render!([["WELCOME TO TERMINAL FITNESS"]])
    <> "\n\rCHOOSE AN OPTION:\n\r"
  end

  def options do
    TableRex.quick_render!([
      ["1", "START PUSHUPS CHALLENGE"],
      ["2", "START SQUAT CHALLENGE"],
      ["3", "START PLANK CHALLENGE"],
      ["help", "SHOW HELP"]],
      ["COMMAND", "ACTION"], "OPTIONS")
  end

  def pushups do
    "pushups it is!"
  end

  def squats do
    "squats it is!"
  end

  def plank do
    "plank it is!"
  end

end
